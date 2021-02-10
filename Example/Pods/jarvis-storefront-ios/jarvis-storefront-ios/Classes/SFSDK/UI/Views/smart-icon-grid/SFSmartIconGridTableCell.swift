//
//  SFSmartIConGridTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 14/10/19.
//

import UIKit

class SFSmartIconGridTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet private weak var viewAllButton: UIButton!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private let noOfItemInARow: Int = 4
    private let collectionCellHeight: CGFloat = 90

    override class func register(table: UITableView) {
        if let mNib = SFSmartIconGridTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconGridTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconGridTableCell" }
    override var collectCellId: String { return "kSFSmartIconGridCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFSmartIconGridTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconGridCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.size.width / CGFloat(noOfItemInARow)
        return CGSize(width: width, height: collectionCellHeight)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        configureViewAllButton()
        collectV.reloadData()
    }
    
    // MARK: Private Methods
    
    @IBAction private func viewAllButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout else { return }
        mLayout.isExpanded = !mLayout.isExpanded
        guard let delegate = mLayout.pDelegate, let layoutIndexPath = indexPath else { return }
        delegate.reloadSection(layoutIndexPath)
    }
    
    private func configureViewAllButton() {
        if mList.count <= noOfItemInARow {
            viewAllButton.isHidden = true
        }
        else if mList.count == 2 * noOfItemInARow {
            viewAllButton.isHidden = true
            collectionViewHeightConstraint.constant = 2 * collectionCellHeight
            layoutIfNeeded()
        }
        else {
            viewAllButton.isHidden = false
            layoutItemsInCollectionView()
        }
    }
    
    private func layoutItemsInCollectionView() {
        if let isExpanded = layout?.isExpanded {
            if !isExpanded {
                if mList.count > noOfItemInARow && mList.count < 2 * noOfItemInARow {
                    collectionViewHeightConstraint.constant = collectionCellHeight
                }
                else {
                    collectionViewHeightConstraint.constant = 2 * collectionCellHeight
                }
                viewAllButton.setTitle("View All", for: .normal)
            }
            else {
                let noOfRows: CGFloat = CGFloat(mList.count) / CGFloat(noOfItemInARow)
                let height: CGFloat = CGFloat(ceil(noOfRows)) * collectionCellHeight
                collectionViewHeightConstraint.constant = height
                viewAllButton.setTitle("View Less", for: .normal)
            }
            
            layoutIfNeeded()
        }
    }
}
