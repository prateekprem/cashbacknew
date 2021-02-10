//
//  JRCBPointListVM.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 24/07/20.
//

import Foundation

class JRCBPointListVM {
    private(set) var lType: JRCBPointListType = .listCashbackEarned
    private (set) var apiPage = JRCBAPIPageInfo()
    private(set) var preParam: JRCBJSONDictionary = [:]
    private(set) var headerVM = JRCBPointListTableHeaderVModel()
    private(set) var beforeTime: Int64?
    private(set) var excludeIds: String?
    private(set) var sections = [JRCBPointListSection]()
    
    var shAddFooter: Bool {
        return self.sections.count > 0 && self.apiPage.pageNumber > 1 && self.apiPage.isNextPage
    }
    
    var isEmpty: Bool {
        return !self.apiPage.apiInProgress && sections.count == 0
    }
    
    init(type: JRCBPointListType) {
        self.lType = type
        self.apiPage.pageSize = 20
        self.headerVM = type.headerInfo
    }
    
    static func typeWith(offerType: String) -> JRCBPointListType? {
        if offerType.lowercased() == "cashback" { return .listCashbackEarned }
        if offerType.lowercased() == "points" { return .listPointsEarned }
        return nil
    }

    private func paramBy(dict: JRCBJSONDictionary) -> JRCBJSONDictionary {
        var mDict = dict
        for (key, value) in self.preParam {
            mDict[key] = value
        }
        return mDict
    }
    
    
    private var mParam: JRCBJSONDictionary {
        var redemptionTypes = ""
        let statusList = "SCRATCHED,REDEEMED"
        if self.lType == .listCashbackEarned {
            redemptionTypes = "CASHBACK,UPI,PPBL,GV_CASHBACK,GOLDBACK,PG_CASHBACK"
        } else {
            redemptionTypes = "COINS"
        }
        let pDict = ["page_number": self.apiPage.pageNumber,
                     "page_size": self.apiPage.pageSize,
                     "userType" : "CUSTOMER",
                     "redemptionTypes": redemptionTypes,
                     "statusList": statusList] as JRCBJSONDictionary
        
        var mParam = self.paramBy(dict: pDict)
        
        if let bfTime = beforeTime {
            mParam["beforeTime"] = "\(bfTime)"
        }
        
        if let excIds = excludeIds {
            mParam["excludedIds"] = excIds
        }
        
        mParam["isAggregationRequired"] = "true"
        return mParam
    }
    
    func fetchData(completion: JRCBVMCompletion?) {
        if self.apiPage.apiInProgress { return }
        if !self.apiPage.isNextPage { return }
        
        guard JRCBCommonBridge.isNetworkAvailable else {
            completion?(false, "jr_ac_noInternetMsg".localized)
            return
        }
        
        self.apiPage.apiInProgress = true
        let apiModel = JRCBApiModel(type: JRCBApiType.pathFetchCashbackCoinList, param: self.mParam, appendUrlExt: "getCardListByUser")
    
        JRCBServiceManager.execute(apiModel: apiModel) {[weak self] (success, resp, error) in
            if let model = resp, let data = model["data"] as? JRCBJSONDictionary {
                self?.parse(data: data)
                completion?(true, "")
                
            } else if let mErr = error {
                completion?(false, mErr.localizedDescription)
                
            } else {
                completion?(false, nil)
            }
            
            self?.apiPage.apiInProgress = false
        }
    }
    
    private func parse(data: JRCBJSONDictionary) {
        
        if self.apiPage.pageNumber == 1 {
            self.sections.removeAll()
            self.updateHeaderAmount(dict: data)
        }
        
        self.apiPage.isNextPage = data.getBoolForKey("isNext")
        if let befTime = data["beforeTime"] as? Int64 {
            self.beforeTime = befTime
        }
        let excIds = data.getArrayKey("excludedIds")
        let stringArr = excIds.map { "\($0)" }
        self.excludeIds = stringArr.joined(separator: ",")
        
        if let anArr = data["scratchCardList"] as? [JRCBJSONDictionary] {
            var sItems = [JRCBPointListInfo]()
            for entity in anArr {
                let anInfo = JRCBPointListInfo(dict: entity)
                if sItems.count == 0 {
                    sItems.append(anInfo)
                } else if sItems[0].secDTime == anInfo.secDTime {
                    sItems.append(anInfo)
                } else {
                    self.appendSec(items: sItems)
                    sItems = [JRCBPointListInfo]()
                    sItems.append(anInfo)
                }
            }
            if sItems.count > 0 {
                self.appendSec(items: sItems) // last section
            }
            
            if self.apiPage.isNextPage {
                self.apiPage.pageNumber += 1
            }
        }
    }
    
    private func appendSec(items: [JRCBPointListInfo]) {
        guard items.count > 0 else { return }
        
        let aSect = self.sections.filter() { $0.sTitle == items[0].secDTime }
        if aSect.count > 0 {
            aSect[0].append(list: items)
        } else {
            self.sections.append(JRCBPointListSection(title: items[0].secDTime, list: items))
        }
    }
    
    
    private  func updateHeaderAmount(dict: JRCBJSONDictionary) {
        if let headerDict = dict["gratificationSummary"] as? [JRCBJSONDictionary], headerDict.count > 0 {
            let firstSummary = headerDict[0]
            let totalAmount = firstSummary.intFor(key: "totalAmount")
            if totalAmount >= 0  {
                let formattedNumber = totalAmount.formattedWithSeparator
                if !formattedNumber.isEmpty {
                    if self.lType == .listCashbackEarned {
                        headerVM.set(value: JRCBConstants.Symbol.kRupee + formattedNumber)
                    } else if self.lType == .listPointsEarned {
                        headerVM.set(value: formattedNumber)
                    }
                }
            }
        }
    }
}

enum JRCBPointListType: String {
    case listCashbackEarned = "tCashbackEarned"    // first sect
    case listPointsEarned   = "tPointsEarned"      // Second sect
    
    var headerInfo: JRCBPointListTableHeaderVModel {
        switch self {
        case .listCashbackEarned:
            return JRCBPointListTableHeaderVModel(ttlStr: "jr_CB_CashbackListWonTtl".localized,
                                                  sortTtlStr: "jr_CB_CashbackListWonTtl".localized, valueStr: "")
        case .listPointsEarned:
            return JRCBPointListTableHeaderVModel(ttlStr: "jr_CB_PointsListTitle".localized,
                                                  sortTtlStr:"jr_CB_PointsListSortTitle".localized, valueStr: "")
        }
    }
    
    var emptyText: String {
        switch self {
        case .listCashbackEarned : return "jr_CB_emptyTextCashbacks".localized
        case .listPointsEarned   : return "jr_CB_emptyTextPoints".localized
        }
    }
    
    var navClr: UIColor {
        switch self {
        case .listCashbackEarned: return UIColor(hex: "4BA7F8")
        case .listPointsEarned: return UIColor(hex: "191E33")
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .listCashbackEarned: return .white
        case .listPointsEarned: return UIColor(hex: "D5A55D")
        }
    }
}



struct JRCBPointListTableHeaderVModel {
   private(set) var ttlStr: String = ""
   private(set) var sortTtlStr: String = ""
   private(set) var valueStr: String = ""
    
    func combileTitle() -> String {
        return valueStr + " " + sortTtlStr
    }
    
    mutating func set(value: String) {
        self.valueStr = value
    }
}
