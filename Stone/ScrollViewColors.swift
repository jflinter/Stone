//
//  ScrollViewColors.swift
//  Stone
//
//  Created by Jack Flintermann on 8/19/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setScrollIndicatorColor(color: UIColor) {
        
        for view in self.subviews {
            if view.isKindOfClass(UIImageView.self),
                let imageView = view as? UIImageView,
                let image = imageView.image  {
                
                imageView.tintColor = color
                imageView.image = image.imageWithRenderingMode(.AlwaysTemplate)
            }
        }
    }
}
