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

class CrystalCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var diffCalculator: CollectionViewDiffCalculator<Crystal>?
    let crystalStore: CrystalStore
    
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        let layout = CrystalFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsZero
        super.init(collectionViewLayout: layout)
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crystalStore.selectedCategory.observe { self.navigationItem.leftBarButtonItem = ($0 == nil) ? nil : UIBarButtonItem(title: "Clear Vibe", style: UIBarButtonItemStyle.Plain, target: self, action: "clearFilter") }
        
        crystalStore.selectedCategory.observe { self.navigationItem.title = $0 ?? "All Crystals" }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showCategories")
        
        guard let collectionView = collectionView, flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView)
        crystalStore.visibleCrystals.observe { self.diffCalculator?.rows = $0 }
        crystalStore.fetchCrystals()
        
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(CrystalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
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
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diffCalculator?.rows.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CrystalCollectionViewCell
        if let crystal = crystalAt(indexPath) {
            let viewModel = CrystalCellViewModel(crystal: crystal)
            cell.viewModel = viewModel
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let collectionView = self.collectionView,
            cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? CrystalCollectionViewCell,
            image = cell.imageView.image else { return }
        guard let crystal = crystalAt(indexPath) else { return }
        let viewModel = CrystalDetailViewModel(crystal: crystal, bootstrapImage: image)
        let detail = CrystalDetailViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: detail)
        self.presentViewController(nav, animated: true, completion: nil)
    }

}
