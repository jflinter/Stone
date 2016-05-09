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
        let filters = self.selectedVibe.combineLatestWith(self.searchQuery)
        return self.allCrystals.combineLatestWith(filters).map { (crystals: [Crystal], filters: (Vibe?, String)) -> [Crystal] in
            var filtered = crystals
            if let vibe = filters.0 {
                filtered = crystals.filter { $0.vibes.contains(vibe) }
            }
            let searchQuery = filters.1
            filtered = TextSuggest(contents: filtered).suggestResults(searchQuery)
            if !searchQuery.isEmpty {
                filtered = Array(filtered.prefix(4))
            }
            return filtered
        }
    }
    
    var allVibes: EventProducer<Set<Vibe>> {
        return self.allCrystals.map { (crystals: [Crystal]) -> Set<Vibe> in
            return Set(crystals.map({ $0.vibes }).flatten())
        }
    }
    var selectedVibe: Observable<Vibe?> = Observable(nil)
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
