//
//  JRCBNewOfferDetailsVC.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 29/01/20.
//

import UIKit

class JRCBNewOfferDetailsVC: JRCBStrechableHeaderBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    var kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    private var closeBtn: UIButton?
    
    private var viewModel: JRCBNewOfferDetailsVM?
    
    class func instance(model: JRCBCampaign) -> JRCBNewOfferDetailsVC {
        let vc = JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBNewOfferDetailsVC") as! JRCBNewOfferDetailsVC
        vc.viewModel = JRCBNewOfferDetailsVM(model: model)
        return vc
    }
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tHeader = JRCBDetailTableHeader.headerWith(fr: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280+self.safeAreaHeight))
        self.addHeaderOn(table: self.tableView)
        
         if let vm = viewModel?.getDataModel() {
            tHeader?.setIcon(url: vm.new_offers_image_url, placeHolder: nil)
            tHeader?.setBackground(url: vm.background_image_url, placeHolder: nil)
            tHeader?.show(overlay: vm.background_overlay)
        }
        
        closeBtn = UIButton(frame: CGRect(x: 10, y: self.safeAreaHeight+20, width: 30, height: 30))
        closeBtn?.setImage( UIImage.imageWith(name: "ic_back_circle"), for: .normal)
        closeBtn?.addTarget(self, action: #selector(self.pressCloseButton(_:)), for: .touchUpInside)
        self.view.addSubview(closeBtn!)
        
             
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        performGAScreenviewEvent()
    }
    
    private func performGAScreenviewEvent() {
        if let vm = viewModel {
            let screenName = JRCBAnalyticsScreen.screen_CashbackNewOfferDetails
            let labels = [JRCBAnalyticsEventLabel.klabel1: vm.getDataModel().campId]
            
            JRCBAnalytics(screen: screenName, vertical: .vertical_Cashback, eventType: .eventCustom, category: .cat_CashbackOffers, action: .act_Screenview, labels: labels).track()
        }
    }
    
    //MARK: Private Methods
    @objc func pressCloseButton(_ sender: UIButton) {
        self.moveBack()
    }
}

extension JRCBNewOfferDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JRCBNewOfferDetailsTVC = tableView.dequeueReusableCell(withIdentifier: JRCBNewOfferDetailsTVC.identifier, for: indexPath) as! JRCBNewOfferDetailsTVC
        if let model = viewModel?.getDataModel() {
            cell.loadData(model: model)
        }
        cell.delegate = self
        return cell
    }
    
}

extension JRCBNewOfferDetailsVC: JRCBNewOfferDetailsCellDelegate {
    
    func handleDetailAction() {
        if let model = viewModel?.getDataModel() {
            let offerDetailModel = JRCBOfferDetailModel(model: model)
            let vc = JRCBTnCVC.instance(offerDetailModel: offerDetailModel)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func handleCtaAction(sender: UIButton) {
        if let model = viewModel?.getDataModel() {
            if model.auto_activate {
                if model.isDeeplink {
                    let eventType: JRCBAnalyticsEventType = .eventCustom
                    let labels: [String: String] = ["event_label": model.campId,
                                                    "event_label2": "cashback-landing"]
                    JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: eventType, category: .cat_CashbackOffers, action: .act_TransactionCtaClicked, labels: labels).track()
                    JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(model.deeplink_url, isAwaitProcessing: false)
                }
                
            } else {
                let titleText = sender.titleLabel?.text
                sender.isUserInteractionEnabled = false
                JRCashbackManager.shared.cbEnvDelegate.cbShowLoaderOn(button: sender, shouldRemoveTitle: true, defaultBGColor: .clear)

                self.activateCampaignAPI(campaignId: model.campId) { (success, errMsg) in
                    DispatchQueue.main.async {
                        sender.isUserInteractionEnabled = true
                        sender.removeLoader(title: titleText)
                    }
                    if success {
//                        model.auto_activate = false

                    } else {
                        DispatchQueue.main.async {
                            JRAlertPresenter.shared.presentSnackBar(title: JRCBConstants.Common.kDefaultErrorTitle, message: errMsg ?? JRCBConstants.Common.kDefaultErrorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - CATEGORIES CAMPAIGNS API
    private func activateCampaignAPI(campaignId: String, completion: JRCBVMCompletion?) {
        JRCBServices.activateCampaignOrGameAPI(isCampaign: true, campaignId: campaignId) {[weak self] (success, postData, errorMsg) in
            if success, let postTrnsData = postData {
                completion?(true, "")
                DispatchQueue.main.async {
                    if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? JRCBNewOfferDetailsTVC {
                        cell.markActivated()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                         self?.pushToGameDetailsVC(postData: postTrnsData)
                    }
                }
                
            } else if let msg = errorMsg {
                completion?(false, msg)
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    private func pushToGameDetailsVC(postData: JRCBPostTrnsactionData) {
        let vc = JRCBGameDetailsVC.newInstance
        vc.isPresented = true
        let vm = JRCBGameDetailsVM(postTransData: postData)
        vc.viewModel = vm
        if let presentingVC = self.presentingViewController {
            self.dismiss(animated: false) {
                presentingVC.present(vc, animated: true, completion: nil)
            }
        } else {
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
    }
}
