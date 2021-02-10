//
//  JRCBGameDetailsTVC.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/01/20.
//

import UIKit

protocol JRCBGameDetailsTVCDelegate: class {
    func cbGmDetailTVCCtaClicked()
    func cbGmDetailTVCDetailsBtnClicked()
}

extension JRCBGameDetailsTVCDelegate {
    func cbGmDetailTVCCtaClicked() {}
    func cbGmDetailTVCDetailsBtnClicked() {}
}


class JRCBGameDetailsTVC: UITableViewCell {
    weak var delegate: JRCBGameDetailsTVCDelegate?
    var backGroundImage: String?

    static var identifier: String { return String(describing: self) }
    
    func loadData(data: JRCBPostTrnsactionData) { }
    func loadData(data: JRCBCampaign) { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - JRCBGameDetailsTVCOne
class JRCBGameDetailsTVCOne: JRCBGameDetailsTVC {
    @IBOutlet weak var scratchBkView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var logoImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scratchBkView.roundedCorners(radius: 16.0)
        logoImgV.circular(1.0, UIColor.white, true)
    }
    
    override func loadData(data: JRCBCampaign) {
        let gameCardConfig = kScratchImageConfigEnum.getActiveGameInfo
        self.scratchBkView.backgroundColor = gameCardConfig().getScratchColors().upper
        self.titleLabel.text = data.offer_text_override
        self.subTitleLabel.text = data.short_description
        self.logoImgV?.jr_setImage(with: URL(string: data.new_offers_image_url), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
        self.layoutIfNeeded()
        logoImgV.circular(1.0, UIColor.white, true)
    }
    
    override func loadData(data: JRCBPostTrnsactionData) {
        self.layoutIfNeeded()
        let gameCardConfig = kScratchImageConfigEnum.getActiveGameInfo
        self.scratchBkView.backgroundColor = gameCardConfig().getScratchColors().upper
        
        if let campaign = data.mCampain {
            self.titleLabel.text = campaign.offer_text_override
            self.logoImgV?.jr_setImage(with: URL(string: campaign.new_offers_image_url), placeholderImage: UIImage.Grid.Placeholder.rewardsPlaceholder)
        }
        
        if let currentTrnsInfo = data.nextTransInfo, let currStage = currentTrnsInfo.stageObject {
            self.subTitleLabel.text = currStage.stage_progress_construct
            
        } else {
            self.subTitleLabel.text = data.unlockText
        }
        
        switch data.gameStatus {
        case .gmInitialized, .gmInProgress: break
            
        case .gmCompleted:
            subTitleLabel.text = "Game Completed"
        case .gmExpired:
            subTitleLabel.text = data.game_expiry_reason
        default:
            break
        }
        logoImgV.circular(1.0, UIColor.white, true)
        
    }
}


// MARK: - JRCBGameDetailsTVCTwo
class JRCBGameDetailsTVCTwo: JRCBGameDetailsTVC {
    @IBOutlet weak var gameProgressView: JRCBGameProgressView!
    @IBOutlet weak var btnTxnHistory: UIButton!
    @IBOutlet weak var txnHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var progressCollHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var txnTopConstant: NSLayoutConstraint!
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    
    @IBAction func btnTxnHistoryClicked(_ sender: Any) {
        
    }
    
    func hideTxnButton(isHidden: Bool) {
        btnTxnHistory.isHidden = isHidden
        if isHidden {
            txnHeightConstant.constant = 0
            txnTopConstant.constant = 0
            
        } else {
            txnHeightConstant.constant = 29
            txnTopConstant.constant = 17
        }
        self.setNeedsLayout()
    }
    
    override func loadData(data: JRCBPostTrnsactionData) {
        gameProgressView.show(model: data, maxWidth: self.bounds.width - 40, shouldShowIcon: true, firstItemWidth: Int(gameProgressView.bounds.height))
        widthConstant.constant = gameProgressView.getwidth()
        self.setNeedsLayout()
    }
}

// MARK: - JRCBGameDetailsTVCThree
class JRCBGameDetailsTVCThree: JRCBGameDetailsTVC {
    
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var ctaBtn: UIButton!
    @IBOutlet weak var detailsBtnTopConstant: NSLayoutConstraint!
    @IBOutlet weak var ctaTopConstant: NSLayoutConstraint!
    @IBOutlet weak var ctaHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var ctaView: UIView! {
        didSet {
            self.ctaView.roundedCorners(radius: 22.0)
        }
    }
    
    @IBAction func ctaBtnClicked(_ sender: Any) {
        self.delegate?.cbGmDetailTVCCtaClicked()
    }
    
    @IBAction func detailsBtnClicked(_ sender: Any) {
        delegate?.cbGmDetailTVCDetailsBtnClicked()
    }
    
    override func loadData(data: JRCBPostTrnsactionData) {
        setDetailsBtnTitle()
        if let campaign = data.mCampain {
            switch data.gameStatus {
            case .gmInitialized:
                self.setCTABtnTitleForCampaign(data: campaign)
            case .gmInProgress:
                if campaign.isDeeplink {
                    hideCTABtn(isHidden: false)
                    self.ctaBtn.setTitle(campaign.progress_screen_cta, for: .normal)
                } else {
                    hideCTABtn(isHidden: true)
                }
                
            default:
                self.hideCTABtn(isHidden: true)
            }
        }
    }
    
    override func loadData(data: JRCBCampaign) {
        self.setCTABtnTitleForCampaign(data: data)
        self.setDetailsBtnTitle()
    }
    
    private func setCTABtnTitleForCampaign(data: JRCBCampaign) {
        
        hideCTABtn(isHidden: false)

        if !data.auto_activate {
            if JRCBManager.userMode == .Merchant {
                self.ctaBtn.setTitle("jr_pay_participate".localized, for: .normal)
            } else {
                self.ctaBtn.setTitle("jr_pay_activateOffer".localized, for: .normal)
            }
        } else if data.isDeeplink {
            self.ctaBtn.setTitle(data.progress_screen_cta, for: .normal)
        } else {
            hideCTABtn(isHidden: true)
        }
    }
    
    private func setDetailsBtnTitle() {
        self.detailsBtn.isHidden = false
//        let detailTTl = "jr_CB_Details".localized + " " + ">"
//        self.detailsBtn.setTitle(detailTTl, for: .normal)
        self.detailsBtn.setAttributedTitle("jr_CB_Details".localized.getUnderlineAttrText(), for: .normal)
    }
    
    private func hideCTABtn(isHidden: Bool) {
        self.ctaView.isHidden = isHidden
        if isHidden {
            detailsBtnTopConstant.constant = 0
            ctaTopConstant.constant = 0
            ctaHeightConstant.constant = 0
            self.ctaBtn.setTitle("", for: .normal)

        } else {
            detailsBtnTopConstant.constant = 25
            ctaTopConstant.constant = 16
            ctaHeightConstant.constant = 44
        }
        self.setNeedsLayout()
    }
}
