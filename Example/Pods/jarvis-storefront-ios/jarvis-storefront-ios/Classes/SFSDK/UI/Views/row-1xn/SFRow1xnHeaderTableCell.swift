//
//  SFRow1xnHeaderTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 18/11/19.
//

import UIKit

class SFRow1xnHeaderTableCell: SFBaseTableCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewAllButton: UIButton!
    
    override class func register(table: UITableView) {
        if let mNib = SFRow1xnHeaderTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFRow1xnHeaderTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFRow1xnHeaderTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFRow1xnHeaderTableCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        doInitialConfiguration()
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        titleLabel.text = info.vTitle
        viewAllButton.isHidden = !info.vSeeAllSeoUrl.isValidString()
    }

    // MARK: Private Methods
    @IBAction private func viewAllButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickViewAll(mLayout)
    }
    
    private func doInitialConfiguration() {
        viewAllButton.titleLabel?.textColor = UIColor.paytmBlueColor()
    }
}
