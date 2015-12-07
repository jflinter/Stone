//
//  Crystal.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation

typealias Category = String

struct Crystal: Equatable {
    let name: String
    let description: String?
    let productID: String
    let imageURLs: [NSURL]
    private let caption: String
    var categories: Set<Category> {
        return Set(self.caption.characters.split{$0 == ","}.map(String.init).map({$0.lowercaseString}))
    }
    
    init(name: String, description: String, productID: String, imageURLs: [NSURL], caption: String) {
        self.name = name
        self.description = description
        self.productID = productID
        self.imageURLs = imageURLs
        self.caption = caption
    }
}

func ==(lhs: Crystal, rhs: Crystal) -> Bool {
    return lhs.productID == rhs.productID
}
