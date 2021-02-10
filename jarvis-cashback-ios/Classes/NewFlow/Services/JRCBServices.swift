//
//  JRCBServices.swift
//  jarvis-cashback-ios
//
//  Created by Prateek Prem on 09/01/20.
//

import Foundation
import jarvis_network_ios

class JRCBServices {
    
    class func fetchCashbackAmount(completion: ((Bool, [String : Any]?, String?) -> Void)?) { // add completion block
        guard let mBlock = completion else { return }
        
        let sumDict = ["SUM"]
        let filterDict = ["TXN_TYPE"]
        let reqDict = [
            "from": JRCBRemoteConfig.kCBLandingAmountFromDate.strValue,
            "to": JRCBRemoteConfig.kCBLandingAmountToDate.strValue,
            "metrics": sumDict,
            "filters": filterDict,
            "txnType":"CASHBACK",
            "visualization": "COUNT"] as [String : Any]
        
        let aBody : [String : Any]  = [ "request": reqDict ]
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchUserTransAnalytics, param: nil, body: aBody, appendUrlExt: "")
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp, let respList = mResp["response"] as? [JRCBJSONDictionary], let tDict = respList.first {
                mBlock(true, tDict , nil)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            } else {
                // default handling..
                mBlock(false, nil, "something went wrong.")
            }
        }
    }
    
    class func fetchLandingSFData(completion: ((Bool, [String : Any]?, String?) -> Void)?) { // add completion block
        guard let mBlock = completion else {
            return
        }
        
        let aBody : [String : Any]  = [:]
        
        let aParam: JRCBJSONDictionary = ["user_id": JRCOAuthWrapper.usrIdEitherBlank,
                                          "version": JRUtility.appVersion ?? "8.12.0",
                                          "client": "iosapp"]
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCashbackLandingSF,
                                    param: aParam,
                                    body: aBody, appendUrlExt: "")
        
        JRCBServiceManager.executeAPI(model: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp  as? [String : Any] {
                mBlock(true, mResp , nil)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            } else {
                // default handling..
                mBlock(false, nil, "something went wrong.")
            }
        }
    }
    
    class func fetchLandingUnScratchedCardData(completion: ((Bool, [String : Any]?, String?) -> Void)?) { // add completion block
        guard let mBlock = completion else {
            return
        }
        
        let aBody : [String : Any]  = [:]
        //["remainingTypes": "ACTIVE_OFFER,NEW_OFFER"]
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCashbackCoinList, param: ["userType": "CUSTOMER", "statusList": "UNSCRATCHED,LOCKED"], body: aBody, appendUrlExt: "getCardListByUser")
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp {
                mBlock(true, mResp , nil)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            } else {
                // default handling..
                mBlock(false, nil, "something went wrong.")
            }
        }
    }
    
    class func fetchLandingScratchCardData(completion: ((Bool, [String : Any]?, String?) -> Void)?) { // add completion block
        guard let mBlock = completion else {
            return
        }
        
        let aBody : [String : Any]  = [:]
        //["remainingTypes": "ACTIVE_OFFER,NEW_OFFER"]
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCBLandingScratchCard, param: ["remainingTypes": "ACTIVE_OFFER,NEW_OFFER"], body: aBody, appendUrlExt: "")
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp {
                mBlock(true, mResp , nil)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            } else {
                // default handling..
                mBlock(false, nil, "something went wrong.")
            }
        }
    }
    

    class func fetchLandingCBCoins(completion: ((Bool, JRCBRewardsVM?, String?) -> Void)?) { // add completion block
        guard let mBlock = completion else {
            return
        }
        
        let aBody : [String : Any]  = [:]
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCBCoinSummary,
                                    param: ["category-type": "CASHBACK,PAYTM_FIRST_COINS,STICKER"], body: aBody, appendUrlExt: "")
        
        JRCBServiceManager.executeAPI(model: apiModel) { (success, resp, err) in
            // parse here and handle try catch for data missmatch
            if let mResp = resp as? JRCBJSONDictionary {
                let jsonData =  mResp.toJSONData()
                do {
                    let reward = try JSONDecoder().decode(JRCBRewardsVM.self, from: jsonData)
                    DispatchQueue.main.async {
                        mBlock(true, reward , nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        mBlock(false, nil, error.localizedDescription)
                    }
                }
                
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            } else {
                // default handling..
                mBlock(false, nil, "something went wrong.")
            }
        }
    }
    
    class func fetchCampaignDetailData(campaignId: Int, completion: ((Bool, [String : Any]?, Error?) -> Void)?) {
        guard let mBlock = completion else {
            return
        }
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCampaignDetail, param: nil, appendUrlExt: "\(campaignId)")
        
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp {
                mBlock(true, mResp , nil)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr)
                
            } else {
                // default handling..
                let customError = NSError(domain: "CustomError", code: -1001, userInfo: nil)
                mBlock(false, nil, customError)
            }
        }
    }
    
    class func fetchGameDetailData(gameId: Int, completion: ((Bool, [String : Any]?, Error?) -> Void)?) {
        guard let mBlock = completion else {
            return
        }
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchGameDetail, param: nil, appendUrlExt: "\(gameId)")
        
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp {
                mBlock(true, mResp , nil)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr)
                
            } else {
                // default handling..
                let customError = NSError(domain: "CustomError", code: -1001, userInfo: nil)
                mBlock(false, nil, customError)
            }
        }
    }
    
    class func activateCampaignOrGameAPI(isCampaign: Bool, gameID: String = "", campaignId: String,
                                         completion: ((Bool, JRCBPostTrnsactionData?, String?) -> Void)?) {
        guard let mBlock = completion else {
            return
        }
        var aParam = ["action": "ACCEPT_OFFER"]
        var apiType = JRCBApiType.pathActivateGameV4
        var appndParam : String = ""
        
        if isCampaign {
            apiType = JRCBApiType.pathSelectOfferV4
            aParam["campaign_id"] = campaignId
            
        } else if !gameID.isEmpty {
            appndParam = "/\(gameID)"
        }
        
        let eventType: JRCBAnalyticsEventType = .eventCustom
        let labels: [String: String] = ["event_label": campaignId,
                                        "event_label2": "cashback-landing"]
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: eventType, category: .cat_CashbackOffers, action: .act_ActivateOffersClicked, labels: labels).track()
        
        let apiModel = JRCBApiModel(type: apiType, param: nil, body: aParam, appendUrlExt: appndParam)
        apiModel.updateEncoding(style: .jsonEncodedWithOptions(options: JSONSerialization.WritingOptions.prettyPrinted))
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let model = resp, let data = model["data"] as? JRCBJSONDictionary {
                
                let postTrnsdata = JRCBPostTrnsactionData(dict: data)
                JRCBNotificationName.notifCampainActivated.fireMeWith(userInfo: ["campId": campaignId])

                mBlock(true, postTrnsdata, nil)
                
            } else if let model = resp,
                let arrErrs = model["errors"] as? [JRCBJSONDictionary],
                let fErr = arrErrs.first {
                let errorModel = JRCBCustomErrorModel(dict: fErr)
                let msg = errorModel.message.isEmpty ? JRCBConstants.Common.kDefaultErrorMsg: errorModel.message
                mBlock(false, nil, msg)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            }  else {
                mBlock(false, nil, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    //---------
    class func serviceGetVoucherList(params: JRCBJSONDictionary, completion: @escaping (JRCOMyVoucherResponseModel?, JRCBError?)-> Void) {
        let apiModel = JRCBApiModel(type: JRCBApiType.pathVoucherList, param: params, appendUrlExt: "")
        JRCBServiceManager.executeAPI(type: JRCOMyVoucherResponseModel.self, model: apiModel, isJson: false) { (isSuccess, data, error) in
            
            if let data = data as? JRCOMyVoucherResponseModel {
                if data.status == 200 {
                    completion(data, nil)
                } else {
                    completion(nil, JRCBError.defaultError)
                }
                
            } else {
                completion(nil, JRCBError.defaultError)
            }
        }
    }
    
    class func serviceFetchStorefrontData(completion: @escaping (JRCBJSONDictionary?, JRCBError?) -> Void) {
        let apiModel = JRCBApiModel(type: JRCBApiType.pathPostTxnStoreFrontUrl, param: nil, appendUrlExt: "")
        JRCBServiceManager.executeAPI(model: apiModel) { (isSuccess, data, error) in
            if let data = data as? [String : Any] {
                completion(data, nil)
            } else {
                completion(nil, JRCBError.defaultError)
            }
        }
    }
    
    class func serviceGetFilterList(params: JRCBJSONDictionary, completion: @escaping (JRCOMyVoucherFilterModel?, JRCBError?) -> Void) {
        let apiModel = JRCBApiModel(type: JRCBApiType.pathMyVoucherFilterV1Url, param: params, appendUrlExt: "")
        
        JRCBServiceManager.executeAPI(type: JRCOMyVoucherFilterModel.self, model: apiModel, isJson: false) { (isSuccess, data, error) in
            if let data = data as? JRCOMyVoucherFilterModel {
                if data.status == 200 {
                    completion(data, nil)
                    
                } else {
                    completion(nil, JRCBError.defaultError)
                }
            } else {
                completion(nil, JRCBError.defaultError)
            }
        }
    }
    
    class func serviceGetTnCForPromocodes(tncUrl: String, completion: @escaping (JRCOPromoTnC?, JRCBError?) -> Void) {
        let apiModel = JRCBApiModel(type: JRCBApiType.pathCustomAPI, param: nil, appendUrlExt: "")
        apiModel.update(urlString: tncUrl)
        apiModel.update(dataType: JRDataType.CodableModel)
        
        JRCBServiceManager.executeAPI(type: JRCOPromoTnC.self, model: apiModel, isJson: false) { (isSuccess, data, error) in
            if let data = data as? JRCOPromoTnC {
                if data.termsTitle != "" {
                    completion(data, nil)
                    
                } else {
                    completion(nil, JRCBError.defaultError)
                }
                
            } else {
                completion(nil, JRCBError.defaultError)
            }
        }
    }
    
    class func serviceGetVoucherDetail(voucherCode: String, params: JRCBJSONDictionary,
                                       completion: @escaping (JRCOMyVoucherDetailResponse?, JRCBError?)-> Void) {
        let apiModel = JRCBApiModel(type: JRCBApiType.pathMyVouchersDetailV3Url, param: params, appendUrlExt: "/\(voucherCode)")
        JRCBServiceManager.executeAPI(type: JRCOMyVoucherDetailResponse.self, model: apiModel, isJson: false) { (isSuccess, data, error) in
            
            if let data = data as? JRCOMyVoucherDetailResponse {
                if data.status == 200 {
                    completion(data, nil)
                    
                } else if data.status == 400 && data.error?.count ?? 0 > 0 {
                    let ttl = data.error?[0].messsage ?? "jr_co_default_msg_title".localized
                    let err = JRCBError(aTitle: ttl, aMessage: "")
                    completion(nil, err)
                    
                } else {
                    completion(nil, JRCBError.defaultError)
                }
                
            } else {
                completion(nil, JRCBError.defaultError)
            }
        }
    }
    //---------

    //MARK: - FLIP API
    class func fetchFlipResponse(refId: String, completion: ((Bool, JRCBPostTrnsactionData?, String?) -> Void)?) {
        if JRCashbackManager.shared.shouldMock { // Mock...
            if let mResp = JRCBMockUtils.kJRCBFlipTxnResponse.getDictFromBundle().dict {
                if let data = mResp["data"] as? JRCBJSONDictionary {
                    let postTrnsdata = JRCBPostTrnsactionData(dict: data)
                    completion?(true, postTrnsdata, nil)
                }
                return
            }
        }
        
        guard let mBlock = completion else {
            return
        }
        let apiType = JRCBApiType.pathActivateGameV4
        let param = ["eventId": refId,
                     "eventType": "FLIP"]
        let apiModel = JRCBApiModel(type: apiType, param: nil, body: param, appendUrlExt: "/eventOffer")
        apiModel.updateEncoding(style:  .jsonEncodedWithOptions(options: JSONSerialization.WritingOptions.prettyPrinted))
        
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let model = resp, let data = model["data"] as? JRCBJSONDictionary {
                
                let postTrnsdata = JRCBPostTrnsactionData(dict: data)
                
                mBlock(true, postTrnsdata, nil)
                
            } else if let model = resp,
                let arrErrs = model["errors"] as? [JRCBJSONDictionary],
                let fErr = arrErrs.first {
                let errorModel = JRCBCustomErrorModel(dict: fErr)
                let msg = errorModel.message.isEmpty ? JRCBConstants.Common.kDefaultErrorMsg: errorModel.message
                mBlock(false, nil, msg)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            }  else {
                mBlock(false, nil, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    
    class func getUserMerchantId(completion: ((Bool, String) -> Void)?) {
        guard let mBlock = completion else {
            return
        }
        let apiType = JRCBApiType.pathGetMerchantContext
        let apiModel = JRCBApiModel(type: apiType, param: nil, body: nil, appendUrlExt: "")
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            if success, let dict = resp {
                if let merchants = dict["merchants"] as? [JRCBJSONDictionary] {
                    if merchants.count > 0{
                        let firstObj = merchants[0]
                        if let mId = firstObj["mid"] as? String {
                            mBlock(true, mId)
                        }
                    }
                }
                mBlock(false, "")
            } else {
                mBlock(false, "")
            }
        }
    }
    
    class func fetchAppOpenData(param: JRCBJSONDictionary, completion: ((Bool, [String : Any]?, Error?) -> Void)?) {
        guard let mBlock = completion else {
            return
        }
        
        let apiType = JRCBApiType.pathActivateGameV4
        let apiModel = JRCBApiModel(type: apiType, param: nil, body: param, appendUrlExt: "/eventOffer")
        apiModel.updateEncoding(style: .jsonEncodedWithOptions(options: JSONSerialization.WritingOptions.prettyPrinted))

        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let model = resp {
                mBlock(false, model, err)
            } else {
                mBlock(false, nil, nil)

            }
        }
    }
    
    // New Data
    
    class func fetchReferralInformation(tag: String, completion: ((Bool, [String : Any]?, String?) -> Void)?) { // add completion block
           guard let mBlock = completion else {
               return
           }
           
           let aBody : [String : Any]  = [:]
            let aParam: JRCBJSONDictionary = ["user_id": JRCOAuthWrapper.usrIdEitherBlank,
                                             "version": JRUtility.appVersion ?? "8.12.0",
                                             "client": "iosapp", "tag": tag]
           let apiModel = JRCBApiModel(type: JRCBApiType.referralLanding,
                                       param: aParam,
                                       body: aBody, appendUrlExt: "")
           
           JRCBServiceManager.executeAPI(model: apiModel) { (success, resp, err) in
               // parse here..
               if let mResp = resp  as? [String : Any] {
                   mBlock(true, mResp , nil)
                   
               } else if let mErr = err {
                   mBlock(false, nil, mErr.localizedDescription)
                   
               } else {
                   // default handling..
                   mBlock(false, nil, "something went wrong.")
               }
           }
       }
    
    class func fetchlinkInformation(campaigne: String,completion: ((Bool, [String : Any]?, String?) -> Void)?) { // add completion block
        guard let mBlock = completion else {
            return
        }
        
        let aBody : [String : Any]  = [:]
        
       let aParam: JRCBJSONDictionary = ["identifier": campaigne,
                                          "version": JRUtility.appVersion ?? "8.12.0",
                                          "client": "iosapp"]
        let apiModel = JRCBApiModel(type: JRCBApiType.referrallink,
                                    param: aParam,
                                    body: aBody, appendUrlExt: "")
        
        JRCBServiceManager.executeAPI(model: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp  as? [String : Any] {
                mBlock(true, mResp , nil)
                
            } else if let mErr = err {
                mBlock(false, nil, mErr.localizedDescription)
                
            } else {
                // default handling..
                mBlock(false, nil, "something went wrong.")
            }
        }
    }
    
    class func saveShortURL(code: String, url: String, completion: ((String?) -> Void)?) {
        guard let mBlock = completion else {
             return
         }
         
         let aBody : [String : Any]  = [:]
         
        let aParam: JRCBJSONDictionary = ["link": code,
                                           "short_url": url]
        let apiModel = JRCBApiModel(type: JRCBApiType.saveShortURL,
                                     param: aParam,
                                     body: aBody, appendUrlExt: "")
        
        JRCBServiceManager.executeAPI(model: apiModel) { (success, resp, err) in
            // parse here..
            if let _ = resp  as? [String : Any] {
                mBlock(url)
                
            } else if let mErr = err {
                mBlock(mErr.localizedDescription)
            } else {
                // default handling..
                mBlock("")
            }
        }
    }
}


class JRCBCustomErrorModel {
    var status: Int = 0
    var code: String = ""
    var message: String = ""
    var title: String = ""
    var errorCode: String = ""
    
    init(dict: JRCBJSONDictionary) {
        self.status = dict.getIntKey("status")
        self.code = dict.stringFor(key: "code")
        self.message = dict.getStringKey("message")
        self.title = dict.getStringKey("title")
        self.errorCode = dict.getStringKey("errorCode")
    }
    
    init(title: String?, message: String?) {
        if let str = title { self.title = str }
        if let str = message { self.message = str }
    }
}
