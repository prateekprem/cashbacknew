//
//  SFCollage5xTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 17/10/19.
//

import UIKit

class SFCollage5xTableCell: SFBaseTableCellIncCollection {

    override class func register(table: UITableView) {
        if let mNib = SFCollage5xTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFCollage5xTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCollage5xTableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFCollage5xTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        if let layout = collectV.collectionViewLayout as? SFCollage5xLayout {
            layout.delegate = self
        }
    }
}

// MARK: MPCollage5xLayoutDelegate

extension SFCollage5xTableCell: SFCollage5xLayoutDelegate {
    
    func colletionView(view: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = SFConstants.windowWidth - 30
        let height = SFConstants.windowWidth * 0.58
        
        switch indexPath.row {
        case 0, 1:
            print(CGSize(width: 0.29 * contentWidth, height: (height) / 2))
            return CGSize(width: 0.29 * contentWidth, height: (height) / 2)
        case 2:
            print(CGSize(width: (0.415 * contentWidth) - 5, height: height + 5))
            return CGSize(width: (0.415 * contentWidth) - 5, height: height + 5)
        case 3:
            print(CGSize(width: (0.29 * contentWidth), height: (height) * 0.605))
            return CGSize(width: (0.29 * contentWidth), height: (height) * 0.605)
        default:
            print(CGSize(width: (0.29 * contentWidth), height: (height ) * 0.395))
            return CGSize(width: (0.29 * contentWidth), height: (height) * 0.395)
        }
    }
}
