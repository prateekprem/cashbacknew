//
//  JRCBDeelNVoucherDetailCell.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 29/07/20.
//

import UIKit

class JRCBDeelNVoucherDetailCell: UITableViewCell {
    @IBOutlet weak private var wonUpToLbl       : UILabel!
    @IBOutlet weak private var vTtlLbl          : UILabel!
    @IBOutlet weak private var subTtlLbl        : UILabel!
    @IBOutlet weak private var descLbl          : UILabel!
    @IBOutlet weak private var detailBtn        : UIButton!
    
    @IBOutlet weak private var pinContainV      : UIView!
    @IBOutlet weak private var pinTtlLbl        : UILabel!
    @IBOutlet weak private var pinValueLbl      : UILabel!
    @IBOutlet weak private var pinContainH      : NSLayoutConstraint!
    
    @IBOutlet weak private var copyCodeContainV : UIView!
    @IBOutlet weak private var copyCodeTtlLbl   : UILabel!
    @IBOutlet weak private var codeValLbl       : UILabel!
    
    @IBOutlet weak private var ctaBtn           : UIButton!
    @IBOutlet weak private var ctaBtnH          : NSLayoutConstraint!
    @IBOutlet weak private var earnedForLbl      : UILabel!
    
    @IBOutlet weak var ctaMoreDetailsBtn: UIButton!
    
    private var isCTAMore = false
    
    weak var delegate : JRCBVoucherDetailBaseCellDelegate?
    
    @IBAction func detailClicked(_ sender: UIButton) {
        self.delegate?.cbVoucherDetailDidClickDetail()
    }
    
    @IBAction func copyVoucherCodeClicked(_ sender: UIButton) {
        self.delegate?.cbVoucherDetailDidClickCopy()
    }
    
    @IBAction func ctaClicked(_ sender: UIButton) {
        if isCTAMore {
            self.delegate?.cbVoucherDetailDidClickDetail()
        } else {
            self.delegate?.cbVoucherDetailDidClickCTA()
        }
    }
    
    @IBAction func ctaMoreDetailsClicked(_ sender: Any) {
        if isCTAMore {
            self.delegate?.cbVoucherDetailDidClickDetail()
        } else {
            self.delegate?.cbVoucherDetailDidClickCTA()
        }
    }
}


extension JRCBDeelNVoucherDetailCell {
    class var cellId: String { return "kJRCBDeelNVoucherDetailCell" }
    
    func show(info: JRCBDeelNVoucherDetailCellVM) {
        wonUpToLbl.text = info.wonUpToTxt
        vTtlLbl.text = info.titleTxt
        subTtlLbl.text = info.validity
        descLbl.text = info.descTxt
        
        pinTtlLbl.text = info.pinTtl
        pinValueLbl.text = info.pinValue
        
        let isPIN = info.pinValue.count > 0
        pinContainV.isHidden = !isPIN
        pinContainH.constant = isPIN ? 84 : 20
        pinValueLbl.toDottedLineViewWithRoundedCorner()
        
        copyCodeContainV.isHidden = true
        if let promoC = info.mPromoCode, promoC.count > 0 {
            copyCodeTtlLbl.text = info.voucherCodeTtl
            if promoC.caseInsensitiveCompare(JRCBConstants.Common.kNoCouponCodeText) == .orderedSame {
                codeValLbl.text = promoC
            } else {
                codeValLbl.text = promoC.separate()
            }
            copyCodeContainV.isHidden = false
        }
        
        if info.isExpired {
            self.ctaBtn.backgroundColor = UIColor.gray
        }
        copyCodeContainV.isUserInteractionEnabled = !info.isExpired
        self.ctaBtn.isUserInteractionEnabled = !info.isExpired
        
        let aCTA = info.ctaTitle
        
        if info.isCTAAvailable {
            self.detailBtn.setAttributedTitle("jr_CB_MoreDetails".localized.getUnderlineAttrText(), for: .normal)
            self.detailBtn.isHidden = false
            ctaBtn.setTitle(aCTA, for: .normal)
            ctaBtn.setTitle(aCTA, for: .highlighted)
            self.ctaMoreDetailsBtn.isHidden = true
            self.ctaBtn.isHidden = false
            
        } else {
            self.detailBtn.setTitle("", for: .normal)
            self.detailBtn.setTitle("", for: .highlighted)
            self.detailBtn.isHidden = true
            self.ctaBtn.isHidden = true
            ctaMoreDetailsBtn.setTitle(aCTA, for: .normal)
            ctaMoreDetailsBtn.setTitle(aCTA, for: .highlighted)
            self.ctaMoreDetailsBtn.isHidden = false
            self.ctaMoreDetailsBtn.roundedCorners(radius: 4.0, borderColor: UIColor.ScratchCard.Blue.commonBtnBlueColor)
        }
        
        isCTAMore = !info.isCTAAvailable
        earnedForLbl.text = info.earnedForText
    }
}


protocol JRCBVoucherDetailBaseCellDelegate: class {
    func cbVoucherDetailDidClickCopy()
    func cbVoucherDetailDidClickCTA()
    func cbVoucherDetailDidClickDetail() // TnC
}
