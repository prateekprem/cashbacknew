//
//  SFItemInCartTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 16/10/19.
//

import UIKit

class SFItemInCartTableCell: SFBaseTableCellIncCollection {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var gotoBagButton: UIButton!

    override class func register(table: UITableView) {
        if let mNib = SFItemInCartTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFItemInCartTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFItemInCartTableCell" }
    override var collectCellId: String { return "kSFItemInCartCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFItemInCartTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFItemInCartCollCell") }
    
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
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        containerView.drawGradient(colors: [UIColor(red: 123/255, green: 67/255, blue: 223/255, alpha: 1.0).cgColor, UIColor(red: 226/255, green: 107/255, blue: 165/255, alpha: 1.0).cgColor], direction: .leftToRight)
    }

    @IBAction private func gotoBagButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout else { return }
        guard let delegate = mLayout.pDelegate else { return }
        delegate.sfNavigateToCart()
    }
}
