//
//  MainContainerViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 5/21/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    let nav: UINavigationController
    let splash: SplashScreenViewController
    let crystals: CrystalCollectionViewController
    let crystalStore: CrystalStore
    
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        self.crystals = CrystalCollectionViewController(crystalStore: crystalStore)
        self.nav = UINavigationController(rootViewController: crystals)
        self.splash = SplashScreenViewController()
        
        super.init(nibName: nil, bundle: nil)
        
        self.addChild(nav)
        nav.didMove(toParent: self)
        
        self.addChild(splash)
        splash.didMove(toParent: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(nav.view)
        self.view.addSubview(splash.view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nav.view.frame = self.view.bounds
        splash.view.frame = self.view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.crystalStore.fetchCrystals().onSuccess { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.splash.view.alpha = 0
            }, completion: { _ in
                self.splash.removeFromParent()
                self.splash.didMove(toParent: nil)
                self.splash.view.removeFromSuperview()
            })
        }
    }

}
