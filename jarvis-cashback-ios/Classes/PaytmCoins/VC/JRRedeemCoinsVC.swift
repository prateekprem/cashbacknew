//
//  JRRedeemCoinsVC.swift
//  Jarvis
//
//  Created by Pankaj Singh on 02/01/20.
//

import UIKit

class JRRedeemCoinsVC: JRPCBaseViewController {
    
    
    @IBOutlet weak var subtitleText: UILabel!
    weak var shadowDelegate: JRPCAddRemoveShadowViewDelegate?
    var  subTitleText: String!
    
    class func initializeRedeemCoinsVC(shadowDelegate: JRPCAddRemoveShadowViewDelegate, text: String) -> JRRedeemCoinsVC {
        let controller = JRRedeemCoinsVC.instanceFromStoryboardPC(storyBoardName: "JRPaytmCoins", type: JRRedeemCoinsVC.self)
        controller.shadowDelegate = shadowDelegate
        controller.subTitleText = text
        return controller
    }
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shadowDelegate?.addShadowView()
        self.subtitleText.text = subTitleText
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        shadowDelegate?.removeShadowView()
        self.dismiss(animated: true, completion: nil)
    }
}
