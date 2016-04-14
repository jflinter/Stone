//
//  AnnotatedImage.swift
//  Stone
//
//  Created by Jack Flintermann on 3/20/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit
import Hue

class ColorCache {
    
    static let sharedInstance = ColorCache()
    private let cacheKey = "jrfcolorcache2"
    private var cache: [String: [String]]
    
    init() {
        if let cache = (NSUserDefaults.standardUserDefaults().dictionaryForKey(cacheKey) as? [String: [String]]) {
            self.cache = cache
        } else {
            self.cache = [:]
        }
    }
    
    func colorsForImage(image: UIImage, url: NSURL) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        if let strings = self.cache[url.absoluteString] {
            return (UIColor.hex(strings[0]), UIColor.hex(strings[1]), UIColor.hex(strings[2]), UIColor.hex(strings[3]))
        }
        let colors = image.colors()
        self.setColors(colors, forURL: url)
        return colors
    }
    
    private func setColors(colors: (UIColor, UIColor, UIColor, UIColor), forURL: NSURL) {
        let strings = [colors.0.hex(), colors.1.hex(), colors.2.hex(), colors.3.hex()]
        self.cache[forURL.absoluteString] = strings
        NSUserDefaults.standardUserDefaults().setObject(self.cache, forKey: cacheKey)
    }
    
    func setImage(image: UIImage, forURL: NSURL) {
        self.setColors(image.colors(), forURL: forURL)
    }
    
}

struct AnnotatedImage {
    let backgroundColor: UIColor
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let detailColor: UIColor
    let image: UIImage
    init(image: UIImage, imageURL: NSURL) {
        let colors = ColorCache.sharedInstance.colorsForImage(image, url: imageURL)
        self.image = image
        self.backgroundColor = colors.background
        self.primaryColor = colors.primary
        self.secondaryColor = colors.secondary
        self.detailColor = colors.detail
    }
}
