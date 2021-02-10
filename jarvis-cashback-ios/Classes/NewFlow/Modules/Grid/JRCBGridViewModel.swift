//
//  JRCBGridViewModel.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 23/01/20.
//

import UIKit


enum JRCBGridViewType: String {
    case tVouchers       = "tVouchers"         // voucher & Deal
    case tDeals          = "tDeals"            // voucher & Deal
    case tExpiredVoucher = "tExpiredVoucher"   // voucher & Deal
    case tCategoryOffers = "tCategoryOffers"   // tags last section in landing
    case tAllScratchCard = "tAllScratchCard"   // cashback and other
    case tAllLockedCard  = "tLockedCard"       // cashback and other
    case tOfferTag       = "tOfferTag"         // Offer Tag Handling
    case tUnknown        = "tUnknown"

    var defaultHeaderInfo: JRCBGridViewHeaderDisplay {
        var mHeader = JRCBGridViewHeaderDisplay()
        switch self {
        case .tVouchers, .tDeals, .tExpiredVoucher:
            mHeader.set(subTtl: "jr_CB_ttlYourVoucherAndDeal".localized)
            mHeader.set(showImg: false)

        case .tAllScratchCard:
            mHeader.set(subTtl: "jr_CB_ttlAllScratchCard".localized)
            mHeader.set(showImg: false)
            
        case .tAllLockedCard:
            mHeader.set(subTtl: "jr_CB_ttlUnlockCards".localized)
            mHeader.set(imgUrl: JRCBRemoteConfig.kCBGridHeaderCashbackURL.strValue)
        default: break
            
        }
        return mHeader
    }
}

enum JRCBGridViewSubType: String {
    case tCategoryOffers = "tCategoryOffers"
    case tScratchGame    = "tScratchGame"
    case tUnknown        = "tUnknown"
}

struct JRCBGridViewHeaderDisplay {
    private(set) var title  = ""
    private(set) var subTtl = ""
    private(set) var placeHolderImg  = "ic_GridHeaderBgCashback"
    private(set) var imgUrl : String?
    private(set) var showImg = true
    private(set) var font = UIFont.boldSystemFont(ofSize: 20)
    
    mutating func set(ttl: String)    { self.title = ttl }
    mutating func set(subTtl: String) { self.subTtl = subTtl }
    mutating func set(showImg: Bool)  { self.showImg = showImg }
    mutating func set(font: UIFont)   { self.font = font}
    mutating func set(imgUrl: String) { self.imgUrl = imgUrl}
}

class JRCBGridViewModel {
    private(set) var dataSource = [JRCBGridBaseInfo]()
    private(set) var gridType: JRCBGridViewType = .tUnknown
    private(set) var headerDisplay = JRCBGridViewHeaderDisplay()
    private(set) var preParam: JRCBJSONDictionary = [:]
    var filterViewModel: JRCOVoucherFilterVM = JRCOVoucherFilterVM()
    
    private(set) var isNextPage: Bool = false
    private(set) var pageNumber: Int = 1
    private(set) var pageSize: Int = 20
    private(set) var apiInProgress: Bool = false
    private(set) var apiHitCompleted: Bool = false
    private(set) var beforeTime: Int64?
    private(set) var excludeIds: String?
    private(set) var remainingTypes: String?
    
    // MARK: - START Params used for voucher and filter
    var selectedFilterIds: String = ""
    var sortingStyle: String = SortingStyle.createdAt.rawValue
    var showExpiredVouchers: String = VoucherStatus.active.statusId
    // MARK: - END Params used for voucher and filter
    
    var emptyText: String {
        switch self.gridType {
        case .tVouchers       : return "jr_CB_emptyTextVouchers".localized
        case .tExpiredVoucher : return "jr_CB_emptyTextVouchers".localized
        case .tDeals          : return "jr_CB_emptyTextDeals".localized
        case .tAllScratchCard : return "jr_CB_emptyTextScratchCards".localized
        case .tAllLockedCard     : return "jr_CB_emptyTextScratchCards".localized
        case .tCategoryOffers, .tOfferTag : return "jr_CB_emptyTextCategories".localized
        case .tUnknown:  return ""
        }
    }
    
    func setGrid(type: JRCBGridViewType) {
        self.gridType = type
    }
    
    func set(param: JRCBJSONDictionary) {
        self.preParam = param
    }
    
    func setHeader(info: JRCBGridViewHeaderDisplay) {
        self.headerDisplay = info
    }
    
    func getOfferTagVal() -> String {
        if let offferTagParam = self.preParam["offer_tag"] as? String {
            return offferTagParam
        }
        return ""
    }
    
    func getCollectionCellIdentifier(type: JRCBGridViewSubType) -> String? {
        switch type {
        case .tCategoryOffers:
            if let offerTagStr = self.preParam["offer_tag"] as? String, offerTagStr.lowercased() == JRCBConstants.Common.kSelOfferTagVal {
                return JRCBGridCollCellCashback.identifier
            }
            return JRCBGridCampaignCollCell.identifier
        case .tScratchGame:
            return JRCBGridScratchCollCell.identifier
        default: return nil
        }
    }
    
    func resetData() {
        self.pageNumber = 1
        self.dataSource.removeAll()
    }
    
    func removeScratchCardWith(sId: String) -> Bool {
        if self.gridType == .tAllScratchCard {
            if let theItems = self.dataSource as? [JRCBGridUnscratchCardInfo], let rIndx = theItems.firstIndex(where: {$0.scratchCardID == sId }) {
                self.dataSource.remove(at: rIndx)
                return true
            }
        }
        return false
    }
    
    @discardableResult func refreshCampainCardWith(cId: String) -> Bool {
        if let rIndx = self.dataSource.firstIndex(where: {$0.campain?.campId == cId }) {
            self.dataSource.remove(at: rIndx)
            return true
        }
        return false
    }
    
    func fetchData(completion: JRCBVMCompletion?) { // add completion block
        guard JRCBCommonBridge.isNetworkAvailable else {
            completion?(false, "jr_ac_noInternetMsg".localized)
            return
        }
        
        apiInProgress = true
        switch gridType {
        case .tCategoryOffers:
            self.fetchCategoryCampaignsList {[weak self] (success, err) in
                if success, self?.isNextPage ?? false {
                    self?.pageNumber += 1
                }
                self?.apiInProgress = false
                completion?(success, err)
            }
        case .tDeals, .tAllScratchCard:
            self.fetchCBCoinList {[weak self] (success, err) in
                self?.apiHitCompleted = success
                if success, self?.isNextPage ?? false {
                    self?.pageNumber += 1
                }
                self?.apiInProgress = false
                completion?(success, err)
            }
        case .tVouchers, .tExpiredVoucher:
            self.fetchMyVouchers { [weak self] (success, err) in
                self?.apiHitCompleted = success
                if success, self?.isNextPage ?? false {
                    self?.pageNumber += 1
                }
                self?.apiInProgress = false
                completion?(success, err)
            }
        case .tOfferTag:
            self.fetchCashbackTagOffers { [weak self] (success, err) in
                if success, self?.isNextPage ?? false {
                    self?.pageNumber += 1
                }
                self?.apiInProgress = false
                completion?(success, err)
            }
        case .tAllLockedCard:
            self.fetchLockedCardDataList{ [weak self] (success, err) in
                if success, self?.isNextPage ?? false {
                    self?.pageNumber += 1
                }
                self?.apiInProgress = false
                completion?(success, err)
            }
        default:
            apiInProgress = false
            break
        }
    }
    
    private func paramBy(dict: JRCBJSONDictionary) -> JRCBJSONDictionary {
        var mDict = dict
        for (key, value) in self.preParam {
            mDict[key] = value
        }
        return mDict
    }
    
    // MARK: - CASHBACK, COINS, DEALS API
     private func fetchCBCoinList(completion: JRCBVMCompletion?) {
        var redemptionTypes = ""
        var statusList = "SCRATCHED,REDEEMED"
        if self.gridType == .tDeals {
            redemptionTypes = "DEAL"
        } else if self.gridType == .tAllScratchCard {
            statusList = "UNSCRATCHED,LOCKED"
        }
        var mParam = self.paramBy(dict: ["page_number": pageNumber,
                                         "page_size": pageSize,
                                         "userType" : "CUSTOMER",
                                         "redemptionTypes": redemptionTypes,
                                         "statusList": statusList,
                                         ])
        if let bfTime = beforeTime {
            mParam["beforeTime"] = "\(bfTime)"
        }
        
        if let excIds = excludeIds {
            mParam["excludedIds"] = excIds
        }
        
        if self.pageNumber == 1, self.gridType != .tAllScratchCard {
            mParam["isAggregationRequired"] = "true"
        }
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCashbackCoinList, param: mParam, appendUrlExt: "getCardListByUser")
        
        JRCBServiceManager.execute(apiModel: apiModel) {[weak self] (success, resp, error) in
            if let model = resp, let data = model["data"] as? JRCBJSONDictionary,
                let campaignArr = data["scratchCardList"] as? [JRCBJSONDictionary],
                let mSelf = self {
                if mSelf.pageNumber == 1 {
                    mSelf.dataSource.removeAll()
                }
                mSelf.isNextPage = data.getBoolForKey("isNext")
                if let befTime = data["beforeTime"] as? Int64 {
                    mSelf.beforeTime = befTime
                }
                let excIds = data.getArrayKey("excludedIds")
                let stringArr = excIds.map { "\($0)" }
                mSelf.excludeIds = stringArr.joined(separator: ",")
            
                for campaign in campaignArr {
                   if mSelf.gridType == .tDeals {
                        let modelObj = JRCBGridVoucherInfo(dict: campaign, index: mSelf.dataSource.count)
                        mSelf.dataSource.append(modelObj)
                    } else if mSelf.gridType == .tAllScratchCard {
                        let modelObj = JRCBGridUnscratchCardInfo(dict: campaign, index: mSelf.dataSource.count)
                        mSelf.dataSource.append(modelObj)
                    }
                }
                completion?(true, "")
                
            } else if let mErr = error {
                completion?(false, mErr.localizedDescription)
                
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    // MARK: - VOUCHERS API
    private func fetchMyVouchers(completion: JRCBVMCompletion?) {
        let mParam = self.paramBy(dict: ["page": "\(pageNumber)",
            "size": 10,
            "filter[category]": "\(selectedFilterIds)",
            "sort": "\(sortingStyle)",
            "filter[status]": "\(showExpiredVouchers)",
            "locale": "\(Locale.current.identifier)",
            "filter[is_merchant]": "false",
            "filter[type]": "DEAL,VOUCHER",
            "filter[client]": "DEAL,PROMO"]
                                  )
        
        JRCBServices.serviceGetVoucherList(params: mParam) {[weak self] (voucherModel, error) in
            if error == nil && voucherModel != nil {
                if self?.pageNumber == 1 {
                    self?.dataSource.removeAll()
                }
                self?.createBaseInfoFromVoucherModel(voucherModel: voucherModel)
                completion?(true, "")
            }
            else if let err = error {
                completion?(false, err.localisedDesc())
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    private func createBaseInfoFromVoucherModel(voucherModel: JRCOMyVoucherResponseModel?) {
        if let voucherlist = voucherModel?.response?.voucherList, voucherlist.count > 0 {
            
            self.isNextPage = voucherModel?.response?.isNext ?? false
            
            for voucher in voucherlist {
                let baseInfo = JRCBGridBaseInfo(dict: [:], index: voucherlist.count)
                baseInfo.metaData = voucher
                baseInfo.title = voucher.title ?? ""
                baseInfo.subTitle = voucher.savingsText ?? ""
                baseInfo.offerIconImage = voucher.icon ?? ""
                if voucher.redemptionType == "DEAL" {
                  baseInfo.backgroundImage = voucher.bgImage ?? ""
                }
                self.dataSource.append(baseInfo)
            }
            
        }
    }
       
    
    // MARK: - SCRATCH CARDS API
    private func fetchLockedCardDataList(completion: JRCBVMCompletion?) {
        var mParam: JRCBJSONDictionary = ["page_size": 10]
        mParam = self.paramBy(dict: mParam)
        
        if let bfTime = beforeTime {
            mParam["beforeTime"] = "\(bfTime)"
        }
        
        if let excIds = excludeIds {
            mParam["excludedIds"] = excIds
        }
        
        if pageNumber == 1 {
            mParam["remainingTypes"] = "ACTIVE_OFFER,NEW_OFFER"
        } else if let remTypes = remainingTypes {
             mParam["remainingTypes"] = remTypes
        }
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCBLandingScratchCard, param: mParam, appendUrlExt: "")        

        JRCBServiceManager.execute(apiModel: apiModel) {[weak self] (success, resp, error) in
            if let model = resp, let data = model["data"] as? JRCBJSONDictionary,
                let campaignArr = data["data"] as? [JRCBJSONDictionary], let mSelf = self {
                if mSelf.pageNumber == 1 {
                    mSelf.dataSource.removeAll()
                }
                mSelf.isNextPage = false
                if let remainigTypes = data["remainingTypes"] as? [String] {
                    if remainigTypes.count > 0 {
                        mSelf.isNextPage = true
                        mSelf.remainingTypes = remainigTypes.joined(separator: ",")
                    } else {
                        mSelf.remainingTypes = nil
                    }
                }
                if let befTime = data["beforeTime"] as? Int64 {
                    mSelf.beforeTime = befTime
                }
                let excIds = data.getArrayKey("excludedIds")
                let stringArr = excIds.map { "\($0)" }
                mSelf.excludeIds = stringArr.joined(separator: ",")
                
                for campaign in campaignArr {
                    let modelObj = JRCBGridScratchMergedInfo(dict: campaign, index: mSelf.dataSource.count)
                    mSelf.dataSource.append(modelObj)
                }
                completion?(true, "")
                
            } else if let mErr = error {
                completion?(false, mErr.localizedDescription)
                
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    // MARK: - CATEGORIES CAMPAIGNS API
    private func fetchCategoryCampaignsList(completion: JRCBVMCompletion?) {
        var after_id = 0
        if self.dataSource.count > 0 {
            if let lastInfo = self.dataSource.last {
                if let metaModel = lastInfo.metaData as? JRCBCampaign {
                    after_id = Int(metaModel.campId) ?? 0
                }
            }
        }
        let mParam = self.paramBy(dict: ["after_id": after_id,
                                         "page_number": pageNumber,
                                         "page_size": pageSize])
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCampaignsList, param: mParam, appendUrlExt: "")
        JRCBServiceManager.execute(apiModel: apiModel) {[weak self] (success, resp, error) in
            if let model = resp,
                let data = model["data"] as? JRCBJSONDictionary,
                let campaignArr = data["campaigns"] as? [JRCBJSONDictionary],
                let mSelf = self {
                if mSelf.pageNumber == 1 {
                    mSelf.dataSource.removeAll()
                }
                mSelf.isNextPage = data.getBoolForKey("is_next")
                for campaign in campaignArr {
                    let modelObj = JRCBGridCategoryOffersInfo(dict: campaign, index: mSelf.dataSource.count)
                    modelObj.setOfferTag(mSelf.getOfferTagVal())
                    mSelf.dataSource.append(modelObj)
                }
                completion?(true, "")
                
            } else if let mErr = error {
                completion?(false, mErr.localizedDescription)
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    // MARK: - TAG OFFERS API
    private func fetchCashbackTagOffers(completion: JRCBVMCompletion?) {
        let mParam = self.paramBy(dict: [:])
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchGameDetail, param: mParam, appendUrlExt: "tagoffers")
        
        JRCBServiceManager.execute(apiModel: apiModel) {[weak self] (success, resp, error) in
            if let model = resp, let data = model["data"] as? JRCBJSONDictionary, let mSelf = self {
                if let superCashArr = data["superCashGameV4List"] as? [JRCBJSONDictionary] {
                    for superCash in superCashArr {
                        let modelObj = JRCBGridScratchInfo(dict: superCash, index: mSelf.dataSource.count)
                        modelObj.setOfferTag(mSelf.getOfferTagVal())
                        mSelf.dataSource.append(modelObj)
                    }
                }
                if let campaignArr = data["campaignData"] as? [JRCBJSONDictionary] {
                    
                    for campaign in campaignArr {
                        let modelObj = JRCBGridCategoryOffersInfo(dict: campaign, index: mSelf.dataSource.count)
                        modelObj.setOfferTag(mSelf.getOfferTagVal())
                        mSelf.dataSource.append(modelObj)
                    }
                }
                
                completion?(true, "")
                
            } else if let mErr = error {
                completion?(false, mErr.localizedDescription)
                
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
}


