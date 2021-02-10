//
//  SFBaseCollCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

public class SFBaseCollCell : UICollectionViewCell {
    
    override public func awakeFromNib() {
        self.isAccessibilityElement = false
        super.awakeFromNib()
    }
    
    weak var lItem : SFLayoutItem?
    @IBOutlet weak var imgV : UIImageView!
    
    let placeholderImage = UIImage.imageNamed(name: "mp_placeholder")
    
    public func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        self.lItem = item
        var imageUrl: String? = self.lItem?.itemImageUrl
        if cellConfig.isFavStore {
            imageUrl = self.lItem?.image
        }
        if let imageUrl = imageUrl, let mURL = URL(string: imageUrl), imgV != nil {
            self.imgV.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        if(imgV != nil) {
            self.imgV.isAccessibilityElement = true
            self.imgV.accessibilityLabel = "BannerImage\(item.itemId)"
            self.imgV.accessibilityIdentifier = "Banner\(item.itemId)"
        }
        if item.itemType != .regular && item.itemType != .showMore, imgV != nil {
            self.imgV.image = UIImage.imageNamed(name: item.localImgName)
        }
        
        if let mode = cellConfig.collCellImageContentMode, imgV != nil {
            imgV.contentMode = mode
        }
    }
    
    func makeRounded(view: UIView, roundV: SFCornerRadius, clr: UIColor, border: CGFloat) {
        var roundBy: CGFloat = 0
        switch roundV {
        case .half:
            roundBy = view.frame.width/2.0
        case .custom(let value):
            roundBy = value
        }
        view.sfRoundCorner(border, clr, roundBy, true)
    }
    
    func makeRounded(view: UIView, roundV: SFCornerRadius) {
        var roundBy: CGFloat = 0
        switch roundV {
        case .half:
            roundBy = view.frame.width/2.0
        case .custom(let value):
            roundBy = value
        }
        view.sfRoundCorner(roundBy)
    }
}
