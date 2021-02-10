//
//  SFRow1xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 14/10/19.
//

import UIKit

class SFRow1xnTableCell: SFBaseTableCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var mrpLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var offerDescriptionLabel: UILabel!
    @IBOutlet private weak var sponsoredLabel: UILabel!{
        didSet{
            sponsoredLabel.layer.cornerRadius = 2
            sponsoredLabel.layer.masksToBounds = true
        }
    }
    override class func register(table: UITableView) {
        if let mNib = SFRow1xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFRow1xnTableCell.cellId)
        }
    }

    override class var cellId: String { return "kSFRow1xnTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFRow1xnTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeRounded(view: offerDescriptionLabel, roundV: .custom(3))
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        mrpLabel.isHidden = false
        discountLabel.isHidden = false
        let item: SFLayoutItem = info.vItems[rowIndex]
        
        if let mURL = URL(string: item.itemImageUrl) {
            self.itemImageView.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        nameLabel.text = item.itemName
        if let offerPrice = item.offerPrice?.getFormattedAmount() {
            priceLabel.text = "\(rupeeSymbol)\(offerPrice)"
        }
        
        if let actualPrice = item.actualPrice?.getFormattedAmount() {
            mrpLabel.setStrikeOutText("\(rupeeSymbol)\(actualPrice)")
        }
        
        if let discount = item.discount , discount != "0" {
            discountLabel.text = "\(discount)% Off"
        }else {
            mrpLabel.isHidden = true
            discountLabel.isHidden = true
        }
        
        if let offerText = item.offerText {
            offerDescriptionLabel.isHidden = false
            offerDescriptionLabel.text = "  \(offerText)  "
        }
        else {
            offerDescriptionLabel.isHidden = true
        }
        
        if let isSponsored = item.sponsored, isSponsored {
            sponsoredLabel.isHidden = false
        }else {
            sponsoredLabel.isHidden = true
        }
    }
}
