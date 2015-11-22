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
    let descriptionText: String
    var detailShown: Bool = false
    
    init(crystal: Crystal) {
        self.crystal = crystal
        if let imageName = crystal.imageName {
            self.image = UIImage(named: imageName)
        } else {
            self.image = nil
        }
        self.descriptionText = "Rose quartz is a type of quartz which exhibits a pale pink to rose red hue. The color is usually considered as due to trace amounts of titanium, iron, or manganese, in the massive material. Some rose quartz contains microscopic rutile needles which produces an asterism in transmitted light. Recent X-ray diffraction studies suggest that the color is due to thin microscopic fibers of possibly dumortierite within the massive quartz.[12] Additionally, there is a rare type of pink quartz (also frequently called crystalline rose quartz) with color that is thought to be caused by trace amounts of phosphate or aluminium. The color in crystals is apparently photosensitive and subject to fading. The first crystals were found in a pegmatite found near Rumford, Maine, USA and in Minas Gerais, Brazil.[13]"
    }
}
