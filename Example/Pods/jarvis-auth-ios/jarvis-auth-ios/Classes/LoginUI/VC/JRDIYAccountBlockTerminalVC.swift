//
//  JRDIYAccountBlockTerminalVC.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 28/09/20.
//

import UIKit

enum JRBlockUnblockState {
    case none
    case blocked(String)
    case unblocked(String)
    case blockError
    case unblockError
    case alreadyBlocked
    case alreadyUnblocked
    case blockLimitReached
    case unblockLimitReached
    case recentlyBlocked
    case internalError
    
    var image: UIImage? {
        switch self {
        case .blocked, .unblocked, .alreadyUnblocked:
            return UIImage(named: "accountBlockedSuccessfully", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        case .none, .blockError, .blockLimitReached, .alreadyBlocked, .unblockError, .recentlyBlocked:
            return UIImage(named: "verificationFailed", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        case .unblockLimitReached:
            return UIImage(named: "verification_failed_yellow", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        case .internalError:
            return UIImage(named: "ill_no_internet", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        }
    }
    
    var title: String {
        switch self {
        case .none:
            return ""
            
        case .blocked(let number):
            return String(format: "jr_login_dabu_paytm_account_blocked_title".localized, number)
            
        case .unblocked:
            return "jr_login_dabu_paytm_account_unblocked_title".localized
            
        case .blockError:
            return "jr_login_dabu_could_not_verify_account".localized
            
        case .unblockError:
            return "jr_login_dabu_could_not_verify_account".localized
            
        case .alreadyBlocked:
            return "jr_login_dabu_account_already_blocked_title".localized
            
        case .alreadyUnblocked:
            return "jr_login_dabu_account_already_active_title".localized
            
        case .blockLimitReached, .unblockLimitReached:
            return "jr_login_dabu_verification_limit_exhausted_title".localized
            
        case .recentlyBlocked:
            return "jr_login_dabu_recently_blocked_title".localized
            
        case .internalError:
            return "jr_SomethingWrong".localized
        }
    }
    
    var subtitle: String {
        switch self {
        case .none:
            return ""
            
        case .blocked:
            return String(format: "jr_login_dabu_paytm_account_blocked_message".localized, "jr_login_dabu_unblock_customer_care".localized)
            
        case .unblocked(let number):
            return String(format: "jr_login_dabu_paytm_account_unblocked_message".localized, number)
            
        case .blockError:
            return "jr_login_dabu_contact_customer_care_to_block".localized
            
        case .unblockError:
            return "jr_login_dabu_contact_customer_care_to_unblock".localized
            
        case .alreadyBlocked:
            return String(format: "jr_login_dabu_account_already_blocked_message".localized, "jr_login_dabu_block_customer_care".localized)
            
        case .alreadyUnblocked:
            return String(format: "jr_login_dabu_account_already_active_message".localized, "jr_login_dabu_unblock_customer_care".localized)
            
        case .blockLimitReached, .unblockLimitReached:
            return "jr_login_dabu_verification_limit_exhausted_message".localized
            
        case .recentlyBlocked:
            return "jr_login_dabu_recently_blocked_message".localized
            
        case .internalError:
            return "jr_login_dabu_internal_error_unblock_message".localized
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .none, .blocked, .recentlyBlocked, .blockLimitReached, .unblockLimitReached:
            return "jr_ac_OK".localized
            
        case .blockError, .alreadyBlocked:
            return "\("jr_login_dabu_call".localized) \("jr_login_dabu_block_customer_care".localized)"
            
        case .unblockError, .internalError:
            return "\("jr_login_dabu_call".localized) \("jr_login_dabu_unblock_customer_care".localized)"
            
        case .unblocked:
            return "jr_login_proceed_to_login".localized
            
        case .alreadyUnblocked:
            return "jr_ac_OK".localized
        }
    }
    
    var didSucceed: Bool {
        switch self {
        case .blocked, .unblocked, .alreadyUnblocked:
            return true
        case .none, .blockError, .blockLimitReached, .alreadyBlocked, .unblockError, .unblockLimitReached, .recentlyBlocked, .internalError:
            return false
        }
    }
    
    var shouldContactCustomerCare: Bool {
        switch self {
        case .none, .blocked, .unblocked, .recentlyBlocked, .blockLimitReached, .unblockLimitReached, .alreadyUnblocked:
            return false
        case .blockError, .unblockError, .alreadyBlocked, .internalError:
            return true
        }
    }
    
    var customerCareNumber: String {
        switch self {
        case .none, .blocked, .unblocked, .recentlyBlocked, .alreadyUnblocked:
            return ""
        case .blockError, .blockLimitReached, .alreadyBlocked:
            return "jr_login_dabu_block_customer_care".localized.digits
        case .unblockError, .unblockLimitReached, .internalError:
            return "jr_login_dabu_unblock_customer_care".localized.digits
        }
    }
}

class JRDIYAccountBlockTerminalVC: JRAuthBaseVC {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitileLabel: UILabel!
    @IBOutlet weak var ctaButtonLbl: UILabel!
    @IBOutlet weak var ctaButtonImgView: UIImageView!
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var ctaButtonContainerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var gotoHomeButton: UIButton!
    
    private var message: String = ""
    private var customerCareNumber = "jr_login_dabu_block_customer_care".localized
    private var state = JRBlockUnblockState.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        imageView.image = state.image
        titleLabel.text = state.title
        subtitileLabel.text = state.subtitle
        ctaButtonLbl.text = state.buttonTitle
        ctaButtonImgView.isHidden = !state.shouldContactCustomerCare
        closeButton.isHidden = state.didSucceed
        gotoHomeButton.isHidden = state.didSucceed
        
        ctaButtonContainerView.makeRoundedBorder(withCornerRadius: 6.0)
        
        /*
        let messageComponent = message.components(separatedBy: " @ ")
        if messageComponent.count > 1,
            let customerCareNumber = messageComponent.last,
            !customerCareNumber.isEmpty {
            
            if customerCareNumber.count > 4 {
                ctaButtonLbl.text = "\("jr_login_dabu_call".localized) \(customerCareNumber.insert(" ", ind: 4))"
            } else {
                ctaButtonLbl.text = "\("jr_login_dabu_call".localized) \(customerCareNumber)"
            }
            ctaButtonImgView.isHidden = false
            defaultCustomerCareNumber = customerCareNumber
            
        } else {
            ctaButtonLbl.text = "jr_ac_OK".localized
            ctaButtonImgView.isHidden = true
        }
        */
    }
    
    class func getController(state: JRBlockUnblockState = .none, message: String) -> JRDIYAccountBlockTerminalVC {
        if let vc = JRAuthManager.kDIYAccountBlockUnblockStoryboard.instantiateViewController(withIdentifier: "JRDIYAccountBlockTerminalVC") as? JRDIYAccountBlockTerminalVC {
            vc.state = state
            vc.message = message
            return vc
        }
        return JRDIYAccountBlockTerminalVC()
    }
    
    @IBAction func ctaBtnTapped(_ sender: UIButton) {
        
        if state.shouldContactCustomerCare {
            let urlString = "tel://\(state.customerCareNumber)"
            
            if let phoneCallURL = URL(string: urlString),
                UIApplication.shared.canOpenURL(phoneCallURL) {
                
                if #available(iOS 10, *) {
                    UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(phoneCallURL)
                }
                
            }
        } else {
            showLoginScreen()
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        showLoginScreen()
    }
    
    @IBAction func gotoHomeTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func showLoginScreen() {
        guard let navCont = navigationController else {
            return
        }
        let controller: UIViewController
        if let number = LoginAuth.sharedInstance().getMobileNumber() {
            controller = JRLoginUI.sharedInstance().invokeLoginFullScreen(number)
        } else {
            controller = JRLoginUI.sharedInstance().invokeLoginFullScreen()
        }
        navCont.present(controller, animated: true) {
            navCont.popToRootViewController(animated: true)
        }
    }
}
