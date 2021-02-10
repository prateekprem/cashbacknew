//
//  SFCBTopOffersCollCell.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 23/01/20.
//

import UIKit


class SFCBLandingBaseCollCell: SFBaseCollCell {
   static var identifier: String { return String(describing: self) }
   public func showShimmerLoading(isShow: Bool) { }
}

class SFCBTopOffersCollCell: SFCBLandingBaseCollCell {
    @IBOutlet weak private var backgroundImage : UIImageView! // imgV in base can play background
    @IBOutlet weak private var logoImage       : UIImageView!
    @IBOutlet weak private var offerTitle      : UILabel!
    @IBOutlet weak private var offerSubTitle   : UILabel!
    @IBOutlet weak private var overlayView     : UIView!
    
    class var cellNib: UINib? { return Bundle.nibWith(name: "SFCBTopOffersCollCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundImage.roundCorner(0, borderColor: nil, rad: 12)
        self.overlayView.roundCorner(0, borderColor: nil, rad: 12)
        self.logoImage.circular(0.0, nil, true)
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo){
        // self.showShimmerLoading(isShow: item.isLoading)
        backgroundImage.jr_setImage(with: URL(string: item.itemImageUrl))
        offerTitle.text = item.itemSubTitle
        offerSubTitle.text = item.itemName
        offerTitle.applyLetterSpacing(latterSpacing: 0.5)
        offerSubTitle.applyLetterSpacing(latterSpacing: 0.5)
        logoImage.jr_setImage(with: URL(string: item.iconUrl))
        overlayView.isHidden = !item.isOverlay
    }
    
    override func showShimmerLoading(isShow: Bool) {
      //  self.cbShowHideLoader(isShow: isShow)
    }
}
