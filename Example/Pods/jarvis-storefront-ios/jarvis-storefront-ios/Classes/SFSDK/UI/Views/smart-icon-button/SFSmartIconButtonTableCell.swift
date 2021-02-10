//
//  SFSmartIconButtonTableCell.swift
//  Jarvis
//
//  Created by Prakash Jha on 20/10/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public class SFSmartIconButtonTableCell: SFBaseTableCellIncCollection {
    override public class func register(table: UITableView) {
        if let mNib = SFSmartIconButtonTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconButtonTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconButtonTableCell" }
    override var collectCellId: String { return "kSFSmartIconButtonCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFSmartIconButtonTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconButtonCollCell") }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
}
