//
//  Order+Deserialization.swift
//  Stone
//
//  Created by Jack Flintermann on 12/21/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

extension LineItem: ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        guard let json = representation as? [String: AnyObject],
        amount = json["amount"] as? Int,
        currency = json["currency"] as? String,
        description = json["description"] as? String
            else { return nil }
        self.name = description
        self.amount = amount
        self.currency = currency
    }
}

extension Order: ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        guard let json = representation as? [String: AnyObject],
            id = json["id"] as? String,
            items = json["items"] as? [AnyObject]
            else { return nil }
        self.id = id
        self.lineItems = items.flatMap({ item in
            return LineItem(response: response, representation: item)
        })
    }
}
//
//{
//    "id": "or_17G0MA2eZvKYlo2CVjGrNuYE",
//    "object": "order",
//    "amount": 499,
//    "application": null,
//    "application_fee": null,
//    "charge": null,
//    "created": 1449638354,
//    "currency": "usd",
//    "customer": null,
//    "email": "jenny@ros.en",
//    "items": [
//    {
//    "object": "order_item",
//    "amount": 499,
//    "currency": "usd",
//    "description": "test name",
//    "parent": "TEST-SKU-FcgCGGKEpMvrwVwc",
//    "quantity": 1,
//    "type": "sku"
//    },
//    {
//    "object": "order_item",
//    "amount": 0,
//    "currency": "usd",
//    "description": "Taxes (included)",
//    "parent": null,
//    "quantity": null,
//    "type": "tax"
//    },
//    {
//    "object": "order_item",
//    "amount": 0,
//    "currency": "usd",
//    "description": "Free shipping",
//    "parent": "ship_free-shipping",
//    "quantity": null,
//    "type": "shipping"
//    }
//    ],
//    "livemode": false,
//    "metadata": {
//    },
//    "selected_shipping_method": "ship_free-shipping",
//    "shipping": {
//        "address": {
//            "city": "Anytown",
//            "country": "US",
//            "line1": "1234 Main Street",
//            "line2": null,
//            "postal_code": "123456",
//            "state": null
//        },
//        "name": "Jenny Rosen",
//        "phone": "6504244242"
//    },
//    "shipping_methods": [
//    {
//    "id": "ship_free-shipping",
//    "amount": 0,
//    "currency": "usd",
//    "description": "Free shipping"
//    }
//    ],
//    "status": "created",
//    "updated": 1449638354
//}