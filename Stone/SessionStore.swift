//
//  SessionStore.swift
//  Stone
//
//  Created by Jack Flintermann on 5/21/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit
import BrightFutures
import Alamofire
import Result
import SSKeychain

class SessionStore: NSObject {
    
    static let sharedInstance = SessionStore()
    
    private var sessionIdentifier: String?
    
    override init() {
        super.init()
        SSKeychain.setAccessibilityType(kSecAttrAccessibleWhenUnlocked)
        self.sessionIdentifier = SSKeychain.passwordForService("api.stoneproject.co", account: "default")
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                       selector: #selector(SessionStore.willResignActive),
                       name: UIApplicationWillResignActiveNotification,
                       object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc private func willResignActive() {
        if let sessionIdentifier = self.sessionIdentifier {
            SSKeychain.setPassword(sessionIdentifier, forService: "api.stoneproject.co", account: "default")
        }
    }
    
    func getOrCreateSession() -> Future<String, NSError> {
        let promise = Promise<String, NSError>()
        if let sessionIdentifier = self.sessionIdentifier {
            promise.success(sessionIdentifier)
        } else if let password = SSKeychain.passwordForService("api.stoneproject.co", account: "default") {
            promise.success(password)
        } else {
            return createSession()
        }
        return promise.future
    }
    
    private func createSession() -> Future<String, NSError> {
        let promise = Promise<String, NSError>()
        let identifierForVendor = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? "unknown_device"
        Alamofire.request(.POST, API.baseURL + "sessions", parameters: ["device_identifier": identifierForVendor]).response(queue: nil) { (request, response, data, error) in
            guard let response = response, header = response.allHeaderFields["Set-Cookie"] as? String where response.statusCode == 200 else {
                let error = error ?? NSError(domain: "", code: 999, userInfo: nil)
                promise.failure(error)
                return
            }
            self.sessionIdentifier = header
            SSKeychain.setPassword(header, forService: "api.stoneproject.co", account: "default")
            promise.success(header)
        }
        return promise.future
    }
    
}
