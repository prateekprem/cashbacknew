//
//  SFSmartIconCarouselCollCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 22/08/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

class SFSmartIconCarouselCollCell: SFBaseCollCell {

    @IBOutlet weak private var baseV  : UIView!
    @IBOutlet weak private var ttlLbl : UILabel!
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        ttlLbl.text = item.itemName.replaceFirst(of: " ", with: "\n")
        self.backgroundColor = cellConfig.collectCellBackColor
        self.makeRounded(view: self, roundV: cellConfig.collectCellRoundBy,
                         clr: cellConfig.collectCellRoundClr, border: cellConfig.collectCellRoundBorder)
    }
}



