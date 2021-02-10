//
//  JRBlockUnblockMessageVC.swift
//  jarvis-auth-ios
//
//  Created by Aakash Srivastava on 27/10/20.
//

import UIKit

class JRBlockUnblockMessageVC: JRAuthPopupVC {
    
    @IBOutlet weak private var headerLbl: UILabel!
    @IBOutlet weak private var messageLbl: UILabel!
    @IBOutlet weak private var callContainerView: UIView!
    
    private var header: String = ""
    private var message: String = ""
    private let customerCareNumber = "jr_login_dabu_block_customer_care".localized
    
    class func getController(header: String, message: String) -> JRBlockUnblockMessageVC {
        let controller = JRAuthManager.kDIYAccountBlockUnblockStoryboard.instantiateViewController(withIdentifier: "JRBlockUnblockMessageVC") as! JRBlockUnblockMessageVC
        controller.header = header
        controller.message = message
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLbl.text = header
        messageLbl.text = message
        callContainerView.makeRoundedBorder(withCornerRadius: 6.0)
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        hidePopup {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func callBtnTapped(_ sender: UIButton) {
        let urlString = "tel://\(customerCareNumber.digits)"
        if let phoneCallURL = URL(string: urlString),
            UIApplication.shared.canOpenURL(phoneCallURL) {
            
            if #available(iOS 10, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneCallURL)
            }
        } else {
            showError(text: "jr_login_dabu_cannot_initiate_call".localized)
        }
    }
}
