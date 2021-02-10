//
//  FSSubStoresTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSSubStoresTableCell: SFBaseTableCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDistance: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    
    private var firstItem: SFLayoutItem?
    override class func register(table: UITableView) {
        if let mNib = FSSubStoresTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: FSSubStoresTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "FSSubStoresTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "FSSubStoresTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .floatRatings
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if let itemsCount = layout?.vItems.count, itemsCount > info.storeSelectedIndex, let storeSelectedIndex = layout?.storeSelectedIndex, let firstItem = layout?.vItems[storeSelectedIndex], firstItem.storeItems.count > indexPath.row {
            let store = firstItem.storeItems[indexPath.row]
            productName.text = store.storeName
            productDistance.text = store.distance
            if let rating = store.rating {
                floatRatingView.rating = rating
            }
            if let imageUrl = store.imageUrl, let mURL = URL(string: imageUrl), productImage != nil {
                self.productImage.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
                }
            }
            logImpressionForItem(item: firstItem)
        }
    }
}
