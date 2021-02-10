//
//  JRFlyoutTransitionAnimator.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 04/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation
import jarvis_utility_ios

open class JRFlyoutTransitionAnimator : JRBaseAnimator {
    @objc open var heightOfBuyButton: CGFloat = 0
    
    
    override open func presentControllerFrom(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
        toController.view.size = fromController.view.size
        if let view = toController.view.viewWithTag(6655) {
            toController.view.top = view.height - heightOfBuyButton
            toController.view.height = JRSwiftConstants.windowHeigth - view.height
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: { () -> Void in
            
            toController.view.backgroundColor = UIColor(white: 0.0, alpha: 0.64)
            toController.view.frame = CGRect(x: 0.0, y: -self.heightOfBuyButton, width: JRSwiftConstants.windowWidth, height: JRSwiftConstants.windowHeigth)
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    
    override open func dismissController(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
        
        if let view = fromController.view.viewWithTag(6655) {
            view.top = JRSwiftConstants.windowHeigth - view.height
            fromController.view.top = -heightOfBuyButton
            fromController.view.height = JRSwiftConstants.windowHeigth
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: { () -> Void in
                fromController.view.frame = CGRect(x: 0.0, y: 0.0, width: JRSwiftConstants.windowWidth, height: JRSwiftConstants.windowHeigth - view.height)
                fromController.view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)

                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
            }
            return
        }
        transitionContext.completeTransition(true)
    }
}
