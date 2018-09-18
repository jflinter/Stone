//
//  TextSuggest.swift
//  Stone
//
//  Created by Jack Flintermann on 3/20/16.
//  Copyright © 2016 Stone. All rights reserved.
//

protocol Searchable {
    var asSearchQuery: String { get }
}

struct TextSuggest<T: Searchable> {
    let contents: [T]
    
    func suggestResults(_ query: String) -> [T] {
        let distances: [(T, Int)] = contents.reduce([]) { accum, c in
            let words = c.asSearchQuery.split{$0 == " "}.map(String.init) + [c.asSearchQuery]
            let distances: [Int] = words.map { word in
                let prefix = String(word.prefix(min(query.count, word.count)))
                return levenshtein(prefix, query)
            }
            guard let minDistance = distances.min() else { return accum }
            return accum + [(c, minDistance)]
        }
        return distances.sorted {
                $0.1 < $1.1
            }.filter {
                return $0.1 < 2
            }.map {
                $0.0
        }
    }
    
    func levenshtein(_ s: String, _ t: String) -> Int {
        var results = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: s.count + 1), count: t.count + 1)
        
        for i in 0...t.count {
            results[i][0] = i
        }
        for i in 0...s.count {
            results[0][i] = i
        }
        
        for j in 1..<t.count + 1 {
            for i in 1..<s.count + 1 {
                let q = s[s.index(s.startIndex, offsetBy: i - 1)]
                let p = t[t.index(t.startIndex, offsetBy: j - 1)]
                let substitutionCost = q == p ? 0 : 1
                
                let a: Int = (results[j-1][i]) + 1
                let b: Int = (results[j][i-1]) + 1
                let c: Int = (results[j-1][i-1]) + substitutionCost
                results[j][i] = [a, b, c].min()!
            }
        }
        
        return results[t.count][s.count]
    }
}
