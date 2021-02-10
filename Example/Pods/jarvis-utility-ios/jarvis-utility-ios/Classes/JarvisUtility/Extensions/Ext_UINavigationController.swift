//
//  Ext_UINavigationController.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    //MARK: Instance Methods
    /**
     Method to pushViewController and removing from stack
     */
    @objc open func pushByRemovingFromStackViewController(_ viewController: UIViewController, animated: Bool) {
        
        var viewcontrollersArray = viewControllers
        
        for vc in viewcontrollersArray {
            if let controller = object_getClass(viewController), vc.isKind(of: controller) {
                viewcontrollersArray.removeObject(vc)
                viewControllers = viewcontrollersArray
                break
            }
        }
        
        pushViewController(viewController, animated: animated)
        
    }
    
}
