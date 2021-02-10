//
//  JRCBScratchMaskV.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 23/05/20.
//

import UIKit

enum JRCBScratchMaskIndex: Int {
    case defaultBlue
    
}

class JRCBScratchMaskV: UIView {
    @IBOutlet weak var containerView: UIView!
    var vModel: JRCBScratchContentVM!
    
    class func maskWith(fr: CGRect, scratchDataVM: JRCBScratchContentVM) -> JRCBScratchMaskV {
        let vv =  UINib(nibName: "JRCBScratchMaskV", bundle: Bundle.cbBundle).instantiate(withOwner: nil, options: nil)[0] as! JRCBScratchMaskV
        vv.frame = fr
        vv.vModel = scratchDataVM
        vv.setupMask()
        return vv
    }
    
    func getSnapshot() -> UIImage {
        self.containerView.roundedCorners(radius: 10.0)
        return self.containerView.image()
    }
    
    func setupMask() {
        
    }

}

class JRCBScratchMaskDefaultV: JRCBScratchMaskV {
    @IBOutlet weak var defScratchContainerV: UIView!
    @IBOutlet weak var wonLbl: UILabel!
    @IBOutlet weak var scratchMsgLbl: UILabel!
    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var luckyDrawV: UIView!
    @IBOutlet weak var ldConfetiImgV: UIImageView!
    @IBOutlet weak var ldAmtLbl: UILabel!
    
    override func setupMask() {
        if let scratchMask = vModel.getCardMaskConfig {
            let fontColor = scratchMask.getFontColor()
            self.iconImgV.isHidden = vModel.isLuckyDrawCard
            self.luckyDrawV.isHidden = !vModel.isLuckyDrawCard
            self.ldAmtLbl.attributedText = vModel.luckyDrawAmountText
            self.scratchMsgLbl.text = vModel.isFromScrstchCardSection ? "jr_co_scratch_now_text".localized : ""
            
            self.wonLbl.text = vModel.cardHeadlineText
            self.defScratchContainerV.backgroundColor = scratchMask.getScratchColors().upper
            self.wonLbl.textColor = fontColor
            self.scratchMsgLbl.textColor = fontColor
            self.ldAmtLbl.textColor = fontColor
            
            self.iconImgV.image = scratchMask.getScratchMaskImages()
        }
    }
    
}
