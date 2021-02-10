//
//  JRPCRedeemPointsVC.swift
//  jarvis
//
//  Created by Pankaj Singh on 21/01/20.
//

import UIKit
import jarvis_network_ios

class JRPCRedeemPointsVC: JRPCBaseViewController, JRPCAddRemoveShadowViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var rewardsVM: JRPCRewardVM = JRPCRewardVM()
    var updateFetchBalance: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavBarHidden = true
        setupView()
        fetchRewards()
        self.fetchCoinsBalance()
    }
    
    private func setupView() {
        let tableHeaderView = JRPCRedeemCoinsHeader.instanceFromPCNib(type: JRPCRedeemCoinsHeader.self)
        self.tableView.setPointsTableHeaderView(headerView: tableHeaderView)
        self.tableView.updatePointsHeaderViewFrame()
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        if (JRNetworkUtility.isNetworkReachable() && self.updateFetchBalance) {
            self.fetchCoinsBalance()
            updateFetchBalance = false
        }
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: ======================== Table View Delegate and Datasource ========================================

extension JRPCRedeemPointsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardsVM.rewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "JRPCRedeemCell", for: indexPath) as! JRPCRedeemCell
        cell.model = rewardsVM.rewards[indexPath.row]
        cell.delegate = self
        return cell
    }
}

//MARK: ======================== API Calls ========================================

extension JRPCRedeemPointsVC {
    
    private func fetchCoinsBalance(isPurchaseFlow: Bool = false, cell: JRPCRedeemCell? = nil) {
        if isPurchaseFlow && cell?.model.productID?.value == nil {
            self.showAlert("jr_pp_kdefaultErrorMsg".localized)
            cell?.resetCell()
            self.tableView.isUserInteractionEnabled = true
            return
        }
        var headerView: JRPCRedeemCoinsHeader?
        headerView = self.tableView.tableHeaderView as? JRPCRedeemCoinsHeader
        if !isPurchaseFlow {
            headerView?.coinsLabel.isHidden = true
            headerView?.loaderBtn.showPoinstCheckBalance(shouldRemoveTitle: true, defaultBGColor: .clear)
        } else {
            JRPCUtilities.trackCustomEventForPaytmCoins(screenName: JRPCScreens.paytmCoinsCatalog, eventAction: JRPCGAEvents.coinsRedemptionClicked.rawValue,  label1Val: cell?.model.productID?.value, label2Val: nil)
        }
        rewardsVM.fetchCoinBalance(data: (JRPCUtilities.getCheckBalanceURL(), getBalanceAPIParams())) {[weak self] (error) in
            headerView?.coinsLabel.isHidden = false
            headerView?.loaderBtn.removeLoader()
            headerView?.coinsLabel.text = JRPCUtilities.generateFormattedStringWithSeparator(self?.rewardsVM.coinsBalance)
            if let fetchBalanceError = error {
                if isPurchaseFlow {
                    self?.showAlert(fetchBalanceError.localizedDescription)
                    cell?.resetCell()
                    self?.tableView.isUserInteractionEnabled = true
                }
            } else {
                if isPurchaseFlow {
                    self?.checkout(cell: cell)
                }
            }
        }
    }
    
    private func getBalanceAPIParams() -> [String: Any] {
        return ["request":["body": [:]]]
    }
    
    private func fetchRewards() {
        JRPPLoadingIndicator.show(self.tableView, loadingText: nil, bgColor: .clear, type: .opaqueBgBubble)
        rewardsVM.fetchRewards(data: (JRPCUtilities.getRewardsURL(), [:])) { [weak self ](error) in
            JRPPLoadingIndicator.hide()
            if let rewardsError = error {
                self?.showAlert(rewardsError.localizedDescription)
            } else {
                self?.tableView.reloadData()
            }
        }
    }
    
    func checkout( cell: JRPCRedeemCell?) {
        rewardsVM.checkout(data: (JRPCUtilities.getCheckoutUrl(), getChcekoutAPIParams(pid: cell?.model.productID?.value))) { [weak self] (error) in
            cell?.resetCell()
            self?.tableView.isUserInteractionEnabled = true
            if let rewardsError = error {
                self?.showAlert(rewardsError.localizedDescription)
            } else {
                // call bridge to open order summary
                if let orderId = self?.rewardsVM.orderId {
                    if JRPCUtilities.isMerchantInvokeFromConsumer(){
                        if let mid = JRCBManager.shareInstance.mid {
                          let deeplink = JRPCUtilities.generateH5OrderDetailLink(orderId:orderId, pgmid: mid)
                            JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(deeplink, isAwaitProcessing: false)
                        }
                    }
                    else {
                        JRCashbackManager.shared.cbEnvDelegate.openGVOrderSummary(orderId: orderId)
                    }
                    self?.updateFetchBalance = true
                }
            }
        }
    }
    
    private func getChcekoutAPIParams(pid: String?) -> [String: Any] {
        return ["cart_items":[["product_id": (pid ?? ""), "qty": 1, "configuration": ["pointsOrderSummary":"GV"]]], "payment_intent": [["mode": "LOYALTY_POINT"]]]
    }
    
    private func isSufficientBalanceAvailable(cell: JRPCRedeemCell) -> (isBalanceAvailable: Bool, diffAmountNeeded: String) {
        
        if let currentCoinBalance = Double(self.rewardsVM.coinsBalance), let rewardCost = cell.model.attributes?.redemptionPoints?.value, let doubleRewardCost = Double(rewardCost), currentCoinBalance < doubleRewardCost {
            let difference: Double = doubleRewardCost - currentCoinBalance
            return (false, String(difference))
        }
        return (true, "")
    }
}


extension JRPCRedeemPointsVC: JRPCRedeemCellDelegate {
    func purchaseVoucher(cell: JRPCRedeemCell) {
        if !isSufficientBalanceAvailable(cell: cell).isBalanceAvailable {
            JRPCUtilities.trackCustomEventForPaytmCoins(screenName: JRPCScreens.paytmCoinsCatalog, eventAction: JRPCGAEvents.coinsRedemptionInsufficientBalance.rawValue,  label1Val: cell.model.productID?.value, label2Val: nil)
            cell.resetCell()
            let controller = JRPCMessageVC.initialize(shadowDelegate: self, messageToShow: getMessage(diff: isSufficientBalanceAvailable(cell: cell).diffAmountNeeded))
            self.present(controller, animated: true, completion: nil)
            return
        }
        self.tableView.isUserInteractionEnabled = false
        self.fetchCoinsBalance(isPurchaseFlow: true, cell: cell)
    }
    
    private func getMessage(diff: String) ->  NSMutableAttributedString {
        let imageAttachment =  NSTextAttachment()
        
        imageAttachment.image = UIImage.imageWith(name: "ic_Star_point")
        imageAttachment.bounds = CGRect(x: 0, y: -1, width: 15.0, height: 15.0)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "jr_pc_you_need".localized + "  ")
        completeText.append(attachmentString)
        let  textAfterIcon = NSMutableAttributedString(string: " " + "\(JRPCUtilities.generateFormattedStringWithSeparator(diff))" + " " + "jr_pc_not_enough_coins".localized)
        completeText.append(textAfterIcon)
        return completeText
    }

    func viewDetailBtnClicked() {
        let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
        self.view.addSubview(tncPopupView)
        tncPopupView.showGVDetail(shortDescription: "Title", tnStr: "jr_pc_gv_description".localized)
    }
}

extension UITableView {
    // Set table header view & add Auto layout.
    public func setPointsTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView = headerView
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    public func updatePointsHeaderViewFrame() {
        guard let headerView: UIView = self.tableHeaderView else { return }
        headerView.layoutIfNeeded()
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }
}
