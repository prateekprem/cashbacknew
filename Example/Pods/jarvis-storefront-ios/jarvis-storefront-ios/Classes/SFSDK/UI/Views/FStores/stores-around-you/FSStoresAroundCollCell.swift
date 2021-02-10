//
//  FSStoresAroundCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSStoresAroundCollCell: SFBaseCollCell {
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeCategory: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var selectedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCollectionCell(_ item: SFLayoutItem?, isSelected: Bool) {
        storeCategory.text = item?.itemName
        if let itemUrl = item?.itemImageUrl, let mURL = URL(string: itemUrl), storeImage != nil {
            self.storeImage.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        if isSelected {
            outerView.backgroundColor = #colorLiteral(red: 0, green: 0.7254901961, blue: 0.9607843137, alpha: 1)
            storeCategory.textColor = #colorLiteral(red: 0, green: 0.7254901961, blue: 0.9607843137, alpha: 1)
            selectedView.isHidden = false
            storeCategory.font = UIFont.boldSystemFont(ofSize: 10.0)
            
        }else{
            outerView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
            storeCategory.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            storeCategory.alpha = 0.8
            selectedView.isHidden = true
            storeCategory.font = UIFont.fontLightOf(size: 10.0)
        }
    }
}
