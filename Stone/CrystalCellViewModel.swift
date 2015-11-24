//
//  CrystalCellViewModel.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

struct CrystalCellViewModel {
    let crystal: Crystal
    let imageURLs: [NSURL]
    let descriptionText: String?
    var detailShown: Bool = false
    
    init(crystal: Crystal) {
        self.crystal = crystal
        self.descriptionText = crystal.description
        self.imageURLs = crystal.imageURLs.flatMap { $0.imgixURL() }
    }
}
