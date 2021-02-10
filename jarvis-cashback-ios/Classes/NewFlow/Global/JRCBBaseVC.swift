//
//  JRCBBaseVC.swift
//  Jarvis
//
//  Created by Ankit Agarwal on 27/06/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class JRCBBaseVC: UIViewController {
    var isCBFromDeeplink = false
    var isPresented = false
    var isNavBarHidden = true
    
    private(set) var pageParam = JRCBJSONDictionary() // used for API
    private(set) var extraParam = JRCBJSONDictionary()
        
    var safeAreaHeight: CGFloat {
       return UIApplication.shared.statusBarFrame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldNavBar(hidden: isNavBarHidden)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Appered -> \(String(describing: self))")
        self.shouldNavBar(hidden: isNavBarHidden)
    }
    
    final func moveBack() {
        if self.isPresented {
         self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.moveBack()
    }
    
    func shouldNavBar(hidden: Bool) {
        self.navigationController?.navigationBar.isHidden = hidden
    }

    func networkStatusChanged() { // must be define properly
        if JRCBCommonBridge.isNetworkAvailable {
            self.shouldNavBar(hidden: true)
        }
    }
    
    func setPage(param: JRCBJSONDictionary) {
        self.pageParam = param
    }
    
    func setExtra(param: JRCBJSONDictionary) {
        self.extraParam = param
    }
    
    func showToastMessage(message: String) {
       JRAlertPresenter.shared.presentSnackBar(title: "", message: message, autoDismiss: true, actions: nil, dismissHandler: nil)
    }
    
    func showNoNetworkToast() {
        self.showToastMessage(message: "jr_ac_noInternetMsg".localized)
    }
}
