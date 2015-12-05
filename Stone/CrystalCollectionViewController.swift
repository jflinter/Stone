//
//  CrystalCollectionViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CrystalCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var crystals: [Crystal] = []
    
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
        CrystalStore.fetchCrystals().onSuccess { crystals in
            self.crystals = crystals
            self.collectionView?.reloadData()
        }.onFailure { error in
            print(error)
        }
        let imageView = UIImageView(image: UIImage(named: "noun_315_cc"))
        imageView.frame = CGRectMake(0, 0, 30, 30)
        imageView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imageView
        guard let collectionView = collectionView, flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(CrystalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.crystals.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CrystalCollectionViewCell
        let crystal = self.crystals[indexPath.row]
        let viewModel = CrystalCellViewModel(crystal: crystal)
        cell.viewModel = viewModel
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let crystal = self.crystals[indexPath.row]
        let detail = CrystalDetailViewController(crystal: crystal)
        let nav = UINavigationController(rootViewController: detail)
        self.presentViewController(nav, animated: true, completion: nil)
    }

}
