//
//  SFCBTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 09/07/20.
//

import UIKit


class SFCBTableCell: SFBaseTableCellIncCollection {
    private var mCollCellId = SFCBTopOffersCollCell.identifier

    override public class func register(table: UITableView) {
        if let mNib = SFCBTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFCBTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCBTableCell" }
    override var collectCellId: String { return mCollCellId }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFCBTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCollect()
    }
    
    func registerCollect() {
        self.collectV.register(SFCBTopOffersCollCell.cellNib, forCellWithReuseIdentifier: SFCBTopOffersCollCell.identifier)
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
    }
}

/*
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cbLandingTableCellDidClick(row: indexPath.row, inCell: self)
    }
}
*/
