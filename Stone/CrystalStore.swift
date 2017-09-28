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
import ReactiveKit

class CrystalStore {
    
    fileprivate let allCrystals: Observable<[Crystal]> = Observable<[Crystal]>([])
    
    var visibleCrystals: ReactiveKit.Signal<[Crystal], ReactiveKit.NoError> {
        let filters = self.selectedVibe.combineLatest(with: self.searchQuery)
        return self.allCrystals.combineLatest(with: filters).map { (crystals: [Crystal], filters: (Vibe?, String)) -> [Crystal] in
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
    
    var allVibes: ReactiveKit.Signal<Set<Vibe>, ReactiveKit.NoError> {
        return self.allCrystals.map { (crystals: [Crystal]) -> Set<Vibe> in
            return Set(crystals.map({ $0.vibes }).joined())
        }
    }
    var selectedVibe: Observable<Vibe?> = Observable(nil)
    var searchQuery: Observable<String> = Observable("")
    
    var crystalPromise: Promise<[Crystal], ReactiveKit.NoError> = {
        let promise = Promise<[Crystal], ReactiveKit.NoError>()
        promise.success([])
        return promise
    }()
    func fetchCrystals() -> Future<[Crystal], ReactiveKit.NoError> {
        if (self.crystalPromise.future.isCompleted) {
            self.crystalPromise = Promise<[Crystal], ReactiveKit.NoError>()
            makeRequest(0) { [weak self] crystals in
                self?.crystalPromise.success(crystals)
            }
        }
        return self.crystalPromise.future
    }
    
    func makeRequest(_ afterDelay: Foundation.TimeInterval, completion: @escaping ([Crystal]) -> Void) {
        Alamofire.request("https://s3-us-west-1.amazonaws.com/stone-products/products-test.json", method: .get).responseCollection { (response: DataResponse<[Crystal]>) in
            if let value = response.result.value {
                self.allCrystals.value = value.filter { !$0.imageURLs.isEmpty }
                completion(value)
                
            } else if let _ = response.result.error {
                let delay: Foundation.TimeInterval
                if (afterDelay <= 0) {
                    delay = 1
                } else {
                    delay = afterDelay * 2
                }
                let delayTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
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
