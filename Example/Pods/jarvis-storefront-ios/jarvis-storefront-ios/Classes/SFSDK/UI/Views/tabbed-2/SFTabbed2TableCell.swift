//
//  SFTabbed2TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 19/12/19.
//

import UIKit

class SFTabbed2TableCell: SFBaseTableCell {
    
    private var tabbed2ContainerView: UIView?

    override class func register(table: UITableView) {
        if let mNib = SFTabbed2TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFTabbed2TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFTabbed2TableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFTabbed2TableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func addChildView(_ view: UIView) {
        tabbed2ContainerView = view
        view.frame = self.bounds
        self.contentView.addSubview(view)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tabbed2ContainerView?.removeFromSuperview()
        tabbed2ContainerView = nil
    }
}
