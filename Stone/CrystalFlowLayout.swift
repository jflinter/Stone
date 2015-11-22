//
//  CrystalFlowLayout.swift
//  Stone
//
//  Created by Jack Flintermann on 10/27/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

class CrystalFlowLayout: UICollectionViewFlowLayout {

    var indexPathsToUpdate: [NSIndexPath] = []
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        var indexPaths: [NSIndexPath] = []
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .Insert:
                indexPaths.append(updateItem.indexPathAfterUpdate)
            case .Delete:
                indexPaths.append(updateItem.indexPathBeforeUpdate)
            case .Move:
                indexPaths.append(updateItem.indexPathBeforeUpdate)
                indexPaths.append(updateItem.indexPathAfterUpdate)
            default:
                break
            }
        }
        self.indexPathsToUpdate = indexPaths
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        if self.indexPathsToUpdate.contains(itemIndexPath) {
            attributes?.alpha = 0
        }
        return attributes
    }
    
}
