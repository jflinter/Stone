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
    
    private let allCrystals: Observable<[Crystal]> = Observable<[Crystal]>([])
    
    var visibleCrystals: EventProducer<[Crystal]> {
        let filters = self.selectedCategory.combineLatestWith(self.searchQuery)
        return self.allCrystals.combineLatestWith(filters).map { (crystals: [Crystal], filters: (Category?, String)) -> [Crystal] in
            var filtered = crystals
            if let category = filters.0 {
                filtered = crystals.filter { $0.categories.contains(category) }
            }
            let searchQuery = filters.1
            filtered = TextSuggest(contents: filtered).suggestResults(searchQuery)
            if !searchQuery.isEmpty {
                filtered = Array(filtered.prefix(4))
            }
            return filtered
        }
    }
    var allCategories: Set<Category> {
        return Set(self.allCrystals.value.map({$0.categories}).flatten())
    }
    var selectedCategory: Observable<Category?> = Observable(nil)
    var searchQuery: Observable<String> = Observable("")
    
    func fetchCrystals() -> Future<[Crystal], NSError> {
        let promise = Promise<[Crystal], NSError>()
        Alamofire.request(.GET, API.baseURL + "products").responseCollection { (response: Response<[Crystal], NSError>) in
            if let value = response.result.value {
                self.allCrystals.value = value.filter { !$0.imageURLs.isEmpty }
                promise.success(value)
            } else if let error = response.result.error {
                promise.failure(error)
            }
        }
        return promise.future
    }
    
}

extension Crystal: Searchable {
    var asSearchQuery: String {
        return self.name
    }
}
