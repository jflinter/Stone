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
import Analytics
import OneSignal

private let reuseIdentifier = "Cell"

class CrystalCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var diffCalculator: CollectionViewDiffCalculator<CrystalCellViewModel>?
    let crystalStore: CrystalStore
    
    let searchView = UIView()
    let searchHairline = UIView()
    
    let searchSegmentedControl: HMSegmentedControl = {
        let segmentedControl = HMSegmentedControl(sectionTitles: ["VIBE ", "NAME "])
        segmentedControl.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Brown-Light", size: 14) ?? UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.stoneLightBlue,
        ]
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed
        segmentedControl.selectionIndicatorHeight = 3
        segmentedControl.segmentEdgeInset = UIEdgeInsetsZero
        segmentedControl.selectionIndicatorColor = UIColor.stoneLightOrange
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.grayColor()
        return segmentedControl
    }()
    
    lazy var searchButton: UIBarButtonItem = {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(CrystalCollectionViewController.toggleSearch))
        searchButton.tintColor = UIColor.stoneLightBlue
        return searchButton
    }()
    
    lazy var cancelSearchButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(Resource.Image.Icon__close.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        button.tintColor = UIColor.stoneLightBlue
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 0)
        button.sizeToFit()
        button.frame = UIEdgeInsetsInsetRect(button.frame, UIEdgeInsetsMake(-8, -8, -8, -8))
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(CrystalCollectionViewController.toggleSearch), forControlEvents: .TouchUpInside)
        let searchButton = UIBarButtonItem(customView: button)
        searchButton.tintColor = UIColor.stoneLightBlue
        return searchButton
    }()
    
    let vibesView: VibesView
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).defaultTextAttributes = [
            NSForegroundColorAttributeName: UIColor.stoneLightBlue,
            NSFontAttributeName: UIFont(name: "Brown-Light", size: 16) ?? UIFont.systemFontOfSize(16),
        ]
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.layer.borderColor = UIColor.stoneDarkOrange.CGColor
        textFieldInsideSearchBar?.layer.borderWidth = 1
        textFieldInsideSearchBar?.layer.cornerRadius = 10
        textFieldInsideSearchBar?.clearButtonMode = .Never
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = UIColor.stoneLightBlue
        return searchBar
    }()
    var searchVisible: Bool = false {
        didSet {
            if searchVisible {
                self.searchView.hidden = false
            }
            else {
                self.crystalStore.selectedVibe.value = nil
                self.crystalStore.searchQuery.value = ""
            }
            UIView.animateWithDuration(0.3, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }) { completed in
                guard completed else { return }
                let showSearch = self.searchSegmentedControl.selectedSegmentIndex == 1
                if self.searchVisible {
                    if showSearch {
                        self.searchBar.becomeFirstResponder()
                    }
                } else {
                    self.vibesView.resetSelection()
                    if self.searchBar.isFirstResponder() {
                        self.searchBar.resignFirstResponder()
                        self.searchBar.text = ""
                    }
                    self.searchView.hidden = true
                }
            }
        }
    }
    
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        self.vibesView = VibesView(crystalStore: crystalStore)
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
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue ?? CGRectZero
        let intersection = CGRectIntersection(keyboardFrame, self.view.frame)
        
        var inset = self.collectionView.contentInset
        inset.bottom = intersection.size.height
        
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
        self.searchHairline.backgroundColor = UIColor.stoneDarkBlue
        self.view.addSubview(self.searchHairline)
        self.searchBar.alpha = 0
        self.vibesView.alpha = 1
        self.searchView.addSubview(self.vibesView)
        
        self.searchSegmentedControl.addTarget(self, action: #selector(CrystalCollectionViewController.segmentedControlChanged(_:)), forControlEvents: .ValueChanged)
        
        let imageView = UIImageView(image: Resource.Image.Stone_Logo_Icon.image)
        imageView.contentMode = .Center
        self.navigationItem.titleView = imageView
        
        self.navigationItem.rightBarButtonItem = self.searchButton
            
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.vibesView.collectionView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
        self.collectionView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
        
        let key = "STNPromptedForPushNotificationsAt"
        let promptedAt = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSDate
        if promptedAt == nil {
            let alertController = UIAlertController(title: nil, message: "Would you like us to let you know when we update STONE with more dazzling crystals?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "No thanks.", style: .Default, handler: { _ in
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: key)
            }))
            alertController.addAction(UIAlertAction(title: "Please do.", style: UIAlertActionStyle.Default, handler: { _ in
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: key)
                OneSignal.defaultClient().registerForPushNotifications()
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func segmentedControlChanged(segmentedControl: UISegmentedControl) {
        let showSearch = segmentedControl.selectedSegmentIndex == 1
        if showSearch {
            self.crystalStore.selectedVibe.value = nil
            self.vibesView.resetSelection()
        } else {
            self.crystalStore.searchQuery.value = ""
            self.searchBar.resignFirstResponder()
        }
        UIView.animateWithDuration(0.2, animations: {
            self.searchBar.alpha = showSearch ? 1 : 0
            self.vibesView.alpha = showSearch ? 0 : 1
        }, completion: { completed in
            if showSearch {
                self.searchBar.becomeFirstResponder()
            } else {
                self.searchBar.text = ""
            }
        })
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
        
        self.vibesView.frame = CGRectMake(0, 40, self.searchView.bounds.width, 80)
        
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
        
    func toggleSearch() {
        self.searchVisible = !self.searchVisible
        self.navigationItem.setRightBarButtonItem(self.searchVisible ? self.cancelSearchButton : self.searchButton, animated: true)
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
            image = cell.imageView.image, cellViewModel = viewModelAt(indexPath) else { return }
        let viewModel = CrystalDetailViewModel(crystal: cellViewModel.crystal, bootstrapImage: image)
        let detail = CrystalDetailViewController(viewModel: viewModel)
        detail.transitioningDelegate = self
        SEGAnalytics.sharedAnalytics().track("Viewed Crystal", properties: ["name": cellViewModel.crystal.name])
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
