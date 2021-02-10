//
//  JRMCOLInProgressCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 15/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRMCOLInProgressCell: UITableViewCell {
    
    @IBOutlet weak var offerImageParentView: UIView!
    @IBOutlet weak var offerImageBackgroundView: UIImageView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var dotButton: UIButton!    
    @IBOutlet weak var successTxnLabel: UILabel!
    @IBOutlet weak var transactionsLeftLabel: UILabel!
    
    @IBOutlet weak var successTrxLblContainerView: UIStackView!
    @IBOutlet weak var activateBtnView: CashBackButtonView!
    @IBOutlet weak var activateBtnContainer: UIView!
    
    @IBOutlet weak var transactionLeftWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: JRMCOMyOfferViewModel?
    var model: JRCOMyOfferModel = JRCOMyOfferModel()
    weak var offerActivateDelegate :JRMCOActivateNewOfferVCDelegate?
    
    //Mark: Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        offerImageParentView.layer.cornerRadius = offerImageParentView.bounds.width/2
        offerImageParentView.layer.masksToBounds = true
        dotButton.layer.cornerRadius = dotButton.bounds.width / 2
        dotButton.layer.masksToBounds = true
        transactionsLeftLabel.layer.cornerRadius =  transactionsLeftLabel.bounds.height/2
        transactionsLeftLabel.layer.masksToBounds = true
    }
    
    //Mark: Public Methods
    func setDataInCell(viewModel:JRMCOMyOfferViewModel) {
        let campaignVM = viewModel.campaignViewModel
        
        self.viewModel = viewModel
        
        if let imageUrl = URL(string: campaignVM.offer_icon_override_url) {
            offerImageView.jr_setImage(with: imageUrl)
        } else {
            offerImageView.image = UIImage.imageWith(name: "offers_placeholder")
        }
        
        model.stage_txn_count = viewModel.total_txn_count
        model.total_txn_count = viewModel.success_txn_count
        
        titleLabel.text     =  campaignVM.getCampaignTitleText()
        
        progressView.isHidden                   = model.stage_txn_count <= 10
        collectionView.isHidden                 = model.stage_txn_count > 10
        transactionsLeftLabel.isHidden          = model.stage_txn_count <= 10
        transactionLeftWidthConstant.constant   = 0.0
        
        progressView.progress       = viewModel.getProgressValue()
        successTxnLabel.text        = viewModel.success_txn_text
        transactionsLeftLabel.text  = viewModel.getTransactionsLeftText()
        
        if viewModel.game_status_enum == .initialized {
            activateBtnContainer.isHidden = false
            subTitleLabel.text  = viewModel.initialized_offer_text
            successTrxLblContainerView.isHidden = true
            activateBtnView.delegate = self
            
            if JRCBManager.userMode == .Merchant {
                activateBtnView.renderButton(with: .bordered, title: "jr_pay_participate".localized, image: "icTick1", backgroundColor: .white, textColor: UIColor.cashbackSkyBlue, animationType: .animation, borderColor: UIColor.cashbackSkyBlue)
            } else {
                activateBtnView.renderButton(with: .bordered, title: "jr_pay_activateOffer".localized, image: "icTick1", backgroundColor: .white, textColor: UIColor.cashbackSkyBlue, animationType: .animation, borderColor: UIColor.cashbackSkyBlue)

            }
            
        } else {
            activateBtnContainer.isHidden = true
            successTrxLblContainerView.isHidden = false
            subTitleLabel.text  = viewModel.offer_progress_construct
        }
       
        self.collectionView.reloadData()
    }
}


extension JRMCOLInProgressCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.bounds.width/CGFloat(model.stage_txn_count) < 50.0{
            return Int(collectionView.bounds.width/50.0)
        }
        
        return model.stage_txn_count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JRCOLInProgressCollCell", for: indexPath) as? JRCOLInProgressCollCell else{return UICollectionViewCell()}
        cell.indexPath = indexPath
        
        let shLeft: Bool = collectionView.bounds.width/CGFloat(model.stage_txn_count) < 50.0 && indexPath.row == Int(collectionView.bounds.width/50.0) - 1
        
        cell.setupCell(model: model, showTransactionLeftLabel: shLeft)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: collectionView.bounds.height)
    }
}

extension JRMCOLInProgressCell: CashBackButtonViewProtocol {
    
    func flatButtonTapped(tag: Int) {}
    
    func borderedAnimatedButtonTapped(tag: Int) {
        let gameId = viewModel?.offer_id ?? ""
        if gameId == "" { return }
        
        JRCBLandingMerchantVModel.activateMerchantNewOffers(merchantType: .myOffer, id: gameId) { [weak self] (responseVM, success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.offerActivateDelegate?.campaignSucceessFullyActivated(responseVM)
                    
                } else {
                    if let error = error {
                        JRAlertPresenter.shared.presentSnackBar(title: error.localizedFailureReason, message: error.localizedDescription, autoDismiss: true, actions: nil, dismissHandler: nil)
                        return
                    }
                }
            }
        }
    }
}
