//
//  JRChooseBlockMethodVC.swift
//  jarvis-auth-ios
//
//  Created by Aakash Srivastava on 30/10/20.
//

import UIKit

enum JRBlockUnblockVerificationMethod: String {
    case passcode = "PASSCODE"
}

class JRChooseBlockMethodVC: JRAuthBaseVC {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak private var proceedContainerView: UIView!

    private var stateCode = ""
    private var verifierId = ""
    private var methods = [JRBlockUnblockVerificationMethod]()

    class func getController(stateCode: String, verifierId: String, methods: [JRBlockUnblockVerificationMethod]) -> JRChooseBlockMethodVC {
        let controller = JRAuthManager.kDIYAccountBlockUnblockStoryboard.instantiateViewController(withIdentifier: "JRChooseBlockMethodVC") as! JRChooseBlockMethodVC
        controller.stateCode = stateCode
        controller.verifierId = verifierId
        controller.methods = methods
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        proceedContainerView.makeRoundedBorder(withCornerRadius: 6.0)
    }
}

private extension JRChooseBlockMethodVC {
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dontHaveAccessBtnTapped(_ sender: UIButton) {
        let header = "jr_login_dabu_do_not_have_these_details".localized
        let message = "jr_login_dabu_dont_have_access_info_message".localized
        let controller = JRBlockUnblockMessageVC.getController(header: header, message: message)
        present(controller, animated: false)
    }
    
    @IBAction func proceedBtnTapped(_ sender: UIButton) {
        
    }
}

extension JRChooseBlockMethodVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension JRChooseBlockMethodVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
