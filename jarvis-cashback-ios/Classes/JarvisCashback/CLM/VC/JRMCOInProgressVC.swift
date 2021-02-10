//
//  JRMCOInProgressVC.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 17/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRMCOInProgressVC: JRCBBaseVC {
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var scrolledHeaderLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = headerView
            tableView.tableFooterView = tableFooterView
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .none
            tableView.estimatedSectionHeaderHeight = 128
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            registerCustomViewsInTableView()
        }
    }
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet var sectionHeaderEarnedView: UIView!
    @IBOutlet var topSectionHeader: UIView!
    
    @IBOutlet var sectionHeaderExpiredView: UIView!
    @IBOutlet var sectionHeaderExpiredContentView: UIView!
    @IBOutlet weak var sectionHeaderExpiredTitleLabel : UILabel!
    @IBOutlet weak var sectionHeaderExpiredSubtitleLabel : UILabel!
    @IBOutlet weak var sectionHeaderExpiredDateLabel : UILabel!
    @IBOutlet var sectionHeaderExpiredInnerView: UIView!
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerSubtitleLabel: UILabel!
    @IBOutlet weak var offerImageView: UIImageView! {
        didSet {
            offerImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var offerImageViewWidth:NSLayoutConstraint!
    @IBOutlet weak var offerImageViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var tncLabel: UILabel!
    @IBOutlet weak var tncHeadingLabel: UILabel!
    
    @IBOutlet weak var sectionHeaderEarnedContentView: UIView!
    @IBOutlet var sectionHeaderEarnedInnerView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var viewAllBtnHConst: NSLayoutConstraint!
    @IBOutlet weak var sectionHeaderEarnedTitleLabel : UILabel!
    @IBOutlet weak var sectionHeaderEarnedSubtitleLabel : UILabel!
    @IBOutlet weak var sectionHeaderEarnedDateLabel : UILabel!
    @IBOutlet weak var sectionHeaderEarnedKYCLabel : UILabel!    
    @IBOutlet weak var sectionHeaderEarnedKYCDateTimeLabel: UILabel!
    @IBOutlet weak var sectionHeaderEarnedKYCView : UIView!
    @IBOutlet weak var sectionHeaderEarnedKYCImageViewHeight:NSLayoutConstraint!
    @IBOutlet weak var sectionHeaderEarnedKYCImageViewTop:NSLayoutConstraint!
    
    @IBOutlet weak var sectionInProgressHeaderInnerView: UIView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var summaryLablel: UILabel!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var summaryVHeightCons: NSLayoutConstraint!
    
    var viewModel: JRMCOMyOfferViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        JRCBAnalytics(screen: .screen_CashbackOfferMerchantProgress,
                      vertical: .vertical_MarchantCashback, eventType: .eventUserInfo).track()
    }
    
    class func instance(myOfferVM: JRMCOMyOfferViewModel) -> JRMCOInProgressVC {
        let controller = JRCBStoryboard.stbMerchant.instantiateViewController(withIdentifier: "JRMCOInProgressVC") as! JRMCOInProgressVC
        controller.viewModel = myOfferVM
        return controller
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sectionInProgressHeaderInnerView.roundCorners([.topLeft,.topRight], radius: 6.0)
        sectionHeaderExpiredContentView.roundCorners([.topLeft,.topRight], radius: 6.0)
        sectionHeaderExpiredInnerView.roundCorners([.topLeft,.topRight], radius: 6.0)
        sectionHeaderEarnedInnerView.roundCorners([.topLeft,.topRight], radius: 6.0)
        sectionHeaderEarnedContentView.roundCorners([.topLeft,.topRight], radius: 6.0)
        sectionInProgressHeaderInnerView.roundCorners([.topLeft,.topRight], radius: 6.0)
        offerImageView.layer.cornerRadius = offerImageView.frame.size.height / 2.0
    }
    
    //MARK: Private Methods
    private func setup() {
        blurView.isHidden = true
        backgroundImageView.backgroundColor = UIColor.init(red: 255.0/255, green: 131.0/255, blue: 120.0/255, alpha: 1)
        headerTitleLabel.text = viewModel?.campaignViewModel.getCampaignTitleText()
        scrolledHeaderLabel.text = viewModel?.campaignViewModel.getCampaignTitleText()
        scrolledHeaderLabel.alpha = 0
        sectionHeaderEarnedKYCLabel.text = ""
        headerSubtitleLabel.text = viewModel?.campaignViewModel.short_description
        tncHeadingLabel.text = "jr_pay_offerterms".localized
        if let txt = viewModel?.campaignViewModel.important_terms {
            tncLabel.setHTML(text: txt)
        } else {
            tncLabel.text = ""
        }
        
        tableView.register(UINib(nibName: String(describing: JRMCoInProgressNewCell.self), bundle: Bundle.cbBundle), forCellReuseIdentifier: String(describing: JRMCoInProgressNewCell.self))
        
        backgroundImageView.contentMode = .scaleAspectFill
        
        if let backgroundImageUrl = URL(string: viewModel?.campaignViewModel.background_image_url ?? "") {
            backgroundImageView.jr_setImage(with: backgroundImageUrl)
        }else{
            backgroundImageView.image = nil
        }
        
        if let imageUrlString = viewModel?.campaignViewModel.offer_icon_override_url, imageUrlString != "" {
            if let imageUrl = URL(string: imageUrlString) {
                offerImageView.jr_setImage(with: imageUrl)
            }else{
                offerImageView.image = UIImage.imageWith(name: "offers_placeholder")
            }
        }else{
            offerImageView.image = UIImage.imageWith(name: "offers_placeholder")
        }
        
        timeLeftLabel.text = viewModel?.remaining_time
        let gameStatus = viewModel?.game_status_enum ?? JRMCOMyOfferViewModel.GameStatus.none
        summaryView.isHidden = true
        summaryLablel.text = ""
        
        switch gameStatus {
        case .inProgress:
            summaryView.isHidden = false
            summaryLablel.text = viewModel?.txn_count_text
            headerSubtitleLabel.text = viewModel?.offer_progress_construct
            break
        case .completed:
            sectionHeaderEarnedTitleLabel.text = "jr_pay_congratulations".localized
            sectionHeaderEarnedSubtitleLabel.text = viewModel?.game_gratification_message
            sectionHeaderEarnedKYCLabel.text = viewModel?.txn_count_text
            sectionHeaderEarnedDateLabel.text = viewModel?.game_completion_time.getFormattedDateString("d MMM yyyy, h:mm a")
            JRCBAnalytics(screen: .screen_CashbackOfferMerchantCompletes,
                          vertical: .vertical_MarchantCashback, eventType: .eventUserInfo).track()            
            break
        case .expired:
            if (viewModel?.game_expiry_amount ?? 0) > 0 {
                sectionHeaderEarnedTitleLabel.text = "jr_pay_offerExpired".localized
                sectionHeaderEarnedSubtitleLabel.text = viewModel?.game_gratification_message
                sectionHeaderEarnedKYCLabel.text = viewModel?.txn_count_text
                sectionHeaderEarnedDateLabel.text = viewModel?.game_expiry.getFormattedDateString("d MMM yyyy, h:mm a")
            } else {
                sectionHeaderExpiredSubtitleLabel.text = viewModel?.game_expiry_reason_text
                sectionHeaderExpiredDateLabel.text = viewModel?.game_expiry.getFormattedDateString("d MMM yyyy, h:mm a")
                sectionHeaderExpiredTitleLabel.text = "jr_pay_offerExpired".localized
            }
            
            JRCBAnalytics(screen: .screen_CashbackOfferMerchantExpired,
                          vertical: .vertical_MarchantCashback, eventType: .eventUserInfo).track()
            break
        default: break
        }
        
        sectionHeaderEarnedKYCImageViewHeight.constant = 0
        sectionHeaderEarnedKYCImageViewTop.constant = 0
    }
    
    private func registerCustomViewsInTableView() {
        tableView.register(UINib(nibName: "JRMCOInProgressSectionHeader", bundle: Bundle.cbBundle), forHeaderFooterViewReuseIdentifier: "JRMCOInProgressSectionHeader")
    }
    
    //MARK: IBActions
    @IBAction func didTappedBackButton(_ sender: Any) {
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is JRCBLandingVC {
                    self.navigationController?.popToViewController(viewController,animated: true)
                    return
                }
            }
            self.navigationController?.popViewController(animated:true)
            return
        }
        self.navigationController?.popViewController(animated:true)
        JRCashbackManager.shared.cbEnvDelegate.cbBackBtnClicked(controller: .myOfferDetail)
    }
    
    @IBAction func didTappedViewAllTnCButton(_ sender: Any) {
        if let campaignVM = viewModel?.campaignViewModel, !campaignVM.tnc_url.isEmpty {
            let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
            self.view.addSubview(tncPopupView)
            tncPopupView.showOfferDetailPopUpInMerchant(shortDescription: campaignVM.short_description, tncUrl: campaignVM.tnc_url)
        }
    }
    
    @IBAction func didTappedPaymentDetails(_ sender: Any) {
        guard let stagesVM = viewModel?.stagesVM else { return }
        guard let id = viewModel?.offer_id else { return }
        let vc = JRMCOPaymentDetailVC.instance(dataSource:stagesVM, gameId: id)
        self.navigationController?.pushViewController(vc,animated:true)
    }
}

extension JRMCOInProgressVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let totalTransaction = viewModel?.total_txn_count else {
            return 0
        }
        let stageCount = (viewModel?.stagesVM.count ?? 0)
        return totalTransaction > 10 ? stageCount + 1 : stageCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalTransaction = viewModel?.total_txn_count ?? 0
        
        if totalTransaction > 10 {
            if section == 0 { return 0 }
            
            let stageVM = viewModel?.getStageVMForIndex(index:section - 1)
            guard let status = stageVM?.stage_status_enum else { return 0 }
            
            switch status {
            case .completed, .expired, .offerExpired,
                 .denied, .notStarted: return 1
            case .inProgress: return 2
            default: return 0
            }
        }
        
        let stageVM = viewModel?.getStageVMForIndex(index:section)
        return stageVM?.stage_total_txn_count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let totalTransaction = viewModel?.total_txn_count ?? 0
        let itemIndex = totalTransaction > 10 ? indexPath.section - 1 : indexPath.section
        guard let stageVM = viewModel?.getStageVMForIndex(index: itemIndex) else { return UITableViewCell() }
        let status = stageVM.stage_status_enum
        
        if totalTransaction > 10 {
            switch status {
            case .completed, .expired, .offerExpired, .denied:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRCOMGameStatusCell", for: indexPath) as? JRCOMGameStatusCell else { return UITableViewCell() }
                cell.setDataInCell(stageViewModel: stageVM)
                cell.delegate = self
                return cell
            case .inProgress:
                if indexPath.row == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRCOMInProgressDetailCell", for: indexPath) as? JRCOMInProgressDetailCell else { return UITableViewCell() }
                    cell.setDataInCell(stageViewModel: stageVM)
                    return cell
                }
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRCOMGameStatusCell", for: indexPath) as? JRCOMGameStatusCell else { return UITableViewCell() }
                cell.setDataInCell(stageViewModel: stageVM)
                cell.delegate = self
                return cell
                
            case .notStarted:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRCOMGameStatusCell", for: indexPath) as? JRCOMGameStatusCell else { return UITableViewCell() }
                cell.setDataInCell(stageViewModel: stageVM)
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
            
        }else{
            
            let identifier = String(describing: JRMCoInProgressNewCell.self)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? JRMCoInProgressNewCell else { return UITableViewCell() }
            
            let stageTrasCount  = viewModel?.stagesVM.count ?? 0
            let stageCount      = stageVM.stage_total_txn_count
            
            var lastStageCount  = 0
            for i in 0..<indexPath.section{
                lastStageCount += viewModel?.getStageVMForIndex(index: i).stage_total_txn_count ?? 0
            }
            
            let totalSuccessTransaction = viewModel?.success_txn_count ?? 0
            var stageConnectorStatus: TransactionStageConnector = .lineGrey
            if stageTrasCount == indexPath.section+1 && stageCount == indexPath.row+1 {
                stageConnectorStatus = .lineHide
            }else if lastStageCount + indexPath.row + 1 < totalSuccessTransaction {
                stageConnectorStatus = .lineGreen
            }
            
            cell.delegate       = self
            cell.configureCell(stageVM, stageConnector: stageConnectorStatus, indexPath: indexPath, lastStageCount: lastStageCount)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let totalTransaction = viewModel?.total_txn_count ?? 0
        
        if section == 0 {
            let status = viewModel?.game_status_enum ?? JRMCOMyOfferViewModel.GameStatus.none
            switch status {
            case .inProgress:
                return topSectionHeader
            case .completed:
                return sectionHeaderEarnedView
            case .expired, .offerExpired:
                if (viewModel?.game_expiry_amount ?? 0) > 0 {
                    return sectionHeaderEarnedView
                }else {
                    return sectionHeaderExpiredView
                }
            default:
                return UIView()
            }
        }else {
            if totalTransaction > 10 {
                guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JRMCOInProgressSectionHeader") as? JRMCOInProgressSectionHeader else {
                    return UIView()
                }
                guard let stageVM = viewModel?.getStageVMForIndex(index:section - 1) else { return headerView }
                headerView.setDataInView(stageViewModel: stageVM)
                return headerView
            }else{
                return UIView(frame: .zero)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let totalTransaction = viewModel?.total_txn_count ?? 0
        return  (totalTransaction > 10 || section == 0) ? UITableView.automaticDimension : 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 67{
            UIView.animate(withDuration:0.15, animations:{
                self.scrolledHeaderLabel.alpha = 1
            })
        }else{
            UIView.animate(withDuration:0.15, animations:{
                self.scrolledHeaderLabel.alpha = 0
            })
        }
    }
}

extension JRMCOInProgressVC: JRCOMGameStatusCellDelegate {
    
    func openMerchantPointsPassbook() {
        let deepLink = JRCBRemoteConfig.kCBMerchantPointsDeeplink.strValue
        JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(deepLink, isAwaitProcessing: false)
    }
    
    func openVoucherDetailView(siteID: String?, promoCode: String?, model: Any?) {
        let vc = JRCBVoucherDetailInput.detailVCWith(siteID: siteID, promoCode: promoCode, model: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTappedStatusButton(title:String, description:String, rrn:String, isGratificationProcessed:Bool) {
        
        let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
        var updatedDescription : String = "\(description)"
        if rrn.length > 0 {
            updatedDescription = "\(description) <br><br><br> Ref. No. \(rrn)"
        }
        let tncModel = JRCOTNCModel(termsTitle: title, termsDescription: updatedDescription)
        self.view.addSubview(tncPopupView)
        
        if isGratificationProcessed {
            tncPopupView.showPopUpDealCrossPromo(tncModel: tncModel, titleColor : UIColor(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1), isRedemptionPopUp : true)
        }else {
            tncPopupView.showPopUpDealCrossPromo(tncModel: tncModel, titleColor : UIColor(red: 245.0/255, green: 161.0/255, blue: 9.0/255, alpha: 1), isRedemptionPopUp : true)
        }
    }
}
