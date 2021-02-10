//
//  SFRowBs2CollCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 14/10/19.
//

import UIKit

class SFRowBs2CollCell: SFBaseCollCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var brandLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var mrpLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet weak private var offerTextLabel: UILabel!
    @IBOutlet weak private var offerSubTextLabel: UILabel!
    @IBOutlet weak private var cashbackStackView: UIStackView!
    @IBOutlet weak private var ratingStackView: UIStackView!
    @IBOutlet weak private var averageRatingLabel: UILabel!
    @IBOutlet weak private var totalRatingLabel: UILabel!
    @IBOutlet weak private var brandStoreView: UIStackView!
    @IBOutlet weak private var brandStoreSeparator: UIView!
    @IBOutlet weak private var badgeLabel: UILabel!
    @IBOutlet weak private var badgeIcon: UIImageView!
    @IBOutlet private weak var sponsoredLabel: UILabel!{
        didSet{
            sponsoredLabel.layer.cornerRadius = 2
            sponsoredLabel.layer.masksToBounds = true
        }
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        self.makeRounded(view: imgV, roundV: cellConfig.collectCellRoundBy, clr: cellConfig.collectCellRoundClr,  border: cellConfig.collectCellRoundBorder)
        configureCollectionCell(item)
    }
    
    func configureCollectionCell(_ item: SFLayoutItem?) {
        clearAllValues()
        nameLabel.text = item?.itemName
        if let showBrand = item?.showBrand, showBrand {
            brandLabel.isHidden = false
            brandLabel.text = item?.brand
        }
        else {
            brandLabel.isHidden = true
        }
        if let price = item?.offerPrice?.getFormattedAmount() {
            priceLabel.text = "\(rupeeSymbol)\(price)"
        }
        if let actualPrice = item?.actualPrice?.getFormattedAmount() {
            mrpLabel.setStrikeOutText("\(rupeeSymbol)\(actualPrice)")
        }
        
        if let discount = item?.discount, discount != "0" {
            discountLabel.text = "\(discount)% Off"
        }else {
            mrpLabel.isHidden = true
            discountLabel.isHidden = true
        }
        
        offerSubTextLabel.text = nil
        if let offerText = item?.v1OfferText {
            cashbackStackView.isHidden = false
            offerTextLabel.text = offerText
            if let offerText = item?.v1OfferSubText {
                offerSubTextLabel.text = offerText
            }
            if let redemptionType = item?.v1RedemptionType, redemptionType == "SINGLE_REDEMPTION" {
                offerTextLabel.textColor = UIColor(hex: "FF585D")
            }else {
                offerTextLabel.textColor =  UIColor(hex: "11BF80")
            }
            
        }else {
            cashbackStackView.isHidden = true
        }
        
        if let avgRating = item?.avgRating , avgRating > 0.0  {
            ratingStackView.isHidden = false
            averageRatingLabel.text = String(describing: avgRating)
            if let totalRatings = item?.totalRatings , totalRatings > 0 {
                totalRatingLabel.text = "(" + String(describing: totalRatings) + ")"
            }
        }else {
            ratingStackView.isHidden = true
        }
        
        if let item = item , let (text,url) = item.getGridBadgeToShow(),let imageUrl = URL(string: url){
            brandStoreView.isHidden = false
            brandStoreSeparator.isHidden = ratingStackView.isHidden
            badgeLabel.text = text
            badgeIcon.setImageFrom(url: imageUrl, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }else {
            brandStoreView.isHidden = true
            brandStoreSeparator.isHidden = true
        }
        
        if let isSponsored = item?.sponsored, isSponsored {
            sponsoredLabel.isHidden = false
        }else {
            sponsoredLabel.isHidden = true
        }
    }
    
    private func clearAllValues(){
        nameLabel.text = nil
        priceLabel.text = nil
        mrpLabel.text = nil
        discountLabel.text = nil
        offerTextLabel.text = nil
        offerSubTextLabel.text = nil
    }
}
