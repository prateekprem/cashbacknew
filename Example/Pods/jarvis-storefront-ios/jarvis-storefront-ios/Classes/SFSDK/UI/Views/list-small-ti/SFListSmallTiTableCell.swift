//
//  SFSmallListViewTableCell.swift
//  Bolts
//
//  Created by Rajat Kasliwal on 04/02/20.
//

import UIKit

class SFListSmallTiTableCell: SFBaseTableCell {
    @IBOutlet weak private var iconImageView  : UIImageView!
    @IBOutlet weak private var nameLabel : UILabel!
    @IBOutlet weak private var subTitleLabelNew : UILabel!
    @IBOutlet weak private var rightImageView: UIImageView!
    @IBOutlet weak private var icnW: NSLayoutConstraint!
    
    @IBOutlet weak private var tagContainerView: UIView!
    @IBOutlet weak private var tagLabelView: UIView!
    @IBOutlet weak private var tagLabel: UILabel!
    
    @IBOutlet weak private var titleStackView: UIStackView!
    @IBOutlet weak private var titleIconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var separatorView: UIView!
    
    override public class func register(table: UITableView) {
        if let mNib = SFListSmallTiTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFListSmallTiTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "SFListSmallTiTableCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFListSmallTiTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagLabelView.makeRoundedBorder(withCornerRadius: 3.0)
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if let mLayout = self.layout {
            let item =  mLayout.vItems[indexPath.row]
            let titleText = item.itemName
            nameLabel.text = titleText
            nameLabel.isAccessibilityElement = true
            nameLabel.accessibilityLabel = titleText
            if let imgUrl = URL(string: item.itemImageUrl) {
                iconImageView.setImageFrom(url: imgUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
                }
            }
            else {
                iconImageView.image = nil
            }
            
            if let imgUrl = URL(string: mLayout.vImageUrl), item.itemUrl.isValidString(), let _ = URL(string: item.itemUrl) {
                rightImageView.isHidden = false
                rightImageView.setImageFrom(url: imgUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
                }
            }
            else {
                rightImageView.isHidden = true
            }
            
            if let mFnt = info.cellPresentInfo.titleFont {
                nameLabel.font = mFnt
            }
            
            if let sizeString: String = info.iconContainerSize, let containerSize = Int(sizeString) {
                icnW.constant = CGFloat(containerSize)
            }
            else if let ww = info.cellPresentInfo.iconHW {
                icnW.constant = ww
            }
            else {
                icnW.constant = 32
            }
            let subTitle = item.itemSubTitle
            subTitleLabelNew.text = subTitle
            subTitleLabelNew.isAccessibilityElement = true
            subTitleLabelNew.accessibilityLabel = subTitle
            
            if let labelString = item.layoutLabel, labelString.isValidString() {
                tagContainerView.isHidden = false
                tagLabel.text = labelString
                if let textColor = item.layoutLabelColor, textColor.isValidString() {
                    tagLabel.textColor = UIColor.colorWithHexString(textColor)
                }
                else {
                    tagLabel.textColor = UIColor.black
                }
                
                if let labelBGColor = item.layoutLabelBG, labelBGColor.isValidString() {
                    tagLabelView.backgroundColor = UIColor.colorWithHexString(labelBGColor)
                }
                else {
                    tagLabelView.backgroundColor = UIColor.colorWithHexString("FFD766")
                }
            }
            else {
                tagContainerView.isHidden = true
                tagLabel.text = nil
            }
            
            if let altImageUrl = item.altImageUrl, let imgUrl = URL(string: altImageUrl) {
                titleIconImageView.setImageFrom(url: imgUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
                }
            }
            titleLabel.text = item.itemTitle
            
            let isAltImageValid: Bool = item.altImageUrl != nil && item.altImageUrl!.isValidString()
            let isTitleValid: Bool = item.itemTitle.isValidString()
            titleStackView.isHidden = !(isAltImageValid || isTitleValid)
            titleIconImageView.isHidden = !isAltImageValid
            
            separatorView.isHidden = item.isLastItem
            logImpressionForItem(item: item)
        }
        addBorderSupport(info: info)
    }
    
    private func addBorderSupport(info: SFLayoutViewInfo) {
        if let bgColor = info.metaLayoutInfo?.bgColor, !bgColor.isEmpty {
            contentView.backgroundColor = UIColor.colorWithHexString(bgColor)
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    
    @IBAction func tableRowButtonClick(_ sender: UIButton) {
        guard let indexPath = indexPath, let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfSDKDidClick(item: mLayout.vItems[indexPath.row],viewInfo:mLayout, tableIndex: indexPath.section, collectIndex: indexPath.row)
    }
}
