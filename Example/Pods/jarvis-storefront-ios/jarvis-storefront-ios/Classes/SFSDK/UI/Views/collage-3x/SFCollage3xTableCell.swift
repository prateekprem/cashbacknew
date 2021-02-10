//
//  SFCollage3xTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 17/10/19.
//

import UIKit

class SFCollage3xTableCell: SFBaseTableCellIncCollection {

    override class func register(table: UITableView) {
        if let mNib = SFCollage3xTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFCollage3xTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCollage3xTableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFCollage3xTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        if let layout = collectV.collectionViewLayout as? SFCollage3xLayout {
            layout.delegate = self
        }
    }
}

// MARK: MPCollage3xLayoutDelegate
extension SFCollage3xTableCell: SFCollage3xLayoutDelegate {
    func colletionView(view: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: round(SFConstants.windowWidth * 0.57), height: collectV.frame.size.height)
        default:
            return CGSize(width: round(SFConstants.windowWidth * 0.43), height: collectV.frame.size.height / 2)
        }
    }
}
