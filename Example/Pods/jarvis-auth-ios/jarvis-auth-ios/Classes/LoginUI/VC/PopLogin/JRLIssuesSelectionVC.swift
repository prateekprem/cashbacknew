//
//  JRLIssuesSelectionVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 28/01/20.
//

import UIKit

class JRLIssuesSelectionVC: JRAuthBaseVC {
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    var dataModel: JRLOtpPsdVerifyModel?
    
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    
    //MARK:-Instance
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRLIssuesSelectionVC {
        let vc = UIStoryboard.init(name: "JRLOTPViaEmail", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRLIssuesSelectionVC") as! JRLIssuesSelectionVC
        vc.dataModel = dataModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataModel?.isLoginFlow == false {
            if let loginType = dataModel?.loginType, loginType == .mobile, let mobileNumber = dataModel?.loginId {
                mobileNumberLbl.text = JRAuthUtility.addSeparator(mobileNumber, " ", 5)
            } else {
                mobileNumberLbl.text = dataModel?.loginId
            }
        }
        
        // Do any additional setup after loading the view.
        loadingIndicatorView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if dataModel?.isLoginFlow == true {
            return
        }
        let maskPath = UIBezierPath(roundedRect: popUpView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        popUpView.layer.mask = shape
        hideView(false)
    }
    
    private func bringView(_ animated:Bool){
        if dataModel?.isLoginFlow == true {
            return
        }
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.transparentView.backgroundColor = UIColor.clear
        self.transparentView.frame.origin.y = self.transparentView.frame.size.height
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.transparentView.backgroundColor = LOGINCOLOR.blackBgWithAlpha70
            self.transparentView.backgroundColor = UIColor.clear
            self.transparentView.frame.origin.y = 0
        }, completion: { _ in
            self.transparentView.backgroundColor = LOGINCOLOR.blackBgWithAlpha70
            self.transparentView.frame.origin.y = 0
        })
    }
    
    private func hideView(_ animated:Bool){
        
        if dataModel?.isLoginFlow == true {
            return
        }
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.transparentView.frame.origin.y = 0
        self.transparentView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.transparentView.frame.origin.y = self.transparentView.frame.size.height
        }, completion: { _ in
            self.transparentView.frame.origin.y = self.transparentView.frame.size.height
        })
    }
    
    @IBAction func onBackBtnTouched(_ sender: UIButton) {
        if let dataModel = dataModel{
            let loginType = dataModel.loginType
            switch loginType
            {
            case .mobile, .email:
//                JRLoginGACall.loginBackBtnClicked()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            case .newAccount:
//                JRLoginGACall.signUpBackBtnClicked()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }else if controller.isKind(of: JRAuthSignInVC.self){
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onOtpViaEmailBtnTouch(_ sender: UIButton) {
        if dataModel?.isLoginFlow == true {
            return
        }
        bringView(true)

    }
    
    @IBAction func onSomeOtherIssueBtnTouched(_ sender: UIButton) {
        //JRLoginGACall.forgotPwdContactUsClicked()
        JRLoginUI.sharedInstance().delegate?.openLoginIssues("", self)
    }
    
    @IBAction func onConfirmBtnTouched(_ sender: UIButton) {
        
        if let ldatamodel = dataModel{
            if ldatamodel.isLoginFlow{
                //Logged in
                if isEmailOTPLoginEnabled(), let _ = LoginAuth.sharedInstance().getEmail(){
                    sendEmailOTP()
                }
                else{
                    invokeVerifierAPI()
                }
            }else{
                //Logged out
                if isEmailOTPLogoutEnabled(){
                    sendEmailOTP()
                }
                else{
                    invokeVerifierAPI()
                }
            }
        }
        else{
            //Open CST
            var loginId = ""
            if let ldataModel = dataModel, let id = ldataModel.loginId{
                loginId = id
            }
            JRLoginUI.sharedInstance().delegate?.openLoginIssues(loginId, self)
        }
    }
    
    @IBAction func onCancelBtnTouched(_ sender: UIButton) {
        if dataModel?.isLoginFlow == true {
            return
        }
        hideView(true)
    }
    
    //OTP via Email Related changes
    func sendEmailOTP() {
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken else {
            return
        }
        if let vc = JRLVerifyVC.controller("jr_login_verifying_your_details".localized) {
            view.endEditing(true)
            navigationController?.pushViewController(vc, animated: true)
        }
        let params: [String: String] = ["state_token": stateToken, LOGINWSKeys.kMode: "1"]
        JRLServiceManager.sendEmailOTP(params) { [weak self] (data,error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelf.navigationController?.popViewController(animated: false)
                if error != nil {
                    if let message = error?.localizedDescription {
                        weakSelf.showSettingsAlert(message)
                    } else {
                        weakSelf.showSettingsAlert(JRLoginConstants.generic_error_message)
                    }
                    return
                }
                if let responseData = data, let status = responseData[LOGINWSKeys.kStatus] as? String,let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    if let state = responseData["state"] as? String, status == "SUCCESS", responseCode == "01" {
                        if let dataModel = weakSelf.dataModel{
                            let dataModel = dataModel
                            dataModel.stateToken = state
                            dataModel.otpTextCount = 6
                            let vc = JRPUEmailOtpVC.controller(dataModel)
                            if let email = responseData["meta"] as? String{
                                vc.email = email
                            }
                            weakSelf.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else if status == "FAILURE", let message = responseData[LOGINWSKeys.kMesssage] as? String{
                        if responseCode == "3006"{
                            // reinitate from the beginning
                            weakSelf.showStateTokenAlert()
                        }else{
                            weakSelf.showSettingsAlert(message)
                        }
                    }
                }
                else {
                    weakSelf.showSettingsAlert("jr_login_server_error".localized)
                }
            }
        }
    }
    
    private func showSettingsAlert(_ message : String){
        if dataModel?.isLoginFlow == false {
            hideView(true)
        }
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "jr_login_ok".localized, style: UIAlertAction.Style.default, handler: { action in
            if self.dataModel?.isLoginFlow == true {
                JRLoginUI.sharedInstance().delegate?.pushLoginIssues("", self)
            }
            else {
                JRLoginUI.sharedInstance().delegate?.openLoginIssues("", self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    private func showStateTokenAlert(){
        let alert = UIAlertController(title: "", message: "jr_login_invalid_state_error".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "jr_login_ok".localized, style: UIAlertAction.Style.default, handler: { action in
            if self.dataModel?.isLoginFlow == true {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension JRLIssuesSelectionVC{
    
    internal func isEmailOTPLoginEnabled() -> Bool{
        var value: Bool = false
        if let val: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("emailOtpLoginEnable_ios"){
            value = val
        }
        
        return value
    }
    
    internal func isEmailOTPLogoutEnabled() -> Bool{
        var value: Bool = false
        if let val: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("emailOtpLogoutEnable_ios"){
            value = val
        }
        return value
    }
    
    func invokeVerifierAPI() {
        guard self.isNetworkReachable() else { return }
        
        if let dataModel = dataModel, dataModel.stateToken != nil || LoginAuth.sharedInstance().getSsoToken() != nil  {
            
            UIView.animate(withDuration: 0.1) {
                self.loadingIndicatorView.isHidden = false
                self.loadingIndicatorView.showLoadingView()
            }
            view.isUserInteractionEnabled = false
            var params: [String: String] = [String : String]()
            if dataModel.isLoginFlow == true {
                params["bizFlow"] = "DIY_PHONE_UPDATE_LOGGEDIN"
            }
            else {
                if let stateToken = dataModel.stateToken{
                    params["stateCode"] = stateToken
                }
                params["bizFlow"] = "DIY_PHONE_UPDATE"
            }
            
            JRLServiceManager.verifierInit(params) { [weak self] (data,error) in
                guard let weakSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    weakSelf.loadingIndicatorView.isHidden = true
                    weakSelf.view.isUserInteractionEnabled = true
                    if error != nil {
                        if let message = error?.localizedDescription {
                            weakSelf.showSettingsAlert(message)
                        } else {
                            weakSelf.showSettingsAlert(JRLoginConstants.generic_error_message)
                        }
                        return
                    }
                    if let responseData = data, let status = responseData[LOGINWSKeys.kStatus] as? String,let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                        
                        var loginId = ""
                        if let id = weakSelf.dataModel?.loginId {
                            loginId = id
                        }
                        
                        if dataModel.isLoginFlow == true { //LoggedIn
                            if let stateCode = responseData["stateCode"] as? String, status == "SUCCESS", responseCode == "BE1400001" {
                                if let verifierId = responseData["verifierId"] as? String{
                                    weakSelf.invokeDoViewAPI(stateToken: stateCode, verifierId: verifierId)
                                    return
                                }
                            }
                            JRLoginUI.sharedInstance().delegate?.openLoginIssues(loginId, weakSelf)
                        }
                        else {//Logout
                            
                            //Email OTP verification mechanism is considered for the phone update flow
                            //The logic of when to show the email OTP still remains same
                            if let stateCode = responseData["stateCode"] as? String, status == "SUCCESS", responseCode == "BE1400001" {
                                if let verifierId = responseData["verifierId"] as? String{
                                    weakSelf.invokeDoViewAPI(stateToken: stateCode, verifierId: verifierId)
                                }
                                else{
                                    JRLoginUI.sharedInstance().delegate?.openLoginIssues(loginId, weakSelf)
                                }
                            }
                            else if status == "FAILURE", responseCode == "BE1426004",
                                weakSelf.isEmailOTPLogoutEnabled(){
                                weakSelf.sendEmailOTP()
                            }
                            else if status == "FAILURE"{
                                JRLoginUI.sharedInstance().delegate?.openLoginIssues(loginId, weakSelf)
                            }
                        }
                    }
                    else {
                        weakSelf.showAlert("jr_login_server_error".localized)
                    }
                }
            }
        }
    }
    
    func invokeDoViewAPI(stateToken:String, verifierId:String) {
        guard self.isNetworkReachable() else { return }
        
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        
        let bodyDict:[String:String] = ["verifyId" : verifierId,
                                        "method" : "SAVED_CARD"]
        JRLServiceManager.doView(bodyDict, isLoginFlow: dataModel?.isLoginFlow ?? false) { [weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                self?.loadingIndicatorView.isHidden = true
                self?.view.isUserInteractionEnabled = true
                if error != nil {
                    weakSelf.showSettingsAlert(JRLoginConstants.generic_error_message)
                    return
                }
                if let responseData = data, let renderData = responseData["renderData"]as? [String:Any], let cardList = renderData["masked_card_list"]{
                    if let dataModel = weakSelf.dataModel{
                        let dataModel = dataModel
                        dataModel.stateToken = stateToken
                        let vc = JRLSavedCardVC.controller(dataModel)
                        vc.verifierId = verifierId
                        if let cardString = cardList as? String, let array = weakSelf.convertToArray(str: cardString){
                            vc.cardList = array
                        }
                        weakSelf.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    weakSelf.showSettingsAlert(JRLoginConstants.generic_error_message)
                }
            }
        }
    }
    
    func convertToArray(str: String) -> [String]? {
        
        let data = str.data(using: .utf8)
        
        do {
            return try JSONSerialization.jsonObject(with: data!, options: []) as? [String]
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
}
