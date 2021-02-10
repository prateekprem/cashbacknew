//
//  SFSmartIconButton2xnCollCell.swift
//  Jarvis
//
//  Created by Pankaj Singh on 24/08/20.
//  Copyright © 2020 One97. All rights reserved.
//

import UIKit

class SFSmartIconButton2xnCollCell: SFBaseCollCell {
    @IBOutlet weak private var baseContainerV: UIView!
    @IBOutlet weak private var ttlLbl: UILabel!
    @IBOutlet weak private var leftDivider: UIView!
    @IBOutlet weak private var rightDivider: UIView!
    var bgColor: String?
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        baseContainerV.isHidden = false
        ttlLbl.textColor = cellConfig.collectTitleClr
        ttlLbl.accessibilityLabel = item.itemName
        ttlLbl.isAccessibilityElement = true
        ttlLbl.text = item.itemName
        if let color = item.layoutLabelColor, !color.isEmpty {
            ttlLbl.textColor = UIColor.colorWithHexString(color)
        }
        self.imgV.backgroundColor = UIColor.clear
        if let color = item.layoutLabelBG, !color.isEmpty {
            baseContainerV.backgroundColor = UIColor.colorWithHexString(color)
        } else if let color = bgColor, !color.isEmpty {
            baseContainerV.backgroundColor = UIColor.colorWithHexString(color)
        } else {
            baseContainerV.backgroundColor = .white
        }
        self.makeRounded(view: baseContainerV, roundV: cellConfig.collectCellRoundBy, clr: cellConfig.collectCellRoundClr,  border: cellConfig.collectCellRoundBorder)
    }
    
    func updateDividerUI(indexPath: IndexPath, itemCount: Int) {
        self.rightDivider.backgroundColor = UIColor(hexString: "E8EDF3")
        self.leftDivider.backgroundColor = UIColor(hexString: "E8EDF3")
        if itemCount <= 1 {
            self.rightDivider.isHidden = true
            self.leftDivider.isHidden = true
            return
        }
        if indexPath.row % 2 == 0 {
            self.rightDivider.isHidden = false
            self.leftDivider.isHidden = true
        } else {
            self.rightDivider.isHidden = true
            self.leftDivider.isHidden = false
        }
    }
    
}
