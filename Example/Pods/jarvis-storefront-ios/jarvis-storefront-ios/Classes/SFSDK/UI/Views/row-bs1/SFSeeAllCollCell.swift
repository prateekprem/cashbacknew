//
//  SFSeeAllCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 15/10/19.
//

import UIKit

class SFSeeAllCollCell: SFBaseCollCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    // MARK: Private Methods
    private func configureViews() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
