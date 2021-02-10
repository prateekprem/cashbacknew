//
//  JRCBDeelsNVoucherDetailVC.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 28/05/20.
//

import UIKit

class JRCBStrechableHeaderBaseVC: JRCBBaseVC, UIScrollViewDelegate {
    var tHeader : JRCBDetailTableHeader?
    
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
    }
}

class JRCBDeelsNVoucherDetailVC: JRCBStrechableHeaderBaseVC {
    @IBOutlet weak private var table : UITableView!
       
    private var detailInput = JRCBVoucherDetailInput()
    private var contentCellVM = JRCBDeelNVoucherDetailCellVM()

    private let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
    
    class var newInstance: JRCBDeelsNVoucherDetailVC {
        return JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBDeelsNVoucherDetailVC") as! JRCBDeelsNVoucherDetailVC
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tHeader = JRCBDetailTableHeader.headerWith(fr: CGRect(x: 0, y: 0, width: self.table.frame.width, height: 300))
        self.addHeaderOn(table: self.table)
        tHeader?.show(overlay: true)
        
        self.table.rowHeight = UITableView.automaticDimension
        table.contentInsetAdjustmentBehavior = .never
        self.fetchDetails()
    }
    
    func set(input: JRCBVoucherDetailInput) {
        self.detailInput = input
    }
    
    func updateWith(dealModel: Any?) {
        self.contentCellVM.updateWith(dealModel: dealModel)
    }
}

// MARK: Private Methods
private extension JRCBDeelsNVoucherDetailVC {
    func addLoader() {
        if animationView.superview != self.view {
            animationView.frame = CGRect(x: 0, y: 100, width: 100, height: 30)
            animationView.center = self.view.center
            self.view.addSubview(animationView)
            self.view.bringSubviewToFront(animationView)
        }
        animationView.play()
    }
    
    func refreshUI() {
        tHeader?.setIcon(url: self.contentCellVM.iconUrl, placeHolder: self.contentCellVM.mIconPlaceholder)
        tHeader?.setBackground(url: self.contentCellVM.bannerImgUrl, placeHolder: nil)
        self.table.reloadData()
    }
    
    func fetchDetails() {
        if !self.detailInput.callAPI {
            self.refreshUI()
            return
        }
        
        self.addLoader()
        contentCellVM.fetchDetailWith(input: self.detailInput) { [weak self] (success, error) in
            DispatchQueue.main.async {
                self?.animationView.removeFromSuperview()
                if let error = error, let msg = error.message {
                    JRAlertPresenter.shared.presentSnackBar(title: error.title ?? "", message: msg,
                                                            autoDismiss: true, actions: nil, dismissHandler: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                else {
                    self?.refreshUI()
                }
            }
        }
    }
    
    func redirectToRedeemDeeplink() {
        if let dLink = self.contentCellVM.deepLink, dLink.trimmingCharacters(in: .whitespaces) != "" {
            
            let labelsArray = ["event_label": "",
                               "event_label2": JRCOConstant.GA_SCREENTYPE_MYVOUCHER,
                               "event_label3": ""]
            
            JRCBAnalytics(screen: .screen_CashbackOfferVouchersListing, vertical: .vertical_MyVoucherCashback,
                          eventType: .eventCustom, category: .cat_MyVoucher,
                          action: .act_RedeemNowClicked, labels: labelsArray).track()
            openDeeplink(urlString: dLink)
        }
    }
}
private func openDeeplink(urlString: String){
    if let url: URL = URL(string : urlString)
    {
        let application:UIApplication = UIApplication.shared
        if application.canOpenURL(url) {
            application.open(url, options: [:], completionHandler: nil)
            return
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate, JRCBVoucherDetailBaseCellDelegate
extension JRCBDeelsNVoucherDetailVC: UITableViewDataSource, UITableViewDelegate, JRCBVoucherDetailBaseCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentCellVM.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JRCBDeelNVoucherDetailCell.cellId, for: indexPath) as! JRCBDeelNVoucherDetailCell
        cell.show(info: self.contentCellVM)
        cell.delegate = self
        return cell
    }

    // JRCBVoucherDetailBaseCellDelegate
    func cbVoucherDetailDidClickCopy() {
         let labelsArray = ["event_label": "",
                            "event_label2": JRCOConstant.GA_SCREENTYPE_MYVOUCHER,
                            "event_label3": ""]
         
         JRCBAnalytics(screen: .screen_CashbackOfferVouchersListing,
                       vertical: .vertical_MyVoucherCashback, eventType: .eventCustom, category: .cat_MyVoucher,
                       action: .act_VoucherCodeCopyClicked, labels: labelsArray).track()
         
        if let code = self.contentCellVM.mPromoCode, code.caseInsensitiveCompare(JRCBConstants.Common.kNoCouponCodeText) != .orderedSame {
            UIPasteboard.general.string = code
            self.showToastMessage(message: JRCBConstants.Symbol.kVoucherCopied)
        }
    }
    
    func cbVoucherDetailDidClickCTA() {
        guard let code = self.contentCellVM.mPromoCode else { return }
        UIPasteboard.general.string = code
        let message = "Please paste your code in the 'Apply Promocode' section to avail offer before placing your order"
        UIAlertController.cbShowWith(title: "Code Copied!", body: message, btnTitles: ["Proceed", "Cancel"],
                                     onController: self, isSheetStyle: true) { (index) in
                                        if index == 0 {
                                            self.redirectToRedeemDeeplink()
                                        }
        }
    }
    
    
    func cbVoucherDetailDidClickDetail() { // TnC
        if let tncModel = contentCellVM.tncModel {
            let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
            self.view.addSubview(tncPopupView)
            tncPopupView.showPopUpDealCrossPromo(tncModel: tncModel)
        } else {
            guard JRCBCommonBridge.isNetworkAvailable else {
                let err = JRCBError.networkError
                JRAlertPresenter.shared.presentSnackBar(title: err.title ?? "", message: err.message ?? "", autoDismiss: true, actions: nil, dismissHandler: nil)
                return
            }
            let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
            self.view.addSubview(tncPopupView)
            tncPopupView.showTermsAndCondition(tncURL: self.contentCellVM.tnc ?? "")
        }
    }
}

