//
//  SFSmartIConListTableCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 27/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

class SFSmartIConListTableCell: SFBaseTableCellIncCollection {
    
    override class func register(table: UITableView) {
        if let mNib = SFSmartIConListTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIConListTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIConListTableCell" }
    override var collectCellId: String { return "kSFSmartIConListCollCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFSmartIConListTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIConListCollCell") }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
}
