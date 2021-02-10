//
//  Ext_UITextField.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

fileprivate let keyboardHeight = CGFloat(250)

extension UITextField {
    
    public func setMargin(_ margin: CGFloat) {
        let padV = UIView(frame: CGRect(x: 0, y: 0, width: margin, height: 20))
        self.leftView = padV;
        self.leftViewMode = UITextField.ViewMode.always;
    }
    
    public func movingHeightIn(view: UIView) -> CGFloat {
        var bottHeight = view.frame.size.height
        bottHeight -= self.frame.maxY
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                if subView is UIScrollView {
                    let scrollView:UIScrollView = subView as! UIScrollView
                    bottHeight += scrollView.contentOffset.y
                }
                bottHeight -= (subView?.frame.minY)!
            }
            subView = subView?.superview
        }
        let movingHeight = keyboardHeight + 75 - bottHeight
        return movingHeight
    }
    
    public func getTopOriginYFrom(view:UIView) -> CGFloat {
        var topOriginY = self.frame.origin.y
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                topOriginY += (subView?.frame.origin.y)!
            }
            subView = subView?.superview
        }
        return topOriginY
    }
    
    public func getOriginXFrom(view:UIView) -> CGFloat {
        var originX = self.frame.origin.x
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                originX += (subView?.frame.origin.x)!
            }
            subView = subView?.superview
        }
        return originX
    }
    
    public func setBottomBorder() { // @Comment : This should be moved to extention file.
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    @IBInspectable public var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    public func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.tintColor = .black
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc public func doneButtonAction()
    {
        self.resignFirstResponder()
    }

}
