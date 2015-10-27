//
//  CrystalCollectionViewCell.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

class CrystalCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    var viewModel: CrystalCellViewModel? {
        didSet(newValue) {
            self.imageView.image = viewModel?.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
    
}
