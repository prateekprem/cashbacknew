//
//  SFRecentlyViewedCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 16/10/19.
//

import UIKit

class SFRecentlyViewedCollCell: SFBaseCollCell {
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        nameLabel.text = item.itemName
    }
    
    // MARK: Private Methods
    private func configureViews() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
