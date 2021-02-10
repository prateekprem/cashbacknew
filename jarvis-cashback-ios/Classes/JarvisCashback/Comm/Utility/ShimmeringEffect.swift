//
//  ShimmeringEffect.swift
//  Jarvis
//
//  Created by Narottam Tailor on 03/04/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

protocol ShimmeringEffect{
    func shimmeringEffect(display:Bool)
}

extension ShimmeringEffect where Self: UIView {
    func addShimmeringEffect() {
        removeShimmeringEffect()
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = UIColor.clear.cgColor
        let light = UIColor.white.withAlphaComponent(0.01).cgColor
        let middle = UIColor.white.withAlphaComponent(0.1).cgColor
        let alpha = UIColor.white.withAlphaComponent(0.5).cgColor
        gradientLayer.name = "ShimmerLayer"
        gradientLayer.colors = [light,light,light,light,middle,alpha,middle,light,light,light,light]
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.54)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.61)
        gradientLayer.frame = self.bounds
        
        self.layer.mask = nil
        self.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.8
        animation.fromValue = -self.frame.size.width
        animation.toValue = self.frame.size.width
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation, forKey: "")
        
    }
    
    func removeShimmeringEffect(){
        if let layer = self.layer.sublayers {
            for layerObj in layer {
                if layerObj.name == "ShimmerLayer" {
                    layerObj.removeFromSuperlayer()
                    self.layer.mask = nil
                    break
                }
            }
        }
    }
}

extension UIView: ShimmeringEffect{
    func shimmeringEffect(display:Bool){ }
}
