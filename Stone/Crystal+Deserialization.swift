//
//  Crystal+Deserialization.swift
//  Stone
//
//  Created by Jack Flintermann on 11/23/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation
import Alamofire

extension Crystal: ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Crystal]? {
        guard let json = representation as? [String: AnyObject],
        results = json["data"] as? [AnyObject] else { return nil }
        return results.flatMap { object in
            guard let name = object["name"] as? String,
                description = object["description"] as? String,
                productId = object["id"] as? String,
                imageURLStrings = object["images"] as? [String]
            else {
                    return nil
            }
            let imageURLs = imageURLStrings.flatMap(NSURL.init)
            return Crystal(name: name, description: description, productID: productId, imageURLs: imageURLs)
        }
    }
}
