//
//  JRPPTransactionDetailVC.swift
//  Pods
//
//  Created by Pankaj Singh on 31/12/19.
//

import UIKit

class JRPCTransactionDetailVC: JRPCBaseViewController {
    
    @IBOutlet weak var inYourImageContainer: UIView!
    @IBOutlet weak var forImageContainer: UIView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var issuedByLabel: UILabel!
    @IBOutlet weak var inYourImageView: UIImageView!
    @IBOutlet weak var inYourTitleLabel: UILabel!
    @IBOutlet weak var inYourLabel: UILabel!
    @IBOutlet weak var forImageView: UIImageView!
    @IBOutlet weak var forTitleLabel: UILabel!
    @IBOutlet weak var forLabel: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var expiryBottomConstrain: NSLayoutConstraint!
    
    var model: JRPPLoyaltyPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavBarHidden = true
        setupView()
    }
    
    
    private func setupView() {
        switch model.transactionType {
        case JRPCTransactionType.REFUND.rawValue:
            self.titleLabel.text = "jr_pc_coins_refunded".localized
        case JRPCTransactionType.PAY.rawValue:
            self.titleLabel.text = "jr_pc_coins_redeemed".localized
        case JRPCTransactionType.REWARD.rawValue:
            self.titleLabel.text = "jr_pc_coins_received".localized
        default:
            self.titleLabel.text = "jr_pc_coins_received".localized
        }
        self.coinsLabel.text = "\(JRPCUtilities.generateFormattedStringWithSeparator(model.accountingAmount?.value))"
        let closingBalance = String(format: "jr_pp_kclosingbalance".localized, (JRPCUtilities.generateFormattedStringWithSeparator(model.activeBalance?.value)))
        if let dateInfo = model.dateStringInfo {
            self.dateLbl.text = "\(dateInfo.date), \(dateInfo.time) | \(closingBalance)"
        } else {
            self.dateLbl.text = closingBalance
        }
        if let orderId = model.orderID {
            orderIdLabel.text = String(format: "jr_pp_order_id".localized, orderId)
        } else {
            orderIdLabel.text = ""
        }
        if let expiryDate = model.expiryTime, let date = JRPCUtilities.change(dateString: expiryDate, outputFormat: "d MMM yyyy") {
            self.expiryLabel.text = String(format: "jr_pc_expiry_date".localized, date)
            expiryBottomConstrain.constant = 2
        } else {
            self.expiryLabel.text = ""
            expiryBottomConstrain.constant = 0
        }
        
        if model.accountingType == JRPCAccountingType.DEBIT.rawValue {
            inYourLabel.text = "jr_pc_from".localized
        }
        
        if let offerText = model.extendedInfo?.offerName, offerText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            forTitleLabel.text = offerText
            forLabel.text = "jr_pc_for".localized
        } else {
            if model.accountingType == JRPCAccountingType.DEBIT.rawValue {
                forTitleLabel.text = "jr_pc_gift_vocher".localized
                forLabel.text = "jr_pc_for".localized
            } else {
                forTitleLabel.text = "jr_pc_paytm".localized
                forLabel.text = "jr_pc_from".localized
            }
        }
        
        if let imageUrl = model.extendedInfo?.offerIconImage, let url = URL(string: imageUrl) {
            forImageView.jr_setImage(with: url, placeholderImage: nil)
        } else {
            forImageView.image = UIImage.imageWith(name: "ic_Star_point")
        }
        
        inYourImageContainer.roundCorner(1.0, borderColor: UIColor.colorRGB(232, g: 241, b: 244, a: 1.0), rad: 25.0)
        inYourImageContainer.backgroundColor = UIColor.clear
        
        forImageContainer.roundCorner(1.0, borderColor: UIColor.colorRGB(232, g: 241, b: 244, a: 1.0), rad: 25.0)
        forImageContainer.backgroundColor = UIColor.clear
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        let activityItem: [AnyObject] = [UIImage.imageFromView(self.view) as AnyObject]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
        
    }
    
}
