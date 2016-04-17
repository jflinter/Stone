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
    let colorLayers: [CALayer]
    
    static func buildGradientLayer(color1: UIColor, _ color2: UIColor, top: Bool) -> CALayer {
        let grayColor = UIColor(white: 0.9, alpha: 1.0)
        let layer = CAGradientLayer()
        if top {
            layer.colors = [
                grayColor.colorWithAlphaComponent(0).CGColor,
                color1.colorWithAlphaComponent(0.2).CGColor,
                color2.colorWithAlphaComponent(0.4).CGColor
            ]
            layer.locations = [0, 0.75, 1]
            layer.opacity = 0.7
        } else {
            layer.colors = [
                grayColor.colorWithAlphaComponent(0).CGColor,
                color2.colorWithAlphaComponent(0.2).CGColor,
                color1.colorWithAlphaComponent(0.2).CGColor
            ]
            layer.locations = [0, 0.6, 1]
            layer.opacity = 0.9
        }
        layer.anchorPoint = CGPointZero
        return layer
    }
    
    init(colors: [UIColor]) {
        
        self.colors = Array(colors.prefix(2))
        self.colorLayers = [
            CrystalBackdropView.buildGradientLayer(self.colors.first!, self.colors.last!, top: false),
            CrystalBackdropView.buildGradientLayer(self.colors.first!, self.colors.last!, top: true),
        ]
        super.init(frame: CGRectZero)
        self.colorLayers.forEach({ self.layer.addSublayer($0) })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.skewLayers()
    }
    
    func skewLayers() {
        self.colorLayers.forEach { layer in
            layer.frame = self.bounds
            
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
