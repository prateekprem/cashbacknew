//
//  SFRow2xnCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 14/10/19.
//

import UIKit

class SFRow2xnCollCell: SFBaseCollCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var offerDescLabel: UILabel!
    @IBOutlet private weak var sponsoredLabel: UILabel!{
        didSet{
            sponsoredLabel.layer.cornerRadius = 2
            sponsoredLabel.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeRounded(view: offerDescLabel, roundV: .custom(3))
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        nameLabel.text = item.itemName
        if let price = item.offerPrice?.getFormattedAmount() {
            priceLabel.text = "\(rupeeSymbol)\(price)"
        }
        
        if let offerText = item.offerText {
            offerDescLabel.isHidden = false
            offerDescLabel.text = "  \(offerText)  "
        }
        else {
            offerDescLabel.isHidden = true
        }
        if let isSponsored = item.sponsored, isSponsored {
            sponsoredLabel.isHidden = false
        }else {
            sponsoredLabel.isHidden = true
        }
    }
}
