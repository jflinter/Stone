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

    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Brown-Light", size: 10)
        label.textColor = self.unselectedColor
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = self.unselectedColor
        self.addSubview(imageView)
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var title: String? {
        didSet {
            self.label.text = title
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.imageView.tintColor = (self.isSelected && self.highlightsSelection) ? self.selectedColor : self.unselectedColor
            self.label.textColor = self.unselectedColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconHeight = self.frame.height - 13
        let iconWidth = iconHeight
        self.imageView.frame = CGRect(x: (self.frame.size.width - iconHeight) / 2, y: 0, width: iconWidth, height: iconHeight)
        self.label.frame = CGRect(x: 0, y: self.imageView.frame.maxY + 3, width: self.frame.size.width, height: 10)
    }
    
}
