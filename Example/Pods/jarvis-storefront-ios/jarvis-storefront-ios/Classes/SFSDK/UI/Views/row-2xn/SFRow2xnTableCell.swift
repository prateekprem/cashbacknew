//
//  SFRow2xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 14/10/19.
//

import UIKit

class SFRow2xnTableCell: SFBaseTableCellIncCollection {
    static var noOfRowsToShowInCollectionView: Int = 2
    static var noOfColumnsToShowInCollectionView: Int = 2
    static var collectionCellHeight: CGFloat = 240
    
    @IBOutlet private weak var viewAllButton: UIButton!

    override class func register(table: UITableView) {
        if let mNib = SFRow2xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFRow2xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFRow2xnTableCell" }
    override var collectCellId: String { return "kSFRow2xnCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFRow2xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFRow2xnCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        viewAllButton.isHidden = !info.vSeeAllSeoUrl.isValidString()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / CGFloat(SFRow2xnTableCell.noOfColumnsToShowInCollectionView), height: SFRow2xnTableCell.collectionCellHeight)
    }

    @IBAction private func viewAllButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickViewAll(mLayout)
    }
}
