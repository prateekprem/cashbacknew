//
//  JRFadeTransitionAnimator.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 04/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios

@objc public enum JRTransitionType: NSInteger {
    
    case Fade = 0, DropDown = 1
}


open class JRFadeTransitionAnimator: JRBaseAnimator {

    @objc public var transitionType: JRTransitionType = .Fade
    
    override open func presentControllerFrom(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
        presetToOriginalValue(reset: true, of: toController)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {[weak self] () -> Void in
            
            self?.presetToOriginalValue(reset: false, of: toController)
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
        }
        
    }
    override open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Double(duration)
    }
    override open func dismissController(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
        presetToOriginalValue(reset: false, of: fromController)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {[weak self] () -> Void in
            self?.presetToOriginalValue(reset: true, of: fromController)
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    
   fileprivate func presetToOriginalValue(reset: Bool, of controller: UIViewController) {
        if  transitionType == .Fade {
            controller.view.alpha = reset ? 0 : 1
        } else {
              controller.view.height = reset ? 64 : JRSwiftConstants.windowHeigth
        }
        
    }
}
