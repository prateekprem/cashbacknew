//
//  JRCOLEmptyCell.swift
//  Jarvis
//
//  Created by Ankit Agarwal on 18/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class JRCOLEmptyCell: UITableViewCell {

    @IBOutlet weak var noOffersView  : UIView!
    @IBOutlet weak var noOffersLabel : UILabel!
    @IBOutlet weak var imgV          : UIImageView!
    
    let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animationView.center = self.center
    }

    func configureCellForCashbackType(currentSectionType: JRCBMerchantOfferType?, isEmpty: Bool) {
        if !JRCBCommonBridge.isNetworkAvailable {
            noOffersLabel.text =  "jr_ac_noInternetMsg".localized
            imgV.image = UIImage.imageWith(name: "emptyView")
            
        } else if isEmpty {
            noOffersLabel.text = "jr_CB_MerchantOfferEmptyText".localized
            imgV.image = UIImage.imageWith(name: "ic_noTransactions")

        } else {
            imgV.image = UIImage.imageWith(name: "emptyView")
            if currentSectionType == .newOffer {
                noOffersLabel.text = "jr_pay_noNewOffer".localized
            } else {
                noOffersLabel.text = "jr_pay_noMyOffer".localized
            }
        }
    }
}
