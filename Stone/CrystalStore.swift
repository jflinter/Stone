//
//  CrystalStore.swift
//  Stone
//
//  Created by Jack Flintermann on 10/26/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation
import BrightFutures
import Alamofire

struct CrystalStore {
    
    static let baseURL = "https://powerful-dusk-1713.herokuapp.com/products"
    
    static func fetchCrystals() -> Future<[Crystal], NSError> {
        let promise = Promise<[Crystal], NSError>()
        Alamofire.request(.GET, CrystalStore.baseURL).responseCollection { (response: Response<[Crystal], NSError>) in
            if let value = response.result.value {
                promise.success(value)
            } else if let error = response.result.error {
                promise.failure(error)
            }
        }
        return promise.future
    }
    
}
