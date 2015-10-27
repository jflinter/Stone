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
    let image: UIImage?
    
    init(crystal: Crystal) {
        self.crystal = crystal
        if let imageName = crystal.imageName {
            self.image = UIImage(named: imageName)
        } else {
            self.image = nil
        }
        
    }
}
