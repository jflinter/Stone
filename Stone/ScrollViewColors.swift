//
//  ScrollViewColors.swift
//  Stone
//
//  Created by Jack Flintermann on 8/19/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setScrollIndicatorColor(_ color: UIColor) {
        
        for view in self.subviews {
            if view.isKind(of: UIImageView.self),
                let imageView = view as? UIImageView,
                let image = imageView.image  {
                if image.size.width < 5 {
                    imageView.image = Resource.Image.ScrollIndicator.image
                    imageView.layer.cornerRadius = 3
                    imageView.layer.masksToBounds = true
                }
                imageView.superview?.sendSubview(toBack: imageView)
            }
        }
    }
}
