//
//  SFPortrait3xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 11/10/19.
//

import UIKit

class SFPortrait3xnTableCell: SFBaseTableCellIncCollection {
    @IBOutlet private weak var titleLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLblBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!

    
    private let numberOfItemsInEachRow = 3
    let ratio: CGFloat = 0.859
    let widthFactor: CGFloat = 3.6
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    override class func register(table: UITableView) {
        if let mNib = SFPortrait3xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFPortrait3xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFPortrait3xnTableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFPortrait3xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.isScrollEnabled = false
         self.isAccessibilityElement = false
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        screenWidth = info.cellPresentInfo.tableWidth - 30
        addBorderSupport(info: info)
        let title = info.vTitle
        if title.length == 0 {
            titleLblHeightConstraint.constant = 0.0
            titleLblBottomConstraint.constant = 0.0
        }
        
        var totalRows = (mList.count/numberOfItemsInEachRow)
        if ((mList.count % numberOfItemsInEachRow) > 0) { totalRows = totalRows + 1 }
        let cellHeight = Int(((screenWidth / widthFactor) / ratio)) * totalRows
        let cellSpaceHeight = 10 * totalRows
        collectionViewHeightConstraint.constant = CGFloat(cellHeight + cellSpaceHeight)
        layoutIfNeeded()
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
        return CGSize(width: (screenWidth / widthFactor) , height: ((screenWidth / widthFactor) / ratio))
    }
}
