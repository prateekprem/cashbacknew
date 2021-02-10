//
//  JRDIYAccountBlockReasonVC.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 28/09/20.
//

import jarvis_utility_ios

enum JRVerificationType {
    case ssoToken
    case stateCode(String, String)
}

class JRDIYAccountBlockReasonVC: JRAuthBaseVC {
    
    enum BlockReason {
        case none
        case phoneStolen
        case fraudDetected
        case other
    }
    
    @IBOutlet weak private var phoneStolenReasonRadioImgView: UIImageView!
    @IBOutlet weak private var fraudReasonRadioImgView: UIImageView!
    @IBOutlet weak private var otherReasonRadioImgView: UIImageView!
    
    @IBOutlet weak private var phoneStolenReasonLbl: UILabel!
    @IBOutlet weak private var fraudReasonLbl: UILabel!
    @IBOutlet weak private var otherReasonLbl: UILabel!
    
    @IBOutlet weak private var phoneStolenReasonRadioBtn: UIButton!
    @IBOutlet weak private var fraudReasonRadioBtn: UIButton!
    @IBOutlet weak private var otherReasonRadioBtn: UIButton!
    
    @IBOutlet weak private var otherReasonPlacehohlderLbl: UILabel!
    @IBOutlet weak private var otherReasonTextView: UITextView!
    @IBOutlet weak private var otherReasonCharacterCountLbl: UILabel!
    @IBOutlet weak private var otherReasonTextViewContainer: UIView!
    @IBOutlet weak private var otherReasonTextStack: UIStackView!
    
    @IBOutlet weak private var proceedContainerView: UIView!
    @IBOutlet weak private var backBtn: UIButton!
    @IBOutlet weak private var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak private var viewTopConstraint: NSLayoutConstraint!
    
    private var selectedReason = BlockReason.none {
        didSet {
            if oldValue != selectedReason {
                updateViews()
            }
        }
    }
    private let maxOtherReasonCharacters = 150
    private let topConstraintDefaultValue: CGFloat = 0.0
    private var verificationType = JRVerificationType.ssoToken

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        otherReasonTextView.resignFirstResponder()
    }
    
    class func getController(verificationType: JRVerificationType = .ssoToken) -> JRDIYAccountBlockReasonVC? {
        if let controller =  JRAuthManager.kDIYAccountBlockUnblockStoryboard.instantiateViewController(withIdentifier: "JRDIYAccountBlockReasonVC") as? JRDIYAccountBlockReasonVC {
            controller.verificationType = verificationType
            return controller
        }
        return nil
    }
    
    @objc override func keyboardWillShow(notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let safeAreaTopInset: CGFloat
            if #available(iOS 11.0, *) {
                safeAreaTopInset = view.safeAreaInsets.top
            } else {
                safeAreaTopInset = 0.0
            }
            
            let actualFrame = otherReasonTextStack.convert(otherReasonTextStack.bounds, to: view)
            let projectedTop = (topConstraintDefaultValue - (actualFrame.maxY + safeAreaTopInset - endFrame.cgRectValue.minY))
            viewTopConstraint.constant = min(topConstraintDefaultValue, projectedTop)
        }
    }
    
    @objc override func keyboardWillHide(notification: Notification) {
        viewTopConstraint.constant = topConstraintDefaultValue
    }
}

private extension JRDIYAccountBlockReasonVC {
    
    func setupView() {
        otherReasonTextView.delegate = self
        proceedContainerView.makeRoundedBorder(withCornerRadius: 6.0)
        otherReasonTextViewContainer.roundCorner(1.0, borderColor: UIColor(hex: "00aced"), rad: 4.0)
        
        updateViews()
        updateOtherReasonCharacterCount()
    }
    
    func updateOtherReasonCharacterCount() {
        otherReasonCharacterCountLbl.text = "\(otherReasonTextView.text.count)/\(maxOtherReasonCharacters) \("jr_login_dabu_characters".localized)"
    }
    
    func resetRadioButtons() {
        let inactiveRadioImage = UIImage(named: "icAuthRadioInactive", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        phoneStolenReasonRadioImgView.image = inactiveRadioImage
        fraudReasonRadioImgView.image = inactiveRadioImage
        otherReasonRadioImgView.image = inactiveRadioImage
    }
    
    func resetLabelFont() {
        phoneStolenReasonLbl.font = .systemFont(ofSize: 14.0, weight: .regular)
        fraudReasonLbl.font = .systemFont(ofSize: 14.0, weight: .regular)
        otherReasonLbl.font = .systemFont(ofSize: 14.0, weight: .regular)
    }
    
    func updateViews() {
        resetRadioButtons()
        resetLabelFont()
        
        let selectedFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        let activeRadioImage = UIImage(named: "icAuthRadioActive", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        
        switch selectedReason {
        case .none:
            break
            
        case .phoneStolen:
            phoneStolenReasonLbl.font = selectedFont
            phoneStolenReasonRadioImgView.image = activeRadioImage
            otherReasonTextStack.isHidden = true
            otherReasonTextView.resignFirstResponder()
            
        case .fraudDetected:
            fraudReasonLbl.font = selectedFont
            fraudReasonRadioImgView.image = activeRadioImage
            otherReasonTextStack.isHidden = true
            otherReasonTextView.resignFirstResponder()
            
        case .other:
            otherReasonLbl.font = selectedFont
            otherReasonRadioImgView.image = activeRadioImage
            otherReasonTextStack.isHidden = false
            otherReasonTextView.becomeFirstResponder()
        }
    }
    
    @IBAction func phoneStolenReasonBtnTapped(_ sender: UIButton) {
        selectedReason = .phoneStolen
    }
    
    @IBAction func fraudReasonBtnTapped(_ sender: UIButton) {
        selectedReason = .fraudDetected
    }
    
    @IBAction func otherReasonBtnTapped(_ sender: UIButton) {
        selectedReason = .other
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedBtnTapped(_ sender: UIButton) {
        
        /*
        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .recentlyBlocked, message: "message")
        navigationController?.pushViewController(terminalScene, animated: true)
        JRLoginUI.sharedInstance().delegate?.signOutAfterUserBlock()
        return;
        */
        let comment: String
        
        switch selectedReason {
        case .none:
            showError(text: "jr_login_dabu_no_reason_selected_message".localized)
            return
        case .phoneStolen:
            comment = "jr_login_dabu_phone_stolen_reason".localized
        case .fraudDetected:
            comment = "jr_login_dabu_fraud_activity_reason".localized
        case .other:
            if let otherReason = otherReasonTextView.text, !otherReason.isEmpty {
                comment = "Other, \(otherReason)"
            } else {
                showError(text: "jr_login_dabu_empty_other_reason_message".localized)
                return
            }
        }
        
        let message = "jr_login_dabu_block_confirm_message".localized
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "jr_ac_yes".localized, style: .default) { [weak self] _ in
            if let weakSelf = self {
                weakSelf.blockAccount(with: comment)
            }
        }
        let noAction = UIAlertAction(title: "jr_ac_No".localized, style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func blockAccount(with comment: String) {
        
        var parameters: [String: String] = ["comment": comment,
                                             "status": "BLOCK",
                                             "channelName": "DIY",
                                             "userConsent": "1"]
        
        switch verificationType {
            
        case .ssoToken:
            let number = (LoginAuth.sharedInstance().getMobileNumber() ?? "")
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken(), !ssoToken.isEmpty {
                parameters["verificationData"] = ssoToken
                parameters["verificationType"] = "SESSION_TOKEN"
                updateAccountStatus(parameters: parameters, phoneNumber: number)
                
            } else {
                LoginAuth.getSSOTokenWith { [weak self] (success, token, _) in
                    if let weakSelf = self, let ssoToken = token {
                        parameters["verificationData"] = ssoToken
                        parameters["verificationType"] = "SESSION_TOKEN"
                        weakSelf.updateAccountStatus(parameters: parameters, phoneNumber: number)
                    }
                }
            }
            
        case .stateCode(let code, let number):
            parameters["verificationData"] = code
            parameters["verificationType"] = "STATE_CODE"
            updateAccountStatus(parameters: parameters, phoneNumber: number)
        }
    }
    
    private func updateAccountStatus(parameters: [String: String], phoneNumber: String) {
        
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        
        JRLServiceManager.updateAccountStatus(parameters) { [weak self] (response, error) in
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self else {
                    return
                }
                weakSelf.loadingIndicatorView.isHidden = true
                weakSelf.view.isUserInteractionEnabled = true
                
                if let response = response,
                    let responseCode = response.getOptionalStringForKey("responseCode"),
                    let message = response.getOptionalStringForKey("message") {
                    
                    switch responseCode {
                        
                    case LOGINRCkeys.successBE:
                        JRLoginUI.sharedInstance().delegate?.signOutAfterUserBlock()
                        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .blocked(phoneNumber), message: message)
                        weakSelf.navigationController?.pushViewController(terminalScene, animated: true)
                        
                    case LOGINRCkeys.issueProcessingRequestAB,
                         LOGINRCkeys.internalServerErrorAB:
                        let message = "jr_login_something_went_wrong_please_try_after_sometime".localized
                        weakSelf.showError(text: message)
                        
                    case LOGINRCkeys.invalidStateTokenAB,
                         LOGINRCkeys.invalidSessionTokenAB,
                         LOGINRCkeys.anyParamterMissingAB:
                        //weakSelf.showTerminalAlert(with: message)
                        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .blockError, message: message)
                        weakSelf.navigationController?.pushViewController(terminalScene, animated: true)
                        
                    default:
                        weakSelf.showError(text: message)
                    }
                    
                } else if let error = error {
                    weakSelf.showError(text: error.localizedDescription)
                    
                } else {
                    let message = "jr_login_something_went_wrong_please_try_after_sometime".localized
                    weakSelf.showError(text: message)
                }
            }
        }
    }
    
    func showTerminalAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let weakSelf = self, let navCont = weakSelf.navigationController {
                navCont.popToRootViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension JRDIYAccountBlockReasonVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let prevText = textView.text,
           let textRange = Range(range, in: prevText) {
           let updatedText = prevText.replacingCharacters(in: textRange, with: text)
            return (updatedText.count <= maxOtherReasonCharacters)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        otherReasonPlacehohlderLbl.isHidden = !textView.text.isEmpty
        updateOtherReasonCharacterCount()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        otherReasonPlacehohlderLbl.isHidden = !textView.text.isEmpty
    }
}
