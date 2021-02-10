//
//  SFActiveOrderCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/11/19.
//

import UIKit

class SFActiveOrderCollCell: SFBaseCollCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfigurations()
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        titleLabel.attributedText = nil
        if let attrText = item.statusText2?.htmlToAttributedString {
            let fontAttribute = [NSAttributedString.Key.font: UIFont.systemMediumFontOfSize(14.0)]
            let finalAttrString = NSMutableAttributedString(attributedString: attrText)
            finalAttrString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attrText.length))
            titleLabel.attributedText = finalAttrString
        }
        if let thumbImageUrlString = item.orderItemThumbnailImageUrl, let mURL = URL(string: thumbImageUrlString) {
            self.thumbnailImageView.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
    }
    
    // MARK: Private Methods
    private func doInitialConfigurations() {
        makeRounded(view: containerView, roundV: .custom(8.0), clr: UIColor(hex: "DDE5ED"), border: 1.0)
    }
}
