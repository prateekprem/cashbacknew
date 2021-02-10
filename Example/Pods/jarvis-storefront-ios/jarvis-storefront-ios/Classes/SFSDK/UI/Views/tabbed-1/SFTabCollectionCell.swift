//
//  SFTabCollectionCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/10/19.
//

import UIKit

let tabItemFont: UIFont = UIFont.systemMediumFontOfSize(14.0)

class SFTabCollectionCell: SFBaseCollCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bottomLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLineView.backgroundColor = UIColor.themeBlueColor()
        titleLabel.font = tabItemFont
    }
    
    func configureCollectionCell(_ item: SFLayoutItem?) {
        titleLabel.text = item?.itemName
        if let selected = item?.isSelected {
            if selected {
                titleLabel.textColor = UIColor(hex: "1D252D")
                bottomLineView.isHidden = false
            }
            else {
                titleLabel.textColor = UIColor(hex: "8BA6C1")
                bottomLineView.isHidden = true
            }
        }
    }
    
    func hideBottomLineForTabbedView(_ hide: Bool){
        bottomLineView.isHidden = hide
    }
    
    func makeHeaderBold(){
        titleLabel.font = UIFont.systemMediumFontOfSize(16.0)
    }
}
