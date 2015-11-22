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
    let scrollView = UIScrollView()
    let textView = UITextView()
    
    var viewModel: CrystalCellViewModel? {
        didSet {
            self.imageView.image = viewModel?.image
            self.textView.text = viewModel?.descriptionText
            self.textView.hidden = !(viewModel?.detailShown ?? false)
            self.scrollView.userInteractionEnabled = viewModel?.detailShown ?? false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scrollView.userInteractionEnabled = false
        self.addSubview(self.scrollView)
        self.textView.font = UIFont.systemFontOfSize(24)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        let edgeSize = min(self.bounds.size.width, self.bounds.size.height)
        self.imageView.frame = CGRectMake(0, 0, edgeSize, edgeSize)
        let maxSize = CGSizeMake(self.bounds.size.width, CGFloat.max)
        let boundingSize = self.textView.sizeThatFits(maxSize)
        textView.frame = CGRectMake(0, edgeSize, self.bounds.width, boundingSize.height)
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, edgeSize + boundingSize.height)

    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        self.layoutIfNeeded()
    }
    
}
