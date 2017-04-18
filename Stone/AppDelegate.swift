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
import Analytics
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let crystalStore: CrystalStore = CrystalStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        var t = 0
        srand48(time(&t))
        BITHockeyManager.shared().configure(withIdentifier: "6e9f05f2cfa44a098bfbba010a692853")
        // Do some additional configuration if needed here
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        let segmentConfig = SEGAnalyticsConfiguration(writeKey: "vwWphE64rZPxJpoWzFYblkyHgeQxkUuc")
        segmentConfig.trackApplicationLifecycleEvents = true
        SEGAnalytics.setup(with: segmentConfig)

        OneSignal.setDefaultClient(OneSignal(launchOptions: launchOptions, appId: "24cf8981-2d7c-4983-bcb2-6ebe14c590bf", handleNotification: nil, autoRegister: false))
        
        let bytesPerMegabyte = 1000000
        URLCache.shared = URLCache(memoryCapacity: 100 * bytesPerMegabyte, diskCapacity: 200 * bytesPerMegabyte, diskPath: "com.stonecrystals.urlcache")
        
        let configuration = ImageDownloader.defaultURLSessionConfiguration()
        configuration.urlCache = URLCache.shared
        configuration.httpAdditionalHeaders = ["Cache-Control": "max-age=31536000"]
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        UIImageView.af_sharedImageDownloader = ImageDownloader(configuration: configuration, downloadPrioritization: .lifo, maximumActiveDownloads: 16)
        
        let navBarAppearance: UINavigationBar = UINavigationBar.appearance()
        navBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.isTranslucent = false
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        self.window?.rootViewController = MainContainerViewController(crystalStore: crystalStore)
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let _ = crystalStore.fetchCrystals()
    }

}

