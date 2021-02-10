//
//  SFActiveOrderTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/11/19.
//

import UIKit

class SFActiveOrderTableCell: SFBaseTableCellIncCollection {
    
    override class func register(table: UITableView) {
        if let mNib = SFActiveOrderTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFActiveOrderTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFActiveOrderTableCell" }
    override var collectCellId: String { return "kSFActiveOrderCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFActiveOrderTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFActiveOrderCollCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.size.height)
    }
}
