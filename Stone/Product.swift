//
//  Product.swift
//  Stone
//
//  Created by Jack Flintermann on 2/18/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import Foundation

struct SKU {
    let amount: Int
    let currency: String
    let id: String
}

struct Product: Equatable {
    let name: String
    let description: String?
    let productID: String
    let imageURLs: [NSURL]
    let caption: String
    let skus: [SKU]
    init(name: String, description: String, productID: String, imageURLs: [NSURL], caption: String, skus: [SKU]) {
        self.name = name
        self.description = description
        self.productID = productID
        self.imageURLs = imageURLs
        self.caption = caption
        self.skus = skus
    }
}

func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.productID == rhs.productID
}
