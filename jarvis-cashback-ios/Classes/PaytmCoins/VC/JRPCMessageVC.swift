//
//  JRPCMessageVC.swift
//  jarvis
//
//  Created by Pankaj Singh on 22/01/20.
//

import UIKit

class JRPCMessageVC: JRPCBaseViewController {
    @IBOutlet weak var msgLbl: UILabel!
    var messageToShow: NSMutableAttributedString!
    weak var shadowDelegate: JRPCAddRemoveShadowViewDelegate?
    
    class func initialize(shadowDelegate: JRPCAddRemoveShadowViewDelegate, messageToShow: NSMutableAttributedString) -> JRPCMessageVC {
        let controller = JRPCMessageVC.instanceFromStoryboardPC(storyBoardName: "JRPaytmCoins", type: JRPCMessageVC.self)
        controller.shadowDelegate = shadowDelegate
        controller.messageToShow = messageToShow
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowDelegate?.addShadowView()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        self.msgLbl.attributedText = messageToShow;
    }
    
    @IBAction func closeVC(_ sender: UIButton) {
        shadowDelegate?.removeShadowView()
        self.dismiss(animated: true, completion: nil)
    }
}
