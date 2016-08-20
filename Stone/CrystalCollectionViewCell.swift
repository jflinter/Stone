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
    
    var filter: Image -> Image {
        return { image in
            let transformed = image.pbk_imageByReplacingColorAt(1, 1, withColor: UIColor.clearColor(), tolerance: 320, antialias: false)
            return transformed
        }
    }
}

class CrystalCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let loadingView = CrystalLoadingView()
    
    var viewModel: CrystalCellViewModel? {
        didSet {
//            let colors = [
//                UIColor(red:0.992,  green:0.714,  blue:0.427, alpha:1),
//                UIColor(red:0.996,  green:0.718,  blue:0.875, alpha:1),
//                UIColor(red:0.839,  green:0.741,  blue:0.992, alpha:1),
//                UIColor(red:0.996,  green:0.902,  blue:0.439, alpha:1),
//            ]
            let colors = [
                UIColor.stoneDarkBlue,
                UIColor.stoneLightBlue,
                UIColor.stoneDarkOrange,
                UIColor.stoneLightOrange,
            ]
            let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
            let color = colors[randomIndex]
            
            self.imageView.image = nil
            let size = CGRectIntegral(self.bounds).size
            self.loadingView.tintColor = color
            if let url = viewModel?.imageURLForSize(size) {
                self.imageView.af_setImageWithURL(url, placeholderImage: nil, filter: nil, imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .ScaleAspectFit
        self.loadingView.frame = self.bounds
        self.addSubview(self.loadingView)
        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override var highlighted: Bool {
        set {
            UIView.animateWithDuration(0.5, delay: newValue ? 0 : 0.1, usingSpringWithDamping: 17.5, initialSpringVelocity: 0, options: [], animations: {
                self.imageView.transform = newValue ? CGAffineTransformMakeScale(0.8, 0.8) : CGAffineTransformIdentity
                }, completion: nil)
            super.highlighted = newValue
        }
        get {
            return super.highlighted
        }
    }
    
}
