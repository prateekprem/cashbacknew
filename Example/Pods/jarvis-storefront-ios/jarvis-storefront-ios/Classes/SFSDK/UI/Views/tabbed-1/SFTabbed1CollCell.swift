//
//  SFTabbed1CollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/10/19.
//

import UIKit

protocol SFTabbed1CollCellDelegate: class {
    func didClickOnWishlist(_ item: SFLayoutItem, completionHandler: ((_ error: Error?, _ isAdded: Bool) -> Void)?)
    func isItemPresentInWishlist(_ item: SFLayoutItem) -> Bool
}

class SFTabbed1CollCell: SFBaseCollCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var brandLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var mrpLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet weak private var offerTextLabel: UILabel!
    @IBOutlet weak private var offerSubTextLabel: UILabel!
    @IBOutlet weak private var cashbackStackView: UIStackView!
    @IBOutlet weak private var ratingStackView: UIStackView!
    @IBOutlet weak private var averageRatingLabel: UILabel!
    @IBOutlet weak private var totalRatingLabel: UILabel!
    @IBOutlet weak private var wishlistButton: UIButton!
    @IBOutlet weak private var brandStoreView: UIStackView!
    @IBOutlet weak private var brandStoreSeparator: UIView!
    @IBOutlet weak private var badgeIcon: UIImageView!
    @IBOutlet weak private var badgeLabel: UILabel!
    @IBOutlet private weak var timerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var timerImgView: UIImageView!
    @IBOutlet weak private var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var sponsoredLabel: UILabel!{
        didSet{
            sponsoredLabel.layer.cornerRadius = 2
            sponsoredLabel.layer.masksToBounds = true
        }
    }
    
    weak var delegate: SFTabbed1CollCellDelegate?
    private var gridItem: SFLayoutItem?
    private var timer: Timer?
    private var counter = 0
    
    func configureCollectionCell(_ item: SFLayoutItem?) {
        clearAllValues()
        
        if let bool = item?.isFlashSaleTimerShow, bool {
            timerView.isHidden = false
            timerLabel.isHidden = false
            timerImgView.isHidden = false
            if let endDate = item?.isFlashSaleValidUpto {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
                if let date = dateFormatter.date(from: endDate) {
                    showFirstFrame(endTime: date)
                    startTimer(endTime: date) { (lblValue) in
                        self.timerLabel.text = lblValue
                    }
                }
            }
        }
        else {
            timerView.isHidden = true
            timerLabel.isHidden = true
            timerImgView.isHidden = true
        }
        
        gridItem = item
        if let item = item, item.isOfflineFlow == true {
            wishlistButton.isHidden = true
        }
        if let isSponsored = item?.sponsored, isSponsored {
            sponsoredLabel.isHidden = false
        }else {
            sponsoredLabel.isHidden = true
        }
        
        if let imageUrlString = item?.itemImageUrl, let imageUrl = URL(string: imageUrlString) {
            imageView.setImageFrom(url: imageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        if let itm = item, let del = delegate, del.isItemPresentInWishlist(itm) {
            showWishlistIcon(selected: true)
        }
        else {
            showWishlistIcon(selected: false)
        }
        
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
    }
    
    func configureImageHeight(_ height: CGFloat) {
        imageViewHeightConstraint.constant = height
        layoutIfNeeded()
    }
    
    private func showWishlistIcon(selected isSelected: Bool) {
        if isSelected {
            wishlistButton.setImage(UIImage.imageNamed(name: "wishlist_selected"), for: .normal)
        }
        else {
            wishlistButton.setImage(UIImage.imageNamed(name: "whishlist"), for: .normal)
        }
    }
    
    private func clearAllValues(){
        nameLabel.text = nil
        priceLabel.text = nil
        mrpLabel.text = nil
        discountLabel.text = nil
        offerTextLabel.text = nil
        offerSubTextLabel.text = nil
        averageRatingLabel.text = nil
        totalRatingLabel.text = nil
    }
    func hideInfoForFlashSale(_ hide: Bool) {
        priceLabel.isHidden = hide
        mrpLabel.isHidden = hide
        discountLabel.isHidden = hide
    }
    
    private func startTimer( endTime: Date, result: ((String) -> ())?) {
        invalidateTimerForTabbed2Cell()
        if timer == nil {
            if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int {
                if let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                    let difference = Calendar.current.dateComponents([.second], from: date, to: endTime)
                    counter = difference.second!
                    timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                        self.counter-=1
                        if self.counter <= 0 {
                            self.timer?.invalidate()
                            self.timer = nil
                        }else{
                            result?("\(SFUtilsManager.getHours(counter: self.counter)) : \(SFUtilsManager.getMinutes(counter: self.counter)) : \(SFUtilsManager.getSeconds(counter: self.counter))")
                        }
                        
                    })
                }else {
                    invalidateTimerForTabbed2Cell()
                }
            }
        }
    }
    
    func invalidateTimerForTabbed2Cell() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func showFirstFrame( endTime: Date) {
        if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int {
            if let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                let difference = Calendar.current.dateComponents([.second], from: date, to: endTime)
                counter = difference.second!
                timerLabel.text = "\(SFUtilsManager.getHours(counter: self.counter)) : \(SFUtilsManager.getMinutes(counter: self.counter)) : \(SFUtilsManager.getSeconds(counter: self.counter))"
            }
        }
    }
    
    
    
    @IBAction func wishlistTapped(_ sender: Any) {
        if let item = gridItem {
            delegate?.didClickOnWishlist(item, completionHandler: { [weak self] (error, isAdded) in
                if error == nil {
                    self?.showWishlistIcon(selected: isAdded)
                }
            })
        }
    }
}

