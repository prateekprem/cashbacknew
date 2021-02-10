//
//  SFSmartIconGrid4xnCollCell.swift
//  Jarvis
//
//  Created by Pankaj Singh on 12/08/20.
//  Copyright © 2020 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios

class SFSmartIconGrid4xnCollCell: SFBaseCollCell {
    @IBOutlet weak private var baseContainerV: UIView!
    @IBOutlet weak private var ttlLbl: UILabel!
    @IBOutlet weak private var iconContainerView: UIView!
    @IBOutlet weak private var titleInitial: UILabel!
    @IBOutlet weak private var iconImage: UIImageView!
    
    @IBOutlet weak private var topSeparatorView: UIView!
    @IBOutlet weak private var tagLabelView: UIView!
    @IBOutlet weak private var tagLabel: UILabel!
    
    private let popularServicesViewId: Int = 302614
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagLabelView.makeRoundedBorder(withCornerRadius: 4)
    }
    
    private func showEmpty() {
        baseContainerV.isHidden = true
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        if item.itemType == .empty { self.showEmpty(); return }
        let mURL = URL(string: item.itemImageUrl)
        var defaultImage: UIImage? = UIImage.imageNamed(name: "icon_placeholder")
        if let viewId = item.viewId, viewId == popularServicesViewId {
            if let cachedImage = JRImageCache.shared.imageFromDiskCache(forKey: item.itemImageUrl) {
                defaultImage = cachedImage
            }
            else if !item.isItemImageCached, let placeHolderImage: UIImage = UIImage.imageNamed(name: "ps\(item.itemIndex)") {
                defaultImage = placeHolderImage
            }
        }
        
        self.iconImage.setImageFrom(url: mURL, placeHolderImg: defaultImage) { (img, err, cacheType, url) in
            if let _ = img {
                item.isItemImageCached = true
            }
        }
        
        baseContainerV.isHidden = false
        ttlLbl.textColor = cellConfig.collectTitleClr
        iconContainerView.backgroundColor = UIColor.clear
        ttlLbl.accessibilityLabel = item.itemName
        ttlLbl.isAccessibilityElement = true
        ttlLbl.text = item.itemName
        self.iconImage.backgroundColor = UIColor.clear
        topSeparatorView.isHidden = !item.showSeparator
        
        if let labelString = item.layoutLabel, labelString.isValidString() {
            tagLabelView.isHidden = false
            tagLabel.text = labelString
            if let textColor = item.layoutLabelColor, textColor.isValidString() {
                tagLabel.textColor = UIColor.colorWithHexString(textColor)
            }
            else {
                tagLabel.textColor = UIColor.black
            }
            
            if let labelBGColor = item.layoutLabelBG, labelBGColor.isValidString() {
                tagLabelView.backgroundColor = UIColor.colorWithHexString(labelBGColor)
            }
            else {
                tagLabelView.backgroundColor = UIColor.colorWithHexString("FFD766")
            }
        }
        else {
            tagLabelView.isHidden = true
            tagLabel.text = nil
        }
        
        if item.itemImageUrl == "" {
            titleInitial.isHidden = false
            var itemInitial = item.itemInitial
            if !itemInitial.isValidString() {
                itemInitial = String(item.itemName.prefix(1))
            }
            titleInitial.text = itemInitial
            iconImage.isHidden = true
            let hexColor =  item.itemColor.replaceFirst(of: "#", with: "")
            iconContainerView.backgroundColor = UIColor.colorWith(hex:hexColor)
            iconContainerView.makeRoundedBorder(withCornerRadius: iconContainerView.frame.height/2)
        } else {
            titleInitial.isHidden = true
            iconImage.isHidden = false
            iconContainerView.backgroundColor = UIColor.clear
            iconContainerView.layer.cornerRadius = 0.0
        }
    }
}
