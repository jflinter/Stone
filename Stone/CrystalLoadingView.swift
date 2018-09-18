//
//  CrystalLoadingView.swift
//  Stone
//
//  Created by Jack Flintermann on 5/21/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import UIKit

class CrystalLoadingView: UIView {

    let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleView.layer.cornerRadius = 15
        circleView.layer.borderWidth = 1
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = NSNumber(value: 1.4 as Double)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        circleView.layer.add(pulseAnimation, forKey: nil)
        self.addSubview(circleView)
    }
    
    override var tintColor: UIColor! {
        didSet {
            self.circleView.layer.borderColor = tintColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.center = self.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
