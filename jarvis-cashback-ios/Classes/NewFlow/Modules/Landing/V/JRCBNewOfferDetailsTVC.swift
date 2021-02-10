//
//  JRCBNewOfferDetailsTVC.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/01/20.
//

import UIKit

protocol JRCBNewOfferDetailsCellDelegate: class {
    func handleDetailAction()
    func handleCtaAction(sender: UIButton)
}

class JRCBNewOfferDetailsTVC: UITableViewCell {
    
    @IBOutlet weak var ttlLbl    : UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var validityLbl: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    
    @IBOutlet weak var ctaBtn: UIButton!
    @IBOutlet weak var ctaBtnH: NSLayoutConstraint!
    
    weak var delegate: JRCBNewOfferDetailsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ctaBtn.roundedCorners(radius: 6)
        detailBtn.setAttributedTitle("jr_CB_Details".localized.getUnderlineAttrText(), for: .normal)
    }
   
    static var identifier: String {
        return String(describing: self)
    }
    
    func show(cta: String) {
        guard cta.count > 0 else {
            ctaBtnH.constant = 0
            ctaBtn.isHidden = true
            return
        }
        
        ctaBtnH.constant = 50
        ctaBtn.isHidden = false
        ctaBtn.setTitle(cta, for: .normal)
        ctaBtn.setTitle(cta, for: .highlighted)
    }
    
    func markActivated() {
        let ctaTxt = JRCBManager.userMode == .Merchant ? "jr_pay_participated".localized : "Activated"
        self.show(cta: ctaTxt)
    }

    
    @IBAction func ctaClicked(_ sender: UIButton) {
        delegate?.handleCtaAction(sender: sender)
    }
    
    @IBAction func detailClicked(_ sender: Any) {
        delegate?.handleDetailAction()
    }
    
    func loadData(model: JRCBCampaign) {
        self.ttlLbl.text = model.offer_keyword
        self.valueLbl.text = model.offer_text_override
        self.descLabel.text = model.short_description
        self.validityLbl.text = model.getExpiryDate()
        
        if model.auto_activate, model.isDeeplink {
            self.show(cta: model.progress_screen_cta)
            
        } else if model.auto_activate, !model.isDeeplink{
            self.show(cta: "")

        } else {
             let ctaTxt = JRCBManager.userMode == .Merchant ? "jr_pay_participate".localized : "jr_pay_activateOffer".localized
            self.show(cta: ctaTxt)
        }
    }
}
