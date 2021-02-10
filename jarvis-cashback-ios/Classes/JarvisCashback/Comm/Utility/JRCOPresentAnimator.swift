//
//  JRCBPresentAnimator.swift
//  Jarvis
//
//  Created by nasib ali on 06/05/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRCOPresentAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(herbView)
        
        UIView.animate(withDuration: (0.6), delay:0.0, usingSpringWithDamping: !self.presenting ? 1.0 : 0.6,
                       initialSpringVelocity: 0.0,
                       animations: {
                        herbView.transform = self.presenting ?
                            CGAffineTransform.identity : scaleTransform
                        if !self.presenting {
                            herbView.alpha = 0.01
                        }
                        
                        herbView.center = CGPoint(x: finalFrame.midX,
                                                  y: finalFrame.midY)
        },
                       completion:{_ in
                        if !self.presenting {
                            herbView.alpha = 0.0
                            self.dismissCompletion?()
                        }
                        transitionContext.completeTransition(true)
        }
        )
    }
    
}
