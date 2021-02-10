//
//  SFDeals2xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 18/10/19.
//

import UIKit

class SFDeals2xnTableCell: SFBaseTableCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var cashbackContainerView: UIView!
    @IBOutlet private weak var offerTextLabel: UILabel!
    @IBOutlet private weak var viewAllButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var viewAllTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllHeightCons: NSLayoutConstraint!
    @IBOutlet weak var scrollToTopButton: UIButton!
    
    @IBOutlet weak var viewAllButton: UIButton!{
        didSet{
            viewAllButton.layer.masksToBounds = true
            viewAllButton.layer.cornerRadius = 5.0
        }
    }
    
    override class func register(table: UITableView) {
        if let mNib = SFDeals2xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFDeals2xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFDeals2xnTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFDeals2xnTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfiguration()
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if let item: SFLayoutItem = layout?.vItems[rowIndex] {
            nameLabel.text = item.itemName
            amountLabel.text = nil
            if let price = item.offerPrice?.getFormattedAmount() {
                amountLabel.text = "\(rupeeSymbol)\(price)"
            }
            
            if let offerTxt = item.offerText {
                offerTextLabel.text = offerTxt
                cashbackContainerView.isHidden = false
            }
            else {
                offerTextLabel.text = nil
                cashbackContainerView.isHidden = true
            }
            
            
            if (info.vSeeAllSeoUrl.length > 0) && isRowTheLastRow(row: rowIndex) {
                if info.isDealDataAlreadyExpanded {
                    viewAllButton.isHidden = true
                    
                }else {
                    viewAllButton.isHidden = false
                }
                scrollToTopButton.isHidden = !viewAllButton.isHidden
                viewAllButtonBottomConstraint.constant = 16
                viewAllTopConstraint.constant = 17
                viewAllHeightCons.constant = 28
            } else {
                 viewAllButton.isHidden = true
                 scrollToTopButton.isHidden = true
                 viewAllButtonBottomConstraint.constant = 0
                 viewAllTopConstraint.constant = 10
                 viewAllHeightCons.constant = 0
            }
            
            
            contentView.layoutIfNeeded()
        }
    }
    
    private func isRowTheLastRow(row: Int) -> Bool {
        if let layout = self.layout{
            if layout.isDealDataAlreadyExpanded {
                if row == (layout.vItems.count - 1) {
                    return true
                }
            } else {
                if row == layout.dealsInitialIndex - 1 {
                    return true
                }
            }
        }
        return false
    }
    // MARK: Private Methods
    
    private func doInitialConfiguration() {
        containerView.layer.cornerRadius = 7.0
    }
    
    @IBAction func scrollToTopTapped(_ sender: Any) {
            guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
            delegate.sfDidClickViewAllDeals(mLayout)
    }
    
    @IBAction func viewAllTapped(_ sender: Any) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickViewAllDeals(mLayout)
    }
    
}
