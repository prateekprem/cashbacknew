//
//  JRCBPointListTableCell.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 24/07/20.
//

import UIKit

 class JRCBPointListTableCell: UITableViewCell {
    @IBOutlet private weak var ttlLbl: UILabel!
    @IBOutlet private weak var leftIcnImgV: UIImageView!
    @IBOutlet private weak var valueLbl: UILabel!
    @IBOutlet private weak var dtLbl: UILabel!
    
    @IBOutlet private weak var rightImgW: NSLayoutConstraint!
    @IBOutlet private weak var rightImgV: UIImageView!
    
     class var cellId: String { return "kJRCBPointListTableCell" }
     
    func show(info: JRCBPointListInfo) {
        ttlLbl.text = info.title
        valueLbl.text = info.valueStr
        dtLbl.text = info.cellDTime
        
        self.leftIcnImgV.jr_setImage(with: URL(string: info.offerIconImage),
                                     placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
                
        if info.rightIconImage.count > 0 {
            rightImgW.constant =  35
            rightImgV.jr_setImage(with: URL(string: info.rightIconImage),
                                  placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
        } else {
            rightImgW.constant = 0
        }
        
        self.layoutIfNeeded()
        if info.isPending {
            self.valueLbl.textColor = UIColor(hex: "FF9D00")
            self.dtLbl.textColor = UIColor(hex: "FF9D00")
            self.dtLbl.text = "Pending"
        } else {
            self.valueLbl.textColor = UIColor(hex: "21C17A")
            self.dtLbl.textColor = UIColor(hex: "8BA6C1")
        }
    }
 }
