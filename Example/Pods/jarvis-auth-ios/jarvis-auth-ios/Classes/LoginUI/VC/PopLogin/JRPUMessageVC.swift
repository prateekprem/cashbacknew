//
//  JRPUMessageVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 08/04/20.
//

import UIKit

class JRPUMessageVC: JRAuthBaseVC {
    
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var popUpView: UIView!
    var dataModel: JRLOtpPsdVerifyModel?
    
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loginId = UserDefaults.standard.string(forKey: "prefilledLoginId") {
            dataModel = JRLOtpPsdVerifyModel(loginId: loginId, stateToken: "", otpTextCount: nil, loginType: .mobile)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let maskPath = UIBezierPath(roundedRect: popUpView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        popUpView.layer.mask = shape
    }
    
    static func controller() -> JRAuthBaseVC {
        return UIStoryboard(name: "JRLOTPViaEmail", bundle:JRLBundle).instantiateViewController(withIdentifier: "JRPUMessageVC") as! JRAuthBaseVC
    }
    
    @IBAction func onConfirmBtnTouched(_ sender: UIButton) {
        sendEmailOTP()
    }
    
    @IBAction func onCancelBtnTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //OTP via Email Related changes
    func sendEmailOTP() {
        guard self.isNetworkReachable() else { return }

        guard let dataModel = dataModel, let loginId = dataModel.loginId else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        let params: [String: String] = ["loginId": loginId, "actionType": "UPDATE_PHONE"]
        JRLServiceManager.updatePhoneOTPViaProfile(params) { [weak self] (data,error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                self?.loadingIndicatorView.isHidden = true
                self?.view.isUserInteractionEnabled = true
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
                        //weakSelf.dismiss(animated: true, completion: {
                            if let dataModel = weakSelf.dataModel{
                                let dataModel = JRLOtpPsdVerifyModel(loginId: loginId, stateToken: state, otpTextCount: 6, loginType: dataModel.loginType)
                                let vc = JRPUSmsOtpVC.getJRPUSmsOtpVC(dataModel)
                                weakSelf.navigationController?.pushViewController(vc, animated: true)
                            }
                        //})
                    } else if status == "FAILURE", let message = responseData[LOGINWSKeys.kMesssage] as? String{
                        if responseCode == "3006"{
                            // reinitate from the beginning
                            weakSelf.dismiss(animated: true, completion: nil)
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
}
