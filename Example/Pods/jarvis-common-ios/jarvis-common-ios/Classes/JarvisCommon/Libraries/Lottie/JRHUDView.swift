//
//  JRHUDView.swift
//  Jarvis
//
//  Created by Babul Prabhakar on 01/06/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

public class JRHUDView: UIView {
    
    @IBOutlet weak var loaderContainerView: UIView!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var loaderView: JRPaymentsLoaderView!
    @IBOutlet weak var loaderContainerBackground: UIView!
    
    var apiCount: Int = 1
    
    @IBOutlet weak var loaderBottomPadding: NSLayoutConstraint!
    
    /// Shows HUD to View
    /// In case of transition on current view , toView must be passed.
    /// If HUD is already present, this method wont show any extra hud but incremente the api count variable by +1.
    /// - Parameters:
    ///   - view: View Object on which loader should be shown, if nil , it will add at UIWindow,
    ///   - title: Title Text
    /// - Returns: JRHUDView for customization
    @discardableResult
    public static func showHUD(
        toView view: UIView?,
        title: String? = nil,
        loaderContainerColor: UIColor = UIColor.white,
        textColor: UIColor = UIColor.black,
        bottomPadding: CGFloat = 30.0
        ) -> JRHUDView {
        var hudView: JRHUDView!
        var toView: UIView!
        if view != nil {
            toView = view
        } else {
            toView = UIApplication.shared.keyWindow
        }
        if let view = toView.viewWithTag(-987), view is JRHUDView {
            hudView = view as? JRHUDView
            hudView.apiCount += 1
        } else {
            hudView = Bundle.framework.loadNibNamed("JRHUDView", owner: nil, options: nil)!.first as? JRHUDView
            hudView.tag = -987
            hudView.frame = toView.bounds
            hudView.loaderView.show()
            hudView.loaderView.isHidden = false
            // should animate
            hudView.alpha = 0.0
            toView.addSubview(hudView)
            UIView.animate(withDuration: 0.25) { () -> Void in
                hudView.alpha = 1.0
            }
        }
        if title == nil {
            hudView.labelContainer.isHidden = true
        } else {
            hudView.labelContainer.isHidden = false
            hudView.progressTitleLabel.text = title
        }
        hudView.loaderContainerView.backgroundColor = loaderContainerColor
        hudView.labelContainer.backgroundColor = loaderContainerColor
        hudView.progressTitleLabel.textColor =  textColor
        hudView.loaderBottomPadding.constant = bottomPadding
        return hudView
    }
    
    
    /// Hide HUD on View
    /// In case of Window dont pass any view, if there is 2 calls of show hud , you must call hide hud twice
    /// - Parameter view: UIView on which loader is made to hide
    public static func hideHUD(fromView view: UIView?, animated: Bool = true) {
        var fromView: UIView!
        if view != nil {
            fromView = view
        } else {
            fromView = UIApplication.shared.keyWindow
        }
        if let view = fromView?.viewWithTag(-987), view is JRHUDView {
            let hudView: JRHUDView = view as! JRHUDView
            hudView.apiCount -= 1
            if hudView.apiCount <= 0 {
                if animated{
                    UIView.animate(withDuration: 0.25, animations: {
                        hudView.alpha = 0.0
                    }) { (completed) in
                        hudView.removeFromSuperview()
                    }
                }else{
                    hudView.alpha = 0.0
                    hudView.removeFromSuperview()
                }
            }
            
        }
        
    }
    
    /// Hide All HUD on View
    /// Will Hide the loader irrespective of API Count
    /// - Parameter view: UIView on which loader is made to hide
    public static func hidAllHUD(fromView view: UIView?) {
        var fromView: UIView!
        if view != nil {
            fromView = view
        } else {
            fromView = UIApplication.shared.keyWindow
        }
        if let view = fromView?.viewWithTag(-987), view is JRHUDView {
            let hudView: JRHUDView = view as! JRHUDView
            UIView.animate(withDuration: 0.25, animations: {
                hudView.alpha = 0.0
            }) { (completed) in
                hudView.removeFromSuperview()
            }
        }
    }
    
    public func setBackgroundViewColor(color: UIColor){
        loaderContainerBackground.backgroundColor = color
    }
}
