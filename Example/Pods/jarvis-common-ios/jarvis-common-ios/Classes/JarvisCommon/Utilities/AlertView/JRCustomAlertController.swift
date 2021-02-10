//
//  JRCustomAlertController.swift
//  alert
//
//  Created by Sandesh Kumar on 13/07/18.
//  Copyright © 2018 Sandesh Kumar. All rights reserved.
//

import UIKit

@objc final public class JRCustomAlertController: UIViewController {
    private let actionHeight: Int = 44
    
    @IBOutlet private weak var actionStackView: UIStackView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @objc private (set) var actions = [AlertAction]()
    @objc private (set) var titleText: String?
    @objc private (set) var message: String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        messageLabel.text = message
        if actions.count > 0 {
            heightConstraint.constant = CGFloat(actions.count * actionHeight)
            setupActions()
        }
    }
    
    private func setupActions() {
        for action in actions {
            let button1: CustomAlertActionButton = CustomAlertActionButton.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(actionHeight)))
            button1.action = action
            actionStackView.addArrangedSubview(button1)
        }
    }
    override public func viewDidLayoutSubviews() {
        let avilableHeight: CGFloat = getAvailableHeight() - titleLabel.frame.height
        scrollHeightConstraint.constant = min(messageLabel.frame.height,avilableHeight)
        super.viewDidLayoutSubviews()
    }
    
    
    private func getAvailableHeight() -> CGFloat {
        // top + bottom margin = 140
        // margins = 45
        let actionsHeight: Int = actionHeight * actions.count
        return UIScreen.main.bounds.size.height - 140 - CGFloat(actionsHeight) - 45
    }
    
    @objc public class func controller(title: String?, message: String?) -> JRCustomAlertController {
        let vc: JRCustomAlertController = UIStoryboard.init(name: "JRCustomAlert", bundle: Bundle.framework).instantiateInitialViewController() as! JRCustomAlertController
        vc.title = title
        vc.message = message
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        return vc
    }
    
    @objc public func addAction(_ action: AlertAction) {
        actions.append(action)
    }
}

extension JRCustomAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator: JRFadeTransitionAnimator = JRFadeTransitionAnimator()
        animator.duration = 0.3
        animator.presenting = true
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator: JRFadeTransitionAnimator = JRFadeTransitionAnimator()
        animator.duration = 0.3
        return animator
    }
}

@objcMembers
final public class AlertAction: NSObject {
    
    public init(title: String?, style: UIAlertAction.Style, handler: ((AlertAction) -> Swift.Void)? = nil) {
        self.title = title
        self.handler = handler
        self.style = style
    }
    
    public var style: UIAlertAction.Style = .default
    public var title: String?
    public var handler: ((AlertAction) -> Swift.Void)?
}

final public class CustomAlertActionButton: UIButton {
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        let view: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 0.5))
        view.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        addSubview(view)
        setTitleColor(UIColor.init(red: 21/255, green: 126/255, blue: 251/255, alpha: 1), for: .normal)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc public weak var action: AlertAction? {
        didSet {
            setUp()
        }
    }
    
    private func setUp() {
        if action?.style == .cancel {
            titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        
        setTitle(action?.title, for: .normal)
        self.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
    
    @objc public func buttonTapped() {
        action?.handler?(action!)
    }
}
