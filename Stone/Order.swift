//
//  Order.swift
//  Stone
//
//  Created by Jack Flintermann on 12/21/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

struct Order {
    let id: String
    let lineItems: [LineItem]
}

struct LineItem {
    let name: String
    let amount: Int
    let currency: String
}
