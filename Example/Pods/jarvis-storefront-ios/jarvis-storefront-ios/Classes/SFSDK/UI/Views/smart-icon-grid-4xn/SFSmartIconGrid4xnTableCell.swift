//
//  SFSmartIconGrid4xnTableCell.swift
//  Jarvis
//
//  Created by Pankaj Singh on 12/08/20.
//  Copyright © 2020 One97. All rights reserved.
//

import UIKit

class SFSmartIconGrid4xnTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak private var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var showMoreViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var showMoreView: UIView!
    @IBOutlet weak private var showMoreButtonView: UIView!
    @IBOutlet weak private var showMoreLabel: UILabel!
    @IBOutlet weak private var arrowIcon: UIImageView!
    
    private var defaultCollectionCellHeight: Double = 120
    private var noOfItemsInRow: Int = 4 //On Changing this please make sure to change info.collectColomnCount
    
    override class func register(table: UITableView) {
        if let mNib = SFSmartIconGrid4xnTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconGrid4xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconGrid4xnTableCell" }
    override var collectCellId: String { return "kSFSmartIconGrid4xnCollCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFSmartIconGrid4xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconGrid4xnCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        showMoreButtonView.layer.borderWidth = 1
        showMoreButtonView.layer.borderColor = UIColor(hex: "E8EDF3").cgColor
        showMoreButtonView.layer.cornerRadius = 15
        collectV.isScrollEnabled = false
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        configureSeparator(info)
        addBorderSupport(info: info)
        shouldShowShowMore()
        if layout?.vTitle != "" {
            headerViewHeight.constant = 34.0
        } else {
            headerViewHeight.constant = 0
        }
        let clumns = Int(info.cellPresentInfo.collectColomnCount)
        let noOfRows = ceil((Double(mList.count) / Double(clumns)))
        collectionViewHeight.constant = CGFloat(defaultCollectionCellHeight * noOfRows)
        contentView.layoutIfNeeded()
        collectV.reloadData()
    }
    
    private func configureSeparator(_ info: SFLayoutViewInfo) {
        let items: [SFLayoutItem] = info.vItems
        if items.isEmpty || !info.grayLineSeparator {
           return
        }
        let clumns = Int(info.cellPresentInfo.collectColomnCount)
        if items.count > clumns {
            var lastRowItemCount = items.count % clumns
            if lastRowItemCount == 0 {
                lastRowItemCount = clumns
            }
            
            let slicedArray = items.prefix(items.count - lastRowItemCount)
            for item in slicedArray {
                item.showSeparator = true
            }
        }
    }
    
    private func addBorderSupport(info: SFLayoutViewInfo) {
        if let bgColor = info.metaLayoutInfo?.bgColor, !bgColor.isEmpty {
            contentView.backgroundColor = UIColor.colorWithHexString(bgColor)
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    private func shouldShowShowMore() {
        if let layout = layout, (layout.vItems.count % noOfItemsInRow) == 0,  (layout.vSeoUrl.isValidString() || layout.vSubTitle.isValidString())  {
            showMoreButtonView.isHidden = false
            showMoreViewHeight.constant = 45
            var showMoreText = "jr_home_all_services".localized
            if let btnText = layout.viewAllLabel, btnText.isValidString() {
                showMoreText = btnText
            }
            showMoreLabel.text = showMoreText
        } else {
            //hide show more(center) button
            showMoreButtonView.isHidden = true
            showMoreViewHeight.constant = 0
        }
    }
    
    @IBAction func showMoreButtonTap(_ sender: Any) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        let url = mLayout.vSubTitle.isValidString() ? mLayout.vSubTitle : mLayout.vSeoUrl //CAI-35211
        delegate.sfHandleFooterShowMoreClick(url, type: mLayout.layoutVType, showMoreText: showMoreLabel.text ?? "jr_home_all_services".localized)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectCellId.count > 0, let mLayout = self.layout {
            var margin = CGFloat(0)
            if mLayout.cellPresentInfo.collectColomnCount == 1 { margin = 0 }
            if mLayout.layoutVType == .smartIconCarousel { margin = 8 }
            
            var clmCnt = mLayout.cellPresentInfo.collectColomnCount
            
            if mLayout.layoutVType == .smartIconButton {
                clmCnt = min(clmCnt, CGFloat(mLayout.vItems.count))
            }
            let ww = (collectionView.frame.width)/clmCnt
            return CGSize(width: ww-margin, height: CGFloat(defaultCollectionCellHeight))
        }
        return CGSize(width: 0, height: 0)
    }
}
