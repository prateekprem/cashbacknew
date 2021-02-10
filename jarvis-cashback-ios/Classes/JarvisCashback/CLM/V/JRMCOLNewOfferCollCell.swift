//
//  JRMCOLNewOfferCollCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 18/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

protocol JRMCOActivateNewOfferCellDelegate: class {
    func activateBtnTapped(_ viewModel:JRMCOMyOfferViewModel)
}

class JRMCOLNewOfferCollCell: UICollectionViewCell {    
    @IBOutlet weak var parentView : UIView!
    @IBOutlet weak var activateButton : UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var offerImageView: UIImageView!
    
    @IBOutlet weak var offerImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var offerImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var offerImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var offerImageViewRight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var btnActivateAnimationView : UIView!
    @IBOutlet weak var btnActivateAnimationImage : UIImageView!
    @IBOutlet weak var btnActivateAnimationLabel : UILabel!
    
    @IBOutlet weak var multiStageView : UIView!
    @IBOutlet weak var multiStageIcon : UIImageView!
    @IBOutlet weak var multiStageSurpriseText : UILabel!
    
    var indexPath : IndexPath?
    weak var delegate: JRMCOActivateNewOfferCellDelegate?
    var campaignId:Int?
    
    //MARK: Private Methods
    private func setupUI() {
        parentView.layer.cornerRadius = 6.0
        parentView.layer.masksToBounds = true
        activateButton.layer.cornerRadius = 3.0
        activateButton.layer.masksToBounds = true
        btnActivateAnimationView.layer.cornerRadius = 3.0
        btnActivateAnimationView.layer.masksToBounds = true
        btnActivateAnimationView.alpha = 0.0
        if JRCBManager.userMode == .Merchant {
            btnActivateAnimationLabel.text = "jr_pay_participated".localized
        } else {
            btnActivateAnimationLabel.text = "jr_pay_activatedOffer".localized
        }
    }
    
    private func showAnimationAfterApiSuccess(model:JRMCOMyOfferViewModel) {
        
        activateButton.isEnabled = false
        let animationView = JRCBLOTAnimation.animationActOfferSparcleBigButton.lotView
        let btnActivateFrame = activateButton.superview!.convert(activateButton.frame, to: self)
        animationView.frame = CGRect(x: btnActivateFrame.origin.x, y: btnActivateFrame.origin.y-btnActivateFrame.size.height, width: btnActivateFrame.size.width, height: btnActivateFrame.size.width)
        addSubview(animationView)
        btnActivateAnimationView.alpha = 0.0
        btnActivateAnimationImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: 0.40, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.btnActivateAnimationView.alpha = 1.0
            self.btnActivateAnimationImage.transform = .identity
        },completion:{(finish) in
        })
        
        animationView.play{ [weak self] (finished) in
            animationView.removeFromSuperview()
            DispatchQueue.main.async {
                self?.delegate?.activateBtnTapped(model)
            }
        }
    }
        
    //MARK: Public Methods
    func setupCell(model:JRMCONewOfferViewModel,indexPath:IndexPath) {
        let campaignModel = model.getMerchantCampaignVMData()
        campaignId = campaignModel.campId
        setupUI()
        self.indexPath = indexPath
        offerImageView.layer.cornerRadius = 0
        offerImageView.layer.masksToBounds  = false
        if campaignModel.isDeeplink {
            offerImageViewWidth.constant = 96
            offerImageViewHeight.constant = 96
            offerImageViewTop.constant = 10
            offerImageViewRight.constant = 10
            offerImageView.layer.cornerRadius = 0
            offerImageView.layer.masksToBounds  = false
            blurView.isHidden = true
        }
        else{
            offerImageViewWidth.constant = 48
            offerImageViewHeight.constant = 48
            offerImageViewTop.constant = 25
            offerImageViewRight.constant = 25
            offerImageView.layer.cornerRadius = 24
            offerImageView.layer.masksToBounds  = true
            blurView.isHidden = false
        }
        if let background_image_url = URL(string: campaignModel.background_image_url) {
            backgroundImageView.jr_setImage(with: background_image_url)
        }else{
            backgroundImageView.image = nil
        }
        if let new_offers_image_url = URL(string: campaignModel.new_offers_image_url) {
            offerImageView.jr_setImage(with: new_offers_image_url)
        }
        else{
            offerImageView.image = UIImage.imageWith(name: "offers_placeholder")
        }
        titleLabel.text = campaignModel.getCampaignTitleText()
        subTitleLabel.text = campaignModel.short_description
        
        if JRCBManager.userMode == .Merchant {
            activateButton.setTitle("jr_pay_participate".localized, for: .normal)
        } else {
            activateButton.setTitle("jr_pay_activateOffer".localized, for: .normal)
        }
        
    }
    
    //MARK: IBActions
    @IBAction func didTappedActivateButton(_ sender: Any) {
        guard let campaignId = campaignId else { return }
        JRCBLandingMerchantVModel.activateMerchantNewOffers(merchantType: .newOffer, id: String(campaignId)) { [weak self] (responseVM, success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.showAnimationAfterApiSuccess(model:responseVM)
                    JRCBNotificationName.notifMerchantOfferActivated.fireMeWith(userInfo: ["offer_id": responseVM.offer_id])
                }else{
                    if let error = error{
                        JRAlertPresenter.shared.presentSnackBar(title: error.localizedFailureReason, message: error.localizedDescription, autoDismiss: true, actions: nil, dismissHandler: nil)
                        return
                    }
                }
            }
        }
    }
}
