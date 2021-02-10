//
//  SFTabbed2SaleTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 19/12/19.
//

import UIKit

class SFTabbed2SaleTableCell: SFBaseTableCell {
    
    private var tabbed2SaleContainerView: UIView?
    @IBOutlet private weak var tabbed2SaleCollectionView: UICollectionView!
    @IBOutlet private weak var collectionContainerHeightConstraint: NSLayoutConstraint!
    
    private var didTappedOnCell: Bool = false
    
    override class func register(table: UITableView) {
        if let mNib = SFTabbed2SaleTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFTabbed2SaleTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFTabbed2SaleTableCell" }
    private var collectCellId: String { return "kSFTabbed2SaleCollCell" }

    private class var nib: UINib? { return Bundle.nibWith(name: "SFTabbed2SaleTableCell") }
    private class var collectNib: UINib? { return Bundle.nibWith(name: "SFTabbed2SaleCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tabbed2SaleCollectionView.register(SFTabbed2SaleTableCell.collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func addChildView(_ view: UIView) {
        tabbed2SaleContainerView = view
        var frame = self.bounds
        frame.origin.y = collectionContainerHeightConstraint.constant
        frame.size.height -= collectionContainerHeightConstraint.constant
        view.frame = frame
        self.contentView.addSubview(view)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tabbed2SaleContainerView?.removeFromSuperview()
        tabbed2SaleContainerView = nil
    }
}

extension SFTabbed2SaleTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = layout?.vItems.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: SFTabbed2SaleCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as? SFTabbed2SaleCollCell {
            if let item = layout?.vItems[indexPath.item] {
                cell.configureViews(with: item)
                if indexPath.row == 0 && !didTappedOnCell {
                    cell.didSelectedCell()
                }
                else {
                    cell.didUnSelectCell()
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        if !didTappedOnCell {
            if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? SFTabbed2SaleCollCell {
                cell.didUnSelectCell()
            }
        }
        didTappedOnCell = true
        delegate.sfDidClickOnFlashSaleItemAtIndex(indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? SFTabbed2SaleCollCell {
            cell.didSelectedCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SFTabbed2SaleCollCell {
            cell.didUnSelectCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SFTabbed2SaleCollCell {
            cell.removeTimerIfAny()
        }
    }
}

