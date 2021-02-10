//
//  SFListSmallTiHeaderCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 21/09/20.
//

import UIKit

class SFListSmallTiHeaderCell: SFBaseTableCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel: UILabel!
    
    override class func register(table: UITableView) {
        if let mNib = SFListSmallTiHeaderCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFListSmallTiHeaderCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFListSmallTiHeaderCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFListSmallTiHeaderCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        titleLabel.isHidden = !info.vTitle.isValidString()
        titleLabel.text = info.vTitle
        subTitleLabel.isHidden = !info.vSubTitle.isValidString()
        subTitleLabel.text = info.vSubTitle
    }
}
