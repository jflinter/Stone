//
//  VibesView.swift
//  Stone
//
//  Created by Jack Flintermann on 4/25/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit
import Dwifft

protocol CrystalVibesViewDelegate {
    func crystalVibesViewDidSelectVibe(vibe: Vibe)
}

class CrystalVibesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var diffCalculator: CollectionViewDiffCalculator<Vibe>?
    
    var delegate: CrystalVibesViewDelegate?
    
    init(availableVibes: [Vibe]) {
        super.init(frame: CGRectZero)
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: self.collectionView, initialRows: availableVibes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSizeMake((self.frame.size.width / 3) - 10, 45)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.itemSize = CGSize(width: 70, height: 45)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsZero
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.scrollEnabled = false
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
        cell.selectedColor = UIColor.stoneLightBlue
        cell.unselectedColor = UIColor.stoneLightBlue
        guard let diffCalculator = self.diffCalculator else { return cell }
        let vibe = diffCalculator.rows[indexPath.row]
        cell.image = vibe.image
        cell.title = vibe.rawValue.uppercaseString
        cell.highlightsSelection = false
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let diffCalculator = self.diffCalculator else { return }
        let vibe = diffCalculator.rows[indexPath.row]
        self.delegate?.crystalVibesViewDidSelectVibe(vibe)
    }
    
}
