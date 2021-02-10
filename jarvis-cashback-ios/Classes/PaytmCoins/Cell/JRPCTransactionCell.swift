//
//  JRPPTransactionCell.swift
//  Jarvis
//
//  Created by Pankaj Singh on 30/12/19.
//

import UIKit

class JRPCTransactionCell: UITableViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var transactionImageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var closingBalanceLbl: UILabel!
    @IBOutlet weak var sepatorLeadingConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        imageContainer.roundCorner(1.0, borderColor: UIColor.colorRGB(232, g: 241, b: 244, a: 1.0), rad: 25.0)
        imageContainer.backgroundColor = UIColor.clear
        sepatorLeadingConstrain.constant = 83.0
    }
    
    func setData(isLastCell: Bool = false, model: JRPPLoyaltyPoint) {
        imageContainer.roundCorner(1.0, borderColor: UIColor.colorRGB(232, g: 241, b: 244, a: 1.0), rad: 24.0)
        imageContainer.backgroundColor = UIColor.clear
        let sepatorLeadingConstrainValue = isLastCell ? 0 : 83.0
        sepatorLeadingConstrain.constant = CGFloat(sepatorLeadingConstrainValue)
        self.timeLbl.text = model.dateStringInfo?.time
        switch model.accountingType {
        case JRPCAccountingType.CREDIT.rawValue:
            self.pointsLbl.textColor = UIColor(red: 33/255.0, green: 193/255.0, blue: 122/255.0, alpha: 1)
            self.pointsLbl.text = "+ \(JRPCUtilities.generateFormattedStringWithSeparator(model.accountingAmount?.value))"
        case JRPCAccountingType.DEBIT.rawValue:
            self.pointsLbl.textColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
            self.pointsLbl.text = "- \(JRPCUtilities.generateFormattedStringWithSeparator(model.accountingAmount?.value))"
        default:
            self.pointsLbl.text = "\(JRPCUtilities.generateFormattedStringWithSeparator(model.accountingAmount?.value))"
        }
        self.closingBalanceLbl.text = String(format: "jr_pp_kclosingbalance".localized, (JRPCUtilities.generateFormattedStringWithSeparator(model.activeBalance?.value)))
        if let imageUrl = model.extendedInfo?.offerIconImage, let url = URL(string: imageUrl) {
            transactionImageVw.jr_setImage(with: url, placeholderImage: nil)
        } else {
            transactionImageVw.image = UIImage.imageWith(name: "ic_Star_point")
        }
        var defaultText: String!
        switch model.transactionType {
        case JRPCTransactionType.REFUND.rawValue:
            defaultText = "jr_pc_coins_refunded".localized
        case JRPCTransactionType.PAY.rawValue:
            defaultText = "jr_pc_coins_redeemed".localized
        case JRPCTransactionType.REWARD.rawValue:
            defaultText = "jr_pc_coins_received".localized
        default:
            defaultText = "jr_pc_coins_received".localized
        }
        if let displayTitle = model.extendedInfo?.displayName, displayTitle.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.titleLbl.text = displayTitle
        } else {
            self.titleLbl.text = defaultText
        }
    }
    
}

// MARK: - JRPCTransactionDateCell
class JRPCTransactionDateCell : UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func setData(date: String) {
        self.dateLabel.text = date
        let mDate  = date.dateIn(formate: .ddmmmYY)
        if NSCalendar.current.isDateInToday(mDate) {
            self.dateLabel.text = "\("jr_pc_today".localized), " + date
            
        } else if NSCalendar.current.isDateInYesterday(mDate) {
            self.dateLabel.text = "\("jr_pc_yesterday".localized), " + date
            
        } else {
            self.dateLabel.text = date
        }
    }
    
}

