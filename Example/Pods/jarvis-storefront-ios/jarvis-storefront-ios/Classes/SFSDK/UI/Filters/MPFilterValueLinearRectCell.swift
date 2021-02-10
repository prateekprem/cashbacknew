//
//  MPFilterValueLinearRectCell.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 24/07/19.
//

import UIKit

class MPFilterValueLinearRectCell: UITableViewCell {
    
    @IBOutlet weak private var appliedIcon: UIImageView!
    @IBOutlet weak private var count: UILabel!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var colorLabel: UIImageView! {
        didSet {
            colorLabel.layer.cornerRadius = 4
            colorLabel.layer.masksToBounds = true
        }
    }
    
    func configureCell(value:SFFilterValue?){
        if let value = value {
            title.text = value.name
            colorLabel.image = nil
            if let filterCount = value.count, filterCount > 0  {
                count.text = String(describing: filterCount)
            }
            setCellSelectionState(selected: value.isSelected)
            if let color = value.colorCode {
                if color == "multicolor"{
                    colorLabel.setImageFromUrlPath("https://assetscdn1.paytm.com/dexter/weex/images/multi-color.jpg?placeholderRequired=false")
                } else {
                    colorLabel.backgroundColor = UIColor.colorWithHexString(color)
                }
                titleLeadingConstraint.constant = 50
            }else {
                colorLabel.backgroundColor = UIColor.clear
                titleLeadingConstraint.constant = 12
            }
        }
    }
    
    private func setCellSelectionState(selected:Bool){
        if selected {
            appliedIcon.image = UIImage.imageNamed(name: "enabledTick")
            title.font = UIFont.fontSemiBoldOf(size: 12)
            count.font = UIFont.fontSemiBoldOf(size: 12)
            title.textColor = UIColor.black
            count.textColor = UIColor.black
           
        }else {
            appliedIcon.image = UIImage.imageNamed(name: "disabledTick")
            title.font = UIFont.systemFont(ofSize: 12)
            count.font = UIFont.systemFont(ofSize: 12)
            title.textColor = UIColor(hex: "506D85")
            count.textColor = UIColor(hex: "506D85")
        }
    }

    override func prepareForReuse(){
        super.prepareForReuse()
        appliedIcon.image = UIImage.imageNamed(name: "disabledTick")
        title.text = ""
        count.text = ""
    }
}
