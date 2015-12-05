//
//  CrystalCellViewModel.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import Iris

struct CrystalCellViewModel {
    let crystal: Crystal
    let imageURL: NSURL?
    
    init(crystal: Crystal) {
        self.crystal = crystal
        self.imageURL = crystal.imageURLs.first
    }
    
    func imageURLForSize(size: CGSize) -> NSURL? {
        let options = ImageOptions(format: .JPEG, width: size.width, height: size.height, scale: UIScreen.mainScreen().scale, fit: .Clip, crop: nil)
        return self.imageURL?.imgixURL(imageOptions: options)
    }
}
