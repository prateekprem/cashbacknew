//
//  JRCBLandingVM.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 22/01/20.
//

import UIKit
import jarvis_storefront_ios

typealias JRCBLandingVMCompletion = (_ refresh: Bool, _ errMsg: String?, _ indices: JRCBInndeces) -> Swift.Void

public enum JRCBInndeces: Equatable {
    case all
    case update(Int)
}

class JRCBLandingVM {
    private var sfContainer : SFContainer!
    private var mCompletion : JRCBLandingVMCompletion?
    private var isLoading = false // only check SF data
    private var isLoadingScratchCard = false // only check SF data
    private var isLoadingUnlockCard = false // only check SF data
    
    private(set) var mLayouts = [SFLayoutViewInfo]()
    private(set) var scratchLayout : JRCBSFLayout!
    private(set) var lockedLayout  : JRCBSFLayout!
    private(set) var mUserType = CBConsumerType.Customer
    private(set) var sRouter: JRCBHomeScreenRouter?
   
    private let kLScratchCardCount = 10
    
    func kickOff(routerDelegate: JRCBScreenRouterDelegate?, completion: JRCBLandingVMCompletion?) {
        self.sRouter = JRCBHomeScreenRouter(delegate: routerDelegate)
        self.mCompletion = completion
        self.sfContainer = SFContainer(appType: .other, verticalName: "cashback", delegate: self, dataSource: self)
        self.scratchLayout = JRCBSFLayout.emptyWith(type: .lCBScratchCards, title: "jr_CB_ScratchAndGetCashback".localized)
        self.lockedLayout = JRCBSFLayout.emptyWith(type: .lCBLockedCards, title: "jr_CB_UnlockTheseCards".localized)
    }
    
    func refreshFullPage() {
        if self.isLoading { return }
        self.loadDummyData()
        self.isLoading = true
        self.mCompletion?(true, "", .all)
        
        if JRCBCommonBridge.isNetworkAvailable {
            self.fetchSFData()
        } else {
            let ntwrkMsg = "jr_ac_noInternetMsg".localized
            JRAlertPresenter.shared.presentSnackBar(title: "", message: ntwrkMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
            self.isLoading = false
        }
    }
    
    func remove(scratchCardId: String) -> (index: IndexPath?, removeRow: Bool ) {
        if let sIndx = self.mLayouts.firstIndex(where: {$0.layoutVType == .lCBScratchCards}) {
            if  let theItems = self.scratchLayout.lItems as? [JRCBLandingScratchCardInfo] {
                if let rIndx = theItems.firstIndex(where: {$0.unscratchedCardData?.scratchId == scratchCardId}) {
                    self.scratchLayout.removeItem(at: rIndx)
                    if self.scratchLayout.lItems.count == 0 {
                        self.removeItem(index: sIndx)
                        return (IndexPath(row: sIndx, section: 0), true)
                    }
                    return (IndexPath(row: sIndx, section: 0), false)
                }
            }
        }
        return (nil, false)
    }
    
    func removeItem(index: Int) {
        self.mLayouts.remove(at: index)
    }
    
    func localLayoutFor(type: LayoutViewType) -> JRCBSFLayout? {
        if type == .lCBLockedCards { return lockedLayout }
        if type == .lCBScratchCards { return scratchLayout }
        return nil
    }
}

// MARK: - Storefront+support methods
extension JRCBLandingVM {
   private func fetchSFData() {
        let aHeader : [String : String] = ["sso_token": JRCOAuthWrapper.ssoToken ?? "",
                                           "user_id": JRCOAuthWrapper.usrIdEitherBlank]
        let aURL = JRCBApiType.pathFetchCashbackLandingSF.urlStrWith()
        guard let mUrl = JRCBCommonBridge.urlByAppendingDefaultParam(urlStr: aURL) else { return }
        
        sfContainer.loadSFApiWith(url: mUrl, vertical: .cashback, headers: aHeader) { [weak self] (success, resp, err) in
            if success {
                self?.recievedSFResponse()
            } else {
                // handle error
            }
        }
    }
    
    func fetchScratchCard() {
        if isLoadingScratchCard { return }
        isLoadingScratchCard = true
        JRCBServices.fetchLandingUnScratchedCardData { [weak self] (success, response, error) in
            self?.updateCardsWith(dict: response ?? [:], type: .lCBScratchCards)
            self?.isLoadingScratchCard = false
        }
    }
    
    func fetchLockedCard() {
        if isLoadingUnlockCard { return }
        isLoadingUnlockCard = true
        JRCBServices.fetchLandingScratchCardData { [weak self] (success, response, error) in
            self?.updateCardsWith(dict: response ?? [:], type: .lCBLockedCards)
            self?.isLoadingUnlockCard = false
        }
    }
}

// MARK: - Update after JSON
private extension JRCBLandingVM {
    func loadDummyData() {
        self.mLayouts.removeAll()
        let layout1 = SFLayoutViewInfo(title: "", items: [], layoutType: .lCBScratchCards)
        mLayouts.append(layout1)
        
        let layout2 = SFLayoutViewInfo(title: "", items: [], layoutType: .lCBLockedCards)
        mLayouts.append(layout2)
    }
    
    func recievedSFResponse() {
        self.mLayouts.removeAll()
        self.mLayouts = self.sfContainer.pageLayoutInfo.allLayouts
        var isScratchCardFound = false
        var isLockedCardFound = false
        
        for aLayout in self.mLayouts {
            if aLayout.layoutVType == .lCBScratchCards {
                isScratchCardFound = true
                self.scratchLayout.update(title: aLayout.vTitle)
                
            } else if aLayout.layoutVType == .lCBLockedCards {
                isLockedCardFound = true
                self.lockedLayout.update(title: aLayout.vTitle)
            }
            
            print(aLayout.layoutVType.rawValue)
        }       
        
        if isScratchCardFound {
            self.fetchScratchCard()
        } else {
             self.mLayouts = self.mLayouts.filter() { $0.layoutVType !=  .lCBScratchCards }
        }
        if isLockedCardFound {
            self.fetchLockedCard()
        } else {
            self.mLayouts = self.mLayouts.filter() { $0.layoutVType !=  .lCBLockedCards }
        }
         self.mCompletion?(true, "", .all)
    }
    
    func updateCardsWith(dict: JRCBJSONDictionary, type: LayoutViewType) {
        self.isLoading = false
        guard let indx = self.mLayouts.firstIndex(where: {$0.layoutVType == type }) else { return }
        
        let cnt = self.updateItemsFrom(dict: dict, type: type)
        if cnt > 0 {
            self.mCompletion?(true, "", .update(indx))
        } else {
            self.mLayouts = self.mLayouts.filter() {$0.layoutVType !=  type}
            self.mCompletion?(true, "", .all)
        }
    }
    // erned text
    
    func updateItemsFrom(dict: JRCBJSONDictionary, type: LayoutViewType) -> Int {
        var mItems = [JRCBSFItem]()
        if type == .lCBScratchCards {
            if let tDict = dict["data"] as? JRCBJSONDictionary, let tDicts = tDict["scratchCardList"] as?[JRCBJSONDictionary], tDicts.count > 0 {
                for itemDict in tDicts {
                    let scratchInfo = JRCBLandingScratchCardInfo(dict: ["unscratchedCardData" :itemDict])
                    scratchInfo.updateCardConfig(index: mItems.count)
                    mItems.append(scratchInfo)
                    if mItems.count >= self.kLScratchCardCount {
                        mItems.append(JRCBLandingScratchCardInfo(title: "View All", viewAll: true, backImg: ""))
                        break
                    }
                }
            }
            self.scratchLayout.update(items: mItems)
            return mItems.count
            
        } else if type == .lCBLockedCards {
            if let tDct = dict["data"] as? JRCBJSONDictionary,
                let tDicts = tDct["data"] as? [JRCBJSONDictionary], tDicts.count > 0 {
                for itemDict in tDicts {
                    let scratchInfo = JRCBLandingScratchCardInfo(dict: itemDict)
                    scratchInfo.updateCardConfig(index: mItems.count)
                    mItems.append(scratchInfo)
                    if mItems.count >= self.kLScratchCardCount {
                        mItems.append(JRCBLandingScratchCardInfo(title: "View All", viewAll: true, backImg: ""))
                        break
                    }
                }
            }
            self.lockedLayout.update(items: mItems)
            return mItems.count
        }
        return 0
    }
}

// MARK: - SFLayoutPresentDatasource, SFLayoutPresentDelegate
extension JRCBLandingVM: SFLayoutPresentDatasource, SFLayoutPresentDelegate {
    public func sfSDKLayoutPresentInfoFor(type: LayoutViewType) -> SFTableCellPresentInfo? {
        let info = type.defaultPresentCellInfo
        info.backColor = UIColor.clear
        info.showAltImage = false
        
        switch type {
        case .listSmallTi:
            info.titleFont = UIFont.boldSystemFont(ofSize: 12)
           // systemMediumFontOfSize(12)
            info.iconHW = 20.0
            
        case .lCBOffers:
            info.collectColomnCount = 2.30
            let sz = JRCBSFLayoutCellDisplayConfig.sizeWith(ratio: 1.16, displayCount: 2.30)
            info.collectInterimSpace = 10
            info.collectLineSpace = 16
            info.cellHeight = sz.height + 80
//        case .banner3_0:
//            info.collectCellRoundBorder = 1
//            info.collectCellRoundClr = UIColor(hex: "DFE7F0")
            
        default: break
        }
        return info
    }
    
    public func sfSDKShouldIgnoreItemCountValidationFor(type: LayoutViewType) -> Bool {
        return JRCBSFLayout.locallySupportedLayouts.contains(type)
    }
    
    // MARK: - SFLayoutPresentDelegate
    func sfSDKDidSelect(info: SFLayoutItem?, tableIndex: Int, collectIndex: Int, type: LayoutViewType) {
        self.sRouter?.handleClickSFSDK(item: info, tableIndex: tableIndex, collectIndex: collectIndex, type: type)
    }
}
