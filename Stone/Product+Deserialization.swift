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
    init?(response: HTTPURLResponse, representation: Any) {
        guard let json = representation as? [String: Any],
        let id = json["id"] as? String,
        let currency = json["currency"] as? String,
        let amount = json["price"] as? Int
            else {
                return nil
        }
        self.id = id
        self.currency = currency
        self.amount = amount
    }
    
    var asDictionary: [String: Any] {
        return [
            "parent": self.id,
        ]
    }
}

extension Product: ResponseCollectionSerializable, ResponseObjectSerializable {
    static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Crystal]? {
        guard let json = representation as? [[String: Any]] else { return nil }
        return json.flatMap { object in
            return Product(response: response, representation: object)
        }
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard let object = representation as? [String: Any],
            let name = object["name"] as? String,
            let description = object["description"] as? String,
            let productId = object["id"] as? String,
            let imageURLStrings = object["images"] as? [String],
            let caption = object["caption"] as? String,
            let rawSkus = object["skus"] as? [String: Any],
            let skuData = rawSkus["data"] as? [Any]
            else { return nil }
        let imageURLs = imageURLStrings.flatMap(URL.init)
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
