//
//  JRNetworkConnectionViewContoller.swift
//  Jarvis
//
//  Created by Siddharth.K on 6/17/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit
import jarvis_network_ios

@objc public protocol JRNetworkConnectionVCDelegate : class{
    func retryButtonPressed()
    func noNetworkBackButtonPressed()
}


public class JRNetworkConnectionVC: UIViewController {
    @objc public class var instance : JRNetworkConnectionVC {
        get{
            let storyboard : UIStoryboard = UIStoryboard.init(name: "NetworkConnectivity", bundle: Bundle.framework)
            return storyboard.instantiateInitialViewController() as! JRNetworkConnectionVC
        }
    }
   
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var headerView:UIView!
  
    @IBOutlet weak var backButton: UIButton!
    @objc public var showBackButton : Bool = false
    @IBOutlet weak var mallBackButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var tryAgainBtn: UIButton! //This is for mall weex View
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @objc public weak var delegate : JRNetworkConnectionVCDelegate?
    @objc public var showNavigationBarInOffline:Bool = false
    @objc public var showMPNoNetView:Bool = false
    @objc public var showMPNoNetViewWithoutBackBtn:Bool = false
    @objc public var showRetryButton: Bool = true
    @objc public var showIconImage: Bool = true

    override public func viewDidLoad() {
        super.viewDidLoad()
        backButton.isHidden = !showBackButton
        retryButton.isHidden = !showRetryButton
        iconImageView.isHidden = !showIconImage
        if showNavigationBarInOffline{
            self.headerView.isHidden = false
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() ) {[weak self] in
            self?.dismiss(animated:true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navigation = self.navigationController as? JRNavigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.isHidden = !showBackButton
        if showMPNoNetView {
            tryAgainBtn.layer.cornerRadius = 2;
            self.containerView.isHidden = true;
            self.mallBackButton.isHidden = showMPNoNetViewWithoutBackBtn;
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if JRNetworkUtility.isNetworkReachable() {
            dismissVC()
        }
        retryButton.updateTextColor()
    }
    
    public class func show() -> JRNetworkConnectionVC {
        let vc = UIStoryboard(name: "NetworkConnectivity", bundle: Bundle.framework).instantiateInitialViewController() as! JRNetworkConnectionVC
        vc.transitioningDelegate = vc
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        let controller: UIViewController?
        if JRCommonManager.shared.navigation.rootNavController.visibleViewController != JRCommonManager.shared.navigation.rootNavController.topViewController {
            controller = JRCommonManager.shared.navigation.rootNavController.visibleViewController
        } else {
            controller = JRCommonManager.shared.navigation.rootNavController.viewControllers.first
        }
        controller?.present(vc, animated: true, completion: nil)
        return vc
    }
    
    public func dismiss() {
        self.dismiss(animated:true, completion: nil)
    }
    
    public func configure(title: String? = nil, subtitle: String? = nil, iconImage: UIImage? = nil) {
        if let image = iconImage {
            iconImageView.image = image
        }
        if let title = title {
            titleLabel.text = title
        }
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
        }
    }
    
// MARK: - Private Methods
   fileprivate func dismissVC() {
        if !(isBeingDismissed || (view.window != nil)) {
            dismiss(animated:true, completion: nil)
        }
    }
    
// MARK: - Action Methods
    
    @IBAction func retryButtonClicked(_ sender: AnyObject!) {
        if JRNetworkUtility.isNetworkReachable() {
            delegate?.retryButtonPressed()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
                self?.dismissVC()
            }
            JRNetworkUtility.executeAllCachedRequests()
        }
      }
    
    @IBAction func backButtonAction(_ sender: Any) {
        delegate?.noNetworkBackButtonPressed()
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject!) {
       dismissVC()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension JRNetworkConnectionVC : UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = JRFadeTransitionAnimator()
        animator.presenting = true
        animator.duration = 0.5
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = JRFadeTransitionAnimator()
        animator.duration = 0.5
        return animator
    }
}

