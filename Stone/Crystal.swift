//
//  Product.swift
//  Stone
//
//  Created by Jack Flintermann on 2/18/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import Foundation

struct Crystal: Equatable, Codable {
    let name: String
    let tagline: String
    let description: String
    let id: String
    let imageURL: URL
    let url: URL
    let vibes: Set<Vibe>
    
    enum CodingKeys: String, CodingKey {
        case name
        case tagline
        case description
        case id
        case url
        case imageURL = "image_url"
        case vibes
    }
}

func ==(lhs: Crystal, rhs: Crystal) -> Bool {
    return lhs.id == rhs.id
}
