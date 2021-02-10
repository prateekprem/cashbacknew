//
//  JRAnimationRipple.swift
//  LottieAnim
//
//  Created by Sourabh Deshpande on 29/08/18.
//  Copyright © 2018 Sourabh Deshpande. All rights reserved.
//

import Foundation
import UIKit
import Lottie

public class JRAnimationRipple: UIView {
    public var animationView: LOTAnimationView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView(){
        animationView = LOTAnimationView(name: "ripple_animation")
        animationView?.animationSpeed = 3
        animationView?.loopAnimation = true
        animationView?.frame = self.bounds
        
        if let animationView = animationView{
            self.addSubview(animationView)
        }
    }
    
    public func startAnimation(){
        self.animationView?.play()
    }
    
    public func stopAnimation(){
        self.animationView?.stop()
    }
}

