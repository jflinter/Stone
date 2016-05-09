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
    
    let searchView = UIView()
    let searchHairline = UIView()
    
    let searchSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Brown-Light", size: 14) ?? UIFont.systemFontOfSize(14)], forState: .Normal)
        segmentedControl.insertSegmentWithTitle("NAME", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("VIBE", atIndex: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.grayColor()
        segmentedControl.layer.borderColor = UIColor.grayColor().CGColor
        segmentedControl.layer.borderWidth = 1.0
        return segmentedControl
    }()
    
    let vibesView = VibesView()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .Minimal
        return searchBar
    }()
    var searchVisible: Bool = false {
        didSet {
            if searchVisible {
                self.searchView.hidden = false
            }
            UIView.animateWithDuration(0.3, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }) { completed in
                guard completed else { return }
                if self.searchVisible {
                    self.searchBar.becomeFirstResponder()
                } else {
                    if self.searchBar.isFirstResponder() {
                        self.searchBar.resignFirstResponder()
                    }
                    self.searchView.hidden = true
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CrystalCollectionViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    var oldInsetBottom: CGFloat = 0
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        let oldFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue() ?? CGRectZero
        guard let window = self.view.window else { return }
        if (!CGRectIntersectsRect(window.frame, oldFrame)) {
            oldInsetBottom = self.collectionView.contentInset.bottom
        }
        
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue ?? CGRectZero
        
        let keyboardHeight = CGRectGetHeight(keyboardFrame)
        var inset = self.collectionView.contentInset
        if (!CGRectIntersectsRect(window.frame, keyboardFrame)) {
            inset.bottom = oldInsetBottom
        } else {
            inset.bottom = oldInsetBottom + keyboardHeight
        }
        
        self.collectionView.contentInset = inset
        self.collectionView.scrollIndicatorInsets = inset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.searchView)
        self.searchView.backgroundColor = UIColor.whiteColor()
        self.searchView.addSubview(self.searchSegmentedControl)
        self.searchView.addSubview(self.searchBar)
        self.searchHairline.backgroundColor = UIColor.grayColor()
        self.view.addSubview(self.searchHairline)
        self.searchBar.alpha = 1
        self.vibesView.hidden = true // TODO
        self.searchView.addSubview(self.vibesView)
        
        let imageView = UIImageView(image: Resource.Image.Stone_Logo_Icon.image)
        imageView.contentMode = .Center
        self.navigationItem.titleView = imageView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(CrystalCollectionViewController.toggleSearch))
        
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView)
        crystalStore.visibleCrystals.observe {
            self.diffCalculator?.rows = $0.map(CrystalCellViewModel.init)
            self.updateCellParallax()
        }
        crystalStore.fetchCrystals()
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(CrystalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        self.searchVisible = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateCellParallax()
    }
    
    func updateCellParallax() {
        for cell in self.collectionView.visibleCells() {
            guard let cell = cell as? CrystalCollectionViewCell else { return }
            let distanceFromBottom = self.collectionView.frame.size.height - CGRectGetMaxY(cell.convertRect(cell.bounds, toView: nil))
            let percentage = distanceFromBottom / self.collectionView.frame.size.height
            let transformed = percentage / 0.5
            let fraction = max(min(transformed + 0.7, 1), 0)
            cell.transform = CGAffineTransformMakeScale(fraction, fraction)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = 120
        let searchY = self.searchVisible ? 0 : -height
        
        self.searchView.frame = CGRectMake(0, searchY, self.view.bounds.size.width, height)
        
        let segmentedControlWidth = CGFloat(175)
        self.searchSegmentedControl.frame = CGRectMake(
            searchView.frame.size.width / 2 - segmentedControlWidth/2,
            10,
            segmentedControlWidth,
            30
        )
        self.searchSegmentedControl.layer.cornerRadius = self.searchSegmentedControl.frame.size.height / 2
        self.searchSegmentedControl.clipsToBounds = true
        let searchBarX = CGFloat(10)
        self.searchBar.frame = CGRectMake(
            searchBarX,
            60,
            searchView.frame.size.width - (searchBarX * 2),
            30
        )
        self.searchHairline.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame) + 0.5, self.searchView.bounds.size.width, 0.5)
        
        self.vibesView.frame = CGRectMake(0, 50, self.searchView.bounds.width, 50)
        
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 + 20)
        
        self.collectionView.frame = self.view.bounds
        var oldContentOffset = self.collectionView.contentOffset
        var inset = self.collectionView.contentInset
        inset.top = self.searchVisible ? CGRectGetMaxY(self.searchView.frame) : 0
        self.collectionView.contentInset = inset
        self.collectionView.scrollIndicatorInsets = inset
        if oldContentOffset.y == 0 {
            oldContentOffset.y -= inset.top
            self.collectionView.contentOffset = oldContentOffset
        }
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
    
    @objc func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CrystalCollectionViewCell,
            image = cell.imageView.image, cellViewModel = viewModelAt(indexPath), imageURL = cellViewModel.imageURLForSize(CGRectIntegral(cell.frame).size) else { return }
        let viewModel = CrystalDetailViewModel(crystal: cellViewModel.crystal, bootstrapImage: AnnotatedImage(image: image, imageURL: imageURL))
        let detail = CrystalDetailViewController(viewModel: viewModel)
        detail.transitioningDelegate = self
        self.presentViewController(detail, animated: true, completion: nil)
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
