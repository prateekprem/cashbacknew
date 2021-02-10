//
//  JRPUResultVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 03/04/20.
//

import UIKit

class JRPUResultVC: JRAuthBaseVC {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var proceedLogin: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var isFromLogin: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:-Instance
    static func controller() -> JRPUResultVC {
        let vc = UIStoryboard.init(name: "JRLOTPViaEmail", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRPUResultVC") as! JRPUResultVC
        return vc
    }
    
    @IBAction func onProceedToLoginBtnTouch(_ sender: UIButton) {
        
        LoginAuth.sharedInstance().resetRSAKeys()
        
        if isFromLogin == true {
            dismiss(animated: false, completion: {
                JRLoginUI.sharedInstance().delegate?.signOutUserAndPresentLogin()
            })
        }
        else {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: JRAuthSignInVC.self) {
                    if let controller = controller as? JRAuthSignInVC{
                        controller.vModel.isNumberUpdated = true
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
        
    }
    
}
