//
//  Crystal.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation

struct Crystal {
    let name: String
    let description: String?
    let productID: String
    let imageName: String?
    
    init(name: String, description: String, productID: String, imageName: String?) {
        self.name = name
        self.description = description
        self.productID = productID
        self.imageName = imageName
    }
}