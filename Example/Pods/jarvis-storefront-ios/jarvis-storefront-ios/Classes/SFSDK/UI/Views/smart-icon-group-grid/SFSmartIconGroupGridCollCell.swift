//
//  SFSmartIconGroupGridCollCell.swift
//  Jarvis
//
//  Created by Prakash Jha on 20/10/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public class SFSmartIconGroupGridCollCell: SFBaseCollCell {
    @IBOutlet weak private var baseContainerV: UIView!
    @IBOutlet weak private var ttlLbl: UILabel!
    @IBOutlet weak private var iconContainerView: UIView!
    @IBOutlet weak var titleInitial: UILabel!
    
    @IBOutlet weak private var tagContainerV: UIView!
    @IBOutlet weak private var tagLblContainerV: UIView!
    @IBOutlet weak private var tagLbl: UILabel!

    private func showEmpty() {
        baseContainerV.isHidden = true
    }
    
    override public func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        if item.itemType == .empty { self.showEmpty(); return }
        
        baseContainerV.isHidden = false
        ttlLbl.textColor = cellConfig.collectTitleClr
        iconContainerView.backgroundColor = UIColor.clear
        iconContainerView.makeRoundedBorder(withCornerRadius: iconContainerView.frame.height/2)
        ttlLbl.accessibilityLabel = item.itemName
        ttlLbl.isAccessibilityElement = true
        ttlLbl.text = item.itemName
        self.imgV.backgroundColor = UIColor.clear
        
        if let tagLabel: String = item.layoutLabel, tagLabel.count > 0 {
            self.tagContainerV.isHidden = false
            self.tagLbl.text = tagLabel
        } else {
            self.tagContainerV.isHidden = true
        }
        if item.itemImageUrl == "" {
            titleInitial.isHidden = false
            var itemInitial = item.itemInitial
            if !itemInitial.isValidString() {
                itemInitial = String(item.itemName.prefix(1))
            }
            titleInitial.text = itemInitial
            imgV.isHidden = true
            let hexColor =  item.itemColor.replaceFirst(of: "#", with: "")
            iconContainerView.backgroundColor = UIColor.colorWith(hex:hexColor)
        } else {
           titleInitial.isHidden = true
            imgV.isHidden = false
            iconContainerView.backgroundColor = UIColor.clear
        }
    }
}
