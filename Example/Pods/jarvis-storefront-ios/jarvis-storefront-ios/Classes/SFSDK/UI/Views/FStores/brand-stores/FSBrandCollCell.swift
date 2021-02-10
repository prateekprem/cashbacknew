//
//  FSBrandCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSBrandCollCell: SFBaseCollCell {
    
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         brandImage.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        brandName.text = item.itemName
        if let mURL = URL(string: item.itemImageUrl), brandImage != nil {
            self.brandImage.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
    }
}
