//
//  JRCBDeepLinkVC.swift
//  Jarvis
//
//  Created by Ankit Agarwal on 09/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class JRCBDeepLinkVC: JRCBBaseVC {
    @IBOutlet weak private var backButton   : UIButton!
    @IBOutlet weak private var loadingView  : UIView!
    @IBOutlet weak private var activityView : UIView!
    @IBOutlet weak private var messageLabel : UILabel!
    @IBOutlet weak private var titleLabel   : UILabel!
    
    private let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
    private(set) var viewModel : JRCBDeepLinkVM!
    
    class func instance(instanceId:Int, txnNumber: Int = -1, screen: JRCBDeepLinkScreen) -> JRCBDeepLinkVC {
        let controller = JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBDeepLinkVC") as! JRCBDeepLinkVC
        controller.viewModel = JRCBDeepLinkVM(instId: instanceId, screen: screen, txnNumber: txnNumber)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoaderAnimation()
        self.checkLanding()
        self.viewModel.fetchData { [weak self] (mVCs, err) in
            self?.handleResponse(controllers: mVCs, err: err)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if isPresented {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkLanding() {
        if !self.viewModel.takeToBase { return }
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc is JRCBLandingVC || vc is JRCBMerchLandingVC {
                   self.viewModel.takeToBase = false
                    break
                }
            }
        }
    }
    
}
  

// MARK: - Private Methods
private extension JRCBDeepLinkVC {
    
    func showLoaderAnimation() {
        self.backButton.isHidden = true
        messageLabel.text = "jr_pay_fetchingcashback".localized
        
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animationView.center = activityView.center
        activityView.addSubview(animationView)
        animationView.play()
    }
    
    func hideLoader() {
        self.animationView.stop()
        self.backButton.isHidden = false
        self.animationView.isHidden = true
    }
    
    private func handleResponse(controllers: [UIViewController]?, err: JRCBCustomErrorModel?) {
        DispatchQueue.main.async {
            self.hideLoader()
            if let vCs = controllers {
                self.pushTo(vcList: vCs); return
            }
            
            if let mErr = err {
                self.titleLabel.text = mErr.title
                self.messageLabel.text = mErr.message
            }
        }
    }
    
    private func pushTo(vcList: [UIViewController]) {
        guard vcList.count > 0 else { return }
        guard var allVCs = self.navigationController?.viewControllers else { return }
        allVCs.removeLast()
        allVCs.append(contentsOf: vcList)
        self.navigationController?.setViewControllers(allVCs, animated: true)
    }
}
