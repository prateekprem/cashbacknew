//
//  SFBanner2xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 16/10/19.
//

import UIKit

class SFBanner2xnTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private let collectionCellHeight: Int = 172
    private let numberOfItemsInEachRow = 2

    override class func register(table: UITableView) {
        if let mNib = SFBanner2xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFBanner2xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFBanner2xnTableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFBanner2xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.isScrollEnabled = false
         self.isAccessibilityElement = false
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        configureCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth:Int = Int(collectionView.frame.size.width) / numberOfItemsInEachRow
        return CGSize(width: itemWidth, height: collectionCellHeight)
    }

    private func configureCollectionView() {
        collectionViewHeightConstraint.constant = CGFloat(collectionCellHeight * (mList.count/numberOfItemsInEachRow))
        self.layoutIfNeeded()
        collectV.reloadData()
    }
}
