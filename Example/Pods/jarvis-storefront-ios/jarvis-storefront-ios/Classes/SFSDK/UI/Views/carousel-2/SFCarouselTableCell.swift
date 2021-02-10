//
//  SFCarouselTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 15/10/19.
//

import UIKit

class SFCarouselTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    override class func register(table: UITableView) {
        if let mNib = SFCarouselTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFCarouselTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCarouselTableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFCarouselTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if info.layoutVType == .carousel1 {
            titleLabel.text = ""
            titleBottom.constant = 0
            collectionViewHeight.constant = 176.0
        } else {
            titleLabel.text = info.vTitle
            titleBottom.constant = 14
            collectionViewHeight.constant = 105.0
        }
        contentView.layoutIfNeeded()
        collectV.reloadData()
    }
}
