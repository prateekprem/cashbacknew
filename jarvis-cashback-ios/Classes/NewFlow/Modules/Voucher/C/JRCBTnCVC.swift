//
//  JRCBTnCVC.swift
//  jarvis-cashback-ios
//
//  Created by Siddharth Suneel on 05/02/20.
//

import UIKit
import Lottie

class JRCBTnCVC: JRCBBaseVC {
    
    //IBOutlets
    @IBOutlet weak var containerView     : UIView!
    @IBOutlet weak var headerTitleLbl    : UILabel!
    @IBOutlet weak var headerSubtitleLbl : UILabel!
    @IBOutlet weak var validityLbl       : UILabel!
    @IBOutlet weak var bookNowBtn        : UIButton!
    @IBOutlet weak var tncTitleLbl       : UILabel!
    @IBOutlet weak var tncTxtView        : UITextView!
    @IBOutlet weak var ctaView           : UIView!
    
    // Vairables
    private var viewModel: JRCBTnCVM?
    private let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
    
    class func instance(offerDetailModel: JRCBOfferDetailModel) -> JRCBTnCVC {
        let vc = JRCBStoryboard.stbConsumer.instantiateViewController(withIdentifier: "JRCBTnCVC") as! JRCBTnCVC
        vc.viewModel = JRCBTnCVM(model: offerDetailModel)
        return vc
    }
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    

    //IBActions
    @IBAction func didTappedBookNow(_ sender: UIButton) {
        if let detailModel = self.viewModel?.getOfferDetailModelData() {
            if detailModel.isActivate, !detailModel.campaignId.isEmpty {
                let titleLabel = sender.titleLabel?.text
                sender.isUserInteractionEnabled = false
                JRCashbackManager.shared.cbEnvDelegate.cbShowLoaderOn(button: sender, shouldRemoveTitle: true, defaultBGColor: .clear)
                JRCBServices.activateCampaignOrGameAPI(isCampaign: detailModel.isCampaign, gameID:detailModel.gameId,  campaignId: detailModel.campaignId) {[weak self] (success, postData, errorMsg) in
                    DispatchQueue.main.async {
                        sender.isUserInteractionEnabled = true
                        sender.removeLoader(title: titleLabel)
                    }
                    if success, let postTrnsData = postData {
                        if detailModel.isCampaign {
                            DispatchQueue.main.async {
                                self?.pushToGameDetailsVC(postData: postTrnsData)
                            }
                        } else {
                            let offerDetailModel = JRCBOfferDetailModel(model: postTrnsData)
                            self?.viewModel = JRCBTnCVM(model: offerDetailModel)
                            DispatchQueue.main.async {
                                self?.changeCTABtnTitle()
                            }
                        }
                        
                    } else if let msg = errorMsg {
                        DispatchQueue.main.async {
                            JRAlertPresenter.shared.presentSnackBar(title: JRCBConstants.Common.kDefaultErrorTitle, message: msg , autoDismiss: true, actions: nil, dismissHandler: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            JRAlertPresenter.shared.presentSnackBar(title: JRCBConstants.Common.kDefaultErrorTitle, message: JRCBConstants.Common.kDefaultErrorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                        }
                    }
                }
            } else if !detailModel.deeplinkURL.isEmpty {
                // dismiss all the presented view controller as deeplink will break if any controller is presented.
                self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                    JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(detailModel.deeplinkURL, isAwaitProcessing: false)
                })
            }
        }
    }
    
    @IBAction func didTappedCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func setup() {
        if let model = viewModel?.getOfferDetailModelData() {
            showLoaderAnimation()
            startLoaderAnimation()
            headerTitleLbl.text = model.titleText
            headerSubtitleLbl.text = model.subtitleText
            validityLbl.text = model.validityText
            if model.ctaTitle.isEmpty {
                ctaView.isHidden = true
            } else {
                ctaView.isHidden = false
                bookNowBtn.setTitle(model.ctaTitle, for: .normal)
            }
            viewModel?.getTnCData() { [weak self] (_success, error)  in
                DispatchQueue.main.async {
                    self?.stopLoaderAnimation()
                }
                if let success = _success, success {
                    DispatchQueue.main.async {
                        self?.tncTxtView.setHTML(html: self?.viewModel?.getTnCModelData()?.terms ?? "")
                        self?.tncTitleLbl.text = self?.viewModel?.getTnCModelData()?.termsTitle ?? ""
                        self?.containerView.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    private func changeCTABtnTitle() {
        if let model = viewModel?.getOfferDetailModelData() {
            if model.ctaTitle.isEmpty {
                ctaView.isHidden = true
            } else {
                ctaView.isHidden = false
                bookNowBtn.setTitle(model.ctaTitle, for: .normal)
            }
        }
    }
    
    private func showLoaderAnimation(){
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.view.addSubview(animationView)
        animationView.center = self.view.center
    }
    
    private func stopLoaderAnimation() {
        animationView.stop()
        animationView.isHidden = true
    }
    
    private func startLoaderAnimation() {
        self.view.bringSubviewToFront(animationView)
        animationView.isHidden = false
        animationView.play()
    }
    
    private func pushToGameDetailsVC(postData: JRCBPostTrnsactionData) {
        if let presentingVC = self.presentingViewController {
            let vc = JRCBGameDetailsVC.newInstance
            vc.isPresented = true
            let vm = JRCBGameDetailsVM(postTransData: postData)
            vc.viewModel = vm
            self.dismiss(animated: false) {
                presentingVC.present(vc, animated: true, completion: nil)
            }
        }
    }
}
