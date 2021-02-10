//
//  JRCBLandingTableHeaderVM.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 11/06/20.
//

import Foundation

class JRCBLandingTableHeaderRaw {
    private(set) var rawTtl = ""
    private(set) var rValue = ""
    private(set) var rIcon = ""
    private(set) var rSubTitle = ""
    private(set) var isLoading = true
    private(set) var rDeeplink : String?
    
    init(title: String, value: String, img: String, subTitle: String, loading: Bool, deeplink: String? = nil) {
        self.update(title: title, value: value, img: img, loading: loading)
        self.rSubTitle = subTitle
        self.rDeeplink = deeplink
    }
    
    func update(title: String, value: String, img: String, loading: Bool) {
        self.rawTtl = title
        self.rValue = value
        self.rIcon = img
        self.isLoading = loading
    }
    
    func update(rewardSummary: Summary) {
        self.update(amount: rewardSummary.amount)
        if rewardSummary.catType == .sticker {
            if rewardSummary.amount > -1 {
                self.rSubTitle = ""
            } else {
                self.rSubTitle = "jr_CB_StickerStartCollectionText".localized
            }
        }
//        if let categoryMessage = rewardSummary.categoryMessage {
//            self.rSubTitle = categoryMessage
//        }
        if let icon = rewardSummary.icon {
            self.rIcon = icon
        }
        self.rDeeplink = rewardSummary.deeplink
    }
    
    func update(amount: Int) {
        if amount > -1 {
          self.rValue = amount.formattedWithSeparator
        }
    }
}



protocol JRCBLandingTableHeaderVMDelegate: class {
    func cbLandingRefreshCBAndPoints()
    func cbLandingRefreshSticker()
}

class JRCBLandingTableHeaderVM {
    
    private(set) var cashBackInfo = JRCBLandingTableHeaderRaw(title: "jr_CB_TotalCashbackWon".localized,
                                                              value: "", img: "",
                                                              subTitle: "", loading: true)
    private(set) var pointInfo = JRCBLandingTableHeaderRaw(title: "jr_CB_PaytmFirstPoints".localized,
                                                           value: "", img: "",
                                                           subTitle: "", loading: true)
    private(set) var stickerInfo = JRCBLandingTableHeaderRaw(title: "jr_CB_YourSticker".localized,
                                                           value: "", img: "",
                                                           subTitle: "jr_CB_StickerStartCollectionText".localized, loading: true)
//    private(set) var stickerInfo = JRCBLandingTableHeaderRaw(title: "jr_CB_YourSticker".localized,
//                                                             value: "", img: "",
//                                                             subTitle: "jr_CB_YourStickerViewAll".localized, loading: true,
//                                                             deeplink: JRCBRemoteConfig.kCBViewAllStickerDeeplink.strValue)
    private(set) var voucherInfo = JRCBLandingTableHeaderRaw(title: "jr_CB_VoucherNDealTitle".localized,
                                                             value: "", img: "",
                                                             subTitle: "jr_CB_VoucherNDealSubTitle".localized , loading: true)
    
   weak var delegate: JRCBLandingTableHeaderVMDelegate?
    
    func refreshData() {
        self.fetchRewards()
        // fetch the sticker here..with dispatch group
    }
    
    private func fetchRewards() {
        JRCBServices.fetchLandingCBCoins { [weak self] (success, reward, error) in
            if success, let rew = reward, let data = rew.data, let items = data.summary, items.count > 0 {
                self?.updateRewardsWith(reward: rew)
                self?.delegate?.cbLandingRefreshCBAndPoints()
                
                // move to API call for sticker
              //  self?.stickerInfo.update(amount: 1000)
               // self?.delegate?.cbLandingRefreshSticker()
            }
        }
    }
    
    func updateRewardsWith(reward: JRCBRewardsVM) {
        guard let rSummaries = reward.data?.summary, rSummaries.count > 0 else { return }
        for mSummary in rSummaries {
            if mSummary.catType == .cashback {
                cashBackInfo.update(rewardSummary: mSummary)
            } else if mSummary.catType == .coin {
                pointInfo.update(rewardSummary: mSummary)
            } else if mSummary.catType == .sticker {
                stickerInfo.update(rewardSummary: mSummary)
            }
        }
    }
}
