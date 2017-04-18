//
//  CrystalCellViewModel.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import Iris

struct CrystalCellViewModel: Equatable {
    let crystal: Crystal
    let imageURL: URL?
    
    init(crystal: Crystal) {
        self.crystal = crystal
        self.imageURL = crystal.imageURLs.first
    }
    
    func imageURLForSize(_ size: CGSize) -> URL? {
        let options = ImageOptions(format: .jpeg, width: size.width, height: size.height, scale: UIScreen.main.scale, fit: .clip, crop: nil)
        return self.imageURL?.imgixURL(imageOptions: options)
    }
}

func ==(lhs: CrystalCellViewModel, rhs: CrystalCellViewModel) -> Bool {
    return lhs.crystal == rhs.crystal
}
