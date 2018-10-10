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
    var rightItem: UIBarButtonItem?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            
            let detailViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! CrystalDetailViewController
            detailViewController.view.backgroundColor = UIColor.clear
            
            UIView.performWithoutAnimation {
                detailViewController.view.setNeedsLayout()
                detailViewController.view.layoutIfNeeded()
            }
            
            transitionContext.containerView.addSubview(collectionViewController.view)
            transitionContext.containerView.addSubview(detailViewController.view)
            
            let indexPaths = collectionViewController.collectionView.indexPathsForVisibleItems
            for indexPath in indexPaths {
                guard let crystalView = collectionViewController.collectionView.cellForItem(at: indexPath) as? CrystalCollectionViewCell else { continue }
                let duration = drand48() * 0.1 + 0.2
                previousTransformations[indexPath.item] = crystalView.transform
                UIView.animate(withDuration: duration, animations: {
                    crystalView.alpha = 0
                    crystalView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                })
            }
            
            self.rightItem = self.collectionViewController.navigationItem.rightBarButtonItem
            
            UIView.animate(withDuration: 0.05, animations: {
                self.collectionViewController.navigationItem.setRightBarButton(nil, animated: true)
                self.collectionViewController.navigationItem.titleView?.alpha = 0
                self.collectionViewController.searchView.alpha = 0
                self.collectionViewController.searchHairline.alpha = 0
            }) 
            
            detailViewController.closeButton.transform =  CGAffineTransform(scaleX: 0.7, y: 0.7).rotated(by: 120)
            detailViewController.closeButton.alpha = 0
            detailViewController.shareButton.transform =  CGAffineTransform(scaleX: 0.7, y: 0.7).rotated(by: -120)
            detailViewController.shareButton.alpha = 0
            UIView.animate(withDuration: 0.63, delay: 0.05, usingSpringWithDamping: 25.51, initialSpringVelocity: 0, options: [], animations: {
                detailViewController.closeButton.alpha = 1
                detailViewController.closeButton.transform = CGAffineTransform.identity
                detailViewController.shareButton.alpha = 1
                detailViewController.shareButton.transform = CGAffineTransform.identity
                }, completion: nil)
            
            
            detailViewController.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).translatedBy(x: 0, y: 70)
            detailViewController.imageView.alpha = 0
            
            UIView.animate(withDuration: 0.63, delay: 0.05, usingSpringWithDamping: 25.51, initialSpringVelocity: 0, options: [], animations: {
                    detailViewController.imageView.transform = CGAffineTransform.identity
                detailViewController.imageView.alpha = 1
                }, completion: nil)
            
            
            detailViewController.contentContainer.alpha = 0
            detailViewController.contentContainer.transform = CGAffineTransform(translationX: 0, y: 70)
            
            UIView.animate(withDuration: 0.68, delay: 0.05, usingSpringWithDamping: 23.27, initialSpringVelocity: 0, options: [], animations: {
                detailViewController.contentContainer.transform = CGAffineTransform.identity
                detailViewController.contentContainer.alpha = 1
                }, completion: { completed in
                    detailViewController.view.backgroundColor = UIColor.white
                    transitionContext.completeTransition(completed)
            })
            
            
        } else {
            let detailViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! CrystalDetailViewController
            detailViewController.view.backgroundColor = UIColor.clear
            
            UIView.animate(withDuration: 0.15, animations: {
                
                detailViewController.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).translatedBy(x: 0, y: 70)
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

            self.collectionViewController.navigationItem.titleView?.alpha = 1
            self.collectionViewController.navigationItem.setRightBarButton(self.rightItem, animated: false)
            
            UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {

                self.collectionViewController.searchView.alpha = 1
                self.collectionViewController.searchHairline.alpha = 1
            }, completion: nil)
            
            let indexPaths = collectionViewController.collectionView.indexPathsForVisibleItems
            for indexPath in indexPaths {
                guard let crystalView = collectionViewController.collectionView.cellForItem(at: indexPath) as? CrystalCollectionViewCell else { continue }
                let duration = drand48() * 0.1 + 0.2
                UIView.animate(withDuration: duration, animations: {
                    crystalView.alpha = 1
                    let previousTransformation = self.previousTransformations[indexPath.item] ?? CGAffineTransform.identity
                    if !previousTransformation.isIdentity {
                        
                    }
                    crystalView.transform = previousTransformation
                })
            }
        }
    }
    
}
