//
//  FSDealsCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSDealsCollCell: SFBaseCollCell {
    @IBOutlet weak var dealImage: UIImageView!
    @IBOutlet weak var dealName: UILabel!
    @IBOutlet weak var offer1Stack: UIStackView!
    @IBOutlet weak var offer2Stack: UIStackView!
    @IBOutlet weak var offer1Label: UILabel!
    @IBOutlet weak var offer2Label: UILabel!
    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var brandImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // offer2Stack.isHidden = true
        dealImage.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        brandView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        dealName.text = item.merchantName
        
        if let mURL = URL(string: item.itemImageUrl), dealImage != nil {
            self.dealImage.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        if let mURL = URL(string: item.itemLogoUrl), brandImage != nil {
            self.brandImage.setImageFrom(url: mURL, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
//        if item.offerItems.count >= 1 {
//            offer1Stack.isHidden = false
//            offer1Label.text = item.offerItems[0].itemTitle
//        }
//        if item.offerItems.count >= 2 {
//            offer2Stack.isHidden = false
//            offer2Label.text = item.offerItems[1].itemTitle
//        }
    }
    
    @IBAction func viewAllAction(_ sender: Any) {
    }
}
