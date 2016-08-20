//
//  VibeCollectionViewCell.swift
//  Stone
//
//  Created by Jack Flintermann on 4/25/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

class VibeCollectionViewCell: UICollectionViewCell {
    
    var selectedColor = UIColor.stoneDarkOrange
    var unselectedColor = UIColor.stoneLightBlue
    
    var highlightsSelection: Bool = true

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont(name: "Brown-Light", size: 10)
        label.textColor = self.unselectedColor
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = self.unselectedColor
        self.addSubview(imageView)
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
    
    var title: String? {
        didSet {
            self.label.text = title
        }
    }
    
    override var selected: Bool {
        didSet {
            self.imageView.tintColor = (self.selected && self.highlightsSelection) ? self.selectedColor : self.unselectedColor
            self.label.textColor = self.unselectedColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconHeight = CGRectGetHeight(self.frame) - 13
        let iconWidth = iconHeight
        self.imageView.frame = CGRectMake((self.frame.size.width - iconHeight) / 2, 0, iconWidth, iconHeight)
        self.label.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 3, self.frame.size.width, 10)
    }
    
}
