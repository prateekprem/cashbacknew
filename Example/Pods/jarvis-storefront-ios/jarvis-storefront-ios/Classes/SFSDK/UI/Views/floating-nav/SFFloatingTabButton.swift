//
//  SFFloatingTabButton.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 26/06/20.
//

import UIKit

protocol SFFloatingTabButtonDelegate: class {
    func didClickItem(_ layoutItem: SFLayoutItem)
}

class SFFloatingTabButton: UIView {
    @IBOutlet weak private var dotV: UIView!
    @IBOutlet weak private var iconImgView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var nameStackView: UIStackView!
    @IBOutlet weak private var stackTopSpacing: NSLayoutConstraint!
    @IBOutlet weak private var stackCenterY: NSLayoutConstraint!
    
    weak var delegate: SFFloatingTabButtonDelegate?
    
    private var layoutItem: SFLayoutItem?
    
    var shShowDot: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.dotV.alpha = self.shShowDot ? 1.0 : 0.0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if dotV != nil {
            dotV.circular(1, .white, true)
            self.dotV.alpha =  0
        }
    }
    
    class func button(_ frame: CGRect) -> SFFloatingTabButton {
        let nib = Bundle.sfBundle.loadNibNamed("SFFloatingTabView", owner: self, options: nil)
        let btn = nib![1] as! SFFloatingTabButton
        btn.frame = frame
        return btn
    }
    
    class func singleButton(_ frame: CGRect) -> SFFloatingTabButton {
        let nib = Bundle.sfBundle.loadNibNamed("SFFloatingTabView", owner: self, options: nil)
        let btn = nib![2] as! SFFloatingTabButton
        btn.frame = frame
        return btn
    }
    
    func configureButton(_ item: SFLayoutItem, isTitlePresent: Bool) {
        layoutItem = item
        if isTitlePresent {
            if let _ = stackTopSpacing {
                stackTopSpacing.isActive = true
            }
            
            if let _ = stackCenterY {
                stackCenterY.isActive = false
            }
        }
        else {
            if let _ = stackTopSpacing {
                stackTopSpacing.isActive = false
            }
            
            if let _ = stackCenterY {
                stackCenterY.isActive = true
            }
        }
        nameLabel.text = item.itemTitle
        nameLabel.isHidden = !(item.itemTitle.isValidString())
        if let _ = nameStackView {
            nameStackView.isHidden = nameLabel.isHidden
        }
        if let imgURL = URL(string: item.itemImageUrl) {
            iconImgView.setImageFrom(url: imgURL, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
    }
    
    @IBAction private func itemButtonClicked(_ sender: UIButton) {
        guard let item = layoutItem else {
            return
        }
        shShowDot = false
        delegate?.didClickItem(item)
    }
}
