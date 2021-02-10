//
//  JRCBPostTxnManager.swift
//  Bolts
//
//  Created by Prakash Jha on 22/06/20.
//

import Foundation

public protocol JRCBPostTxnBannerDelegate {
    func cbPostTxnBannerContainVC() -> UIViewController?
    func cbDidFinishPresentAnimation(uniqueId: String, animated: Bool)
    func cbPostTrClosingPoint(uniqueId:String ) -> CGPoint
    func cbPostTxnBannerContainVCIsOnTop() -> Bool
    func cbDidFailToPresentAniation()
}

public extension JRCBPostTxnBannerDelegate {
    func cbDidFinishPresentAnimation(uniqueId: String, animated: Bool) {}
    func cbPostTrClosingPoint( uniqueId:String ) -> CGPoint {
        return CGPoint(x: -1, y: -1)
    }
    
    func cbPostTxnBannerContainVCIsOnTop() -> Bool {
        return true
    }
    
    func cbDidFailToPresentAniation() {}
}

typealias JRCBPostTxnManagerCompletion = (_ success: Bool, _ contentList: [JRCBScratchContentVM]) -> Swift.Void



class JRCBPostTxnManager {
    private var retryCount: Int = 0
    private var totalRetry: [Int] = JRCBRemoteConfig.postTransRetryList
    
    func addBannerWith(param: JRCBPostTxnBannerParams, delegate: JRCBPostTxnBannerDelegate)  {
        retryCount = 0
        let dispatchTime = Double(exactly: totalRetry[retryCount]) ?? 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
            self.getCardsWith(param: param, delegate: delegate)
        }
    }
    
     func getCardsWith(param: JRCBPostTxnBannerParams, delegate: JRCBPostTxnBannerDelegate?) {
        if retryCount < totalRetry.count {
            param.getPostTransDetail(retryAttempt: "\(retryCount)") { [weak self] (transData, errMsg) in
                if let superData = transData {
                    if superData.status == 1, let mTransData = superData.data {
                        self?.retryCount = 0
                        DispatchQueue.main.async {
                            JRCBPostTxnManager.showPostTransViewWith(transInfo: mTransData, delegate: delegate)
                        }
                        
                    } else if superData.status == 0 {
                        guard let mSelf = self else {
                            return
                        }
                        guard mSelf.retryCount < mSelf.totalRetry.count else {
                            delegate?.cbDidFailToPresentAniation() //Error Case
                            return
                        }
                        
                        if superData.error.count > 0 {
                            let firstErrorObj = superData.error[0]
                            if firstErrorObj.status == JRCBConstants.ScractchCard.kRetryErrorStatus,
                                firstErrorObj.errorCode == JRCBConstants.ScractchCard.kRetryErrorCode {
                                // HIT API Again
                                let dispatchTime = Double(exactly: mSelf.totalRetry[mSelf.retryCount]) ?? 1.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                    mSelf.retryCount += 1
                                    mSelf.getCardsWith(param: param, delegate: delegate)
                                }
                            }
                        }
                    } else  {
                        // show error
                        delegate?.cbDidFailToPresentAniation() //Error Case
                    }
                }
            }
        }
    }
}
    


extension JRCBPostTxnManager {
    class func showPostTransViewWith(transInfo: JRCBPostTrnsactionData, delegate: JRCBPostTxnBannerDelegate?, triggerType: JRCBCardTriggerType = .postTransaction) {
        if transInfo.gameStatus == .gmInProgress || transInfo.gameStatus == .gmCompleted {
            guard let del = delegate else { return } // let transInfo = dataModel.currentTransInfo
            guard let rVC = del.cbPostTxnBannerContainVC() else { return }
            guard let allGratification = transInfo.currentTransInfo?.stageObject?.gratifications,
                allGratification.count > 0 else { return }
            
            var contentItems = [JRCBScratchContentVM]()
            allGratification.forEach { (grat) in
                let viewModel = JRCBScratchContentVM(modelData: grat, assuredOfferName: transInfo.mCampain?.offer_text_override ?? "")
                if grat.isAssuredCard, viewModel.cardType == .betterLuckNextTime {
                    //Do nothing
                } else {
                    viewModel.setCampaignId(campId: transInfo.mCampain?.campId)
                    viewModel.setIsFromScratchCardSection(false)
                    viewModel.setCardTriggerType(triggerType)
                    contentItems.append(viewModel)
                }
            }
            
            if contentItems.count > 0 {
                JRCBPostTxnManager.getScratchCardBy(models: contentItems) { (success, contentList) in
                    DispatchQueue.main.async {
                        if del.cbPostTxnBannerContainVCIsOnTop() {
                            let tView = JRCBScratchCardContainerView.containerWith(superBound: rVC.view.bounds)
                            rVC.view.addSubview(tView)
                            tView.tag = 1001
                            tView.setUpWith(delegate: delegate, contentVMs: contentList)
                        } else {
                            del.cbDidFinishPresentAnimation(uniqueId: JRCBManager.kCBSFTabUniqueID, animated: false)
                        }
                    }
                }
            }
            
        }
    }
    
    class func getIdsFrom(models: [JRCBScratchContentVM]) -> String {
        let allScraths = models.filter() { return $0.modelData.isUnlockedScratchCard }
        if allScraths.count > 0 {
            var sIds: [String] = []
            for sInfo in allScraths {
                if let redModel = sInfo.modelData.redumptionInfo as? JRCBRedumptionScratchCard {
                    sIds.append(redModel.scratchId)
                }
            }
            
            if sIds.count == 0 { return "" }
            
            let appendId = sIds.joined(separator: ",")
            return appendId
        }
        return ""
    }
    
     //Hit scratchCardById for first object if firstObj == UNSCRATCHED_CARD
    class func getScratchCardBy(models: [JRCBScratchContentVM], completion: JRCBPostTxnManagerCompletion?) {
        guard models.count > 0 else {
            completion?(true, models)
            return
        }
        
        let appendId = JRCBPostTxnManager.getIdsFrom(models: models)
        guard !appendId.isEmpty else {
            completion?(true, models)
            return
        }
        
        if JRCashbackManager.shared.shouldMock { // Mock...
            if let mResp = JRCBMockUtils.kJRCBScratchCardBYID_bunch.getDictFromBundle().dict {
                if let tDict = mResp["data"] as? JRCBJSONDictionary,
                    let scList = tDict["scratchCardList"] as? [JRCBJSONDictionary] {
                    JRCBPostTxnManager.updateItemsWith(models: models, list: scList, completion: completion)
                    return
                }
            }
            completion?(true, models)
        }
        
        
        let mParam: JRCBJSONDictionary? = ["scratchCardIds": appendId]
        let apiModel = JRCBApiModel(type: JRCBApiType.pathScratchCardById, param: mParam, appendUrlExt: "getCardListByIds")
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            var dList = [JRCBJSONDictionary]()
            if let mResp = resp, let tDict = mResp["data"] as? JRCBJSONDictionary,
                let scList = tDict["scratchCardList"] as? [JRCBJSONDictionary] {
               dList = scList
            }
             JRCBPostTxnManager.updateItemsWith(models: models, list: dList, completion: completion)
        }
    }
    
    class func updateItemsWith(models: [JRCBScratchContentVM], list: [JRCBJSONDictionary], completion: JRCBPostTxnManagerCompletion?) {
        let allScraths = models.filter() { return $0.modelData.isUnlockedScratchCard }
        if allScraths.count == 0 { return }
        if list.count == 0 { return }
        
        for tDict in list {
            let aScraths = allScraths.filter() { return $0.scratchId == tDict.getStringKey("id")}
            if let frst = aScraths.first {
                frst.updatewith(grDist: tDict)
            }
        }
        completion?(true, models)
    }
}
