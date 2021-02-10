//
//  PostTransactionVC.swift
//  jarvis-cashback-ios_Example
//
//  Created by Rahul Kamra on 13/06/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import jarvis_cashback_ios
import jarvis_storefront_ios

class PostTransactionVC: CBExampleBaseVC {

    @IBOutlet weak private var table: UITableView!
   
    class var instance : PostTransactionVC {
        return PostTransactionVC.storyB.instantiateViewController(withIdentifier: "PostTransactionVC") as! PostTransactionVC
    }

    override func viewDidLoad() {
        JRCashbackManager.shared.shouldMock = true
        self.checkTabbar()
    }
    
    
    @IBAction private func backClicked(_ sender: UIButton) {
        JRCashbackManager.shared.shouldMock = false
        self.navigationController?.popViewController(animated: true)
    }
    
    private func presentScratchCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let txnIds = JRCBPostTxnID.idsWith(orderId: "20200306111212800110168531017923857",
                                               pgTransId: "7898", upiTransId: nil, walletTransId: nil)
            
            let aParam = JRCBPostTxnBannerParams.paramWith(txnIds: txnIds, transType: .order,
                                                           verticalID: "4", categoryID: "21",
                                                           merchantCat: "")
            JRCBManager.addBannerWith(param: aParam, delegate: self)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PostTransactionVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTransactionNormalCell.cellId) as! PostTransactionNormalCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presentScratchCard()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}




// MARK: - JRCBPostTxnBannerDelegate
extension PostTransactionVC: JRCBPostTxnBannerDelegate {
    func cbPostTxnBannerContainVC() -> UIViewController? { return self }
    
    func cbDidFinishPresentAnimation(uniqueId: String, animated: Bool) {
        guard let mTabbar = self.vModel.floatTabbar else { return }
        mTabbar.showDotOnTabItem(uniqueName: uniqueId, animated: animated)
    }
    
     func cbPostTrClosingPoint( uniqueId:String ) -> CGPoint {
        guard let mTabbar = self.vModel.floatTabbar else { return CGPoint(x: -1, y: -1) }
        return mTabbar.centerPointForButtonWith(uniqueName: uniqueId)
    }
}


class PostTransactionNormalCell: UITableViewCell {
     class var cellId: String {
        return "kPostTransactionNormalCell"
    }
}


