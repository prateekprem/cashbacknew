//
//  JRNavigationBridge.swift
//  jarvis-common-ios
//
//  Created by Brammanand Soni on 30/05/20.
//

import UIKit

public class JRNavigationBridge: NSObject {

    static let shared: JRNavigationBridge = JRNavigationBridge()
    
    @objc public var rootNavController : JRNavigationController!
    
    // MARK: Initialization
    public func initializeNavigation(navController: JRNavigationController){
        rootNavController = navController
    }
    
    // MARK: Push & Pop
    @objc public func push(viewController: UIViewController, byPopingCurrentToRoot popCurrentToRoot: Bool = false, animated :Bool) {
        if popCurrentToRoot {
            rootNavController.popToRootViewController(animated: animated)
        }
        
        rootNavController.pushViewController(viewController, animated: animated)
    }
    
    @objc public func popViewController(animated: Bool) {
        rootNavController.popViewController(animated: animated)
    }

    @objc public func popToRoot(animated: Bool) {
        rootNavController.popToRootViewController(animated: animated)
    }

    // MARK: Present & Dismiss
    @objc public func present(viewController controller : UIViewController, animated: Bool, completion : (() -> ())? = nil){
        DispatchQueue.main.async {
            if let visibleController = self.rootNavController.visibleViewController {
                visibleController.present(controller, animated: animated, completion: completion)
            }
            else {
                completion?()
            }
        }
    }
    
    @objc public func dismiss(animated: Bool, completion : (() -> ())? = nil) {
        if let presented = rootNavController.presentedViewController {
            presented.dismiss(animated: animated, completion: completion)
        }
        else {
            completion?()
        }
    }
    
    @objc public func dimissAndPopToRoot(animated: Bool, completion : (() -> ())? = nil) {
        if let presented = rootNavController.presentedViewController {
            presented.dismiss(animated: animated) { [weak self] in
                self?.rootNavController.popToRootViewController(animated: animated)
                completion?()
            }
        }
        else {
            rootNavController.popToRootViewController(animated: animated)
            completion?()
        }
    }
}
