//
//  JRCBHomeScreenRouter.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 16/07/20.
//

import UIKit
import jarvis_storefront_ios

class JRCBHomeScreenRouter: JRCBScreenRouter {
    func handleClickSFSDK(item: SFLayoutItem?, tableIndex: Int, collectIndex: Int, type: LayoutViewType) {
        guard let sItem = item else { return }
      
        var eventType: JRCBAnalyticsEventType = .eventCustom
        var analyticsAction: JRCBAnalyticsAction = .act_None
        var labels: [String: String] = [:]
        var eventCategory: JRCBAnalyticsCategory = .cat_CashbackOffers
        defer {
            //JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: eventType, category: eventCategory, action: analyticsAction, labels: labels).track()
        }
        
        switch type {
        case .listSmallTi:
            analyticsAction = .act_OfferCategoryClicked
            //TODO: Sidd
            labels["event_label"] = sItem.itemName
            JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(sItem.itemUrl, isAwaitProcessing: false)
//            JRCBScreenRouter.handle(deeplink: sItem.itemUrl, navVC: self.rDelegate?.screenRouterHostNavVC(),
//                                    extraParam: [:])
            
        case .lCBOffers:
            analyticsAction = .act_TopOfferCardClicked
            JRCBScreenRouter.handle(deeplink: sItem.itemUrl, navVC: self.rDelegate?.screenRouterHostNavVC(),
                                    extraParam: [:])
        
        case .thinBanner, .banner3_0: //call deeplink here (invite friend)
            JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(sItem.itemUrl, isAwaitProcessing: false)
        default:
             JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(sItem.itemUrl, isAwaitProcessing: false)
        }
    }
}


// MARK: - JRCBLandingTableHeaderActionDelegate
extension JRCBHomeScreenRouter: JRCBLandingTableHeaderActionDelegate {
    func landingTableHeaderDidClickCashback() {
        let vc = JRCBPointListVC.newInstance(type: .listCashbackEarned)
        self.rDelegate?.screenRouterHostNavVC()?.pushViewController(vc, animated: true)
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: .eventCustom,
                      category: .cat_CashbackOffers, action: .act_CashbackSummaryClicked, labels: [:]).track()
    }
    
    func landingTableHeaderDidClickPoint() {
        let vc = JRCBPointListVC.newInstance(type: .listPointsEarned)
        self.rDelegate?.screenRouterHostNavVC()?.pushViewController(vc, animated: true)
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback,
                      eventType: .eventCustom, category: .cat_CashbackOffers, action: .act_PointsSummaryClicked, labels: [:]).track()
    }
    
    func landingTableHeaderDidClickVoucher() {
        let vc = JRCBVoucherDealsListVC.newInstance
         self.rDelegate?.screenRouterHostNavVC()?.pushViewController(vc, animated: true)
        
       //self.openGridWith(type: .tVouchers, title: nil)
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: .eventCustom,
                      category: .cat_CashbackOffers, action: .act_MyVouchersClicked, labels: [:]).track()
    }
    
    func landingTableHeaderOpen(deeplink: String) {
        JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(deeplink, isAwaitProcessing: false)
    }
    
    func openGridWith(type: JRCBGridViewType, title: String?) {
        let vc = JRCBGridVC.newInstance
        var hInfo = type.defaultHeaderInfo
        if let mTtl = title {
            hInfo.set(subTtl: mTtl)
        }
        vc.setGrid(type: type, headerInfo: hInfo)
        self.rDelegate?.screenRouterHostNavVC()?.pushViewController(vc, animated: true)
    }
}

// MARK: - JRCBLandingTableCellDelegate
extension JRCBHomeScreenRouter: JRCBLandingTableCellDelegate {
   
    func cbLandingTableCellDidClick(row: Int, inCell: JRCBLandingTableCell) {
        let aLayout = inCell.layoutInfo
        guard JRCBSFLayout.locallySupportedLayouts.contains(aLayout.lType) else { return }
        
        if aLayout.lItems.count <= row { return }      // just for safe
        let sItem = aLayout.lItems[row]
        
        let eventType: JRCBAnalyticsEventType = .eventCustom
        var analyticsAction: JRCBAnalyticsAction = .act_None
        var labels: [String: String] = [:]
        var eventCategory: JRCBAnalyticsCategory = .cat_CashbackOffers
        defer {
            JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: eventType, category: eventCategory, action: analyticsAction, labels: labels).track()
        }
        
        if sItem.rIsViewAll {
            let vc = JRCBGridVC.newInstance
            let aType: JRCBGridViewType = aLayout.lType == .lCBScratchCards ? .tAllScratchCard : .tAllLockedCard
            let hInfo = aType.defaultHeaderInfo
            vc.setGrid(type: aType, headerInfo: hInfo)
            self.rDelegate?.screenRouterHostNavVC()?.pushViewController(vc, animated: true)
            return
        }
        
        
        if let mItem = sItem as? JRCBLandingScratchCardInfo {
            labels["event_label"] = mItem.sType.rawValue
            //TODO: Sidd
            if mItem.sType == .sTypeUnscratchCard {
                if let model = mItem.unscratchedCardData {
                    let cardType = JRCBCardType.getCardTypeForScratchCard(modelData: model)
                    if cardType != .unknown, let vc = self.rDelegate?.screenRouterHostVC() {
                        let gratf = JRCBGratification(redumpInfo: model)
                        JRCBScratchCardContainerFullScreen.display(gratification: gratf, fromController: vc)
                    }
                }
                
            } else if mItem.sType == .sTypeNew_Offer || mItem.sType == .sTypeActiveOffer {
                let vc = JRCBGameDetailsVC.newInstance
                vc.isPresented = true
                
                if let metaData = mItem.newOfferData {
                    labels["event_label2"] = metaData.campId
                    analyticsAction = .act_LockedCardsClicked
                    metaData.cardConfig = mItem.cardConfig
                    vc.viewModel = JRCBGameDetailsVM(campaignData: metaData, bgImage: mItem.bgImage)
                    vc.viewModel.setCard(config: mItem.cardConfig)
                    
                } else if let metaData = mItem.activeOfferData {
                    labels["event_label2"] = metaData.mCampain?.campId
                    analyticsAction = .act_LockedCardsClicked
                    vc.viewModel = JRCBGameDetailsVM(postTransData: metaData, bgImage: mItem.bgImage)
                    vc.viewModel.setCard(config: mItem.cardConfig)
                }
                let navVC = UINavigationController(rootViewController: vc)
                self.rDelegate?.screenRouterHostVC()?.present(navVC, animated: true, completion: nil)
                
            } else if mItem.sType == .sTypeLockdCard {
                //LOCKED CARD
                if let model = mItem.lockedCardData {
                    let cardType = JRCBCardType.getCardTypeForScratchCard(modelData: model)
                    if cardType != .unknown, let vc = self.rDelegate?.screenRouterHostVC() {
                        let gratf =  JRCBGratification(redumpInfo: model)
                        JRCBScratchCardContainerFullScreen.display(gratification: gratf, fromController: vc)
                    }
                }
                analyticsAction = .act_LockedCardsClicked
            }
        }
    }
}
