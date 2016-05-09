//
//  VibesView.swift
//  Stone
//
//  Created by Jack Flintermann on 4/25/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit
import Dwifft

class VibesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    var diffCalculator: CollectionViewDiffCalculator<Vibe>?
    
    let crystalStore: CrystalStore
    
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        super.init(frame: CGRectZero)
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: self.collectionView)
        crystalStore.allVibes.observe { vibes in
            self.diffCalculator?.rows = Array(vibes).sort({ (a, b) -> Bool in
                return a.rawValue < b.rawValue
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSize(width: 70, height: 45)
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(VibeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        return collectionView
    }()
    
    func resetSelection() {
        self.collectionView.indexPathsForSelectedItems()?.forEach { indexPath in
            self.collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diffCalculator?.rows.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! VibeCollectionViewCell
        guard let diffCalculator = self.diffCalculator else { return cell }
        let vibe = diffCalculator.rows[indexPath.row]
        cell.image = vibe.image
        cell.title = vibe.rawValue.uppercaseString
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let diffCalculator = self.diffCalculator else { return }
        let vibe = diffCalculator.rows[indexPath.row]
        self.crystalStore.selectedVibe.value = vibe
    }

}
