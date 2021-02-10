//
//  SFSmartIconHeaderCollCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

class SFSmartIconHeaderCollCell: SFBaseCollCell {

    @IBOutlet weak private var ttlLbl               : UILabel!
    @IBOutlet weak private var imgContainV          : UIView!
    @IBOutlet weak private var offerContainer       : UIView!
    @IBOutlet weak private var offerCornerView      : UIView!
    @IBOutlet weak private var offerLabel           : UILabel!

    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        self.layoutIfNeeded()
        ttlLbl.text = item.itemName
        ttlLbl.textColor = cellConfig.collectTitleClr
        ttlLbl.alpha = 0.9
        if let tagLabel = item.layoutLabel, tagLabel.count > 0 {
            offerContainer.isHidden = false
            offerLabel.text = tagLabel
            offerCornerView.roundCorner(0.5, UIColor(red : 255.0, green : 164.0, blue : 0.0, alpha : 1.0), 4, true)
        }
        else {
            offerContainer.isHidden = true
        }
        
        imgContainV.backgroundColor = cellConfig.collectCellBackColor
    }
}
