//
//  VibeCollectionViewCell.swift
//  Stone
//
//  Created by Jack Flintermann on 4/25/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

class VibeCollectionViewCell: UICollectionViewCell {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
    
}
