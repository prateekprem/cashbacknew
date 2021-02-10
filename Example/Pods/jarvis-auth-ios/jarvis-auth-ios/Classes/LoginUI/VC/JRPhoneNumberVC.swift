//
//  JRPhoneNumberVC.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 06/11/20.
//

import UIKit

final class JRPhoneNumberVC: JRAuthBaseVC {
    // MARK: - Properties
    private let phoneNumber: String
    private var stateToken: String = ""
    private var fallbackVC: UIViewController?
    
    // MARK: - UIViews
    private let backBtn: UIButton = {
        let image = UIImage(named: "back_default", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        let btn = UIButton(type: .system)
        btn.tintColor = .black
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "jr_login_dabu_enter_your_mobile_number".localized
        label.font = .systemSemiBoldFontOfSize(24)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "jr_login_dabu_enter_registered_number".localized
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textColor = .colorWithHexString("#506d85")
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setBottomBorder()
        return label
    }()
    
    private let confirmButton: CustomButton = {
        let button = CustomButton(ofType: .blueBackground, withText: "jr_login_proceed".localized)
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    
    private let loadingIndicatorView = JRLoadingIndicatorView()
    
    // MARK: - LifeCycle Methods
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.backgroundColor = JRLoginConstants.Colors.lightBlueBG
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mimicButtonTap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addAllSubviews()
        setFallbackVC()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingIndicatorView.isHidden = true
    }
    
    // MARK: - Main Methods
    private func setFallbackVC() {
        guard let index = navigationController?.viewControllers.count, index >= 2 else { return }
        self.fallbackVC = navigationController?.viewControllers[index - 2]
    }
    
    private func mimicButtonTap() {
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        self.confirmTapped()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        numberLabel.text = "+91 " + phoneNumber
    }
    
    // MARK: - IBActions
    @objc private func confirmTapped() {
        invokeVerificationInitAPI()
    }
    
    @objc private func backBtnTapped() {
        guard let navigationController = navigationController else {
            dismiss(animated: true, completion: nil)
            return
        }
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - APIs
extension JRPhoneNumberVC {
    private func invokeVerificationInitAPI() {
        
        let params: [String : String] = [
            "bizFlow": "ACCOUNT_UNBLOCK_VERIFY",
            "anchor": phoneNumber,
            "anchorType": "MOBILE_NO"
        ]
        
        JRLServiceManager.verifyInitDIY(params) {  [weak self] (response, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    self?.showErrorPage()
                    return
                }
                if let response = response,
                    let responseCode = response.getOptionalStringForKey("responseCode") {                    
                    if let stateToken = response.getOptionalStringForKey("stateCode"),
                        let verifierId = response.getOptionalStringForKey("verifierId"),
                        responseCode == LOGINRCkeys.successBE {
                        weakSelf.stateToken = stateToken
                        weakSelf.invokeDoViewAPI(stateToken: stateToken, verifierId: verifierId)
                    } else {
                        switch responseCode {
                        case LOGINRCkeys.verificationCannotBeFulfilled,
                             LOGINRCkeys.userDoesNotExist,
                             LOGINRCkeys.unblockBefore24Hours:
                            weakSelf.showErrorPage()
                        case LOGINRCkeys.limitExceededDeviceIDUnblock,
                             LOGINRCkeys.limitExceededIPUnblock:
                            weakSelf.showErrorPage(type: .unblockLimitReached)
                        case LOGINRCkeys.userAlreadyUnblocked:
                            weakSelf.showAlreadyUnblockedPage()
                        case LOGINRCkeys.internalServerError2AB,
                             LOGINRCkeys.initBadRequest:
                            weakSelf.showErrorPage(type: .internalError)
                        default:
                            weakSelf.showErrorPage()
                        }
                    }
                }
            }
        }
    }
    
    private func invokeDoViewAPI(stateToken:String, verifierId:String) {
        view.isUserInteractionEnabled = false
        let params: [String:String] = [
            "verifyId" : verifierId,
            "method" : "OTP_SMS"
        ]
        
        JRLServiceManager.doView(params, isLoginFlow: false) { [weak self] (data, error) in
            guard let weakSelf = self else {
                self?.showErrorPage()
                return
            }
            DispatchQueue.main.async {
                weakSelf.view.isUserInteractionEnabled = true
                if let responseData = data,
                    let resultInfo = responseData["resultInfo"] as? [String:Any],
                    let resultCode = resultInfo["resultCode"] as? String,
                    let verifyId = responseData["verifyId"] as? String,
                    let method = responseData["method"] as? String {
                    
                    if resultCode == "SUCCESS" {
                        let dataModel = JRLOtpPsdVerifyModel(loginId: self?.phoneNumber, stateToken: stateToken, otpTextCount: 6, loginType: .mobile)
                        let vc = JRLForgotPwdOTPVC.controller(dataModel)
                        vc.unblockModel = JRLUnblockModel(verifyId: verifyId,
                                                          method: method,
                                                          stateToken: stateToken,
                                                          phoneNumber: weakSelf.phoneNumber,
                                                          fallbackVC: weakSelf.fallbackVC)
                        weakSelf.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        weakSelf.showErrorPage()
                    }
                }
                else {
                    weakSelf.showErrorPage()
                }
            }
        }
    }
    
    private func showAlreadyUnblockedPage() {
        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .alreadyUnblocked, message: "")
        navigationController?.pushViewController(terminalScene, animated: true)
    }
    
    private func showErrorPage(type errorState: JRBlockUnblockState = .unblockError) {
        loadingIndicatorView.isHidden = true
        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: errorState, message: "")
        navigationController?.pushViewController(terminalScene, animated: true)
    }
}

// MARK: - SubViews
extension JRPhoneNumberVC {
    private func addAllSubviews() {
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = view.topAnchor
        }
        
        view.addSubview(backBtn)
        backBtn.anchor(top: topAnchor,
                       left: view.leftAnchor,
                       width: 45.0, height: 45.0)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        view.addSubview(stackView)
        stackView.anchor(top: backBtn.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 16.0, paddingLeft: 16.0, paddingRight: 16.0)
        
        view.addSubview(numberLabel)
        numberLabel.anchor(top: stackView.bottomAnchor,
                           left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingTop: 32.0, paddingLeft: 16.0, paddingRight: 16.0,
                           height: 45.0)
        
        view.addSubview(confirmButton)
        confirmButton.anchor(top: numberLabel.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 48.0, paddingLeft: 16.0, paddingRight: 16.0,
                             height: 45.0)
        
        view.addSubview(loadingIndicatorView)
        loadingIndicatorView.anchor(top: confirmButton.topAnchor,
                                    left: view.leftAnchor,
                                    bottom: confirmButton.bottomAnchor,
                                    right: view.rightAnchor)
    }
}
