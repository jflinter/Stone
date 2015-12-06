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
    
    init() {
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
        
        let imageView = UIImageView(image: UIImage(named: "noun_315_cc"))
        imageView.frame = CGRectMake(0, 0, 30, 30)
        imageView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imageView
        guard let collectionView = collectionView, flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView)
        CrystalStore.sharedInstance.visibleCrystals.observe { self.diffCalculator?.rows = $0 }
        CrystalStore.sharedInstance.fetchCrystals()
        
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(CrystalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
    func crystalAtIndex(indexPath: NSIndexPath) -> Crystal {
        return CrystalStore.sharedInstance.visibleCrystals.value[indexPath.row]
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CrystalStore.sharedInstance.visibleCrystals.value.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CrystalCollectionViewCell
        let crystal = crystalAtIndex(indexPath)
        let viewModel = CrystalCellViewModel(crystal: crystal)
        cell.viewModel = viewModel
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let collectionView = self.collectionView,
            cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? CrystalCollectionViewCell,
            image = cell.imageView.image else { return }
        let crystal = crystalAtIndex(indexPath)
        let viewModel = CrystalDetailViewModel(crystal: crystal, bootstrapImage: image)
        let detail = CrystalDetailViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: detail)
        self.presentViewController(nav, animated: true, completion: nil)
    }

}
