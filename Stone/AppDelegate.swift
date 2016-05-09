//
//  AppDelegate.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import HockeySDK
import Alamofire
import AlamofireImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let crystalStore: CrystalStore = CrystalStore()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var t = 0
        srand48(time(&t))
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("6e9f05f2cfa44a098bfbba010a692853")
        // Do some additional configuration if needed here
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
        
        let bytesPerMegabyte = 1000000
        NSURLCache.setSharedURLCache(NSURLCache(memoryCapacity: 100 * bytesPerMegabyte, diskCapacity: 200 * bytesPerMegabyte, diskPath: "com.stonecrystals.urlcache"))
        
        let configuration = ImageDownloader.defaultURLSessionConfiguration()
        configuration.URLCache = NSURLCache.sharedURLCache()
        configuration.HTTPAdditionalHeaders = ["Cache-Control": "max-age=31536000"]
        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        UIImageView.af_sharedImageDownloader = ImageDownloader(configuration: configuration, downloadPrioritization: .LIFO, maximumActiveDownloads: 16)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        let rootViewController = CrystalCollectionViewController(crystalStore: crystalStore)
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.translucent = false
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        crystalStore.fetchCrystals()
    }

}

