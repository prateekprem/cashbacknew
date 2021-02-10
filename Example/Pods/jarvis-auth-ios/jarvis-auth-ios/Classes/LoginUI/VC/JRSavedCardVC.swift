//
//  JRSavedCardVC.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 06/11/20.
//

import UIKit

final class JRSavedCardVC: JRAuthBaseVC {
    // MARK: - Properties
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()
    private let cardNumberTextField = JRGenericTextField(type: .cardNumber)
    private let cardExpiryTextField = JRGenericTextField(type: .expiryDate)
    private let loadingIndicatorView = JRLoadingIndicatorView()

    var unblockModel: JRLUnblockModel?
    
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
        label.numberOfLines = 0
        label.font = .systemSemiBoldFontOfSize(24)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "jr_login_dabu_enter_card_details".localized
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textColor = .colorWithHexString("#506d85")
        return label
    }()
    
    private let dontHaveThisCardLabel: UILabel = {
        let label = UILabel()
        label.text = "jr_login_dabu_dont_have_this_card".localized
        label.font = .fontMediumOf(size: 12.0)
        label.textAlignment = .right
        label.textColor = .colorWithHexString("#00aced")
        return label
    }()
    
    private let invalidCardDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "jr_login_dabu_incorrect_card_details".localized
        label.font = .fontMediumOf(size: 12.0)
        label.textAlignment = .right
        label.textColor = .colorWithHexString("#fd5154")
        return label
    }()
    
    private let confirmButton: CustomButton = {
        let button = CustomButton(ofType: .blueBackground, withText: "jr_login_dabu_confirm_and_unblock".localized)
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    
    var cardNumber: String = "" {
        didSet {
            titleLabel.text = "jr_login_dabu_enter_card_details_ending_with".localized + cardNumber.suffix(4)
        }
    }
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.backgroundColor = JRLoginConstants.Colors.lightBlueBG
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingIndicatorView.isHidden = true
    }
    
    // MARK: - Main Methods
    private func setupUI() {
        view.backgroundColor = .white
        invalidCardDetailsLabel.isHidden = true
        addAllSubviews()
        addGestures()
        setupTextFields()
    }
    
    private func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dontHaveThisCardTapped(tapGestureRecognizer:)))
        dontHaveThisCardLabel.isUserInteractionEnabled = true
        dontHaveThisCardLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupTextFields() {
        cardExpiryTextField.delegate = self
        cardNumberTextField.delegate = self
        cardNumberTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @objc func dontHaveThisCardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let overlayVC = JRGenericBottomSheet()
        overlayVC.viewModel = JRGenericBottomSheetViewModel(title: "jr_login_dabu_dont_have_this_card".localized,
                                                            primaryDesc: "jr_login_dabu_dont_have_this_card_title".localized,
                                                            secondaryDesc: "jr_login_dabu_dont_have_this_card_subtitle".localized,
                                                            buttonText: "jr_login_dabu_call".localized + " " + "jr_login_dabu_unblock_customer_care".localized,
                                                            isCrossBtnEnabled: true)
        overlayVC.transitioningDelegate  = self.overlayTransitioningDelegate
        overlayVC.modalPresentationStyle = .custom
        present(overlayVC, animated: true) {
            self.cardNumberTextField.endEditing(true)
            self.cardExpiryTextField.endEditing(true)
        }
    }
    
    @objc private func backBtnTapped() {
        guard let model = unblockModel else { return }
        
        if let fallbackVC = model.fallbackVC {
            navigationController?.popToViewController(fallbackVC, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc private func confirmTapped() {
        cardNumberTextField.endEditing(true)
        cardExpiryTextField.endEditing(true)
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        invokeVerifyCardDetailsPI()
    }
}

// MARK: - APIs
extension JRSavedCardVC {
    private func invokeVerifyCardDetailsPI() {
        guard let model = unblockModel else { return }
        
        guard areInputsValid() else {
            loadingIndicatorView.isHidden = true
            return
        }
        
        view.isUserInteractionEnabled = false
        let month = cardExpiryTextField.text?.prefix(2)
        let year = cardExpiryTextField.text?.suffix(2)
        let params: [String : Any] = ["meta" : ["verifyId":  model.verifyId],
                                      "cardNo" : cardNumberTextField.text ?? "",
                                      "cardExpiryMonth" : month ?? "",
                                      "cardExpiryYear": year ?? ""
        ]
        
        JRLServiceManager.cardDetails(params) { [weak self] (data,error) in
            guard let weakSelf = self else {
                self?.showErrorPage()
                return
            }
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                if let responseData = data,
                    let status = responseData[LOGINWSKeys.kStatus] as? String,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    
                    if status == "SUCCESS", responseCode == "01" {
                        weakSelf.invokeFullFillAPI()
                    }
                    else {
                        weakSelf.showErrorPage()
                    }
                }
                else {
                    weakSelf.showErrorPage()
                }
            }
        }
    }
    
    private func invokeFullFillAPI() {
        guard let model = unblockModel else { return }
        
        view.isUserInteractionEnabled = false
        let params: [String: String] = ["stateCode": model.stateToken]
        
        JRLServiceManager.fulfill(params) { [weak self] (data,error) in
            guard let weakSelf = self else {
                self?.showErrorPage()
                return
            }
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                if let responseData = data,
                    let status = responseData[LOGINWSKeys.kStatus] as? String,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    
                    if let stateCode = responseData["stateCode"] as? String,
                        status == "SUCCESS",
                        responseCode == "BE1400001" {
                        
                        var parameters: [String: String] = ["comment": "DIY Account Unblock",
                                                            "status": "UNBLOCK",
                                                            "channelName": "DIY",
                                                            "userConsent": "1"]
                        parameters["verificationData"] = stateCode
                        parameters["verificationType"] = "STATE_CODE"
                        weakSelf.invokeUnblockSuccessAPI(parameters: parameters)
                    } else if status == "FAILURE" && responseCode == "BE1426003" {
                        weakSelf.showErrorPage(type: .internalError)
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
    
    private func invokeUnblockSuccessAPI(parameters: [String: String]) {
        view.isUserInteractionEnabled = false
        JRLServiceManager.updateAccountStatus(parameters) { [weak self] (response, error) in
            DispatchQueue.main.async { [weak self] in

                guard let weakSelf = self else {
                    return
                }
                weakSelf.view.isUserInteractionEnabled = true

                if let response = response,
                    let responseCode = response.getOptionalStringForKey("responseCode") {

                    switch responseCode {

                    case LOGINRCkeys.successBE:
                        JRLoginUI.sharedInstance().delegate?.signOutAfterUserBlock()
                        weakSelf.showSuccessPage()

                    case LOGINRCkeys.issueProcessingRequestAB,
                         LOGINRCkeys.internalServerErrorAB:
                        weakSelf.showErrorPage()

                    case LOGINRCkeys.invalidStateTokenAB,
                         LOGINRCkeys.invalidSessionTokenAB,
                         LOGINRCkeys.anyParamterMissingAB:
                        weakSelf.showErrorPage()

                    default:
                        weakSelf.showErrorPage()
                    }

                } else {
                    weakSelf.showErrorPage()
                }
            }
        }
    }
    
    private func showSuccessPage() {
        guard let model = unblockModel else { return }
        
        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .unblocked(model.phoneNumber), message: "")
        navigationController?.pushViewController(terminalScene, animated: true)
    }
    
    private func showErrorPage(type errorState: JRBlockUnblockState = .unblockError) {
        loadingIndicatorView.isHidden = true
        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: errorState, message: "")
        navigationController?.pushViewController(terminalScene, animated: true)
    }
    
    func areInputsValid() -> Bool{
        if cardNumberTextField.text == "" {
            invalidCardDetailsLabel.isHidden = false
            return false
        }
        if let text = cardNumberTextField.text, isStringContainsOnlyNumbers(string:text) == false {
            invalidCardDetailsLabel.isHidden = false
            return false
        }
        if let txt = cardExpiryTextField.text, txt.isEmpty == true {
            invalidCardDetailsLabel.isHidden = false
            return false
        }
        if let txt = cardExpiryTextField.text, txt.length < 7 {
            invalidCardDetailsLabel.isHidden = false
            return false
        }
        invalidCardDetailsLabel.isHidden = true
        return true
    }
    
    func isStringContainsOnlyNumbers(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

// MARK: - SubViews
extension JRSavedCardVC {
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
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        
        view.addSubview(stackView)
        stackView.anchor(top: backBtn.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 16.0, paddingLeft: 16.0, paddingRight: 16.0)
        
        view.addSubview(cardNumberTextField)
        cardNumberTextField.anchor(top: stackView.bottomAnchor,
                                   left: view.leftAnchor,
                                   right: view.rightAnchor,
                                   paddingTop: 48.0, paddingLeft: 16.0, paddingRight: 16.0,
                                   height: 45.0)
        
        view.addSubview(cardExpiryTextField)
        cardExpiryTextField.anchor(top: cardNumberTextField.bottomAnchor,
                                   left: view.leftAnchor,
                                   right: view.rightAnchor,
                                   paddingTop: 32.0, paddingLeft: 16.0, paddingRight: 16.0,
                                   height: 45.0)
        
        view.addSubview(dontHaveThisCardLabel)
        dontHaveThisCardLabel.anchor(top: cardExpiryTextField.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingTop: 16.0, paddingRight: 16.0,
                                     height: 16.0)
        
        view.addSubview(invalidCardDetailsLabel)
        invalidCardDetailsLabel.anchor(top: cardExpiryTextField.bottomAnchor,
                                       left: view.leftAnchor,
                                       paddingTop: 16.0, paddingLeft: 16.0,
                                       height: 16.0)
        
        view.addSubview(confirmButton)
        confirmButton.anchor(top: dontHaveThisCardLabel.bottomAnchor,
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

// MARK: - UITextFieldDelegate Methods
extension JRSavedCardVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case cardNumberTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        case cardExpiryTextField:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            let characterSet = CharacterSet(charactersIn: string)
            if text.count == 2, !string.isEmpty {
                textField.text = text + " / "
            }
            else if text.count == 5, string.isEmpty, let text = textField.text {
                textField.text = String(text.dropLast(3))
            }
            return CharacterSet.decimalDigits.isSuperset(of: characterSet) && newLength <= 7
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        invalidCardDetailsLabel.isHidden = true
    }
}

// MARK: - Overlay Classes
final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController:presented, presenting:presenting)
    }
    
}

final class OverlayPresentationController: UIPresentationController {
    private let dimmedBackgroundView = UIView()
    private let ratio: CGFloat = 276.0 / 812.0
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        addGestures()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerBounds = containerView?.bounds else { return CGRect.zero }
        return CGRect(x: 0, y: containerBounds.height * (1.0 - ratio), width: containerBounds.width, height: containerBounds.height * ratio)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        dimmedBackgroundView.removeFromSuperview()
    }
    
    private func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        dimmedBackgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func backgroundTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let coordinator = presentingViewController.transitionCoordinator else { return }
        containerView.addSubview(dimmedBackgroundView)
        dimmedBackgroundView.backgroundColor = .black
        dimmedBackgroundView.frame = containerView.bounds
        dimmedBackgroundView.alpha = 0
        coordinator.animate(alongsideTransition: { _ in
            self.dimmedBackgroundView.alpha = 0.5
        }, completion: nil)
    }
}

//MARK: - UIButton Extension

extension UIButton {
    func getCustomButton(ofType buttonType: CustomButtonType = .whiteBackground, withText text: String, font: UIFont = .fontSemiBoldOf(size: 14.0), radius: CGFloat = 5.0, borderWidth: CGFloat = 1.0) -> UIButton {
        let colorBlue: UIColor = .colorWithHexString("#00ACED")
        let colorWhite: UIColor = .white
        backgroundColor = (buttonType == .whiteBackground) ? colorWhite : colorBlue
        setTitle(text, for: .normal)
        titleLabel?.font = font
        tintColor = (buttonType == .whiteBackground) ? colorBlue : colorWhite
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = colorBlue.cgColor
        return self
    }
}

public enum CustomButtonType {
    case whiteBackground
    case blueBackground
}

final public class CustomButton: UIButton {
    init(ofType buttonType: CustomButtonType = .whiteBackground, withText text: String, font: UIFont = .fontSemiBoldOf(size: 14.0), radius: CGFloat = 5.0, borderWidth: CGFloat = 1.0) {
        super.init(frame: .zero)
        
        let colorBlue: UIColor = .colorWithHexString("#00aced")
        let colorWhite: UIColor = .white
        
        backgroundColor = (buttonType == .whiteBackground) ? colorWhite : colorBlue
        setTitle(text, for: .normal)
        titleLabel?.font = font
        setTitleColor((buttonType == .whiteBackground) ? colorBlue : colorWhite, for: .normal)
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = colorBlue.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
