//
//  Crystal.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation

typealias Crystal = Product

extension Product {
    var vibes: Set<Vibe> {
        return Set(self.caption.characters.split{$0 == ","}.map(String.init).flatMap({ Vibe(rawValue: $0.lowercased()) }))
    }
}
