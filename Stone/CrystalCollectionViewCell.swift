//
//  CrystalCollectionViewCell.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import AlamofireImage
import PaintBucket

struct BackgroundRemovingImageFilter: ImageFilter {
    
    let url: NSURL?
    
    var filter: Image -> Image {
        return { image in
            let transformed = image.pbk_imageByReplacingColorAt(1, 1, withColor: UIColor.clearColor(), tolerance: 320, antialias: false)
            if let url = self.url {
                ColorCache.sharedInstance.setImage(image, forURL: url)
            }
            return transformed
        }
    }
}

class CrystalCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    var viewModel: CrystalCellViewModel? {
        didSet {
            self.imageView.image = nil
            if let url = viewModel?.imageURLForSize(CGRectIntegral(self.frame).size) {
                self.imageView.af_setImageWithURL(url, placeholderImage: nil, filter: BackgroundRemovingImageFilter(url: url), imageTransition: .CrossDissolve(0.4), runImageTransitionIfCached: false, completion: nil)
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
