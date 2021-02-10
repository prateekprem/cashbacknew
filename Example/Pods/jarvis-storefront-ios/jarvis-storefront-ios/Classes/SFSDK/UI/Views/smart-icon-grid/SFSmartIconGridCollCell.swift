//
//  SFSmartIConGridCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 14/10/19.
//

import UIKit

class SFSmartIconGridCollCell: SFBaseCollCell {
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        nameLabel.text = item.itemName
    }
}
