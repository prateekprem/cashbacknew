//
//  JRCBLandingMerchantVModel.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 28/01/20.
//

import UIKit

enum JRCBMerchantOfferType: Int {
    case newOffer = 0
    case myOffer
}

class JRCBLandingMerchantVModel {
    private(set) var inProgressNewOfferAPI = false
    private(set) var inProgressMyOfferAPI = false
    private(set) var hasMoreMyOffer = false
    private(set) var hasMoreNewOffer = false
  
    var arrayMyOffersVM: [JRMCOMyOfferViewModel] = []
    var arrayNewOffersVM : [JRMCONewOfferViewModel] = []
    var pageNumberMyOffer = 1
    var pageNumberNewOffer = 0
    var isResetNewOffer = false
    var isResetMyOffer = false
    
    var configArray:[JRCBMerchantOfferType] = []
    //-----------------------------------
    
    private(set) var isExpiredOfferTapped: Bool = false
    
    var pageOffsetNewOffer : String  = ""
    var pageNumberMyOfferExpired = 1
    var hasExpiredOffers = false
    var isFromCategoryDeeplink : Bool = false
    var isFromOfferDeeplink : Bool = false
    
    init() {
        updateConfigArray()
    }
    
    func getNumberOfMerchantRowsAccordingToOfferType(_ offerType : TypeOfOffers) -> Int {
        if offerType == .NewOffers {
            return 1
            
        } else {
            if arrayMyOffersVM.count == 0 { return 1 }
            return arrayMyOffersVM.count
        }
    }
    
    func getMerchantNewOfferDataCount() -> Int {
        return arrayNewOffersVM.count
    }
    
    func fetchMerchantNewOffers(completion: @escaping (Bool, NSError?) -> Void) {
        configArray.removeAll()
        updateConfigArray()
        
        pageNumberNewOffer = pageNumberNewOffer + 1
        self.inProgressNewOfferAPI = true
        let aModel = JRCBApiModel(type: .pathCBMerchantNewOffersV1, param: nil, appendUrlExt: "?page_size=10")
        JRCBServiceManager.executeAPI(model: aModel) { [weak self] (isSuccess, response, error) in
             self?.inProgressNewOfferAPI = false
            guard let resp = response as? JRCBJSONDictionary else {
                if self?.pageNumberNewOffer == 1 {
                    self?.arrayNewOffersVM.removeAll()
                }
                if let oldPageNumber =  self?.pageNumberNewOffer, oldPageNumber - 1 >= 1 {
                    self?.pageNumberNewOffer = oldPageNumber - 1
                }
                self?.updateConfigArray()
                let err = error ?? JRCBServiceManager.genericError
                completion(false, err as NSError?)
                return
            }
            
            let superModel = JRMCONewOfferSModel(dict: resp)
            if (self?.arrayNewOffersVM.count == 0 && (self?.pageNumberNewOffer ?? 1) == 1) {
                self?.arrayNewOffersVM = superModel.campaignsViewModel
            } else {
                self?.arrayNewOffersVM += superModel.campaignsViewModel
            }
            self?.hasMoreNewOffer = superModel.is_next
            self?.pageOffsetNewOffer = superModel.page_offset
            self?.updateConfigArray()
            completion(true, nil)
        }
    }
    
    func fetchMerchantMyOffers(completion: @escaping (Bool, NSError?) -> Void) {
       var apiExt = ""
        if self.hasExpiredOffers || self.isExpiredOfferTapped {
            apiExt = "?status=GAME_EXPIRED&page_size=20&page_number=\(pageNumberMyOfferExpired)"
            
        } else {
            apiExt = "?status=INITIALIZED,INPROGRESS,COMPLETED&page_size=20&page_number=\(pageNumberMyOffer)"
        }
        
        self.inProgressMyOfferAPI = true
        
         let aModel = JRCBApiModel(type: .pathCBMerchantGameListV2, param: nil, appendUrlExt: apiExt)
        JRCBServiceManager.executeAPI(model: aModel) { [weak self] (isSuccess, response, error) in
            self?.inProgressMyOfferAPI = false
            guard let resp = response as? JRCBJSONDictionary else {
                if self?.pageNumberMyOffer == 1 {
                    self?.arrayMyOffersVM.removeAll()
                }
                if self?.hasExpiredOffers ?? false || self?.isExpiredOfferTapped ?? false {
                    if let oldPageNumber =  self?.pageNumberMyOfferExpired, oldPageNumber - 1 >= 1 {
                        self?.pageNumberMyOfferExpired = oldPageNumber - 1
                    }
                } else {
                    if let oldPageNumber =  self?.pageNumberMyOffer, oldPageNumber - 1 >= 1 {
                        self?.pageNumberMyOffer = oldPageNumber - 1
                    }
                }
                self?.updateConfigArray()
                completion(false, error as NSError?)
                return
            }
            
            let superModel = JRMCOMyOfferSModel(dict: resp)
            
            if (self?.arrayMyOffersVM.count == 0) {
                self?.arrayMyOffersVM = superModel.supercashList
            } else {
                self?.arrayMyOffersVM += superModel.supercashList
            }
            self?.hasMoreMyOffer = superModel.is_next
            self?.hasExpiredOffers = superModel.hasExpiredOffers
            self?.updateConfigArray()
            completion(true, nil)
        }
    }
    
    class func activateMerchantNewOffers(merchantType: MerchantOfferType, id: String,
                                         completion: @escaping (JRMCOMyOfferViewModel,Bool,NSError?) -> Void) {
        
        var aModel : JRCBApiModel?
        if merchantType == .newOffer {
            aModel = JRCBApiModel(type: .pathCBMerchantActivateOfferV2, param: nil, body: ["action": "ACCEPT_OFFER"], appendUrlExt: "/\(id)")
        } else {
            aModel = JRCBApiModel(type: .pathCBMerchantActivateGame, param: nil, body: ["action": "ACCEPT_OFFER"], appendUrlExt: "/\(id)")
        }
        guard let apiModel = aModel else { return }
        
        JRCBServiceManager.executeAPI(model: apiModel) { (isSuccess, response, error) in
            guard let resp = response as? JRCBJSONDictionary else {
                if let err = error {
                    completion(JRMCOMyOfferViewModel(dict: [:]), false, err as NSError?)
                } else {
                    completion(JRMCOMyOfferViewModel(dict: [:]), false, JRCBServiceManager.genericError as NSError?)
                }
                return
            }
            
            completion(JRMCOMyOfferViewModel(dict: resp), true, nil)
        }
    }
    
    func updateConfigArray() {
        if arrayNewOffersVM.count > 0 {
            if !configArray.contains(.newOffer) {
                configArray.insert(.newOffer, at: JRCBMerchantOfferType.newOffer.rawValue)
            }
            
        } else {
            if configArray.contains(.newOffer) {
                configArray.remove(at: JRCBMerchantOfferType.newOffer.rawValue)
            }
        }
        
        if arrayMyOffersVM.count > 0 {
            if !configArray.contains(.myOffer) {
                configArray.insert(.myOffer, at: configArray.count)
            }
            
        } else if hasExpiredOffers == true {
            if !configArray.contains(.myOffer) {
                configArray.insert(.myOffer, at: configArray.count)
            }
            
        } else {
            if configArray.contains(.myOffer) {
                if let objIndex = configArray.firstIndex(of: .myOffer) {
                    configArray.remove(at: objIndex)
                }
            }
        }
        
        if configArray.count == 0 {
            configArray.append(.newOffer)
        }
    }
    
    func loadMoreData() {
        if hasExpiredOffers || isExpiredOfferTapped {
            pageNumberMyOfferExpired = pageNumberMyOfferExpired + 1
        } else {
            pageNumberMyOffer = pageNumberMyOffer + 1
        }
    }
    
    func setExpiredOfferBtnState() {
        isExpiredOfferTapped = true
    }
}
