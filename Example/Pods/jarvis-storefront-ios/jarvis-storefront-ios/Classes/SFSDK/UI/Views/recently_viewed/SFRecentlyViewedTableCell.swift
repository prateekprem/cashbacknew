//
//  SFRecentlyViewedTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 16/10/19.
//

import UIKit

class SFRecentlyViewedTableCell: SFBaseTableCellIncCollection {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var gotoBagButton: UIButton!
    
    override class func register(table: UITableView) {
        if let mNib = SFRecentlyViewedTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFRecentlyViewedTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFRecentlyViewedTableCell" }
    override var collectCellId: String { return "kSFRecentlyViewedCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFRecentlyViewedTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFRecentlyViewedCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        gotoBagButton.isHidden = !(info.layoutVType == .itemInCart)
        configureContainerView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    // MARK: Private Methods
    private func configureContainerView() {
        makeRounded(view: containerView, roundV: .custom(5.0))
        containerView.drawGradient(colors: [UIColor(hex: "8626E8").cgColor, UIColor(hex: "F460A7").cgColor], direction: .leftToRight)
    }
    
    @IBAction private func gotoBagButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfNavigateToCart()
    }
}
