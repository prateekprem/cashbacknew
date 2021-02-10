//
//  JRTopNavigationTabsCollectionViewCell.swift
//  TopNavigationTabsViewSample
//
//  Created by Alok Rao on 15/05/16.
//  Copyright © 2016 Paytm. All rights reserved.
//

import UIKit

open class JRTopNavigationTabsBaseCell: UICollectionViewCell {
    open var model:JRTopNavigationTabModel!
}

open class JRTopNavigationTabsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var unreadMsgCountSymbol: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    @IBOutlet weak var leadingDividerConstarint: NSLayoutConstraint!
    @IBOutlet weak var trailingDividerConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthEqualsTitleWidthConst: NSLayoutConstraint!
    @IBOutlet weak var bottomDividerConst: NSLayoutConstraint!

    var input: JRTopNavigationTabInput!

    open var shouldShowFullCellWidth = false
    open var model:JRTopNavigationTabModel! = JRTopNavigationTabModel() {
        didSet {
            clear()
            makeSetup()
        }
    }
    
    fileprivate func clear() {
        self.titleLabel.textColor = input.colorDeselectedTitle
        titleLabel.font = input.deSelectedFont
        self.dividerView.backgroundColor = UIColor.clear
        self.titleLabel.text = nil
    }
    
    fileprivate func makeSetup() {
        self.unreadMsgCountSymbol.isHidden = true
        var text = self.model.title
        if self.input.isUpperCase {
            text = text?.uppercased()
        }
        self.titleLabel.text = text
        if (self.model.selected) {
            titleLabel.font = input.selectedFont
            self.titleLabel.textColor = input.colorSelectedTitle
            self.dividerView.backgroundColor = UIColor.appColor()
            self.unreadMsgCountSymbol.backgroundColor = UIColor.appColor()
            
            if (shouldShowFullCellWidth){
                leadingDividerConstarint.priority = UILayoutPriority.defaultHigh
                trailingDividerConstraint.priority = UILayoutPriority.defaultHigh
                widthEqualsTitleWidthConst.priority = UILayoutPriority.defaultLow
            }else{
                leadingDividerConstarint.priority = UILayoutPriority.defaultLow
                trailingDividerConstraint.priority = UILayoutPriority.defaultLow
                widthEqualsTitleWidthConst.priority = UILayoutPriority.defaultHigh
            }
        }
        if (self.model.selected == false && self.model.unreadMsgCount > 0){
            self.unreadMsgCountSymbol.isHidden = false
        }
        bottomDividerConst.constant = input.bottomDividerConstant
    }
    
}

open class JRTopNavigationTabsRadioCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    var input: JRTopNavigationTabInput!
    
    open var shouldShowFullCellWidth = false
    open var model:JRTopNavigationTabModel! = JRTopNavigationTabModel() {
        didSet {
            clear()
            makeSetup()
        }
    }
    
    private func clear() {
        self.titleLabel.textColor = input.colorDeselectedTitle
        self.titleLabel.text = nil
        titleLabel.font = input.deSelectedFont
        radio(enable: false)
    }
    
    fileprivate func radio(enable:Bool) {
        var image = UIImage(named: input.deSelectedRadioImageFileName)
        if enable {
            image = UIImage(named: input.selectedRadioImageFileName)
        }
        radioImageView.image = image
    }
    
    fileprivate func makeSetup() {
        self.titleLabel.text = self.model.title;
        radio(enable: model.selected)
        if model.selected {
            titleLabel.textColor = input.colorSelectedTitle
            titleLabel.font = input.selectedFont
        }
    }
}
