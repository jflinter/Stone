//
//  CrystalCollectionViewCell.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import AlamofireImage

class CrystalCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    var viewModel: CrystalCellViewModel? {
        didSet {
            self.imageView.image = nil
            if let url = viewModel?.imageURLForSize(self.frame.size) {
                self.imageView.af_setImageWithURL(url, imageTransition: .CrossDissolve(0.4))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.contentMode = .ScaleAspectFit
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
