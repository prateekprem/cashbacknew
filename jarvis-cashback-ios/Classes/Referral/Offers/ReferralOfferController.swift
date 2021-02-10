//
//  ReferralOfferController.swift
//  FBSDKCoreKit
//
//  Created by Abhishek Tripathi on 23/07/20.
//

import UIKit
 
class ReferralMoreOfferController: JRCBBaseVC {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var headerBgImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tHeader: UIView!
    @IBOutlet weak var navigation: UIView!
 
    var viewModel: ReferralMoreOfferViewModel!
    
    static func instanse(model: JRCBCampaign, tag: String = "", utmS: String = "") -> ReferralMoreOfferController? {
        let viewController = JRCBStoryboard.stbReferral.instantiateViewController(withIdentifier: "ReferralMoreOfferController") as? ReferralMoreOfferController
        viewController?.viewModel = ReferralMoreOfferViewModel(model: model, tag: tag, utmS: utmS)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startPulseTracking()
        self.registerCell()
        self.startObserving()
        self.addHeaderOn(table: self.tableView)
        icon.layer.cornerRadius = icon.frame.width/2
        icon.clipsToBounds = true
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.viewModel.viewIsReady()
        self.icon.jr_setImage(with: URL(string: self.viewModel.model.new_offers_image_url))
        self.backgroundImage.jr_setImage(with: URL(string: self.viewModel.model.background_image_url))
     }
    
    private func startPulseTracking() {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: true)
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralSecondaryLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_SecondaryOffer, action: .act_SecondaryPageLoad, labels: labelDict).track()
    }
    
    func startObserving() {
        self.viewModel.observer = { [weak self] state in
            switch state {
            case .loding:
                JRPPLoadingIndicator.show(self?.tableView ?? UIView(), loadingText: nil, bgColor: .clear, type: .opaqueBgBubble)
            case .content:
                JRPPLoadingIndicator.hide()
            case .error(let errorMessage):
                JRPPLoadingIndicator.hide()
                self?.showAlert(errorMessage, andTitle: "Error")
            case .refreshing: self?.tableView.reloadData()
            }
        }
    }
    
    func registerCell() {
           self.tableView.register(UINib(nibName: "ReferralInviteCell", bundle: Bundle.cbBundle), forCellReuseIdentifier: "ReferralInviteCell")
       }
    
    @IBAction func didSelectCrossButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func backClicked(_ sender: Any) {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: true)
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralSecondaryLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_SecondaryOffer, action: .act_BackClicked, labels: labelDict).track()
        self.moveBack()
    }
 }

extension ReferralMoreOfferController: UITableViewDataSource, UITableViewDelegate, ReferralLandingProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.row(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.viewModel.data(forRow: indexPath)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: data.identifier.identifer, for: indexPath) as? ReferralTableCells
        cell?.setupData(viewModel: data, self)
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension ReferralMoreOfferController: ReferralInviteCellProtocol {
    func didSelectCopy() {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: true)
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralSecondaryLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_SecondaryOffer, action: .act_OfferRewardsClicked, labels: labelDict).track()
    }
    
    func showAlert(error: String, message: String) {
        UIAlertController.cbShowWith(title: error, body: message, btnTitles: ["Ok"], onController: self) { (val) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didSelectReffralButton(url: String, optionName: String){
        self.pulseTrackingForSocialInvite(optionName: optionName)
        if optionName != "more" {
            if let absoluteUrl  = URL(string: url) {
                if UIApplication.shared.canOpenURL(absoluteUrl) {
                    UIApplication.shared.open(absoluteUrl, options: [:], completionHandler: nil)
                }
            }
        } else {
            if let absoluteUrl  = URL(string: url) {
                let items: [Any] = [self.viewModel.shareText, absoluteUrl]
                let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
                self.present(vc, animated: true)
            }
        }
    }
    
    private func pulseTrackingForSocialInvite(optionName: String) {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: true)
        var evntAction: JRCBAnalyticsAction = .act_None
        if optionName == "whatsapp" {
            evntAction = .act_WhatsappClicked
        } else if optionName == "sms" {
            evntAction = .act_SmsClicked
        } else if optionName == "twitter" {
            evntAction = .act_TwitterClicked
        } else if optionName == "more" {
            evntAction = .act_ShareMoreClicked
        }
        
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralSecondaryLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_SecondaryOffer, action: evntAction, labels: labelDict).track()
    }
    
    func didSelectKnowMore(url: String?) {
        if let urlString = url {
            let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
            self.view.addSubview(tncPopupView)
            tncPopupView.showOfferDetailPopUpInMerchant(shortDescription: "", tncUrl: urlString)
        }
    }
    
    func showToast(message: String) {
        self.showToastMessage(message: message)
    }
    
    func reloadTabel() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addHeaderOn(table: UITableView) {
        guard let header = self.tHeader else { return }
        table.backgroundView = UIView()
        table.backgroundView?.addSubview(header)
        table.contentInset = UIEdgeInsets( top: header.frame.height, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = self.tHeader else { return }
        let offset = scrollView.contentOffset.y
        var fr = header.frame
        fr.size.height = offset < 0 ? abs(offset) : 0
        header.frame = fr
        self.checkNavVisibility()
    }
    
    private func checkNavVisibility() {
        let offset = self.tableView.contentOffset
        let shMoveUp = offset.y > -131
        UIView.animate(withDuration: 0.3) {
            self.navigation.alpha = shMoveUp ? 1.0 : 0
         }
    }
}
