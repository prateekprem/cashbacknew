//
//  JRMCOActivateNewOfferCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 13/03/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

protocol ActivateNewMerchantOfferCellProtocol : NSObjectProtocol {
    func didTapMerchantViewMoreButton()
    func hitActivateMerchantOfferApi(completion: @escaping (JRMCOMyOfferViewModel,Bool,NSError?) -> Void)
    func campaignSuccessfullyActivated(_ model:JRMCOMyOfferViewModel)
}

class JRMCOActivateNewOfferDetailsCell: UITableViewCell {
    
    @IBOutlet weak var offerDetailsLbl: UILabel!
    @IBOutlet weak var multiStageTitle: UILabel!
    
    private var isRoundedCorner : Bool = false
    
    func setupCell(_ viewModel:JRMCOActivateOfferVM, row : Int) {
        if row == 0 {
            isRoundedCorner = true
        }
        
        offerDetailsLbl.setHTMLText(html:viewModel.offerLabelTxt)
        multiStageTitle.text = viewModel.multiStageTitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRoundedCorner {
            self.roundCorners([.topLeft,.topRight], radius: 6.0)
        }
        self.contentView.layoutIfNeeded()
    }
}

class JRMCOActivateNewOfferClockCell: UITableViewCell {
    
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var clockImageView : UIImageView!
    @IBOutlet weak var clockView: UIView!
    private var isRoundedCorner : Bool = false
    
    func setupCell(_ viewModel:JRMCOActivateOfferVM, row : Int) {
        if row == 0 {
            isRoundedCorner = true
        }
        
        clockImageView.image = UIImage.imageWith(name: viewModel.clockImage)
        
        if viewModel.merchantOfferType == .newOffer {
            validityLabel.textColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1.0)
        } else {
            validityLabel.textColor = UIColor.cashbackYellow
        }
        
        validityLabel.text = viewModel.validityLabelText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRoundedCorner {
            self.roundCorners([.topLeft,.topRight], radius: 6.0)
        }
        self.contentView.layoutIfNeeded()
    }
}

class JRMCOActivateNewOfferButtonCell: UITableViewCell {
    
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var btnDeepLinkAfterAnimation:UIButton!
    @IBOutlet weak var btnActivateAnimationView:UIView!
    @IBOutlet weak var btnActivateAnimationImage:UIImageView!
    @IBOutlet weak var btnActivateAnimationLabel:UILabel!
    @IBOutlet weak var offUsTransactionLabel:UILabel!
    @IBOutlet weak var btnActivateHeight: NSLayoutConstraint!
    
    weak var delegate: ActivateNewMerchantOfferCellProtocol?
    private var isRoundedCorner : Bool = false
    private var merchantOfferType: MerchantOfferType = .newOffer
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRoundedCorner {
            self.roundCorners([.topLeft,.topRight], radius: 6.0)
        }
        self.contentView.layoutIfNeeded()
    }
    
    func setupCell(_ viewModel:JRMCOActivateOfferVM, row : Int) {
        if row == 0 {
            isRoundedCorner = true
        }
        merchantOfferType = viewModel.merchantOfferType
        btnActivate.layer.masksToBounds = true
        btnActivate.layer.cornerRadius = 3.0
        btnActivate.setTitle(viewModel.activateBtnTxt, for: .normal)
        btnDeepLinkAfterAnimation.layer.cornerRadius = 3.0
        btnDeepLinkAfterAnimation.layer.masksToBounds = true
        btnActivateAnimationLabel.text = viewModel.activateBtnAnimationLblTxt
        offUsTransactionLabel.text = viewModel.offusTxnLblText
        btnActivateAnimationView.alpha = 0.0
        btnDeepLinkAfterAnimation.isHidden = true
        btnActivateAnimationView.alpha = 0.0
        btnActivateHeight.constant = 55
    }
    
    private func showAnimationAfterApiSuccess(model:JRMCOMyOfferViewModel) {
        JRCBAnalytics(screen: .screen_CashbackOfferActiveteNewOffer).track()
        btnActivate.isEnabled = false
        let animationView = JRCBLOTAnimation.animationActOfferSparcleBigButton.lotView
        let btnActivateFrame = btnActivate.superview!.convert(btnActivate.frame, to: self)
        animationView.frame = CGRect(x: btnActivateFrame.origin.x, y: btnActivateFrame.origin.y-btnActivateFrame.size.height, width: btnActivateFrame.size.width, height: btnActivateFrame.size.width)
        self.addSubview(animationView)
        btnActivateAnimationView.alpha = 0.0
        btnActivateAnimationImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: 0.40, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.btnActivateAnimationView.alpha = 1.0
            self.btnActivateAnimationImage.transform = .identity
        },completion:{(finish) in
        })
        
        animationView.play{ (finished) in
            animationView.removeFromSuperview()
            UIView.animate(withDuration: 0.4, animations: {
                self.setUpOffUsTransactionLbl(isFromAfterSuccess:true, viewModel:model)
                self.delegate?.campaignSuccessfullyActivated(model)
            })
        }
    }
    
    private func setUpOffUsTransactionLbl(isFromAfterSuccess : Bool, viewModel:JRMCOMyOfferViewModel){
        offUsTransactionLabel.text = ""
        btnActivate.isHidden = true
        btnDeepLinkAfterAnimation.isHidden = true
        btnActivateHeight.constant = 0
        btnActivateAnimationView.isHidden = true
    }
    
    @IBAction func didTappedActivateButton(_ sender: Any) {
        self.delegate?.hitActivateMerchantOfferApi(completion: { [weak self] (model,success, error) in
            self?.showAnimationAfterApiSuccess(model: model)
        })
    }
}

// ========================================================================
class JRMCOActivateNewOfferFooter: UIView  {
    @IBOutlet weak var tncLabel: UILabel!
    @IBOutlet weak var tncHeadingLabel: UILabel!
    weak var delegate: ActivateNewMerchantOfferCellProtocol?
    
    func setupCell(_ viewModel:JRMCOActivateOfferVM) {

        tncHeadingLabel.text = viewModel.tncHeadingTxt
        tncLabel.setHTMLTextOnActivate(html: viewModel.tncLabelTxt)
    }
    
    @IBAction func didTapViewMoreButton(_ sender: UIButton) {
        self.delegate?.didTapMerchantViewMoreButton()
    }
}

// ========================================================================
class JRMCOActivateNewOfferHeader: UIView {
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerSubtitle: UILabel!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var offerImageViewHeight: NSLayoutConstraint!
    
    func setupCell(_ viewModel:JRMCOActivateOfferVM) {
        
        headerTitle.text = viewModel.headerTitle
        headerSubtitle.text = viewModel.headerSubTitle
        if viewModel.isDeeplink {
            offerImageViewWidth.constant = 96
            offerImageViewHeight.constant = 96
            offerImageView.layer.cornerRadius = 0
        }
        else{
            offerImageViewWidth.constant = 72
            offerImageViewHeight.constant = 72
            offerImageView.layer.cornerRadius = 16
        }
        offerImageView.clipsToBounds = true
        
        if let imageUrl = URL(string: viewModel.offerImage) {
            offerImageView.jr_setImage(with: imageUrl)
        } else {
            offerImageView.image = UIImage.imageWith(name: "offers_placeholder")
        }
    }
}


class JRMCOActivateNewOfferStageCell: UITableViewCell {
    
    @IBOutlet weak var offerInitialisedTitle: UILabel!
    @IBOutlet weak var multiStageIcon: UIImageView!
    @IBOutlet weak var stageLbl: UILabel!
    
    private var isRoundedCorner : Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupCell(_ viewModel:JRMCOActivateOfferVM, row : Int) {
        if row == 0 {
            isRoundedCorner = true
        }
        offerInitialisedTitle.text = viewModel.activateOfferTitleTxt
        stageLbl.text = viewModel.stageLblText
        multiStageIcon.image = UIImage.imageWith(name:viewModel.multiStageIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRoundedCorner {
            self.roundCorners([.topLeft,.topRight], radius: 6.0)
        }
        self.contentView.layoutIfNeeded()
    }
}
