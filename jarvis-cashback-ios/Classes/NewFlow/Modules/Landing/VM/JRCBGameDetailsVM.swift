//
//  JRCBGameDetailsVM.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/01/20.
//

import Foundation



class JRCBGameDetailsVM {
    enum ContentType: Int {
        case one = 1
        case two = 2
        case three = 3
    }
    
    //This VM can be derive with two data i.e. Game data and campaign data.
    //Need to switch accordingly.
    private var gameDataModel: JRCBPostTrnsactionData?
    private var campaignModel: JRCBCampaign?
    private var bgImage: String?
    
    var contentType: ContentType = .one
    private var shouldShowGameProgress = true
    
    func setCard(config: JRCBScratchConfigEnum) {
        self.campaignModel?.cardConfig = config
        self.gameDataModel?.mCampain?.cardConfig = config
    }
    
    convenience init(postTransData: JRCBPostTrnsactionData, bgImage: String? = nil) {
        self.init()
        
        self.gameDataModel = postTransData
        self.bgImage = bgImage
        setValuesForGameData(gameData: postTransData)
    }
    
    convenience init(campaignData: JRCBCampaign?, bgImage: String? = nil) {
        self.init()
        
        self.campaignModel = campaignData
        self.bgImage = bgImage
        shouldShowGameProgress = false
        contentType = .two
    }
    
    
    private func setValuesForGameData(gameData: JRCBPostTrnsactionData) {
        let showGameProgress = gameData.mCampain?.show_game_progress ?? true
        if gameData.total_txn_count == 1 || showGameProgress == false {
            shouldShowGameProgress = false
            contentType = .two
        } else {
            shouldShowGameProgress = true
            contentType = .three
        }
    }
    
    func getCellIdentifier(row: Int) -> String? {
        if row == 0 {
            return JRCBGameDetailsTVCOne.identifier
        }
        
        if row == 1 {
            if shouldShowGameProgress {
                return JRCBGameDetailsTVCTwo.identifier
            }
            return JRCBGameDetailsTVCThree.identifier
        }
        
        if row == 2 {
            return JRCBGameDetailsTVCThree.identifier
        }
        
        return nil
    }
    
    func loadData(cell: JRCBGameDetailsTVC) {
        cell.backGroundImage = self.bgImage
        if let game = self.gameDataModel {
            cell.loadData(data: game)
        } else if let campaign = self.campaignModel {
            cell.loadData(data: campaign)
        }
    }
    
    func getFooterViewText() -> String {
        if let model = gameDataModel {
            if model.gameStatus == .gmInProgress || model.gameStatus == .gmInitialized {
                return  model.getExpiryDate()
            }
        } else if let campModel = campaignModel {
            return campModel.getExpiryDate()
        }
        return ""
    }
    
    func ctaBtnClicked(completion: JRCBDeeplinkVMCompletion?) {
        if let gameDataModel = self.gameDataModel {
            if let campaignModel = gameDataModel.mCampain {
                if gameDataModel.gameStatus == .gmInitialized, campaignModel.auto_activate == false {
                    self.activateGameAPI(campaignId: campaignModel.campId, gameId: gameDataModel.dataId) { (success, err) in
                        completion?(success, err, "")
                    }
                } else {
                    if campaignModel.isDeeplink {
                        self.performGAForTxnCtaClicked(campId: campaignModel.campId)
                        completion?(true, "", campaignModel.deeplink_url)
                    }
                }
            }
        } else if let campaignModel = self.campaignModel {
            if campaignModel.auto_activate {
                if campaignModel.isDeeplink {
                    self.performGAForTxnCtaClicked(campId: campaignModel.campId)
                    completion?(true, "", campaignModel.deeplink_url)
                }
            } else {
                self.activateCampaignAPI(campaignId: campaignModel.campId) { (success, err) in
                    completion?(success, err, "")
                }
            }
        }
    }
    
    private func performGAForTxnCtaClicked(campId: String) {
        let eventType: JRCBAnalyticsEventType = .eventCustom
        let labels: [String: String] = ["event_label": campId,
                                        "event_label2": "cashback-landing"]
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: eventType, category: .cat_CashbackOffers, action: .act_TransactionCtaClicked, labels: labels).track()
    }
    
    func getTnCDetailModel() -> JRCBOfferDetailModel? {
        if let game = self.gameDataModel {
            return JRCBOfferDetailModel(model: game)
        } else if let campaignModel = self.campaignModel {
             return JRCBOfferDetailModel(model: campaignModel)
        }
        return nil
    }
    
    // MARK: - CATEGORIES CAMPAIGNS ACTIVATE API
    private func activateCampaignAPI(campaignId: String, completion: JRCBVMCompletion?) {
        
        JRCBServices.activateCampaignOrGameAPI(isCampaign: true, campaignId: campaignId) {[weak self] (success, postData, errorMsg) in
            if success, let postTrnsData = postData {
                self?.gameDataModel = postTrnsData
                self?.gameDataModel?.mCampain?.auto_activate = true
                self?.campaignModel = nil
                self?.setValuesForGameData(gameData: postTrnsData)
                completion?(true, "")
            } else if let msg = errorMsg {
                completion?(false, msg)
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    // MARK: - CATEGORIES GAME ACTIVATE API
    private func activateGameAPI(campaignId: String, gameId: String, completion: JRCBVMCompletion?) {
        
        JRCBServices.activateCampaignOrGameAPI(isCampaign: false, gameID: gameId, campaignId: campaignId) {[weak self] (success, postData, errorMsg) in
            if success, let postTrnsData = postData {
                self?.gameDataModel = postTrnsData
                self?.gameDataModel?.mCampain?.auto_activate = true
                self?.campaignModel = nil
                self?.setValuesForGameData(gameData: postTrnsData)
                completion?(true, "")
            } else if let msg = errorMsg {
                completion?(false, msg)
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
}
