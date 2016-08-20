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
import Result

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
            if !searchQuery.isEmpty {
                filtered = TextSuggest(contents: filtered).suggestResults(searchQuery)
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
    
    var crystalPromise: Promise<[Crystal], NoError> = {
        let promise = Promise<[Crystal], NoError>()
        promise.success([])
        return promise
    }()
    func fetchCrystals() -> Future<[Crystal], NoError> {
        if (self.crystalPromise.future.isCompleted) {
            self.crystalPromise = Promise<[Crystal], NoError>()
            makeRequest(0) { [weak self] crystals in
                self?.crystalPromise.success(crystals)
            }
        }
        return self.crystalPromise.future
    }
    
    func makeRequest(afterDelay: NSTimeInterval, completion: [Crystal] -> Void) {
        Alamofire.request(.GET, "https://s3-us-west-1.amazonaws.com/stone-products/products.json").responseCollection { (response: Response<[Crystal], NSError>) in
            if let value = response.result.value {
                self.allCrystals.value = value.filter { !$0.imageURLs.isEmpty }
                completion(value)
                
            } else if let _ = response.result.error {
                let delay: NSTimeInterval
                if (afterDelay <= 0) {
                    delay = 1
                } else {
                    delay = afterDelay * 2
                }
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.makeRequest(delay, completion: completion)
                }
            }
        }
    }
    
}

extension Crystal: Searchable {
    var asSearchQuery: String {
        return self.name
    }
}
