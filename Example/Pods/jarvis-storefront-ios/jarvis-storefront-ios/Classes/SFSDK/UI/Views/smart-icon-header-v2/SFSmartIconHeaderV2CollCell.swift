//
//  SFSmartIconHeaderV2CollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 27/08/20.
//

import UIKit
import jarvis_utility_ios

class SFSmartIconHeaderV2CollCell: SFBaseCollCell {
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        nameLabel.text = item.itemName
        var defaultImage: UIImage? = UIImage.imageNamed(name: "smart_icon_placeholder")
        if let cachedImage = JRImageCache.shared.imageFromDiskCache(forKey: item.itemImageUrl) {
            defaultImage = cachedImage
        }
        else if !item.isItemImageCached, let placeHolderImage: UIImage = UIImage.imageNamed(name: "smart_icon\(item.itemIndex)") {
            defaultImage = placeHolderImage
        }
        
        if let mURL = URL(string: item.itemImageUrl) {
            self.iconImageView.setImageFrom(url: mURL, placeHolderImg: defaultImage) { (img, err, cacheType, url) in
                if let _ = img {
                    item.isItemImageCached = true
                }
            }
        }
    }
}
