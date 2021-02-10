//
//  JRCBScratctContentV.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 23/05/20.
//

import Foundation

protocol JRCBScratchContentVProtocol: class {
    func flipAnimationHandle(contentGratif: JRCBGratification)
}

// MARK: - SUPER VIEW
class JRCBScratchContentV: JRCBScratchableView {
    
    @IBOutlet weak var superContainerV: UIView!
    @IBOutlet weak var offerIconImageV: UIImageView!
    @IBOutlet weak var ctaBtnV: UIView?
    @IBOutlet weak var upperV: UIView!
    @IBOutlet weak var lowerV: UIView!
    @IBOutlet weak var postScratchConfetiImgV: UIImageView?
    
    var viewModel: JRCBScratchContentVM!
    weak var delegate: JRCBScratchContentVProtocol?
    
    class func cardWith(fr: CGRect, viewM: JRCBScratchContentVM) -> JRCBScratchContentV? {
        let cardIndex = viewM.cardType.getCardIndex()
        if cardIndex >= 0 {
            let vv =  UINib(nibName: "JRCBScratchCardContentV", bundle: Bundle.cbBundle).instantiate(withOwner: nil, options: nil)[cardIndex] as! JRCBScratchContentV
            vv.frame = fr
            vv.viewModel = viewM
            return vv
        }
        return nil
    }
    
    func refreshCardUI() {
        self.configureCard()
        if viewModel.canScratch {
            self.scratchDelegate = self
            let maskImage = JRCBScratchMaskV.maskWith(fr: self.frame, scratchDataVM: self.viewModel).getSnapshot()
            self.addScratchOverlay(contentV: self, maskImage: maskImage, maskColor: JRCBScratchConfigEnum.getPlaceholderConfig().getScratchColor())
        }
    }
    
    func configureCard() {
        ctaBtnV?.roundedCorners(radius: 16.0)
        if [JRCBCardType.deal, JRCBCardType.crosspromo] .contains(viewModel.cardType) {
            offerIconImageV.circular(0.5, borderColor: UIColor.white)
        }
        if !viewModel.logoImageURL.isEmpty {
            self.offerIconImageV.jr_setImage(with: URL(string: viewModel.logoImageURL), placeholderImage: viewModel.placeholderIcon)
        }
    }
    
    fileprivate func detailCtaBtnClicked() {
        if viewModel.cardType == .flipCard {
            flipCardAPI()
        } else if !viewModel.detailDeeplink.isEmpty {
            if viewModel.cardType == .cricketCard {
                self.performGAEventForCollectible()
            }
            JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(viewModel.detailDeeplink, isAwaitProcessing: false)
        }
    }
}

// MARK: - CASHBACK VIEW
// Cashback, Goldback, Deal, Voucher, Coin, Points Content
class JRCBScratchContCBV: JRCBScratchContentV {
    @IBOutlet weak var wonLbl: UILabel!
    @IBOutlet weak var prizeLbl: UILabel!
    @IBOutlet weak var frontendRedTLbl: UILabel!
    @IBOutlet weak var ctaBtn: UIButton!
    @IBOutlet weak var redemptionTextLbl: UILabel!
    
    @IBAction func ctaBtnClicked(_ sender: Any) {
        detailCtaBtnClicked()
    }
    
    override func configureCard() {
        super.configureCard()
        if viewModel.cardType == .deal || viewModel.cardType == .crosspromo {
            self.offerIconImageV.isHidden = false
        } else {
            self.offerIconImageV.isHidden = true
        }
        self.wonLbl.text = viewModel.wonText
        self.prizeLbl.text = viewModel.prizeText
        self.frontendRedTLbl.text = viewModel.frontRedText
        self.redemptionTextLbl.text = viewModel.redemptionText
        
        if !viewModel.detailBtnText.isEmpty {
            self.ctaBtnV?.isHidden = false
            self.ctaBtn.setTitle(viewModel.detailBtnText, for: .normal)
            self.ctaBtn.setTitle(viewModel.detailBtnText, for: .highlighted)
        } else {
            self.ctaBtnV?.isHidden = true
        }
        
        if viewModel.cardType == .coins {
            self.upperV.backgroundColor = UIColor.ScratchCard.Blue.scratchPointsBlue
            self.postScratchConfetiImgV?.image = UIImage.ScratchCard.ScratchIcon.postScratchPointsConfeti
            self.frontendRedTLbl.textColor = UIColor.ScratchCard.yellow.pointsLabel
            self.wonLbl.textColor = UIColor.white
        } else {
            self.upperV.backgroundColor = UIColor.ScratchCard.Blue.scratchCommonBlue
            self.postScratchConfetiImgV?.image = UIImage.ScratchCard.ScratchIcon.postScratchCommonConfeti
            self.frontendRedTLbl.textColor = UIColor.white
            self.wonLbl.textColor = UIColor.ScratchCard.Blue.scratchWonBlue
        }
        
    }
}

// MARK: - LOCKED VIEW
// Locked, Supercash game Content
class JRCBScratchContLockV: JRCBScratchContentV {
    
    @IBOutlet weak var wonLbl: UILabel!
    @IBOutlet weak var unlockTextLbl: UILabel!
    @IBOutlet weak var lockedV: UIView!
    @IBOutlet weak var luckyDrawV: UIView!
    @IBOutlet weak var ldConfetiImgV: UIImageView!
    @IBOutlet weak var ldAmtLbl: UILabel!
    @IBOutlet weak var offerImageBottomConst: NSLayoutConstraint!
    @IBOutlet weak var offerImgTopConst: NSLayoutConstraint!
    
    
    override func configureCard() {
        super.configureCard()
        self.wonLbl.text = viewModel.cardHeadlineText
        self.unlockTextLbl.text = viewModel.bannerText
        self.ldAmtLbl.attributedText = viewModel.luckyDrawAmountText
        
        var scratchMask = kScratchImageConfigEnum.getActiveGameInfo()
        if let mask = viewModel.getCardMaskConfig {
            scratchMask = mask
            self.offerIconImageV.image = scratchMask.getScratchMaskImages()
            offerImgTopConst.constant = 2.0
            offerImageBottomConst.constant = 2.0
        }
        else if viewModel.cardType == .superCashGame {
            offerImgTopConst.constant = 20.0
            offerImageBottomConst.constant = 20.0
        }
        self.luckyDrawV.isHidden = !viewModel.isLuckyDrawCard
        self.lockedV.isHidden = viewModel.isLuckyDrawCard
        
        self.upperV.backgroundColor = scratchMask.getScratchColors().upper
        self.lowerV.backgroundColor = scratchMask.getScratchColors().lower
        self.wonLbl.textColor = scratchMask.getFontColor()
        self.unlockTextLbl.textColor = scratchMask.getFontColor()
        self.ldAmtLbl.textColor = scratchMask.getFontColor()
        
        self.layoutIfNeeded()
    }
}

// MARK: - STICKER VIEW
// Collectible or Sticker Content
class JRCBScratchContStickerV: JRCBScratchContentV {
    
    @IBOutlet weak var wonLbl: UILabel!
    @IBOutlet weak var stickerTitleLbl: UILabel!
    @IBOutlet weak var stickerSubLbl: UILabel!
    @IBOutlet weak var redemptionLbl: UILabel!
    @IBOutlet weak var ctaBtn: UIButton!
    @IBAction func ctaBtnClicked(_ sender: Any) {
        detailCtaBtnClicked()
    }
    
    override func configureCard() {
        super.configureCard()
        self.wonLbl.text = viewModel.wonText
        self.stickerTitleLbl.text = viewModel.prizeText
        self.redemptionLbl.text = viewModel.redemptionText
        self.stickerSubLbl.text = viewModel.collectibleStickerText
        if !viewModel.detailBtnText.isEmpty {
            self.ctaBtnV?.isHidden = false
            self.ctaBtn.setTitle(viewModel.detailBtnText, for: .normal)
            self.ctaBtn.setTitle(viewModel.detailBtnText, for: .highlighted)
        } else {
            self.ctaBtnV?.isHidden = true
        }
    }
    
}

// MARK: - BLNT VIEW
// Better Luck Next Time or Flip View
class JRCBScratchContBlntV: JRCBScratchContentV {
    @IBOutlet weak var redemptionLbl: UILabel!
    @IBOutlet weak var ctaBtn: UIButton!
    @IBAction func ctaBtnClicked(_ sender: Any) {
        detailCtaBtnClicked()
    }
    
    override func configureCard() {
        super.configureCard()
        self.redemptionLbl.text = viewModel.redemptionText
        
        if !viewModel.detailBtnText.isEmpty {
            self.ctaBtnV?.isHidden = false
            self.ctaBtn.setTitle(viewModel.detailBtnText, for: .normal)
            self.ctaBtn.setTitle(viewModel.detailBtnText, for: .highlighted)
        } else {
            self.ctaBtnV?.isHidden = true
        }
    }
}

// MARK: - GA Event Handling
extension JRCBScratchContentV: JRCBScratchableViewProtocol {
    
    func scratchEnded() {
        if JRCBCommonBridge.isNetworkAvailable {
            self.performLottieAnimationAfterScratch()
            self.updateScratchCardAPI()
        } else {
            let ntwrkMsg = "jr_ac_noInternetMsg".localized
            JRAlertPresenter.shared.presentSnackBar(title: "", message: ntwrkMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
        }
        
    }
    
    private func performGAEventForScratching() {
        let screenName = viewModel.getAnalyticsScreen()
        let labels = [JRCBAnalyticsEventLabel.klabel1: viewModel.getCampaignId(),
                      JRCBAnalyticsEventLabel.klabel2: screenName.rawValue]
        
        JRCBAnalytics(screen: screenName, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_CashbackOffers, action: .act_ScratchCardScratched, labels: labels).track()
    }
    
    private func performGAEventForCollectible() {
        let screenName = viewModel.getAnalyticsScreen()
        let labelDict = [JRCBAnalyticsEventLabel.klabel1: viewModel.getCampaignId(),
                         JRCBAnalyticsEventLabel.klabel2: screenName.rawValue]
        JRCBAnalytics(screen: screenName, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_CashbackOffers, action: .act_CollectibleCtaClicked, labels: labelDict).track()
        
        if !viewModel.detailDeeplink.isEmpty {
            JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(viewModel.detailDeeplink, isAwaitProcessing: false)
        }
    }
    
    private func performLottieAnimationAfterScratch() {
        self.postScratchConfetiImgV?.isHidden = false
        let animationView = JRCBLOTAnimation.animationAfterScratch.lotView
        animationView.frame = self.upperV.bounds
        
        animationView.isUserInteractionEnabled = false
        animationView.contentMode = .scaleAspectFill
        
        self.upperV.addSubview(animationView)
        self.upperV.bringSubviewToFront(animationView)
        animationView.play()
    }
}

// MARK: - API HANDLING
extension JRCBScratchContentV {
    
    //Update Scratch Card API Handling
    private func updateScratchCardAPI() {
        
        let currentGratif = viewModel.getCurrentGratification()
        if let scratchData = currentGratif.redumptionInfo as? JRCBRedumptionScratchCard {
            scratchData.set(userScratched: true)
            scratchData.updateScratchCard { [weak self] (status, errMsg) in
                if !status {
                    DispatchQueue.main.async {
                        JRAlertPresenter.shared.presentSnackBar(title: "", message: errMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                    }
                } else {
                    self?.viewModel.updateWith(grtfInfo: currentGratif)
                    DispatchQueue.main.async {
                        self?.configureCard()
                        self?.performGAEventForScratching()
                    }
                }
            }
        }
    }
    
    private func flipCardAPI() {
        
        if let referenceId = viewModel.getFlipCardReferenceId() {
            ctaBtnV?.cbAddLoadingView()
            JRCBServices.fetchFlipResponse(refId: referenceId) {[weak self] (success, postData, errorStr) in
                DispatchQueue.main.async {
                    self?.ctaBtnV?.cbRemoveLoadingView()
                }
                
                if success, let postTxnData = postData {
                    if postTxnData.dataId.isEmpty {
                        let betterLuckGrtf = JRCBGratification(dict: [:])
                        self?.viewModel.updateWith(grtfInfo: betterLuckGrtf)
                        DispatchQueue.main.async {
                            self?.delegate?.flipAnimationHandle(contentGratif: betterLuckGrtf)
                        }
                    } else {
                        if let currTrns = postTxnData.currentTransInfo, let stageObj = currTrns.stageObject {
                            if stageObj.gratifications.count > 0 {
                                let firstGratification = stageObj.gratifications[0]
                                self?.viewModel.updateWith(grtfInfo: firstGratification)
                                DispatchQueue.main.async {
                                    self?.delegate?.flipAnimationHandle(contentGratif: firstGratification)
                                }
                            }
                            
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.ctaBtnV?.cbRemoveLoadingView()
                        let errorMsg = errorStr ?? JRCBConstants.Common.kDefaultErrorMsg
                        JRAlertPresenter.shared.presentSnackBar(title: "", message: errorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                    }
                }
            }
            
        } else {
            let errorMsg = JRCBConstants.Common.kDefaultErrorMsg
            JRAlertPresenter.shared.presentSnackBar(title: "", message: errorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
        }
    }
}


// MARK: - Scratchable Protocols
protocol JRCBScratchableViewProtocol: class {
    func scratchEnded()
}

class JRCBScratchableView: UIView, ScratchUIViewDelegate {

    fileprivate(set) var scratchCard: ScratchUIView?
    weak var scratchDelegate: JRCBScratchableViewProtocol?
    
    func addScratchOverlay(contentV: UIView = UIView(), maskImage: UIImage, maskColor: UIColor) {
        let myImg = contentV.image()
        self.scratchCard = ScratchUIView(frame: contentV.bounds, Coupon: myImg, MaskImage: maskImage, MaskColor: maskColor, ScratchWidth: CGFloat(JRCBConstants.ScractchCard.kScratchLineWidth))
        //scratchCard?.roundedCorners(radius: self.layer.cornerRadius)
        scratchCard?.delegate = self
        scratchCard?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let card = scratchCard {
            contentV.addSubview(card)
            contentV.bringSubviewToFront(card)
        }
        self.scratchCard?.roundedCorners(radius: 16.0)
    }
    
    func scratchBegan(_ view: ScratchUIView) { }
    func scratchMoved(_ view: ScratchUIView) { }

    func scratchEnded(_ view: ScratchUIView) {
        if Int(view.getScratchPercent()*100) >= JRCBConstants.ScractchCard.kScratchPercentToComplete {
            view.removeFromSuperview()
            scratchDelegate?.scratchEnded()
        }
        
    }
}
