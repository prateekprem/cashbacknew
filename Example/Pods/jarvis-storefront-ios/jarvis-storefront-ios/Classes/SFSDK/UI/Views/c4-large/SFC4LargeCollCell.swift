//
//  SFC4LargeCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 11/10/19.
//

import UIKit

class SFC4LargeCollCell: SFBaseCollCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        nameLabel.text = item.itemName
        makeRounded(view: containerView, roundV: .custom(5.0), clr: UIColor(hex: "DDE5ED"), border: 1)
    }
    
}
