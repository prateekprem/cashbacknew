//
//  SFImageCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Pankaj Singh on 23/10/20.
//

import UIKit


class SFImageCollCell: SFBaseCollCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet private weak var rightBorder: UIView!
    @IBOutlet private weak var mLeadingConstant: NSLayoutConstraint!
    @IBOutlet private weak var mTrailingConstant: NSLayoutConstraint!
    
    var needToHidePadding: Bool = false
    var classType: String = ""
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        rightBorder.isHidden = cellConfig.collectCellRightBorderhidden
        mLeadingConstant.constant = cellConfig.collectCellMargin.left
        mTrailingConstant.constant = cellConfig.collectCellMargin.right
        updatePadding(cellConfig: cellConfig)
    }
    
    private func updatePadding(cellConfig: SFTableCellPresentInfo) {
        if needToHidePadding {
            self.makeRounded(view: imgV, roundV: SFCornerRadius.custom(0), clr: cellConfig.collectCellRoundClr,  border: 0)
            mLeadingConstant.constant = 0
            mTrailingConstant.constant = 0
        } else {
            var collectCellRoundBy: SFCornerRadius = cellConfig.collectCellRoundBy
            if classType.lowercased() == H1Bannerclass.home.rawValue && cellConfig.collectCellHandleClassType {
                collectCellRoundBy = .custom(18.0)
            }
            self.makeRounded(view: imgV, roundV: collectCellRoundBy, clr: cellConfig.collectCellRoundClr,  border: cellConfig.collectCellRoundBorder)
            mLeadingConstant.constant = cellConfig.collectCellMargin.left
            mTrailingConstant.constant = cellConfig.collectCellMargin.right
        }
    }
}
