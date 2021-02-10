//
//  SFSmartIconButton2xnTableCell.swift
//  Jarvis
//
//  Created by Pankaj Singh on 24/08/20.
//  Copyright © 2020 One97. All rights reserved.
//

import UIKit

class SFSmartIconButton2xnTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak private var headerHeight: NSLayoutConstraint!
    @IBOutlet weak private var collectionViewHeight: NSLayoutConstraint!
    private var defaultCollectionCellHeight: Double = 70.0
    
    override class func register(table: UITableView) {
        if let mNib = SFSmartIconButton2xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconButton2xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconButton2xnTableCell" }
    override var collectCellId: String { return "kSFSmartIconButton2xnCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFSmartIconButton2xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconButton2xnCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.isScrollEnabled = false
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        addBorderSupport(info: info)
        if layout?.vTitle != "" {
            headerHeight.constant = 36.0
        } else {
            headerHeight.constant = 0
        }
        var numberOfRows: Double = 1.0
        if mList.count > 1 {
            numberOfRows = Double(mList.count/2)
        }
        collectionViewHeight.constant = CGFloat(defaultCollectionCellHeight * numberOfRows) + CGFloat((numberOfRows - 1))
        collectV.backgroundColor = UIColor(hexString: "E8EDF3")
        contentView.layoutIfNeeded()
        collectV.reloadData()
    }
    
    private func addBorderSupport(info: SFLayoutViewInfo) {
        if let bgColor = info.metaLayoutInfo?.bgColor, !bgColor.isEmpty {
            contentView.backgroundColor = UIColor.colorWithHexString(bgColor)
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectCellId.count > 0, let mLayout = self.layout {
            var ww = collectionView.frame.width
            if mLayout.vItems.count > 1 {
                ww = (collectionView.frame.width)/2.0
            }
            return CGSize(width: ww, height: 70.0)
        }
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as! SFSmartIconButton2xnCollCell
        cell.bgColor = self.layout?.metaLayoutInfo?.bgColor
        if let mLayout = self.layout, collectCellId.count > 0 {
            cell.show(item: mList[indexPath.row], cellConfig: mLayout.cellPresentInfo)
        }
        cell.updateDividerUI(indexPath: indexPath, itemCount: mList.count)
        return cell
    }
}


