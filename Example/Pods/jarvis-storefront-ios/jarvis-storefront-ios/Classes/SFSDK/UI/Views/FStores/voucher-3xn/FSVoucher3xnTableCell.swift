//
//  FSVoucher3xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSVoucher3xnTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private let collectionCellHeight: Int = 110
    private let numberOfItemsInEachRow = 3
    
    override class func register(table: UITableView) {
        if let mNib = FSVoucher3xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: FSVoucher3xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "FSVoucher3xnTableCell" }
    override var collectCellId: String { return "SFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "FSVoucher3xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.isScrollEnabled = false
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        configureCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth:Int = Int(SFConstants.windowWidth) / numberOfItemsInEachRow - 30
        return CGSize(width: itemWidth, height: collectionCellHeight)
    }
    
    private func configureCollectionView() {
        collectionViewHeightConstraint.constant = CGFloat(collectionCellHeight * (mList.count/numberOfItemsInEachRow))
        self.layoutIfNeeded()
        collectV.reloadData()
    }
}
