//
//  CrystalCollectionViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import Dwifft
import Bond
import pop

private let reuseIdentifier = "Cell"

class CrystalCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsZero
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var diffCalculator: CollectionViewDiffCalculator<CrystalCellViewModel>?
    let crystalStore: CrystalStore
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .Minimal
        return searchBar
    }()
    var searchVisible: Bool = false {
        didSet {
            UIView.animateWithDuration(0.3, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }) { completed in
                guard completed else { return }
                if self.searchVisible {
                    self.searchBar.becomeFirstResponder()
                }
            }
        }
    }
    
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        super.init(nibName: nil, bundle: nil)
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.searchBar)
        
        crystalStore.selectedCategory.observe { self.navigationItem.title = $0 ?? "All Crystals" }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(CrystalCollectionViewController.showCategories))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(CrystalCollectionViewController.toggleSearch))
        
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView)
        crystalStore.visibleCrystals.observe { self.diffCalculator?.rows = $0.map(CrystalCellViewModel.init) }
        crystalStore.fetchCrystals()
        
//        collectionView.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(CrystalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = 44
        let searchY = self.searchVisible ? 0 : -height
        self.searchBar.frame = CGRectMake(0, searchY, self.view.bounds.size.width, height)
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 + 20)
        var collectionViewFrame = self.view.bounds
        collectionViewFrame.origin.y = CGRectGetMaxY(self.searchBar.frame)
        collectionViewFrame.size.height = self.view.bounds.size.height - collectionViewFrame.origin.y
        self.collectionView.frame = collectionViewFrame
    }
    
    func viewModelAt(indexPath: NSIndexPath) -> CrystalCellViewModel? {
        return self.diffCalculator?.rows[indexPath.row]
    }
        
    func showCategories() {
        let categoryController = CategoryTableViewController(crystalStore: self.crystalStore)
        let nav = UINavigationController(rootViewController: categoryController)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func toggleSearch() {
        self.searchVisible = !self.searchVisible
    }
    
    // MARK: UISearchBarDelegate
    @objc func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.crystalStore.searchQuery.value = searchText
    }
    
    // MARK: UICollectionViewDataSource
    
    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diffCalculator?.rows.count ?? 0
    }

    @objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CrystalCollectionViewCell
        if let viewModel = viewModelAt(indexPath) {
            cell.viewModel = viewModel
        }
        return cell
    }
    
//    @objc func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CrystalCollectionViewCell else { return }
//        let animation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
//        animation.springSpeed = 2
//        animation.springBounciness = 1
//        animation.toValue = NSValue(CGSize: CGSizeMake(0.9, 0.9))
//        cell.pop_addAnimation(animation, forKey: nil)
//    }
//    
//    @objc func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CrystalCollectionViewCell else { return }
//        let animation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
//        animation.springSpeed = 2
//        animation.springBounciness = 1
//        animation.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
//        cell.pop_addAnimation(animation, forKey: nil)
//    }
    
    @objc func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CrystalCollectionViewCell,
            image = cell.imageView.image, cellViewModel = viewModelAt(indexPath), imageURL = cellViewModel.imageURLForSize(CGRectIntegral(cell.frame).size) else { return }
//        let viewModel = CrystalDetailViewModel(crystal: cellViewModel.crystal, bootstrapImage: AnnotatedImage(image: image, imageURL: imageURL))
//        let detail = CrystalDetailViewController(viewModel: viewModel)
        
        var indices = self.collectionView.indexPathsForVisibleItems()
//        indices.removeObject(indexPath)
        
        let crystalViews = indices.flatMap { index in
            return self.collectionView.cellForItemAtIndexPath(index) as? CrystalCollectionViewCell
        }
//        
//        let originalRect = cell.frame
//
        
        
//        UIView.animateWithDuration(0.2, animations: {
//            cell.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(3.0, 3.0), 0, 20)
//        })
//        
        for crystalView in crystalViews {
            let duration = drand48() * 0.25 + 0.1
            UIView.animateWithDuration(duration, animations: {
                crystalView.alpha = 0
                crystalView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            })
        }
        
        let fakeView = TempView(image: image)
        self.collectionView.addSubview(fakeView)
        fakeView.frame = collectionView.bounds
        fakeView.layoutSubviews()
        fakeView.show()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            fakeView.removeFromSuperview()
            for crystalView in self.collectionView.visibleCells() {
                crystalView.alpha = 1
                crystalView.transform = CGAffineTransformIdentity
            }
        }
        
//        self.presentViewController(detail, animated: true, completion: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    var animator: CrystalDetailAnimator? = nil
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator = CrystalDetailAnimator(collectionViewController: self)
        return self.animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator?.presenting = false
        return self.animator
    }

}

class TempView: UIView {
    
    let crystalImageView = UIImageView()
    let fakeFooterView = UIImageView(image: UIImage(named: "meta"))
    let fakeBuyView = UIImageView(image: UIImage(named: "footer"))
    
    convenience init(image: UIImage) {
        self.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.crystalImageView.image = image
        self.addSubview(self.crystalImageView)
        self.addSubview(self.fakeFooterView)
        self.crystalImageView.contentMode = .ScaleAspectFit
        self.crystalImageView.frame = CGRectMake(50, 10, 340, 340)
        self.fakeFooterView.frame = CGRectMake(0, 385, 414, 500)
        self.fakeFooterView.contentMode = .Center
        
        self.addSubview(self.fakeBuyView)
        self.fakeBuyView.frame = CGRectMake(0, 626, 414, 50)
    }
    
    func show() {
        
        self.crystalImageView.layer.transform =
            CATransform3DTranslate(CATransform3DMakeScale(0.7, 0.7, 1), 0, 70, 0)
        self.crystalImageView.layer.opacity = 0
        
        for (keyPath, value) in [
            (kPOPLayerTranslationY, 0),
            (kPOPLayerOpacity, 1),
            (kPOPLayerScaleX, 1),
            (kPOPLayerScaleY, 1),
            ] {
                let animation = POPSpringAnimation(propertyNamed: keyPath)
                animation.springSpeed = 4
                animation.springBounciness = 1
                animation.toValue = value
                self.crystalImageView.layer.pop_addAnimation(animation, forKey: nil)
        }
        
        self.fakeFooterView.alpha = 0
        self.fakeFooterView.layer.transform = CATransform3DMakeTranslation(0, 70, 0)
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        animation.springSpeed = 5
        animation.springBounciness = 1
        animation.toValue = 0
        self.fakeFooterView.layer.pop_addAnimation(animation, forKey: nil)
        
        let animation2 = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        animation2.springSpeed = 5
        animation2.springBounciness = 1
        animation2.toValue = 1
        self.fakeFooterView.pop_addAnimation(animation2, forKey: nil)
        
        self.fakeBuyView.layer.transform = CATransform3DMakeTranslation(0, 50, 0)
        let animation3 = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        animation3.springSpeed = 5
        animation3.springBounciness = 1
        animation3.toValue = 0
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.fakeBuyView.layer.pop_addAnimation(animation3, forKey: nil)
        }
    }
    
}

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
