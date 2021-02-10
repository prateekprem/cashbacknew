//
//  JRMCOPaymentDetailCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 22/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRMCOPaymentDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var statusButtonHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        statusButton.layer.borderWidth = 1.0
        statusButton.layer.borderColor = UIColor(red: 250.0/255, green: 94.0/255, blue: 96.0/255, alpha: 1.0).cgColor
        statusButton.layer.cornerRadius = 2.0
    }
    
    private func setStatusButtonHidden(state: Bool) {
        statusButton.isHidden = state
        if state {
            statusButtonHeightConstraint.constant = 0
        }else {
            statusButtonHeightConstraint.constant = 30
        }
    }
    
    // MARK: Public Methods
    func setDataInCell(info: JRMCBTransactionInfo) {
        titleLabel.text = "₹\(info.transAmount)"
        timeLabel.text = info.transTime.getFormattedDateString("d MMM yyyy, h:mm a")
        mobileNumberLabel.text = info.userMobileNo
        let txnState = (info.status == "Success") ? true : false
        setStatusButtonHidden(state: txnState)
        layoutIfNeeded()
    }
}
