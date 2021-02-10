//
//  ApplockViewController.swift
//
//  Created by Deepanshu Jain on 18/06/20.
//  Copyright © 2020 Deepanshu Jain. All rights reserved.
//

import UIKit
import LocalAuthentication

//MARK: - ApplockViewController
final class ApplockViewController: UIViewController {
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitle1: UILabel!
    @IBOutlet weak private var activateButton: UIButton!
    @IBOutlet weak private var skipButton: UIButton!
    
    private var deviceLockPrevState: Bool = false
    var isPasscodeSet: Bool = false
    weak var delegate: JRApplockDelegate?
    public var viewModel: JRApplockViewModel?
    
    class func getController() -> ApplockViewController? {
        if let vc = JRAuthManager.kAuthStoryboard.instantiateViewController(withIdentifier: "ApplockViewController") as? ApplockViewController { return vc }
        return ApplockViewController()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        addNotificationObserver()
    }
    
    private func setupDefaults() {
        addBlurBackground()
        setupViews()
        setupButtons()
        subtitle1.setMargins()
        updateUI()
    }
    
    private func addBlurBackground() {
        guard !UIAccessibility.isReduceTransparencyEnabled else { return }
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        imageView.image = UIImage(named: "paytm_security_shield_secure", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        imageView.image = imageView.image?.imageWithInsets(insets: UIEdgeInsets(top: 30, left: 0, bottom: 25, right: 0))
        if let backgroundImage = UIImage(named: "security_background", in: JRAuthManager.kAuthBundle, compatibleWith: nil) {
            imageView.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowRadius = 8.0
        stackView.customize(backgroundColor: .white, radiusSize: 8.0)
        subtitle1.popupPadding = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    private func setupButtons() {
        let color = UIColor.colorWithHexString("#00ACED")
        activateButton.backgroundColor = color
        activateButton.setTitleColor(.white, for: .normal)
        activateButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        activateButton.layer.cornerRadius = 4.0
        skipButton.backgroundColor = .white
        skipButton.setTitleColor(color, for: .normal)
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.mainTitle
        subtitle1.text = viewModel.subtitle1 + "\n" + viewModel.subtitle2
        activateButton.setTitle(viewModel.confirmText, for: .normal)
        skipButton.setTitle(viewModel.cancelText, for: .normal)
    }
    
    @IBAction private func activateButtonTapped(_ sender: UIButton) {
        if !self.isPasscodeSet {
            // Case: PASSCODE was turned OFF -> ACTIVATE clicked
            setPasscode()
        } else {
            // Case: PASSCODE was turned ON -> ACTIVATE clicked
            dismiss(animated: true) {
                self.delegate?.userTappedConfirm()
            }
        }
    }
    
    @IBAction private func skipButtonTapped(_ sender: UIButton) {
        // Case: PASSCODE was turned OFF / ON (Irrespective) -> SKIP clicked
        dismiss(animated: true, completion: nil)
        delegate?.userTappedSkip()
    }
    
    private func setPasscode() {
        let alertController = UIAlertController(title: nil, message:"jr_login_go_to_settings".localized, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "jr_login_settings".localized, style: .default) { (_) -> Void in
            // Case: PASSCODE was turned off -> Activate clicked -> GO TO SETTINGS clicked
            //redirect the user to settings page
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "jr_login_cancel".localized, style: .default) { (_) in
            // Case: PASSCODE was turned off -> Activate clicked -> CANCEL clicked
            //redirect the user to homepage
            self.dismiss(animated: true) {
                self.delegate?.userTappedCancelOnSettingsAlert()
            }
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Notification Observers
extension ApplockViewController {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func didEnterBackground() {
        deviceLockPrevState = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    @objc func willEnterForeground() {
        let currentDeviceLockState = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        if !deviceLockPrevState && currentDeviceLockState {
            dismiss(animated: true) {
                self.delegate?.didReturnFromSettingsPage()
            }
        }
    }
}
