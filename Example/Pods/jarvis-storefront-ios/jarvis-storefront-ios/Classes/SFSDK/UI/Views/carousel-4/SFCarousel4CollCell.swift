//
//  SFCarousel4CollCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 12/10/19.
//

import UIKit

class SFCarousel4CollCell: SFBaseCollCell {

    @IBOutlet weak private var ttlLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        self.ttlLbl.text = item.itemName
        self.makeRounded(view: imgV, roundV: cellConfig.collectCellRoundBy, clr: cellConfig.collectCellRoundClr,  border: cellConfig.collectCellRoundBorder)
    }

}
