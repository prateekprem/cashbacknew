//
//  JRCBGridCollCellCashback.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 23/01/20.
//

import UIKit

class JRCBGridCollBaseCell: UICollectionViewCell {
    @IBOutlet weak var backV : UIView?
    @IBOutlet weak var logoImgV: UIImageView?
    @IBOutlet weak var ttlLbl: UILabel?
    @IBOutlet weak var subTtlLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let logo = logoImgV {
            logo.circular(0.0, nil, true)
        }
        backV?.roundCorner(1, self.roundColor, 12, true)
    }
    
    var roundColor: UIColor {
        return UIColor.colorWith(hex: "000000").withAlphaComponent(0.1)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func loadData(info: JRCBGridBaseInfo) {
        self.ttlLbl?.text = info.title
        self.subTtlLbl?.text = info.subTitle
    }
}

class JRCBGridCollCellCashback: JRCBGridCollBaseCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadData(info: JRCBGridBaseInfo) {
        super.loadData(info: info)
        self.logoImgV?.jr_setImage(with: URL(string: info.offerIconImage), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
    }
}

class JRCBGridCampaignCollCell: JRCBGridCollBaseCell {
    @IBOutlet weak private var backgroundIMageView: UIImageView!
    @IBOutlet weak private var overlayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadData(info: JRCBGridBaseInfo) {
        super.loadData(info: info)
        let isRechargeCat = info.offerTag.lowercased() == JRCBConstants.Common.kSelOfferTagValRech

        if isRechargeCat {
            self.backV?.backgroundColor = UIColor(hex: "00C4FF")
            self.backgroundIMageView.isHidden = true
            self.overlayView.isHidden = true
        } else {
            self.backgroundIMageView.isHidden = false
            self.backgroundIMageView.jr_setImage(with: URL(string: info.backgroundImage))
            self.overlayView.isHidden = !info.isOverlay
        }
        
        self.ttlLbl?.textColor = UIColor.white
        self.subTtlLbl?.textColor = UIColor.white
        
        self.logoImgV?.circular(0.0, nil, true)
        
        self.logoImgV?.jr_setImage(with: URL(string: info.offerIconImage),
                                   placeholderImage: UIImage.Grid.Placeholder.campaignPlaceholder,
                                   completed: nil)
    }
}

class JRCBGridVoucherCollCell: JRCBGridCollBaseCell {
    
    @IBOutlet weak var bkImageV: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    override func loadData(info: JRCBGridBaseInfo) {
        super.loadData(info: info)
        self.ttlLbl?.text = info.title.capitalizingFirstLetter()
        if !info.offerIconImage.isEmpty {
            self.logoImgV?.jr_setImage(with: URL(string: info.offerIconImage), placeholderImage: UIImage.Grid.Placeholder.offersPlaceholder)
        } else {
            self.logoImgV?.image = UIImage.Grid.Placeholder.offersPlaceholder
        }
        if info.backgroundImage.isEmpty {
            self.bkImageV.isHidden = true
            self.overlayView.isHidden = true
        } else {
            self.overlayView.isHidden = false
            self.bkImageV.isHidden = false
            self.bkImageV.jr_setImage(with: URL(string: info.backgroundImage))
        }
        
    }
}

class JRCBGridScratchCollCell: JRCBGridCollBaseCell {
    
    @IBOutlet weak var upperV: UIView!
    @IBOutlet weak var lowerV: UIView!
    @IBOutlet weak var lockImgV: UIImageView!
    @IBOutlet weak var redDotImgV: UIImageView!
    @IBOutlet weak var scratchIconImgV: UIImageView!
    
    @IBOutlet weak var luckyDrawV: UIView!
    @IBOutlet weak var ldConfetiImgV: UIImageView!
    @IBOutlet weak var ldUptoLbl: UILabel!
    @IBOutlet weak var ldAmtLbl: UILabel!
    
    
    override var roundColor: UIColor {
        return .clear
    }
    
    override func loadData(info: JRCBGridBaseInfo) {
        super.loadData(info: info)
        
        // Using same model as Landing cell
        if let itemData = info.metaData as? JRCBLandingScratchCardInfo {
            
            let config = itemData.sCardConfig
            self.setColorFromConfig(config: config)
            
            if itemData.isLuckyDrawCard {
                self.luckyDrawV.isHidden = false
                self.scratchIconImgV.isHidden = true
                self.ldUptoLbl.text = "jr_CB_UptoString".localized
                self.ldAmtLbl.attributedText = itemData.luckyDrawAmount
            } else {
                self.luckyDrawV.isHidden = true
                self.scratchIconImgV.isHidden = false
            }
            
            if let unData = itemData.unscratchedCardData {
                self.logoImgV?.isHidden = true
                self.lockImgV.isHidden = true
                self.redDotImgV.isHidden = !itemData.isCardExpiring
                
                if unData.isSupported {
                    self.ttlLbl?.text = itemData.message
                } else {
                    self.ttlLbl?.text = JRCBRemoteConfig.kCBScratchAppUpdateMsg.strValue
                }
                
            } else if let _ = itemData.lockedCardData {
                self.redDotImgV.isHidden = true
                self.logoImgV?.isHidden = true
                self.lockImgV.isHidden = false
                self.self.ttlLbl?.text = itemData.message
                
            } else {
                self.redDotImgV.isHidden = true
                self.scratchIconImgV.isHidden = true
                self.luckyDrawV.isHidden = true
                self.logoImgV?.isHidden = false
                self.lockImgV.isHidden = false
                self.ttlLbl?.text = itemData.rTitle
                
                if let activeOffer = itemData.activeOfferData {
                    logoImgV?.jr_setImage(with: URL(string: activeOffer.mCampain?.new_offers_image_url ?? ""), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
                } else if let newOffer = itemData.newOfferData {
                    logoImgV?.jr_setImage(with: URL(string: newOffer.new_offers_image_url), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
                }
            }
        } else {
            let config = info.cardConfig
            self.setColorFromConfig(config: config)
            self.redDotImgV.isHidden = true
            self.scratchIconImgV.isHidden = true
            self.luckyDrawV.isHidden = true
            self.logoImgV?.isHidden = false
            self.lockImgV.isHidden = false
            logoImgV?.jr_setImage(with: URL(string: info.offerIconImage), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
        }
    }
    
    private func setColorFromConfig(config: kScratchImageConfigEnum) {
        let colors = config.getScratchColors()
        upperV.backgroundColor = colors.upper
        lowerV.backgroundColor = colors.lower
        let fontColor = config.getFontColor()
        self.ttlLbl?.textColor = fontColor
        ldAmtLbl.textColor = fontColor
        ldUptoLbl.textColor = fontColor
        let iconImage = config.getScratchMaskImages()
        scratchIconImgV.image = iconImage
    }
}
