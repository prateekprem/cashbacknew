//
//  JRNavigationController.swift
//  NavigationPOC
//
//  Created by Sanjay Mohnani on 31/10/18.
//  Copyright © 2018 one97. All rights reserved.
//

import Foundation
import UIKit

@objc open class JRNavigationController: UINavigationController {
    
    @objc override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 13, *) {
            // Restriction of swipe to dismiss functionality (iOS 13)
            viewControllerToPresent.isModalInPresentation = true
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    @discardableResult
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        JRCommonManager.shared.applicationDelegate?.flyout(false, animated: false)
        return super.popToRootViewController(animated: animated)
    }
}
