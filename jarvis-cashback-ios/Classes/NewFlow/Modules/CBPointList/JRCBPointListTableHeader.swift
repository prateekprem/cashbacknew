//
//  JRCBTStrechHeader.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 23/07/20.
//

import UIKit

class JRCBPointListTableHeader: UIView {
    @IBOutlet weak private var ttlLbl    : UILabel!
    @IBOutlet weak private var valueLbl  : UILabel!
    @IBOutlet weak private var redeemV   : UIView!
    @IBOutlet weak private var redeemBtn : UIButton!
    
    class func headerWith(fr: CGRect) -> JRCBPointListTableHeader {
        let nib = Bundle.cbBundle.loadNibNamed("JRCBPointListTableHeader", owner: self, options: nil)
        let header = nib![0] as! JRCBPointListTableHeader
        header.frame = fr
        header.layoutIfNeeded()
        return header
    }
    
    func show(hInfo: JRCBPointListTableHeaderVModel, type: JRCBPointListType) {
        ttlLbl.text = hInfo.ttlStr
        valueLbl.text = hInfo.valueStr
        
        let txtClr = type.titleColor
        ttlLbl.textColor = txtClr
        valueLbl.textColor = txtClr
        
        let showRedeem = type == .listPointsEarned
        redeemV.isHidden = !showRedeem
        self.redeemV.roundCorner(0, nil, 6, true)
    }
    
    @IBAction func btnPointDeeplinkClicked(_ sender: Any) {
        JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(JRCBRemoteConfig.kCBGridPointsDeeplinkKey.strValue, isAwaitProcessing: false)
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback,
        eventType: .eventCustom, category: .cat_CashbackOffers, action: .act_PointsSummaryClicked, labels: [:]).track()
    }
}


class JRCBEmptyView: UIView {
    @IBOutlet weak private var ttlLbl : UILabel!
    @IBOutlet weak private var imgV   : UIImageView!
    
    class func emptyVWith(fr: CGRect) -> JRCBEmptyView {
        let nib = Bundle.cbBundle.loadNibNamed("JRCBPointListTableHeader", owner: self, options: nil)
        let header = nib![1] as! JRCBEmptyView
        header.frame = fr
        header.layoutIfNeeded()
        return header
    }
    
    func show(title: String, image: UIImage?) {
        self.ttlLbl.text = title
        if let img = image {
            imgV.image = img
        }
    }
}

class JRCBSecHeader: UIView {
    @IBOutlet weak private var ttlLbl : UILabel!
    
    class func headerWith(fr: CGRect) -> JRCBSecHeader {
        let nib = Bundle.cbBundle.loadNibNamed("JRCBPointListTableHeader", owner: self, options: nil)
        let header = nib![2] as! JRCBSecHeader
        header.frame = fr
        header.layoutIfNeeded()
        return header
    }
    
    func show(text: String) {
        self.ttlLbl.text = text
    }
}

class JRCBDetailTableHeader: UIView {
    @IBOutlet weak private var backImgV : UIImageView!
    @IBOutlet weak private var iconImgV : UIImageView!
    @IBOutlet weak private var overlayV: UIView!
    
    class func headerWith(fr: CGRect) -> JRCBDetailTableHeader {
        let nib = Bundle.cbBundle.loadNibNamed("JRCBPointListTableHeader", owner: self, options: nil)
        let header = nib![3] as! JRCBDetailTableHeader
        header.frame = fr
        header.layoutIfNeeded()
        return header
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImgV.circular(4, .white, true)
    }
    
    func show(overlay: Bool) {
        overlayV.isHidden = !overlay
    }
    
    func setIcon(url: String?, placeHolder: UIImage?) {
        if let mUrl = url, mUrl.count > 0, let imageUrl = URL(string: mUrl) {
            self.iconImgV.jr_setImage(with: imageUrl)
            
        } else {
            self.iconImgV.image = placeHolder
        }
    }
    
    func setBackground(url: String?, placeHolder: UIImage?) {
        if let mUrl = url, mUrl.count > 0, let imageUrl = URL(string: mUrl) {
            self.backImgV.jr_setImage(with: imageUrl)
            
        } else {
            self.backImgV.backgroundColor = UIColor(hex: "07448E")
        }
    }
}
