//
//  JRPaymentsLoaderView.swift
//  Jarvis
//
//  Created by Swati Goel on 05/03/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import Lottie

public class JRPaymentsLoaderView: UIView {

    private let loaderAnimationView =  LOTAnimationView(name: "Paytm-Loader", bundle: Bundle.framework)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addLoaderView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLoaderView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    private func addLoaderView() {
        updateFrame()
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.alpha = 0
        self.addSubview(loaderAnimationView)
    }
    
    private func updateFrame() {
        loaderAnimationView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
    }
    
    /*
     * Plays the animation, unhides self
     * Parameter: isInfinite = true/false to play it infinitely or for default time interval
     */
    public func show(_ isInfinite: Bool = true) {
        loaderAnimationView.loopAnimation = isInfinite
        loaderAnimationView.play()
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 0.23) {
            self.alpha = 1
        }
    }
    
    /*
     * Stops the animation, hides self
     */
    public func hide() {
        loaderAnimationView.stop()
        UIView.animate(withDuration: 0.23, animations: {
            self.alpha = 0
        }) { (finished) in
            self.isHidden = true
        }
    }
}

public extension LOTAnimationView {
    
    /**
     Create LOTAnimationView instance from assets catalog.
     */
    convenience init(asset name: String, bundle: Bundle = Bundle.main) {
        if let assetData = NSDataAsset(name: name, bundle: bundle) {
        
            if let json = try? JSONSerialization.jsonObject(with: assetData.data, options: []) as? [AnyHashable: Any] {
                self.init(json: json)
            } else {
                self.init()
            }
        } else {
            self.init()
        }
    }
}
