//
//  SFSearchBarTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 01/12/20.
//

import UIKit

class SFSearchBarTableCell: SFBaseTableCell {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    override class func register(table: UITableView) {
        if let mNib = SFSearchBarTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFSearchBarTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSearchBarTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFSearchBarTableCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        let firstItem: SFLayoutItem? = info.vItems.first
        titleLabel.text = firstItem?.itemTitle
        subtitleLabel.text = firstItem?.itemSubTitle
        logImpressionForItem(item: firstItem)
        if let firstItem = firstItem, let mURL = URL(string: firstItem.itemImageUrl), iconImageView != nil {
            self.iconImageView.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate, let firstItem = mLayout.vItems.first else { return }
        delegate.sfSDKDidClick(item: firstItem, viewInfo: mLayout, tableIndex: self.index, collectIndex: 0)
    }
}
