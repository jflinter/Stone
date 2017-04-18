//
//  VibesView.swift
//  Stone
//
//  Created by Jack Flintermann on 4/25/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit
import Dwifft
import ReactiveKit

class VibesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    var diffCalculator: SingleSectionCollectionViewDiffCalculator<Vibe>?
    
    let crystalStore: CrystalStore?
    
    var highlightsSelection: Bool = true
    
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        super.init(frame: CGRect.zero)
        self.diffCalculator = SingleSectionCollectionViewDiffCalculator(collectionView: self.collectionView)
        let _ = crystalStore.allVibes.observeNext { vibes in
            self.diffCalculator?.items = Array(vibes).sorted(by: { (a, b) -> Bool in
                return a.rawValue < b.rawValue
            })
        }
        let _ = crystalStore.selectedVibe.observe { value in
            if case .next(let vibe) = value {
                if let vibe = vibe {
                    guard let index = self.diffCalculator?.items.index(of: vibe) else { return }
                    let indexPath = IndexPath(item: index, section: 0)
                    if !(self.collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false) {
                        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                    }
                }
            }
        }
    }
    
    init(availableVibes: [Vibe]) {
        self.crystalStore = nil
        super.init(frame: CGRect.zero)
        self.diffCalculator = SingleSectionCollectionViewDiffCalculator(collectionView: self.collectionView, initialItems: availableVibes)
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
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 45)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
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
        return self.diffCalculator!.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VibeCollectionViewCell
        let vibe = diffCalculator!.items[indexPath.item]
        cell.image = vibe.image
        cell.title = vibe.rawValue.uppercased()
        cell.highlightsSelection = self.highlightsSelection
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vibe = diffCalculator!.items[indexPath.item]
        self.crystalStore?.selectedVibe.value = vibe
    }

}
