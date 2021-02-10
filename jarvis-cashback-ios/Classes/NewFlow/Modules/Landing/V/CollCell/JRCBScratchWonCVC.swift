//
//  JRCBScratchWonCVC.swift
//  FBSDKCoreKit
//
//  Created by Shubham Raj on 06/06/20.
//

import UIKit


class JRCBLandingBaseCollCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    func loadData(item: JRCBSFItem) { }
    func showShimmerLoading(isShow: Bool) { }
}


class JRCBScratchWonCVC: JRCBLandingBaseCollCell {
    
    @IBOutlet weak private var superContentV: UIView!
    @IBOutlet weak private var upperV: UIView!
    @IBOutlet weak private var lowerV: UIView!
    
    @IBOutlet weak private var redDotImgV: UIImageView! //Expiring Soon indicator
    @IBOutlet weak private var lockImgV: UIImageView! //Lock card indicator
    @IBOutlet weak private var mainImgV: UIImageView! //Image With Confeti Used for unscratch card
    @IBOutlet weak private var iconImgV: UIImageView! //Icon image for locked game
    @IBOutlet weak private var bannerLbl: UILabel!
    
    @IBOutlet weak private var luckyDrawV: UIView! //LuckyDraw View
    @IBOutlet weak private var ldConfetiImgV: UIImageView! //LuckyDraw
    @IBOutlet weak private var ldUptoLbl: UILabel! //LuckyDraw
    @IBOutlet weak private var ldAmtLbl: UILabel! //LuckyDraw
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.superContentV.roundedCorners(radius: 10.0)
        self.iconImgV.circular(0.0, nil, true)
    }
    
    override func showShimmerLoading(isShow: Bool) {
        self.superContentV.cbShowHideLoader(isShow: isShow)
    }
    
    override func loadData(item: JRCBSFItem) {
        self.showShimmerLoading(isShow: item.isLoading)
        if let itemData = item as? JRCBLandingScratchCardInfo {
            let colors = itemData.sCardConfig.getScratchColors()
            upperV.backgroundColor = colors.upper
            lowerV.backgroundColor = colors.lower
            let fontColor = itemData.sCardConfig.getFontColor()
            bannerLbl.textColor = fontColor
            ldAmtLbl.textColor = fontColor
            ldUptoLbl.textColor = fontColor
            
            let iconImage = itemData.sCardConfig.getScratchMaskImages()
            
            if itemData.isLuckyDrawCard {
                self.luckyDrawV.isHidden = false
                self.mainImgV.isHidden = true
                self.ldUptoLbl.text = "jr_CB_UptoString".localized
                self.ldAmtLbl.attributedText = itemData.luckyDrawAmount
            } else {
                self.luckyDrawV.isHidden = true
                self.mainImgV.isHidden = false
                mainImgV.image = iconImage
            }
            
            if let unData = itemData.unscratchedCardData {
                self.iconImgV.isHidden = true
                self.lockImgV.isHidden = true
                self.redDotImgV.isHidden = !itemData.isCardExpiring
                
                if unData.isSupported {
                    bannerLbl.text = itemData.message
                } else {
                    bannerLbl.text = JRCBRemoteConfig.kCBScratchAppUpdateMsg.strValue
                }
                
            } else if let _ = itemData.lockedCardData {
                self.redDotImgV.isHidden = true
                self.iconImgV.isHidden = true
                self.lockImgV.isHidden = false
                self.bannerLbl.text = itemData.message
                
            } else {
                self.redDotImgV.isHidden = true
                self.mainImgV.isHidden = true
                self.luckyDrawV.isHidden = true
                self.iconImgV.isHidden = false
                self.lockImgV.isHidden = false
                self.bannerLbl.text = itemData.rTitle
                if let activeOffer = itemData.activeOfferData {
                    iconImgV.jr_setImage(with: URL(string: activeOffer.mCampain?.new_offers_image_url ?? ""), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
                } else if let newOffer = itemData.newOfferData {
                    iconImgV.jr_setImage(with: URL(string: newOffer.new_offers_image_url), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
                }
            }
        }
    }
}



class JRCBLandingViewAllCollCell: JRCBLandingBaseCollCell {
    @IBOutlet weak private var containerV: UIView!

    override func loadData(item: JRCBSFItem) {
        let clr = UIColor(red: 221/255.0, green: 229/255.0, blue: 237/255.0, alpha: 1.0)
        containerV.roundCorner(1, clr, 12, true)
    }
}
