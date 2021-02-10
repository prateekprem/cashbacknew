//
//  JRBottomSheetViewController.swift
//  Jarvis
//
//  Created by Sandeep Chhabra on 24/08/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

public typealias BottomSheetCompletion = (_ actionType:BottomSheetAction,_ confirmClicked:Bool) -> Void
public enum BottomSheetAction {
    case actionButtons
    case tapOutSide
    case closeButton
}
open class JRBottomSheetViewController: UIViewController {
    @IBOutlet weak open var titleLabel: UILabel!
    @IBOutlet weak open var messageLabel: UILabel!
    @IBOutlet weak open var cancelButton: UIButton!
    @IBOutlet weak open var confirmButton: UIButton!
    @IBOutlet weak open var closeButton: UIButton!
    @IBOutlet weak open var cancelButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak open var confirmButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak open var bottomContainerView: UIView!
    
    private var sheetTitle:String!
    open var attributedSheetTitle:NSAttributedString?

    open var message:String?
    open var attributedMessage:NSAttributedString?

    open var cancelText:String?
    open var attributedCancelText:NSAttributedString?

    open var confirmText:String?
    open var attributedConfirmText:NSAttributedString?

    open var showCloseButton:Bool = false
    
    private var completion:BottomSheetCompletion!

    open class func bottomSheetWith(title:String,message:String? = nil,cancelText:String? = nil,confirmText:String? = nil , completionHandler:@escaping BottomSheetCompletion)  -> JRBottomSheetViewController{
        if let vc = UIStoryboard(name: "JRBottomSheet", bundle: Bundle.framework).instantiateInitialViewController() as? JRBottomSheetViewController{
            vc.sheetTitle = title
            vc.message = message
            vc.cancelText = cancelText
            vc.confirmText = confirmText
            vc.completion = completionHandler
            return vc
        }
        return JRBottomSheetViewController()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func confirmButtonClicked(_ sender: Any) {
        completion(.actionButtons,true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        completion(.actionButtons,false)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        completion(.closeButton,false)
    }
}

private extension JRBottomSheetViewController{
    func updateUI(){
        updateTitle()
        updateMessage()
        updateButtons()
        addTapGesture()
    }
    func updateTitle(){
        if let _ = attributedSheetTitle{
            titleLabel.attributedText = attributedSheetTitle
        }else{
            titleLabel.text = sheetTitle
        }
    }
    func updateMessage(){
        if let _ = attributedMessage{
            messageLabel.attributedText = attributedMessage
        }else{
            messageLabel.text = message
        }
    }
    func updateButtons(){
        setCancelTitleOrHide()
        setConfirmTitleOrHide()
        updateButtonsCornerRadius()
        closeButton.isHidden = !showCloseButton
    }
    func setCancelTitleOrHide(){
        if let _ = attributedCancelText{
            cancelButton.setAttributedTitle(attributedCancelText, for: .normal)
        }else if let _ = cancelText{
            cancelButton.setTitle(cancelText, for: .normal)
        }else{
            cancelButtonHeightConstraint.constant = 0
        }
    }
    func setConfirmTitleOrHide(){
        if let _ = attributedConfirmText{
            confirmButton.setAttributedTitle(attributedConfirmText, for: .normal)
        }else if let _ = confirmText{
            confirmButton.setTitle(confirmText, for: .normal)
        }else{
            confirmButtonHeightConstraint.constant = 0
        }
    }
    func updateButtonsCornerRadius(){
        confirmButton.layer.cornerRadius = 3.0
        bottomContainerView.layer.cornerRadius = 7.0
        closeButton.layer.cornerRadius = closeButton.frame.size.height/2.0
    }
}

extension JRBottomSheetViewController : UIGestureRecognizerDelegate{
    private func addTapGesture(){
        let gest = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gest.delegate = self
        view.addGestureRecognizer(gest)
    }
    @objc private func viewTapped(){
         completion(.tapOutSide,false)
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool { // Why this was declared private 
        if touch.view == view{
            return true
        }
        return false
    }
}
