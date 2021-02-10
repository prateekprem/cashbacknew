//
//  CBReferralLandingViewController.swift
//  FBSDKCoreKit
//
//  Created by Abhishek Tripathi on 23/07/20.
//

import UIKit
 
class CBReferralLandingViewController: JRCBBaseVC {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var headerBgImage: UIImageView!
    @IBOutlet weak var wonAmountView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tHeader: UIView!
    @IBOutlet weak var navigation: UIView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    var viewModel: ReferralLendingViewModel!
    
    class func newInstanse(tag: String?, utmSource: String?) -> CBReferralLandingViewController{
        let vc = JRCBStoryboard.stbReferral.instantiateViewController(withIdentifier: "CBReferralLandingViewController") as! CBReferralLandingViewController
        vc.viewModel = ReferralLendingViewModel(tag: tag ?? "referral_1", utmSource: utmSource ?? "")
        return vc
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.startObserving()
        self.startPulseTracking()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToSeeUserList))
        wonAmountView.addGestureRecognizer(tapGesture)
        wonAmountView.layer.cornerRadius = 8
        wonAmountView.layer.shadowColor = UIColor(red: 29/255.0, green: 37/255.0, blue: 45/255.0, alpha: 0.1).cgColor
        wonAmountView.layer.borderWidth = 0.5
        wonAmountView.layer.borderColor = UIColor(red: 221/255.0, green: 229/255.0, blue: 237/255.0, alpha: 1.0).cgColor
        wonAmountView.clipsToBounds = true
        wonAmountView.isHidden =  true
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.isHidden = true
        self.viewModel.viewIsReady()
    }
    
    private func startPulseTracking() {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: false)
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_PrimaryOffer, action: .act_PrimaryPageLoad, labels: labelDict).track()
    }
    
    func startObserving() {
        self.viewModel.observer = { [weak self] state in
            switch state {
            case .loding:
                JRPPLoadingIndicator.show(self?.view ?? UIView(), loadingText: nil, bgColor: .clear, type: .opaqueBgBubble)
            case .content:
                JRPPLoadingIndicator.hide()
            case .error(let errorMessage):
                JRPPLoadingIndicator.hide()
                self?.showCbAlert(errorMessage)
            case .refreshing:
                self?.showCbAlert("No Offer Available")
                if self?.viewModel.dataModel?.campaigns?.count == 1 {
                    self?.tableView.backgroundColor = UIColor(red: 0.0, green: 172/255.0, blue: 237/255.0, alpha: 0.06)
                }
                self?.tableView.reloadData()
            case .upadeTotalBonus:
                self?.updateTotalBonus()
            }
        }
    }
    
    func updateTotalBonus() {
        self.showStrip()
    }
    
    func showCbAlert(_ message: String) {
        if !self.viewModel.isRecord {
            UIAlertController.cbShowWith(title: "", body: message, btnTitles: ["Ok"], onController: self) { (val) in
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.tableView.isHidden = !self.viewModel.isRecord
    }
    
    func showStrip() {
        self.tHeader.frame.size.height = self.viewModel.isVisibale ? 357.0 : 298.0
        self.bottom.constant = self.viewModel.isVisibale ? 84.0 : 33.0
        self.tHeader.frame.size.width = self.tableView.frame.width
        
        self.addHeaderOn(table: self.tableView)
        wonAmountView.isHidden = !self.viewModel.isVisibale
        self.icon.jr_setImage(with: URL(string: self.viewModel.cashBackImageUrl))
        if let point = self.viewModel.totalPoint {
            self.amountLabel.text = "₹\(Int(point))"
        }
        self.titleLabel.text = self.viewModel.pointTitle
        if let url = URL(string: self.viewModel.bannerUrl) {
            self.headerBgImage.jr_setImage(with: url)
        }
        
        // self.headerBgImage.setImageFromUrlPath(self.viewModel.bannerUrl, placeHolderImageName: nil)
        self.tableView.reloadData()
    }
    
    func registerCell() {
        self.tableView.register(UINib(nibName: "ReferralInviteCell", bundle: Bundle.cbBundle), forCellReuseIdentifier: "ReferralInviteCell")
        
    }
    
    @objc func tapToSeeUserList() {
        if self.viewModel.isVisibale  {
            let labelDict = viewModel.getPulseLabelDict(includeCampaign: false)
            JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_PrimaryOffer, action: .act_TotalCashbackClicked, labels: labelDict).track()
            if let viewController = UserListViewController.instanse(model: self.viewModel.userList, totalAmount: self.viewModel.totalPoint ?? 0.0, headerTile: self.viewModel.pointTitle) {
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didSelectBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func backClicked(_ sender: Any) {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: false)
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_PrimaryOffer, action: .act_BackClicked, labels: labelDict).track()
        self.moveBack()
    }
}
 

extension CBReferralLandingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.row(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.viewModel.data(forRow: indexPath)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: data.identifier.identifer, for: indexPath) as! ReferralTableCells
        cell.setupData(viewModel: data, self)
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let count = self.viewModel.dataModel?.campaigns?.count  else  {
                return nil
            }
            if count > 1 {
                let headerView: ReferralSection = UIView.fromNib(inBundle: Bundle.cbBundle)
                return headerView
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let count = self.viewModel.dataModel?.campaigns?.count  else  {
            return CGFloat.leastNormalMagnitude
        }
        return section == 1 ? ((count > 1) ? 56.0 : CGFloat.leastNormalMagnitude) : CGFloat.leastNormalMagnitude
    }
}

extension CBReferralLandingViewController: ReferralInviteCellProtocol, ReferralOfferCellDelegate {
    
    func didSelectReffralButton(url: String, optionName: String) {
        pulseTrackingForSocialInvite(optionName: optionName)
        if optionName != "more" {
            if let absoluteUrl  = URL(string: url) {
                if UIApplication.shared.canOpenURL(absoluteUrl) {
                    UIApplication.shared.open(absoluteUrl, options: [:], completionHandler: nil)
                }
            }
        } else {
            if let absoluteUrl  = URL(string: url) {
                let items: [Any] = [self.viewModel.shareUrl, absoluteUrl]
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
        
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_PrimaryOffer, action: evntAction, labels: labelDict).track()
    }
    
    func showAlert(error: String, message: String) {
        UIAlertController.cbShowWith(title: error, body: message, btnTitles: ["Ok"], onController: self) { (val) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didSelectKnowMore(url: String?) {
        if let urlString = url {
            let labelDict = viewModel.getPulseLabelDict(includeCampaign: true)
            JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_PrimaryOffer, action: .act_KnowMoreClicked, labels: labelDict).track()
            let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
            self.view.addSubview(tncPopupView)
            tncPopupView.showOfferDetailPopUpInMerchant(shortDescription: "Terms and Conditions", tncUrl: urlString)
        }
    }
    
    func didselectInvite(info: JRCBCampaign) {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: true)
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_PrimaryOffer, action: .act_InviteClicked, labels: labelDict).track()
        if let controller = ReferralMoreOfferController.instanse(model: info,tag: viewModel.tag,utmS: viewModel.utmSource) {
            self.navigationController?.pushViewController(controller, animated: true)
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
    
    func didSelectCopy() {
        let labelDict = viewModel.getPulseLabelDict(includeCampaign: true)
        JRCBAnalytics(screen: JRCBAnalyticsScreen.screen_ReferralLanding, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_PrimaryOffer, action: .act_CopyClicked, labels: labelDict).track()
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
        let shMoveUp = offset.y > -200
        UIView.animate(withDuration: 0.3) {
            self.navigation.alpha = shMoveUp ? 1.0 : 0
        }
    }
}
