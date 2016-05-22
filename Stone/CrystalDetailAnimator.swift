//
//  CrystalDetailAnimator.swift
//  Stone
//
//  Created by Jack Flintermann on 4/17/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

@objc class CrystalDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var previousTransformations: [Int: CGAffineTransform] = [:]
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
            detailViewController.view.backgroundColor = UIColor.clearColor()
            
            UIView.performWithoutAnimation {
                detailViewController.view.setNeedsLayout()
                detailViewController.view.layoutIfNeeded()
            }
            
            transitionContext.containerView()?.addSubview(collectionViewController.view)
            transitionContext.containerView()?.addSubview(detailViewController.view)
            
            let indexPaths = collectionViewController.collectionView.indexPathsForVisibleItems()
            for indexPath in indexPaths {
                guard let crystalView = collectionViewController.collectionView.cellForItemAtIndexPath(indexPath) as? CrystalCollectionViewCell else { continue }
                let duration = drand48() * 0.1 + 0.2
                previousTransformations[indexPath.item] = crystalView.transform
                UIView.animateWithDuration(duration, animations: {
                    crystalView.alpha = 0
                    crystalView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                })
            }
            UIView.animateWithDuration(0.05) {
                self.collectionViewController.navigationController?.navigationBar.alpha = 0
                self.collectionViewController.searchView.alpha = 0
                self.collectionViewController.searchHairline.alpha = 0
            }
            
            detailViewController.closeButton.transform =  CGAffineTransformRotate(CGAffineTransformMakeScale(0.7, 0.7), 120)
            detailViewController.closeButton.alpha = 0
            UIView.animateWithDuration(0.63, delay: 0.05, usingSpringWithDamping: 25.51, initialSpringVelocity: 0, options: [], animations: {
                detailViewController.closeButton.alpha = 1
                detailViewController.closeButton.transform = CGAffineTransformIdentity
                }, completion: nil)
            
            
            detailViewController.imageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.7, 0.7), 0, 70)
            detailViewController.imageView.alpha = 0
            
            UIView.animateWithDuration(0.63, delay: 0.05, usingSpringWithDamping: 25.51, initialSpringVelocity: 0, options: [], animations: {
                    detailViewController.imageView.transform = CGAffineTransformIdentity
                detailViewController.imageView.alpha = 1
                }, completion: nil)
            
            
            detailViewController.contentContainer.alpha = 0
            detailViewController.contentContainer.transform = CGAffineTransformMakeTranslation(0, 70)
            
            UIView.animateWithDuration(0.68, delay: 0.05, usingSpringWithDamping: 23.27, initialSpringVelocity: 0, options: [], animations: {
                detailViewController.contentContainer.transform = CGAffineTransformIdentity
                detailViewController.contentContainer.alpha = 1
                }, completion: { completed in
                    detailViewController.view.backgroundColor = UIColor.whiteColor()
                    transitionContext.completeTransition(completed)
            })
            
            
        } else {
            let detailViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! CrystalDetailViewController
            detailViewController.view.backgroundColor = UIColor.clearColor()
            
            UIView.animateWithDuration(0.15, animations: {
                
                detailViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.7, 0.7), 0, 70)
                detailViewController.view.alpha = 0
                
//                detailViewController.closeButton.transform =  CGAffineTransformRotate(CGAffineTransformMakeScale(0.7, 0.7), 120)
//                detailViewController.closeButton.alpha = 0
//                
//                detailViewController.imageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.7, 0.7), 0, 70)
//                detailViewController.imageView.alpha = 0
//                
//                detailViewController.contentContainer.transform = CGAffineTransformMakeTranslation(0, 70)
//                detailViewController.contentContainer.alpha = 0

                }, completion: { completed in
                    transitionContext.completeTransition(completed)
                }
            )
            
            UIView.animateWithDuration(0.1, delay: 0.1, options: [], animations: { 
                self.collectionViewController.navigationController?.navigationBar.alpha = 1
                self.collectionViewController.searchView.alpha = 1
                self.collectionViewController.searchHairline.alpha = 1
            }, completion: nil)
            
            let indexPaths = collectionViewController.collectionView.indexPathsForVisibleItems()
            for indexPath in indexPaths {
                guard let crystalView = collectionViewController.collectionView.cellForItemAtIndexPath(indexPath) as? CrystalCollectionViewCell else { continue }
                let duration = drand48() * 0.1 + 0.2
                UIView.animateWithDuration(duration, animations: {
                    crystalView.alpha = 1
                    let previousTransformation = self.previousTransformations[indexPath.item] ?? CGAffineTransformIdentity
                    if !CGAffineTransformIsIdentity(previousTransformation) {
                        
                    }
                    crystalView.transform = previousTransformation
                })
            }
        }
    }
    
}
