//
//  JRCBShimmerPromotionCell.swift
//  jarvis-auth-ios
//
//  Created by Nikita Maheshwari on 24/06/19.
//

import UIKit

class JRCBShimmerPromotionCell: UICollectionViewCell {
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var storeFrontImage: UIImageView!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.cbBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configureCell(data : JRCBPostTransactionCellVM?, state: PostTransactionStates) {
        switch state {
        case .promotionState:
            containerView.removeShimmeringEffect()
            storeFrontImage.isHidden = false
            if let url = URL.init(string: data?.imageURl ?? "") {
                storeFrontImage.jr_setImage(with: url)
            }
        default:
            storeFrontImage.isHidden = true
            containerView.addShimmeringEffect()
        }
    }
}
