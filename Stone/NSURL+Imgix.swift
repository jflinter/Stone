//
//  NSURL+Imgix.swift
//  Stone
//
//  Created by Jack Flintermann on 11/23/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation
import UIKit

extension NSURL {
    func imgixURL() -> NSURL? {
        guard let components = NSURLComponents(
            URL: self,
            resolvingAgainstBaseURL: true
            ) else {
                return nil
        }
        var imgixItems = components.queryItems ?? []
        let bounds = UIScreen.mainScreen().bounds
        let dimension = max(bounds.size.width, bounds.size.height)
        imgixItems += [
            NSURLQueryItem(name: "fm", value: "jpeg"),
            NSURLQueryItem(name: "w", value: String(dimension)),
            NSURLQueryItem(name: "h", value: String(dimension)),
            NSURLQueryItem(name: "fit", value: "fill")
        ]
        components.queryItems = imgixItems
        return components.URL
    }
}
