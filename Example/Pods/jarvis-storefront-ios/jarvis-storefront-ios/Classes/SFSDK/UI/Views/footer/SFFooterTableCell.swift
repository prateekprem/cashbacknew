//
//  SFSealTrustBannerTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Romit Kumar on 27/02/20.
//

import UIKit

class SFFooterTableCell: SFBaseTableCell {

    @IBOutlet weak var sealTrustTitle: UILabel!
    @IBOutlet weak var sealTrustSubtitle: UILabel!
    @IBOutlet weak var sealTrustLogo: UIImageView!
    
    override class func register(table: UITableView) {
        if let mNib = SFFooterTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFFooterTableCell.cellId)
        }
    }
    override class var cellId: String { return "KSFFooterTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFFooterTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if let items = layout?.vItems, let firstItem = items.first {
            sealTrustTitle.text = firstItem.itemTitle
            if let mURL = URL(string: firstItem.itemImageUrl ) {
                self.sealTrustLogo.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
                }
            }
            let attributedString = NSMutableAttributedString(string: firstItem.itemSubTitle )
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2.5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            sealTrustSubtitle.attributedText = attributedString
             logImpressionForItem(item: firstItem)
        }
    }
    
    @IBAction func tableRowButtonClick(_ sender: UIButton) {
        guard let indexPath = indexPath, let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfSDKDidClick(item: mLayout.vItems[indexPath.row],viewInfo:mLayout, tableIndex: indexPath.section, collectIndex: indexPath.row)
    }
}
