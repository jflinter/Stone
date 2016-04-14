//
//  CrystalBackdropView.swift
//  Stone
//
//  Created by Jack Flintermann on 3/21/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit
import AGGeometryKit
import CoreImage

class CrystalBackdropView: UIView {

    let colors: [UIColor]
    let colorViews: [UIView]
    
    init(colors: [UIColor]) {
        
        self.colors = Array(colors.prefix(2))
        self.colorViews = self.colors.enumerate().map { i, color in
            let view = UIView()
            view.backgroundColor = color
            view.layer.anchorPoint = CGPoint.zero
            view.layer.opacity = pow(0.8, Float(i + 2))
            return view
        }
        super.init(frame: CGRectZero)
        self.colorViews.forEach({ self.addSubview($0) })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.skewLayers()
    }
    
    func skewLayers() {
        self.colorViews.forEach { view in
            view.frame = self.bounds
            let layer = view.layer
            
            var quad = AGKQuadMakeWithCGSize(CGSizeMake(1, 1))
            
            let h = self.bounds.height
            let w = self.bounds.width
            
            let tl = drand48() * 0.2
            let bl = (drand48() * 0.2) + 0.8
            quad.tl.y = CGFloat(tl)
            quad.bl.y = CGFloat(bl)

            let tr = drand48() * 0.4
            let br = (drand48() * 0.4) + 0.6
            quad.tr.y = CGFloat(tr)
            quad.br.y = CGFloat(br)
            
            let trx = (drand48() * 0.2) + 1.1
            let brx = (drand48() * 0.4) + 0.6
            quad.tl.x = 0
            quad.bl.x = 0
            quad.tr.x = CGFloat(trx)
            quad.br.x = CGFloat(brx)
            
            let flipX = arc4random_uniform(2) == 0
            let flipY = arc4random_uniform(2) == 0
            if flipX {
                quad = AGKQuadMirrorHorizontalAroundX(quad, 0.5)
            }
            if flipY {
                quad = AGKQuadMirrorVerticalAroundY(quad, 0.5)
            }
            
            quad = AGKQuadApplyCGAffineTransform(quad, CGAffineTransformMakeScale(w, h))
            
            layer.quadrilateral = quad
        }
    }
    
}
