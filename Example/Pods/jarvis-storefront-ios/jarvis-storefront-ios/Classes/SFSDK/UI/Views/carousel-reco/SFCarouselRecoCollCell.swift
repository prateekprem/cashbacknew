//
//  SFRecoCollectionCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 28/01/20.
//

import UIKit


class SFCarouselRecoCollCell: SFBaseCollCell {
    
    private let singleLabelLine = 1
    
    @IBOutlet weak private var mContentView: UIView!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var subTitle: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var btn: UIButton!
    @IBOutlet weak private var imgWidth: NSLayoutConstraint!
    @IBOutlet weak private var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var subtitleWrapperView: UIView!
    
    
    var layout: SFLayoutViewInfo?
    private var item: SFLayoutItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        self.item = item
        super.show(item: item, cellConfig: cellConfig)
        backgroundColor = cellConfig.collectCellBackColor
        title.numberOfLines = singleLabelLine
        title.text = item.itemTitle
        btn.isUserInteractionEnabled = false
        if item.itemSubTitle.isEmpty {
            subtitleWrapperView.isHidden = true
        } else {
            subtitleWrapperView.isHidden = false
            subtitleWrapperView.layer.cornerRadius = 6
            subTitle.text = item.itemSubTitle
        }
        if let labelColor = item.labelColor {
            subTitle.textColor = UIColor(hex: labelColor)
        } else {
            subTitle.textColor = UIColor.white
        }
        
        let label = item.ctaLabel ?? ""
        btn.setTitle(label, for: UIControl.State.normal)
        if let imgUrl = URL(string: item.itemImageUrl) {
            self.imageView.setImageFrom(url: imgUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        } else {
            imageView.image = placeholderImage
        }
        makeImageCircular()
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
    }
    
    func makeImageCircular() {
        makeRounded(view: imageView, roundV: .custom(imgWidth.constant / 2), clr: UIColor(hex: "DDE5ED"), border: 0.8)
    }
}
