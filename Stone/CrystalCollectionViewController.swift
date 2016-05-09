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
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    let searchGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(white: 1, alpha: 1).CGColor,
            UIColor(white: 1, alpha: 1).CGColor,
            UIColor(white: 1, alpha: 0).CGColor
        ]
        gradient.locations = [0, 0.65, 1]
        gradient.startPoint = CGPointMake(0.5, 0)
        gradient.endPoint = CGPointMake(0.5, 1)
        return gradient
    }()
    let searchSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegmentWithTitle("NAME", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("VIBE", atIndex: 1, animated: false)
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
        self.view.addSubview(self.searchView)
        self.searchView.layer.addSublayer(self.searchGradientLayer)
        self.searchView.addSubview(self.searchSegmentedControl)
        self.searchView.addSubview(self.searchBar)
        self.searchBar.alpha = 0
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
        
        self.searchGradientLayer.frame = self.searchView.bounds
        
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
            50,
            searchView.frame.size.width - (searchBarX * 2),
            30
        )
        
        self.vibesView.frame = CGRectMake(0, 50, self.searchView.bounds.width, 50)
        
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 + 20)
        
        self.collectionView.frame = self.view.bounds
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
