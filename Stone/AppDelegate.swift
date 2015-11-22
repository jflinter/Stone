//
//  AppDelegate.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        let rootViewController = CrystalCollectionViewController()
        rootViewController.useLayoutToLayoutNavigationTransitions = false
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.translucent = false
        nav.delegate = rootViewController
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }

}

