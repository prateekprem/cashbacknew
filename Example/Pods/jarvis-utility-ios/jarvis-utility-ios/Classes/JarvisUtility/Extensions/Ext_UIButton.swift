//
//  Ext_UIButton.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 13/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable public var borderedRound : Bool {
        set {
            self.roundCorner(1, borderColor: self.titleColor(for: .normal), rad: self.frame.height/2)
        }
        get {
            return true
        }
    }
    
    public func round(corner:UIRectCorner, radius: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.layer.bounds
        borderLayer.strokeColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1).cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1.0
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer);
    }
    
    public func removeLoader(title: String? = "") {
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        if title != "" {
            self.setTitle(title, for: .normal)
        }
    }
    
    public func updateBorderColor() {
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            layer.borderColor = UIColor.paytmRedColor().cgColor
        case .paytm:
            layer.borderColor = UIColor.paytmBlueColor().cgColor
        }
    }
    
    @objc
    public func updateTextColor() {
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            setTitleColor(UIColor.paytmRedColor(), for: .normal)
        case .paytm:
            setTitleColor(UIColor.paytmBlueColor(), for: .normal)
        }
    }
    
    @objc
    public func updateBackgroundColor() {
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            backgroundColor = UIColor.paytmRedColor()
        case .paytm:
            backgroundColor = UIColor.paytmBlueColor()
        }
    }
}
