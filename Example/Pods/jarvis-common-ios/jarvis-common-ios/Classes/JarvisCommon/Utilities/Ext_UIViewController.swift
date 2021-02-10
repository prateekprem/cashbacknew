//
//  Ext_UIViewController.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 23/05/19.
//

import UIKit

public extension UIViewController{
    
    @discardableResult
    class func goBack(toViewController vc: Any, animated: Bool = true) -> Bool {
        
        let navigationController = JRCommonManager.shared.navigation.rootNavController
        if let viewControllers: [UIViewController] = navigationController?.viewControllers {
            for element in viewControllers {
                if type(of: element) == type(of: vc) {
                    _ = navigationController?.popToViewController(element, animated: animated)
                    return true
                }
            }
        }
        return false
    }
    
}
