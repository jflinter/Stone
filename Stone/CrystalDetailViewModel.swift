//
//  CrystalDetailViewModel.swift
//  Stone
//
//  Created by Jack Flintermann on 12/5/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import Iris
import PassKit
import Stripe
import Hue

struct CrystalDetailViewModel {
    private let crystal: Crystal
    let name: String
    let imageURLs: [NSURL]
    let descriptionText: NSAttributedString
    let bootstrapImage: AnnotatedImage
    let skus: [SKU]
    
    init(crystal: Crystal, bootstrapImage: AnnotatedImage) {
        self.crystal = crystal
        self.name = crystal.name
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 20.0
        paragraphStyle.minimumLineHeight = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        let attributedString = NSAttributedString(string: crystal.description ?? "", attributes: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: UIFont(name: "Brown-Light", size: 14) ?? UIFont.systemFontOfSize(14)
        ])
        self.descriptionText = attributedString
        self.imageURLs = crystal.imageURLs
        self.bootstrapImage = bootstrapImage
        self.skus = crystal.skus
    }
    
    func imageURLForSize(size: CGSize) -> NSURL? {
        let options = ImageOptions(format: .JPEG, width: size.width, height: size.height, scale: UIScreen.mainScreen().scale, fit: .Clip, crop: nil)
        return self.imageURLs.first?.imgixURL(imageOptions: options)
    }
}
