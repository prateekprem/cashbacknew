//
//  SFDealsGridTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 04/12/19.
//

import UIKit

class SFDealsGridTableCell: SFBaseTableCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var brandLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var offerLabel: UILabel!
    @IBOutlet private weak var cashbackDescLabel: UILabel!
    @IBOutlet private weak var sponsoredLabel: UILabel!{
        didSet{
            sponsoredLabel.layer.cornerRadius = 2
            sponsoredLabel.layer.masksToBounds = true
        }
    }
    
    override class func register(table: UITableView) {
        if let mNib = SFDealsGridTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFDealsGridTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFDealsGridTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFDealsGridTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        var selectedItem: SFLayoutItem?
        if let items = layout?.vItems {
            for item in items {
                if item.isSelected {
                    selectedItem = item
                    break
                }
            }
        }
        
        if let item = selectedItem?.gridItems[rowIndex].first {
            configureCell(item)
        }
    }
    
    private func configureCell(_ item: SFLayoutItem?) {
        clearAllValues()
        if let isSponsored = item?.sponsored, isSponsored {
            sponsoredLabel.isHidden = false
        }else {
            sponsoredLabel.isHidden = true
        }
        
        if let imageUrlString = item?.itemImageUrl, let imageUrl = URL(string: imageUrlString) {
            itemImageView.setImageFrom(url: imageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        brandLabel.text = item?.brand
        nameLabel.text = item?.itemName
        
        if let price = item?.offerPrice?.getFormattedAmount() {
            priceLabel.text = "\(rupeeSymbol)\(price)"
        }
        
        if let offerText = item?.v1OfferText {
            offerLabel.text = offerText
            if let offerText = item?.v1OfferSubText {
                cashbackDescLabel.text = offerText
            }
            if let redemptionType = item?.v1RedemptionType, redemptionType == "SINGLE_REDEMPTION" {
                offerLabel.textColor = UIColor(hex: "FF585D")
            }else {
                offerLabel.textColor =  UIColor(hex: "11BF80")
            }
        }else {
            offerLabel.isHidden = true
            cashbackDescLabel.isHidden = true
        }
    }
    
    private func clearAllValues(){
        brandLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        offerLabel.text = nil
        cashbackDescLabel.text = nil
    }
}
