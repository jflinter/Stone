//
//  CrystalStore.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation

struct CrystalStore {
    static var allCrystals: [Crystal] = {
        guard let path = NSBundle.mainBundle().pathForResource("products", ofType: "json"),
            data = NSData(contentsOfFile: path) else { return [] }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [AnyObject] ?? []
            return json.flatMap { object in
                guard let name = object["name"] as? String, description = object["description"] as? String, productId = object["id"] as? String else { return nil }
                return Crystal(name: name, description: description, productID: productId)
            }
        } catch {
            return []
        }
    }()
}
