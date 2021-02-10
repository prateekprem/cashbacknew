//
//  SFSmartIConListCollCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 27/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

class SFSmartIConListCollCell: SFBaseCollCell {
    @IBOutlet weak private var ttlLbl      : UILabel!
    @IBOutlet weak private var imgContainV : UIView!
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        ttlLbl.text = item.itemName
        ttlLbl.textColor = cellConfig.collectTitleClr
        
        imgContainV.backgroundColor = cellConfig.collectCellBackColor
        self.makeRounded(view: imgContainV, roundV: cellConfig.collectCellRoundBy, clr: cellConfig.collectCellRoundClr,  border: cellConfig.collectCellRoundBorder)
    }
}
