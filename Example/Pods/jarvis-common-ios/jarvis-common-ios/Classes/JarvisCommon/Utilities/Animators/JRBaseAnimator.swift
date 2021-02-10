//
//  JRBaseAnimator.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 04/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation

//This is the base class for all animator.
//All animator, derived from this class don't have to implement UIViewControllerAnimatedTransitioningion methods
//Need to implemnent only following methods,
//
//presentControllerFrom:to:withTransition:
//dismissController:to:withTransition:
public let JRAnimationDuration: Float = 0.5

open class JRBaseAnimator: NSObject {
   
    
    @objc open var presenting: Bool = false
    //Default duration is 0.5
    @objc open var duration: Float = 0.5
    @objc open var ignoreAnimation = false //since we can't use custom transition for presenting/dismissing controllers without animation, we added this property
    //if this property is YES , then we just ignore animation.The presentation resembles just as that of presentViewController:animated:completion: with animated set to value 'NO'
 
    open class func animator() -> JRBaseAnimator {
        return animatorWithDuration(JRAnimationDuration, forPresenting: true)
        
    }
    
    open class func animatorWithDuration(_ duration: Float, forPresenting isPresenting: Bool) -> JRBaseAnimator {
        
        let animator = self.init()
        animator.presenting = isPresenting
        animator.duration = duration
        return animator
    }
    
    required override public init() {
        super.init()
    }
    
}




extension JRBaseAnimator: UIViewControllerAnimatedTransitioning {
   
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return  Double(0.5)
        
    }
    
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
            
            if ignoreAnimation {
                
                // don't do any animation just present the view controller that's it
                if presenting {
                    containerView.addSubview(toViewController.view)
                    transitionContext.completeTransition(true)
                }
                else {
                    transitionContext.completeTransition(true)
                }
                return;
            }
           
            if presenting {
                containerView.addSubview(toViewController.view)
                
                presentControllerFrom(fromViewController, to: toViewController, withTransition: transitionContext)
            }
            else
            {
                dismissController(fromViewController, to: toViewController, withTransition: transitionContext)
            }
            
        }
    }
    
    
    @objc open func presentControllerFrom(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
        
    }

    
    @objc open func dismissController(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
    
    }
    
    
}
