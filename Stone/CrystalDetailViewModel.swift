//
//  CrystalDetailViewModel.swift
//  Stone
//
//  Created by Jack Flintermann on 12/5/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import Iris

struct CrystalDetailViewModel {
    private let crystal: Crystal
    let name: String
    let imageURLs: [NSURL]
    let descriptionText: String?
    let bootstrapImage: UIImage
    
    init(crystal: Crystal, bootstrapImage: UIImage) {
        self.crystal = crystal
        self.name = crystal.name
        self.descriptionText = crystal.description
        self.imageURLs = crystal.imageURLs
        self.bootstrapImage = bootstrapImage
    }
    
    func imageURLForSize(size: CGSize) -> NSURL? {
        let options = ImageOptions(format: .JPEG, width: size.width, height: size.height, scale: UIScreen.mainScreen().scale, fit: .Clip, crop: nil)
        return self.imageURLs.first?.imgixURL(imageOptions: options)
    }
}
