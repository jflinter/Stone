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
import Bond

class CrystalStore {
    
    static let baseURL = "https://powerful-dusk-1713.herokuapp.com/products"
    private let allCrystals: Observable<[Crystal]> = Observable<[Crystal]>([])
    
    var visibleCrystals: EventProducer<[Crystal]> {
        return self.allCrystals.combineLatestWith(self.selectedCategory).map { (crystals: [Crystal], category: Category?) -> [Crystal] in
            if let category = category {
                return crystals.filter { $0.categories.contains(category) }
            } else {
                return crystals
            }
        }
    }
    var allCategories: Set<Category> {
        return Set(self.allCrystals.value.map({$0.categories}).flatten())
    }
    var selectedCategory: Observable<Category?> = Observable(nil)
    
    func fetchCrystals() -> Future<[Crystal], NSError> {
        let promise = Promise<[Crystal], NSError>()
        Alamofire.request(.GET, CrystalStore.baseURL).responseCollection { (response: Response<[Crystal], NSError>) in
            if let value = response.result.value {
                self.allCrystals.value = value
                promise.success(value)
            } else if let error = response.result.error {
                promise.failure(error)
            }
        }
        return promise.future
    }
    
}
