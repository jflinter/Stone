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

private let reuseIdentifier = "Cell"

class CrystalCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsZero
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var diffCalculator: CollectionViewDiffCalculator<Crystal>?
    let crystalStore: CrystalStore
    let searchBar = UISearchBar()
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
        
        crystalStore.selectedCategory.observe { self.navigationItem.leftBarButtonItem = ($0 == nil) ? nil : UIBarButtonItem(title: "Clear Vibe", style: UIBarButtonItemStyle.Plain, target: self, action: "clearFilter") }
        
        crystalStore.selectedCategory.observe { self.navigationItem.title = $0 ?? "All Crystals" }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: "showCategories")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "toggleSearch")
        
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView)
        crystalStore.visibleCrystals.observe { self.diffCalculator?.rows = $0 }
        crystalStore.fetchCrystals()
        
//        collectionView.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
        collectionView.backgroundColor = UIColor(red: 255.0/255.0, green: 211.0/255.0, blue: 224.0/255.0, alpha: 1)
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
    
    func crystalAt(indexPath: NSIndexPath) -> Crystal? {
        return self.diffCalculator?.rows[indexPath.row]
    }
    
    func clearFilter() {
        self.crystalStore.selectedCategory.value = nil
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
        if let crystal = crystalAt(indexPath) {
            let viewModel = CrystalCellViewModel(crystal: crystal)
            cell.viewModel = viewModel
        }
        return cell
    }
    
    @objc func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? CrystalCollectionViewCell,
            image = cell.imageView.image else { return }
        guard let crystal = crystalAt(indexPath) else { return }
        let viewModel = CrystalDetailViewModel(crystal: crystal, bootstrapImage: image)
        let detail = CrystalDetailViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: detail)
        self.presentViewController(nav, animated: true, completion: nil)
    }

}
