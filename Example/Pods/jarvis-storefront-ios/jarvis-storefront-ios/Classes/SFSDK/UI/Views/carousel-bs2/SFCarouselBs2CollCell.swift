//
//  SFCarouselBs2CollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 15/10/19.
//

import UIKit

class SFCarouselBs2CollCell: SFBaseCollCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        titleLabel.text = item.itemName
        makeRounded(view: self, roundV: cellConfig.collectCellRoundBy, clr: cellConfig.collectCellRoundClr,  border: cellConfig.collectCellRoundBorder)
    }
}
