//
//  SFDeals2xnHeaderCell.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 18/12/19.
//

import UIKit

class SFDeals2xnHeaderCell: SFBaseTableCell {

    override class func register(table: UITableView) {
        if let mNib = SFDeals2xnHeaderCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFDeals2xnHeaderCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFDeals2xnHeaderCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFDeals2xnHeaderCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        let item = info.vItems[rowIndex]
        logImpressionForItem(item: item)
    }

}
