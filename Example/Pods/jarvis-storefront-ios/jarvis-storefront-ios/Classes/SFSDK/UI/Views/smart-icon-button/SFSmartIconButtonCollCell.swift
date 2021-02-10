//
//  SFSmartIconButtonCollCell.swift
//  Jarvis
//
//  Created by Prakash Jha on 20/10/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public class SFSmartIconButtonCollCell: SFBaseCollCell {
    @IBOutlet weak private var baseContainerV: UIView!
    @IBOutlet weak private var ttlLbl: UILabel!
    
    override public func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        baseContainerV.isHidden = false
        ttlLbl.textColor = cellConfig.collectTitleClr
        ttlLbl.accessibilityLabel = item.itemName
        ttlLbl.isAccessibilityElement = true
        ttlLbl.text = item.itemName
        if let color = item.layoutLabelColor {
            ttlLbl.textColor = UIColor.colorWithHexString(color)
        }
        self.imgV.backgroundColor = UIColor.clear
        if let color = item.layoutLabelBG {
            baseContainerV.backgroundColor = UIColor.colorWithHexString(color)
        }
        self.makeRounded(view: baseContainerV, roundV: cellConfig.collectCellRoundBy, clr: cellConfig.collectCellRoundClr,  border: cellConfig.collectCellRoundBorder)
    }
}
