//
//  CrystalDetailViewModel.swift
//  Stone
//
//  Created by Jack Flintermann on 12/5/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import Iris
import PassKit

struct CrystalDetailViewModel {
    fileprivate let crystal: Crystal
    let name: String
    let subtitle: String
    let imageURLs: [URL]
    let descriptionText: NSAttributedString
    let bootstrapImage: UIImage
    let skus: [SKU]
    let vibes: [Vibe]
    
    init(crystal: Crystal, bootstrapImage: UIImage) {
        self.crystal = crystal
        self.name = crystal.name
        let lines = crystal.description?.components(separatedBy: "\n") ?? [""]
        self.subtitle = lines[0]
        self.vibes = Array(crystal.vibes)
        let description = lines.dropFirst().joined(separator: "\n").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 20.0
        paragraphStyle.minimumLineHeight = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        let attributedString = NSAttributedString(string: description, attributes: convertToOptionalNSAttributedStringKeyDictionary([
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Brown-Light", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]))
        self.descriptionText = attributedString
        self.imageURLs = crystal.imageURLs
        self.bootstrapImage = bootstrapImage
        self.skus = crystal.skus
    }
    
    func imageURLForSize(_ size: CGSize) -> URL? {
        let options = ImageOptions(format: .jpeg, width: size.width, height: size.height, scale: UIScreen.main.scale, fit: .clip, crop: nil)
        return self.imageURLs.first?.imgixURL(imageOptions: options)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
