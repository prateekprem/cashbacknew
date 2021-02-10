//
//  JRMCOLCompletedCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 15/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit


class JRMCOLCompletedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var offerImageParentView: UIView!
    @IBOutlet weak var offerImageBackgroundView: UIImageView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var separatorLine : UIView!
    @IBOutlet weak var statusTagLabel: EdgeInsetLabel!
    
    //Mark: Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        offerImageParentView.layer.cornerRadius = offerImageParentView.bounds.width/2
        offerImageParentView.layer.masksToBounds = true
    }
    
    //Mark: Private Methods
    private func setup() {
        selectionStyle = .none
        statusTagLabel.layer.cornerRadius =  statusTagLabel.bounds.height/2
        statusTagLabel.layer.masksToBounds = true
        statusTagLabel.layer.borderWidth = 1.0
    }
    
    private func setDefaultStatusTagStyle(viewModel:JRMCOMyOfferViewModel) {
        let status = viewModel.game_status_enum
        switch status {
        case .completed:
            statusTagLabel.text = getStatusTitleForGameCompletedCell(viewModel:viewModel)
            subTitleLabel.text = viewModel.game_gratification_message
            statusTagLabel.layer.borderColor = UIColor(red:9/255 , green: 172/255, blue: 99/255, alpha: 1.0).cgColor
            statusTagLabel.textColor = UIColor(red:9/255 , green: 172/255, blue: 99/255, alpha: 1.0)
            break
        case .expired, .offerExpired:
            statusTagLabel.text = "  \("jr_pay_offerExpired".localized)  "
            subTitleLabel.text = String(format: "jr_pay_offerExpiredOn".localized,
                                            viewModel.game_expiry.getFormattedDateString("dd MMM yy"))
                statusTagLabel.layer.borderColor = UIColor(red:153/255 , green: 153/255, blue: 153/255, alpha: 1.0).cgColor
                statusTagLabel.textColor = UIColor(red:153/255 , green: 153/255, blue: 153/255, alpha: 1.0)
            break
        default:
            break
        }
    }
    
    private func getStatusTitleForGameCompletedCell(viewModel:JRMCOMyOfferViewModel) -> String {
        let stageVMArray = viewModel.stagesVM
        var titleText = "  \("jr_co_cashback_pending".localized)  "
        
        for stageVM in stageVMArray {
            let taskVMArray = stageVM.tasksVM
            let isCashbackEarned = taskVMArray.contains {$0.gratification_processed == true}
            if isCashbackEarned {
                titleText = "  \("jr_co_cashback_earned".localized)  "
                break
            }
        }
        return titleText
    }
    
    //Mark: Public Methods
    func setDataInCell(viewModel:JRMCOMyOfferViewModel) {
        setDefaultStatusTagStyle(viewModel: viewModel)
        let campaignVM = viewModel.campaignViewModel
        
        if let imageUrl = URL(string: campaignVM.offer_icon_override_url) {
            offerImageView.jr_setImage(with: imageUrl)
            
        } else {
            offerImageView.image = UIImage.imageWith(name: "offers_placeholder")
        }
        titleLabel.text =  campaignVM.getCampaignTitleText()
    }
}
