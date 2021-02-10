//
//  Ext_UISwitch.swift
//  jarvis-locale-ios
//
//  Created by Shivam Jaiswal on 28/10/20.
//

import UIKit

extension UISwitch {
    
    @objc
    public func updateTintColor() {
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            onTintColor = UIColor.paytmGreenColor()
        case .paytm:
            onTintColor = UIColor.paytmBlueColor()
        }
    }
}
