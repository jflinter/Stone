//
//  Crystal.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation

typealias Category = String

typealias Crystal = Product

extension Product {
    var categories: Set<Category> {
        return Set(self.caption.characters.split{$0 == ","}.map(String.init).map({$0.lowercaseString}))
    }
}
