//
//  JRKeyboardUtil.swift
//  Jarvis
//
//  Created by Shrinivasa Bhat on 20/06/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation

@objc public protocol JRKeyboardUtilDelegate {
    @objc optional func keyBoardDidShown(_ notification: Notification?)
    @objc optional func keyBoardDidHidden(_ notification: Notification?)
}

open class JRKeyboardUtil:NSObject {
    
    open var enabled = true //Default is YES,
    
    weak open var bottomView:UIView? { // Last view to be visible when keyboard is up
        didSet {
            bottomRect = bottomView?.frame
        }
    }
    
    open var bottomRect: CGRect? { //Rect of container which is to be visible when kwyboard is up
        didSet {
            setScrollViewContentInsetValue()
        }
    }
    open var bottomOffset:CGFloat = 10.0 { //An extra space from bottom view or bottom rect. Default 10 pixels.
        didSet {
            setScrollViewContentInsetValue()
        }
    }
    
    open var movedOffset:CGFloat = 0
    open var extraOffsetForiOS8ModalypresentedController:CGFloat  = 0//TODO: #warning Fix this issue : An extra 55 pixel space is created for formsheet?????
    weak open var delegate:JRKeyboardUtilDelegate?// delegate if you want to listen to keyboard notification
    
    open var keyBoardHeight: CGFloat { // an getter to get keyboard height at any time.
        return localkeyBoardHeight
    }
    
    fileprivate var localkeyBoardHeight:CGFloat = 0.0
    
    fileprivate weak var scrollView:UIScrollView?
    fileprivate var initialInset:UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var keyBoardRect:CGRect = CGRect.zero
    
    
    @objc public convenience init(scrollView:UIScrollView, bottomVisibleView:UIView) {
        self.init(scrollView: scrollView, bottomrectToBeVisible:bottomVisibleView.frame)
        bottomView = bottomVisibleView
    }
    
    public init(scrollView:UIScrollView, bottomrectToBeVisible:CGRect) {
        self.scrollView = scrollView
        self.bottomRect = bottomrectToBeVisible
        super.init()
        self.setUpKeyboardNotificationListners()
    }
    
    deinit{
        removeKeyboardNotificationListners()
    }
}

extension JRKeyboardUtil{
    @objc public func keyBoardDidShown(_ notification:Notification){
        if let userInfo = notification.userInfo as? [String: Any], let rectInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let rect = (rectInfo as AnyObject).cgRectValue {
            keyBoardRect = rect
            if let rootView = UIApplication.shared.delegate?.window??.rootViewController?.view {
                let convertedRect = rootView.convert(rect, from:nil)
                localkeyBoardHeight = convertedRect.size.height
                setScrollViewContentInsetValue()
            }
        }
        delegate?.keyBoardDidShown?(notification)
    }
    
    @objc public func keyBoardDidHidden(_ notification:Notification) {
        if enabled {
            localkeyBoardHeight = 0
            movedOffset = 0
            UIView.animate(withDuration: 0.1) {[weak self] () -> Void in
                if let initialInset = self?.initialInset {
                    let inset = UIEdgeInsets(top: initialInset.top, left: initialInset.left, bottom: 0, right: initialInset.right)
                    self?.scrollView?.contentInset = inset
                    self?.scrollView?.scrollIndicatorInsets = inset
                }
                self?.scrollView?.setContentOffset(CGPoint.zero, animated:false)
            }
        }
        delegate?.keyBoardDidHidden?(notification)
    }
}

fileprivate extension JRKeyboardUtil {
    func setUpKeyboardNotificationListners(){
        NotificationCenter.default.addObserver(self, selector: #selector(JRKeyboardUtil.keyBoardDidShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JRKeyboardUtil.keyBoardDidHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotificationListners(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setScrollViewContentInsetValue(){
        //If not enabled or keyboard is hidden
        if !enabled || keyBoardHeight == 0 {
            return
        }
        
        //Store current scrollview inset
        initialInset = scrollView?.contentInset ?? initialInset
        
        var height:CGFloat = 0
        
        var bRect = bottomRect
        if  let bottomView = bottomView {
            bRect = bottomView.frame
        }
        
        var bView:UIView? = scrollView
        if let bottomView = bottomView, bottomView != scrollView {
            bView = bottomView.superview
        }
        if let scrollView = scrollView, let bRect = bRect, let bView = bView,let rect = scrollView.superview?.convert(bRect, from:bView) {
            if let rectInWindowCoordinates = scrollView.window?.convert(keyBoardRect, from:nil) ,
                let rectCoveredByKeyboard = scrollView.superview?.convert(rectInWindowCoordinates, from:nil) {
                let top = rectCoveredByKeyboard.minY
                
                if scrollView.contentSize.height < top {
                    return
                }    
                let offset = max(0, (scrollView.frame.size.height - scrollView.contentSize.height))
                height = (rect.origin.y + rect.size.height + bottomOffset) - top + offset
                
                if UIApplication.shared.statusBarOrientation.isLandscape {
                    height = height - extraOffsetForiOS8ModalypresentedController
                }
                movedOffset = height
            }
        }
        
        scrollView?.contentInset = UIEdgeInsets(top: initialInset.top, left: initialInset.left, bottom: max(0, height) , right: initialInset.right)
        scrollView?.scrollIndicatorInsets = UIEdgeInsets(top: initialInset.top, left: initialInset.left,  bottom: max(0, height), right: initialInset.right)
    }
}
