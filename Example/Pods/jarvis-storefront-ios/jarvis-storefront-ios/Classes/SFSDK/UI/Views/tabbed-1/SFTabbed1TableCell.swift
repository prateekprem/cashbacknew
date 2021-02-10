//
//  SFTabbed1TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/10/19.
//

import UIKit

let noOfItemInARowForInfiniteGrid: Int = 2

class SFTabbed1TableCell: SFBaseTableCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var gridItems: [SFLayoutItem] = [SFLayoutItem]()
    private var collectionImageHeight: CGFloat = 160 // Default is grid
    private var isHideInfoForFlashSale: Bool = false
    override class func register(table: UITableView) {
        if let mNib = SFTabbed1TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFTabbed1TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFTabbed1TableCell" }
    var collectCellId: String { return "kSFTabbed1CollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFTabbed1TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFTabbed1CollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        
        if let items = layout?.vItems {
            var selectedItem: SFLayoutItem?
            for item in items {
                if item.isSelected {
                    selectedItem = item
                    break
                }
            }
            
            if let selectedItem = selectedItem {
                gridItems.removeAll()
                gridItems.append(contentsOf: selectedItem.gridItems[rowIndex])
                if let viewType = selectedItem.gridLayout?.viewType {
                    if viewType == .largeGrid {
                        collectionViewHeightConstraint.constant = 365
                        collectionImageHeight = 160 + 60
                    }
                    else {
                        collectionViewHeightConstraint.constant = 305
                        collectionImageHeight = 160
                    }
                    self.layoutIfNeeded()
                }
                collectionView.reloadData()
            }
        }
    }
    
    override func hideInfoForFlashSale(_ hide: Bool) {
       isHideInfoForFlashSale = hide
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SFTabbed1TableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as? SFTabbed1CollCell {
            cell.delegate = self
            cell.configureImageHeight(collectionImageHeight)
            cell.configureCollectionCell(gridItems[indexPath.item])
            cell.hideInfoForFlashSale(isHideInfoForFlashSale)
            logImpressionForItem(item: gridItems[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / CGFloat(noOfItemInARowForInfiniteGrid), height: collectionViewHeightConstraint.constant)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }        
        delegate.sfSDKDidClick(item: gridItems[indexPath.item],viewInfo: mLayout,tableIndex: self.index, collectIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView.indexPathsForVisibleItems.contains(indexPath) == false) {
            if let cell = cell as? SFTabbed1CollCell {
                cell.invalidateTimerForTabbed2Cell()
            }
        }
    }
}

extension SFTabbed1TableCell: SFTabbed1CollCellDelegate {
    func didClickOnWishlist(_ item: SFLayoutItem, completionHandler: ((_ error: Error?, _ isAdded: Bool) -> Void)?) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickOnWishlist(item, completionHandler: completionHandler)
    }
    
    func isItemPresentInWishlist(_ item: SFLayoutItem) -> Bool {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return false }        
        return delegate.sfIsItemPresentInWishlist(item)
    }
}
