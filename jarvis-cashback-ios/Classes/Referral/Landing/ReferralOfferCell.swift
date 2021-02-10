//
//  ReferralCell.swift
//  FBSDKCoreKit
//
//  Created by Abhishek Tripathi on 27/07/20.
//

import UIKit

protocol ReferralOfferCellDelegate: ReferralLandingProtocol  {
   func didselectInvite(info: JRCBCampaign)
}


class ReferralOfferCell: UITableViewCell, ReferralTableCells {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ctaBtn: UIButton!
    
    weak var delegate: ReferralOfferCellDelegate?
    var viewModel: ReferralOffersCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        ctaBtn.layer.cornerRadius = ctaBtn.frame.height/2
        ctaBtn.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(viewModel: ReffralViewModel, _ deleage: ReferralLandingProtocol) {
        if let deleage = deleage as? ReferralOfferCellDelegate {
            self.delegate = deleage
        }
        if let cellVM = viewModel as? ReferralOffersCellViewModel {
            self.viewModel = cellVM
            titleLabel.text = cellVM.title
            descriptionLabel.text = cellVM.subTitle
             self.offerImage.jr_setImage(with: URL(string: cellVM.offerImage))
             self.backGroundImage.jr_setImage(with: URL(string: cellVM.backGroundImageUrl))
            ctaBtn.setTitle("Invite", for: .normal)
         }
    }
    
    
    @IBAction func tapToInvite(_ sender: UIButton) {
        self.delegate?.didselectInvite(info: self.viewModel.campaign)
    }
}

