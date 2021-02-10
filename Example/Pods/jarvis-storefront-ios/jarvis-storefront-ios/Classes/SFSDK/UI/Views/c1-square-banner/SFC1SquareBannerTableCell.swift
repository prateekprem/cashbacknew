//
//  SFC1SquareBannerTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 16/10/19.
//

import UIKit

class SFC1SquareBannerTableCell: SFBaseTableCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    
    private var firstItem: SFLayoutItem?
    
    override class func register(table: UITableView) {
        if let mNib = SFC1SquareBannerTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFC1SquareBannerTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFC1SquareBannerTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFC1SquareBannerTableCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        doInitialConfiguration()
    }

    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        firstItem = layout?.vItems.first
        logImpressionForItem(item: firstItem)
        if let firstItem = firstItem, let mURL = URL(string: firstItem.itemImageUrl), bannerImageView != nil {
            self.bannerImageView.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
    }
    
    // MARK: Private Methods
    private func doInitialConfiguration() {
        makeRounded(view: bannerImageView, roundV: .custom(5.0))
        bannerImageView.isUserInteractionEnabled = true
        addTapGestureToImageView()
    }
    
    private func addTapGestureToImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnImageView))
        bannerImageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapOnImageView() {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate, let firstItem = firstItem else { return }
        delegate.sfSDKDidClick(item: firstItem,viewInfo:mLayout, tableIndex: self.index, collectIndex: 0)
    }
}
