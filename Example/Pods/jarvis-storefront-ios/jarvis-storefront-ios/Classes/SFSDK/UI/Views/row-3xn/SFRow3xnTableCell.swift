//
//  SFRow3xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 14/10/19.
//

import UIKit

class SFRow3xnTableCell: SFBaseTableCellIncCollection {

    static var noOfRowsToShowInCollectionView: Int = 2
    static var noOfColumnsToShowInCollectionView: Int = 3
    static var collectionCellHeight: CGFloat = 140
    
    @IBOutlet private weak var viewAllButton: UIButton!
    
    override class func register(table: UITableView) {
        if let mNib = SFRow3xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFRow3xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFRow3xnTableCell" }
    override var collectCellId: String { return "kSFRow3xnCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFRow3xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFRow3xnCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        viewAllButton.isHidden = !info.vSeeAllSeoUrl.isValidString()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / CGFloat(SFRow3xnTableCell.noOfColumnsToShowInCollectionView), height: SFRow3xnTableCell.collectionCellHeight)
    }
    
    @IBAction private func viewAllButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout else { return }
        
        guard let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickViewAll(mLayout)
    }
}
