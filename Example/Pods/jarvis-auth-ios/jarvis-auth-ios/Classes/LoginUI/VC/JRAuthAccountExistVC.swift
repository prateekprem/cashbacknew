//
//  JRAuthAccountExistVC.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 17/02/20.
//

import UIKit

class JRAuthAccountExistVC: JRAuthBaseVC {
    
    //MARK:- Outlets & Properties
    @IBOutlet weak private var titleLbl           : UILabel!
    @IBOutlet weak private var subtitleLbl        : UILabel!
    @IBOutlet weak private var proceedBtn         : UIButton!
    @IBOutlet weak private var loginToExistingBtn : UIButton!
    
    var dataModel: JRLOtpPsdVerifyModel?
    var loginId: String = ""
    
    //MARK:- Instance
    class var newInstance: JRAuthAccountExistVC {
        let vc = JRAuthManager.kAuthStoryboard.instantiateViewController(withIdentifier: "JRAuthAccountExistVC") as! JRAuthAccountExistVC
        return vc
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
}

// MARK: - IBAction
private extension JRAuthAccountExistVC {
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ProceedToCreateButtonTapped(_ sender: Any) {
//        JRLoginGACall.signUpProceedToCreatedAccountClicked()
        claimAccount()
    }
    
    @IBAction func loginToExistingAccountTapped(_ sender: Any) {
        guard let dataModel = dataModel else {
            return
        }
//        JRLoginGACall.signUpLoginToExistingAccountClicked()
        let vc = JRAuthPasswordVC.controller(dataModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Private methods
private extension JRAuthAccountExistVC {
    func setUpUI() {
        guard let fullLoginId = JRLHelper.getFullLoginId(dataModel: dataModel) else {
            return
        }
        titleLbl.text = "jr_login_a_paytm_account_already_exists_for".localized + fullLoginId
        loginId = fullLoginId
//        JRLoginGACall.claimAccountPageLoader()
    }
    
    func claimAccount(retryCount: Int = 0) {
        guard let stateToken = dataModel?.stateToken else {
            return
        }
        let params = [LOGINWSKeys.kStateToken:stateToken]
        JRLServiceManager.initiateClaimAccount(params) { [weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    if (error as NSError).code == 311 {
                        if retryCount < 2 {
                            let updateRetryCount = (retryCount + 1)
                            weakSelf.claimAccount(retryCount: updateRetryCount)
                        } else {
                            weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                        }
                    } else if !error.localizedDescription.isEmpty {
                        weakSelf.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                    } else {
                        weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                    }
                    return
                }
                if let responseData = data,
                    let status = responseData[LOGINWSKeys.kStatus] as? String,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    
                    switch responseCode {
                    case LOGINRCkeys.success:
                        if (status.caseInsensitiveCompare("SUCCESS") == .orderedSame),
                            let oauthCode = responseData[LOGINWSKeys.kOauthCode] as? String {
                            JRLServiceManager.setAccessToken(code: oauthCode,loginId: weakSelf.loginId, completionHandler: { (isSuccess, error) in
                                if let success = isSuccess, success {
//                                    JRLoginGACall.signupSuccess()
                                }
                                weakSelf.signInCompleted(isSuccess: isSuccess, error: error)
                            })
                        } else if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                            weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        } else {
                            let message = JRLoginConstants.generic_error_message
                            weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        }
                        
                    case LOGINRCkeys.invalidPublicKey:
                        if retryCount < 2 {
                            let updateRetryCount = (retryCount + 1)
                            weakSelf.claimAccount(retryCount: updateRetryCount)
                        } else {
                            fallthrough
                        }
                        
                    case LOGINRCkeys.badRequest,
                         LOGINRCkeys.issueProcessingRequest,
                         LOGINRCkeys.signatureTimeExpired,
                         LOGINRCkeys.invalidSignature,
                         LOGINRCkeys.authorizationMissing,
                         LOGINRCkeys.BEInvalidToken,
                         LOGINRCkeys.clientPermissionNotFound,
                         LOGINRCkeys.missingMandatoryHeaders,
                         LOGINRCkeys.scopeNotRefreshable,
                         LOGINRCkeys.invalidAuthCode,
                         LOGINRCkeys.invalidRefreshToken,
                         LOGINRCkeys.internalServerErr,
                         LOGINRCkeys.authErr:
                        let message = JRLoginConstants.generic_error_message
                        weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        
                    case LOGINRCkeys.unprocessableEntity:
                        fallthrough
                        //JRAuthSessionExpiryMgr.openLogin()
                        
                    default:
                        if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                            weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        } else {
                            let message = JRLoginConstants.generic_error_message
                            weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        }
                    }
                } else {
                    weakSelf.view.showToast(toastMessage: "jr_login_server_error".localized, duration: 3.0)
                }
            }
        }
    }
}
