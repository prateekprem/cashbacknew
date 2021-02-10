//
//  Ext_UIButton.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 23/05/19.
//

import UIKit
import Lottie

public extension UIButton{
    
    func showLoader(shouldRemoveTitle: Bool = true, defaultBGColor: UIColor = UIColor(red: 234.0/255.0, green: 250.0/255.0, blue: 255.0/255.0, alpha: 1.0)) {
        let viewLoading = UIView(frame: self.bounds)
        viewLoading.tag = 999
        viewLoading.backgroundColor = defaultBGColor
        let animationView: LOTAnimationView =  LOTAnimationView(name: "Paytm-Loader", bundle: Bundle.framework)
        animationView.accessibilityIdentifier = "ctaInlineLoader"
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animationView.center = viewLoading.center
        viewLoading.addSubview(animationView)
        if shouldRemoveTitle {
            self.setTitle("", for: .normal)
        }
        self.addSubview(viewLoading)
        JRPaytmLoaderAnimationView().infinitePlay(viewAnimate: animationView)
    }
    
    func showCheckBalance(shouldRemoveTitle: Bool = true, defaultBGColor: UIColor = UIColor(red: 234.0/255.0, green: 250.0/255.0, blue: 255.0/255.0, alpha: 1.0)) {
        let viewLoading = UIView(frame: self.bounds)
        let spacing = self.bounds.size.height > 15.0 ? (self.bounds.size.height - 15.0)/2 : 0.0
        viewLoading.tag = 999
        viewLoading.backgroundColor = defaultBGColor
        let animationView =  LOTAnimationView(name: "Paytm-Loader", bundle: Bundle.framework)
        animationView.frame = CGRect(x: 0, y: spacing, width:  self.bounds.size.width, height: 15.0)
        animationView.center = viewLoading.center
        viewLoading.addSubview(animationView)
        if shouldRemoveTitle {
            self.setTitle("", for: .normal)
        }
        self.addSubview(viewLoading)
        JRPaytmLoaderAnimationView().infinitePlay(viewAnimate: animationView)
    }
    
}
