//
//  JRPPTransactionVC.swift
//  Jarvis
//
//  Created by Pankaj Singh on 27/12/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios
import jarvis_network_ios

class JRPCTransactionVC: JRPCBaseViewController, JRPCAddRemoveShadowViewDelegate {
    
    @IBOutlet weak private var tableView: UITableView!
    private var transactionVM: JRPCTransactionVM = JRPCTransactionVM()
    private var transactionAPIInProgress: Bool = false
    private var footerView = JRLoadMoreFooterView.footer()
    private var retryView = JRLoadMoreFooterView.retry()
    private var isShowingNoMore: Bool = false
    private var isInitialTransactionAPI: Bool {
        return (transactionVM.loyaltyPoints.count == 0)
    }
    private var pageNumber: Int? {
        if isInitialTransactionAPI {
            return 1
        }
        if let pageNum = self.transactionVM.pagination?.pageNum, let pageCount = self.transactionVM.pagination?.totalPage, pageNum + 1 <= pageCount {
            return pageNum + 1
        }
        return nil
    }
    private let pageSize: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.isNavBarHidden = true
        setupView()
            self.fetchCoinsBalance()
            self.fetchTransactionList()
        if UserDefaults.standard.bool(forKey: JRPCConstants.kShowMorePaytmCoinView) == false && !self.isShowingNoMore {
            self.showKnowMore()
        }
    }
    
    
    private func setupView() {
        let tableHeaderView = JRPCTransactionHeader.instanceFromPCNib(type: JRPCTransactionHeader.self)
        tableHeaderView.redeemCoinsClicked = { [weak self] in
            self?.redeemBtnClicked()
        }
        self.tableView.setPointsTableHeaderView(headerView: tableHeaderView)
        self.tableView.updatePointsHeaderViewFrame()
        retryView.callback = { [weak self] in
            if self?.transactionVM.coinsBalance == JRPCConstants.kPCInvalidCoinBalance {
                self?.fetchCoinsBalance()
            }
            self?.fetchTransactionList()
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func redeemBtnClicked() {
        var coinsBalance: String? = self.transactionVM.coinsBalance
        if coinsBalance == JRPCConstants.kPCInvalidCoinBalance {
            coinsBalance = nil
        }
        JRPCUtilities.trackCustomEventForPaytmCoins(screenName: JRPCScreens.paytmCoinsPassbook, eventAction: JRPCGAEvents.redeemsClicked.rawValue,  label1Val: coinsBalance, label2Val: nil)
        if JRPCUtilities.isRedeemFlowEnabled() {
            JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(JRCBRemoteConfig.kCBRedeemPointsDeeplinkKey.strValue, isAwaitProcessing: false)
            
        } else if let currentCoinBalance = Double(self.transactionVM.coinsBalance), let limit = Double(JRPCUtilities.getRedeemCoinLimit()), currentCoinBalance >= limit {
            let text: String = "jr_pp_redeem_limit_flow_error".localized
            let controller = JRRedeemCoinsVC.initializeRedeemCoinsVC(shadowDelegate: self, text: text)
            self.present(controller, animated: true, completion: nil)
        } else {
            let text: String = String(format: "jr_pp_redeem_coins_limit_msg".localized, (JRPCUtilities.generateFormattedStringWithSeparator(JRPCUtilities.getRedeemCoinLimit())))
            let controller = JRRedeemCoinsVC.initializeRedeemCoinsVC(shadowDelegate: self, text: text)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func showKnowMore(){
        self.isShowingNoMore = true
        UserDefaults.standard.set(true, forKey: JRPCConstants.kShowMorePaytmCoinView)
        let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
               self.view.addSubview(tncPopupView)
               tncPopupView.showGVDetail(shortDescription: "Title", tnStr: "jr_pc_gv_description".localized)
        self.isShowingNoMore = false
    }
}

//MARK: ======================== Table View Delegate and Datasource ========================================

extension JRPCTransactionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionVM.loyaltyPoints.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionVM.loyaltyPoints[section].transactionList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "JRPCTransactionDateCell", for: indexPath) as! JRPCTransactionDateCell
            cell.setData(date: transactionVM.loyaltyPoints[indexPath.section].dateString)
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "JRPCTransactionCell", for: indexPath) as! JRPCTransactionCell
            cell.setData(isLastCell: indexPath.row == transactionVM.loyaltyPoints[indexPath.section].transactionList.count, model: transactionVM.loyaltyPoints[indexPath.section].transactionList[indexPath.row - 1])
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        JRPCUtilities.trackCustomEventForPaytmCoins(screenName: JRPCScreens.paytmCoinsPassbook, eventAction: JRPCGAEvents.transactionDetailClicked.rawValue,  label1Val: nil, label2Val: nil)
        let detailVC = JRPCTransactionDetailVC.instanceFromStoryboardPC(storyBoardName: "JRPaytmCoins", type: JRPCTransactionDetailVC.self)
        detailVC.model = transactionVM.loyaltyPoints[indexPath.section].transactionList[indexPath.row - 1]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == transactionVM.loyaltyPoints.count - 1 && indexPath.row == transactionVM.loyaltyPoints[indexPath.section].transactionList.count {
            self.fetchTransactionList()
        }
    }
}

//MARK: ========================================== API Calls ============================================

extension JRPCTransactionVC {
    
    private func fetchCoinsBalance() {
        var headerView: JRPCTransactionHeader?
        headerView = self.tableView.tableHeaderView as? JRPCTransactionHeader
        headerView?.coinBalance.text = ""
        headerView?.loaderBtn.showPoinstCheckBalance(shouldRemoveTitle: true, defaultBGColor: .clear)
        transactionVM.fetchCoinBalance(data: (JRPCUtilities.getCheckBalanceURL(), getBalanceAPIParams())) { [weak self] (error) in
            headerView?.loaderBtn.removeLoader()
            headerView?.coinBalance.text = JRPCUtilities.generateFormattedStringWithSeparator(self?.transactionVM.coinsBalance)
            if let fetchBalanceError = error {
                self?.showAlert(fetchBalanceError.localizedDescription)
            }
        }
    }
    
    private func getBalanceAPIParams() -> [String: Any] {
        return ["request":["body": [:]]]
    }
    
    private func fetchTransactionList() {
        guard let params = self.getTransactionAPIParams() else {
            return
        }
        if transactionAPIInProgress {
            return
        }
        self.tableView.tableFooterView = self.isInitialTransactionAPI ? nil : self.footerView
        if self.isInitialTransactionAPI {
            JRPPLoadingIndicator.show(self.tableView, loadingText: nil, bgColor: .clear, type: .opaqueBgBubble, topPaddingg: 326.0)
        }
        transactionAPIInProgress = true
        transactionVM.fetchTransactionList(data: (JRPCUtilities.getTransactionListURL() , params)) { [weak self] (error) in
            self?.tableView.tableFooterView = nil
            self?.transactionAPIInProgress = false
            JRPPLoadingIndicator.hide()
            if let transactionError = error {
                self?.handleTransactionListAPIError(error: transactionError.localizedDescription)
            } else {
                self?.handleTransactionListSuccess()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func handleTransactionListSuccess() {
        if isInitialTransactionAPI && !self.isShowingNoMore {
            self.showKnowMore()
        }
    }
    
    
    private func handleTransactionListAPIError(error: String) {
        if self.isInitialTransactionAPI {
            self.retryView.additionalText = error
            self.tableView.tableFooterView = self.retryView
        }
    }
    
    private func getTransactionAPIParams() -> [String: Any]? {
        guard let pageNumber = self.pageNumber else {
            return nil
        }
        if pageNumber == 1 && self.transactionVM.loyaltyPoints.count > 0 {
            return nil
        }
        return ["request":["body": ["pageNum": pageNumber , "pageSize": self.pageSize]]]
    }
    
}
