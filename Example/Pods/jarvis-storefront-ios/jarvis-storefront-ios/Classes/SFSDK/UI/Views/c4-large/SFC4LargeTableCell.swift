//
//  SFC4LargeTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 11/10/19.
//

import UIKit

class SFC4LargeTableCell: SFBaseTableCellIncCollection {
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var titleTopConstraint: NSLayoutConstraint!
    
    override class func register(table: UITableView) {
        if let mNib = SFC4LargeTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFC4LargeTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFC4LargeTableCell" }
    override var collectCellId: String { return "kSFC4LargeCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFC4LargeTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFC4LargeCollCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if info.vTitle.length > 0 {
            
            title.isHidden = false
            titleTopConstraint.constant = 24
            title.text = info.vTitle
        }else {
            title.isHidden = true
            titleTopConstraint.constant = 0
            
        }
        contentView.layoutIfNeeded()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 68, height: collectionView.frame.size.height)
    }
}
