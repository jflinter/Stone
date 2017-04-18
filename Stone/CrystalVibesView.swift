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
    func crystalVibesViewDidSelectVibe(_ vibe: Vibe)
}

class CrystalVibesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var diffCalculator: SingleSectionCollectionViewDiffCalculator<Vibe>?
    
    var delegate: CrystalVibesViewDelegate?
    
    init(availableVibes: [Vibe]) {
        super.init(frame: CGRect.zero)
        self.diffCalculator = SingleSectionCollectionViewDiffCalculator(collectionView: self.collectionView, initialItems: availableVibes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: (self.frame.size.width / 3) - 10, height: 45)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 70, height: 45)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets.zero
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(VibeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        return collectionView
    }()
    
    func resetSelection() {
        self.collectionView.indexPathsForSelectedItems?.forEach { indexPath in
            self.collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diffCalculator?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VibeCollectionViewCell
        cell.selectedColor = UIColor.stoneLightBlue
        cell.unselectedColor = UIColor.stoneLightBlue
        guard let diffCalculator = self.diffCalculator else { return cell }
        let vibe = diffCalculator.items[indexPath.item]
        cell.image = vibe.image
        cell.title = vibe.rawValue.uppercased()
        cell.highlightsSelection = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diffCalculator = self.diffCalculator else { return }
        let vibe = diffCalculator.items[indexPath.item]
        self.delegate?.crystalVibesViewDidSelectVibe(vibe)
    }
    
}
