//
//  SFTree1L1CollCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 21/10/19.
//

import UIKit

class SFTree1L1CollCell: SFBaseCollCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfiguration()
    }
    
    func configureCell(_ item: SFLayoutItem?) {
        if let imageUrlString = item?.itemImageUrl, let imageUrl = URL(string: imageUrlString) {
            imageView.setImageFrom(url: imageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        titleLabel.text = item?.itemName
        subTitleLabel.text = item?.layoutLabel
    }
    
    // MARK: Private Methods
    
    func doInitialConfiguration() {
        makeRounded(view: containerView, roundV: .custom(5.0))
    }
}
