//
//  JRBottomToTopTransitionAnimator.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 04/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios

@objc public protocol JRBottomToTopAnimatorDelegate: NSObjectProtocol {
    func containerViewToBeAnimated() -> UIView
}

public class JRBottomToTopTransitionAnimator: JRBaseAnimator {
    public var dummyView: UIView?
    public var reversed: Bool = false
    
    fileprivate func removeDummyView() {
        dummyView?.removeFromSuperview()
        dummyView = nil;
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView: UIView = transitionContext.containerView
        
        if ignoreAnimation {
            // don't do any animation just present the view controller that's it
            if presenting {
                if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)  {
                    containerView.addSubview(toViewController.view)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: { () -> Void in
                        
                    }, completion: { (finished: Bool) -> Void in
                        transitionContext.completeTransition(true)
                    })
                }
            } else {
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: { () -> Void in
                    
                }, completion: { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                })
            }
            return
        }
        
        if presenting {
            if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
                dummyView = UIView(frame: toViewController.view.frame)
                if let dummyView = dummyView {
                    containerView.addSubview(dummyView)
                }
                let originalColor: UIColor? = toViewController.view.backgroundColor
                self.dummyView?.backgroundColor = originalColor
                toViewController.view.backgroundColor = UIColor.clear
                containerView.addSubview(toViewController.view)
                
                dummyView?.alpha = 0
                if let toViewController = toViewController as? JRBottomToTopAnimatorDelegate {
                    if reversed {
                        toViewController.containerViewToBeAnimated().bottom = 0
                    } else {
                        toViewController.containerViewToBeAnimated().top = JRSwiftConstants.windowHeigth
                    }
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {[weak self] () -> Void in
                        self?.dummyView?.alpha = 1.0
                        if self?.reversed  == true {
                            toViewController.containerViewToBeAnimated().top = 0
                        } else {
                            toViewController.containerViewToBeAnimated().top = (2.0 / 3.0) * JRSwiftConstants.windowHeigth
                        }
                        }, completion: {[weak self] (finished: Bool) -> Void in
                            self?.removeDummyView()
                            if let toViewController = toViewController as? UIViewController {
                                toViewController.view.backgroundColor = originalColor
                            }
                            transitionContext.completeTransition(true)
                    })
                }
                
            }
        }
        else
        {
            
            
            if let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) {
                dummyView = UIView(frame: fromViewController.view.frame)
                dummyView?.alpha = 1.0
                if let dummyView  = dummyView {
                    containerView.insertSubview(dummyView, belowSubview: fromViewController.view)
                }
                let originalColor: UIColor? = fromViewController.view.backgroundColor
                dummyView?.backgroundColor = originalColor
                fromViewController.view.backgroundColor = UIColor.clear
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {[weak self] () -> Void in
                    self?.dummyView?.alpha = 0.0
                    if let fromViewController = fromViewController as? JRBottomToTopAnimatorDelegate {
                        if self?.reversed  == true {
                            fromViewController.containerViewToBeAnimated().bottom = 0
                        } else {
                            fromViewController.containerViewToBeAnimated().top = JRSwiftConstants.windowHeigth
                        }
                    }
                    }, completion: {[weak self] (finished: Bool) -> Void in
                        self?.removeDummyView()
                        fromViewController.view.backgroundColor = originalColor
                        transitionContext.completeTransition(true)
                })
                
            }
            
        }
    }
}
