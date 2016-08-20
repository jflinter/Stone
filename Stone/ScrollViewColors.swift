//
//  ScrollViewColors.swift
//  Stone
//
//  Created by Jack Flintermann on 8/19/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit
import PaintBucket

extension UIScrollView {
    func setScrollIndicatorColor(color: UIColor) {
        
        for view in self.subviews {
            if view.isKindOfClass(UIImageView.self),
                let imageView = view as? UIImageView,
                let image = imageView.image  {
                if image.size.width < 5 {
                    imageView.image = Resource.Image.ScrollIndicator.image
                    imageView.layer.cornerRadius = 3
                    imageView.layer.masksToBounds = true
                }
                imageView.superview?.sendSubviewToBack(imageView)
            }
        }
    }
}
