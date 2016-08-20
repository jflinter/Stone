//
//  Checkout.swift
//  Stone
//
//  Created by Jack Flintermann on 12/21/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import BrightFutures
import Alamofire

class Checkout {
    static func createOrder(skus: [SKU]) -> Future<Order, NSError> {
        let promise = Promise<Order, NSError>()
        let parameters: [String: AnyObject] = [
            "items": skus.map({$0.asDictionary}),
            "currency": skus.first?.currency ?? "usd"
        ]
        Alamofire.request(.POST, API.baseURL + "orders", parameters: parameters).responseObject { (response: Response<Order, NSError>) -> Void in
            if let value = response.result.value {
                promise.success(value)
            } else if let error = response.result.error {
                promise.failure(error)
            }
        }
        return promise.future
    }
}
