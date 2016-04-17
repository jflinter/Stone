//
//  CrystalDetailAnimator.swift
//  Stone
//
//  Created by Jack Flintermann on 4/17/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

@objc class CrystalDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let collectionViewController: CrystalCollectionViewController
    init(collectionViewController: CrystalCollectionViewController) {
        self.collectionViewController = collectionViewController
        super.init()
    }
    
    var presenting: Bool = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            let detailViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! CrystalDetailViewController
            
            transitionContext.containerView()?.addSubview(collectionViewController.view)
            transitionContext.containerView()?.addSubview(detailViewController.view)
            detailViewController.view.alpha = 0
            
            func fadeOutCrystals() {
                let crystalViews = collectionViewController.collectionView.visibleCells() as! [CrystalCollectionViewCell]
                for crystalView in crystalViews {
                    let duration = drand48() * 0.1 + 0.2
                    UIView.animateWithDuration(duration, animations: {
                        crystalView.alpha = 0
                        crystalView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    })
                }
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    for crystalView in crystalViews {
                        crystalView.alpha = 1
                        crystalView.transform = CGAffineTransformIdentity
                    }
                }
            }
            
            
        } else {
            
        }
    }
    
}
