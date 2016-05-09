//
//  VibesView.swift
//  Stone
//
//  Created by Jack Flintermann on 4/25/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

class VibesView: UIView, UICollectionViewDataSource {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(VibeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        self.addSubview(collectionView)
        return collectionView
    }()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! VibeCollectionViewCell
        cell.image = UIImage(named: "focus")
        return cell
    }

}
