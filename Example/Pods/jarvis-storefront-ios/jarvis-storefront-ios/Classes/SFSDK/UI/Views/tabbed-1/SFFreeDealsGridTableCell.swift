//
//  SFFreeDealsGridTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 04/12/19.
//

import UIKit

class SFFreeDealsGridTableCell: SFBaseTableCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var brandLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var freeLabel: UILabel!
    @IBOutlet private weak var sponsoredLabel: UILabel!{
        didSet{
            sponsoredLabel.layer.cornerRadius = 2
            sponsoredLabel.layer.masksToBounds = true
        }
    }
    
    override class func register(table: UITableView) {
        if let mNib = SFFreeDealsGridTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFFreeDealsGridTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFFreeDealsGridTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFFreeDealsGridTableCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        freeLabel.textColor = UIColor.paytmBlueColor()
        freeLabel.layer.cornerRadius = 5.0
        freeLabel.layer.borderWidth = 1.0
        freeLabel.layer.borderColor = UIColor.paytmBlueColor().cgColor
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        var selectedItem: SFLayoutItem?
        if let items = layout?.vItems {
            for item in items {
                if item.isSelected {
                    selectedItem = item
                    break
                }
            }
        }
        
        if let item = selectedItem?.gridItems[rowIndex].first {
            configureCell(item)
        }
    }
    
    private func configureCell(_ item: SFLayoutItem?) {
        clearAllValues()
        if let isSponsored = item?.sponsored, isSponsored {
            sponsoredLabel.isHidden = false
        }else {
            sponsoredLabel.isHidden = true
        }
        if let imageUrlString = item?.itemImageUrl, let imageUrl = URL(string: imageUrlString) {
            itemImageView.setImageFrom(url: imageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        brandLabel.text = item?.brand
        nameLabel.text = item?.itemName
    }
    
    private func clearAllValues(){
        brandLabel.text = nil
        nameLabel.text = nil
    }
}
