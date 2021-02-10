//
//  SFYourVoucherCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class SFYourVoucherCollCell: SFBaseCollCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var voucherLabel: UILabel!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pinTextLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
   
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        amountLabel.textColor = UIColor.white
        pinTextLabel.textColor = UIColor.white
        dateLabel.textColor = UIColor.white
        brandName.textColor = UIColor.white
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        amountLabel.text = "₹ " + (item.amount ?? "")
       // codeLabel.text = item.cardNo
        brandName.text = item.brandName
        
        if let imageUrl = item.merchantImageName, let mURL = URL(string: imageUrl), brandImage != nil {
            brandImage.setImageFrom(url: mURL, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
    }
    @IBAction func copyBtnAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = codeLabel.text
    }
}
