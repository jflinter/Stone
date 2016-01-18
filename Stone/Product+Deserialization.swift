//
//  Crystal+Deserialization.swift
//  Stone
//
//  Created by Jack Flintermann on 11/23/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation
import Alamofire

extension SKU: ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        guard let json = representation as? [String: AnyObject],
        id = json["id"] as? String,
        currency = json["currency"] as? String,
        amount = json["price"] as? Int
            else {
                return nil
        }
        self.id = id
        self.currency = currency
        self.amount = amount
    }
    
    var asDictionary: [String: AnyObject] {
        return [
            "parent": self.id,
        ]
    }
}

extension Product: ResponseCollectionSerializable, ResponseObjectSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Crystal]? {
        guard let json = representation as? [String: AnyObject],
        results = json["data"] as? [[String: AnyObject]] else { return nil }
        return results.flatMap { object in
            return Product(response: response, representation: object)
        }
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        guard let object = representation as? [String: AnyObject],
            name = object["name"] as? String,
            description = object["description"] as? String,
            productId = object["id"] as? String,
            imageURLStrings = object["images"] as? [String],
            caption = object["caption"] as? String,
            skuData = object["skus"]?["data"] as? [AnyObject]
            else { return nil }
        let imageURLs = imageURLStrings.flatMap(NSURL.init)
        let skus = skuData.flatMap { data in
            return SKU(response: response, representation: data)
        }
        self.name = name
        self.description = description
        self.productID = productId
        self.imageURLs = imageURLs
        self.caption = caption
        self.skus = skus
    }
}
