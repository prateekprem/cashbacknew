//
//  SFManager.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import Foundation
import jarvis_network_ios

public protocol SFManagerInteractorProtocol {
    func getCompleteAppContext() -> [String: Any]?
    func getBodyDetail() -> [String: Any]?
    func getRecmendedBodyDetail() -> [String: Any]?
    func urlByAppendingDefaultParams(_ url: String?) -> String?
    func getNetworkType() -> String?
    func isNetworkReachable() -> Bool
}

public protocol SFManagerJRInteractorProtocol {
    func getContextParams() -> [String: Any]?
}

extension SFManagerInteractorProtocol {
    public func getCompleteAppContext() -> [String: Any]? {
        return nil
    }
    
    public func getBodyDetail() -> [String: Any]? {
        return nil
    }
    
    public func getRecmendedBodyDetail() -> [String: Any]? {
        return nil
    }
   
    public func urlByAppendingDefaultParams(_ url: String?) -> String? {
        return url
    }
    
    public func getNetworkType() -> String? {
        return nil
    }
    
    public func isNetworkReachable() -> Bool {
        return true
    }
}

extension SFManagerJRInteractorProtocol {
    public func  getContextParams() -> [String: Any]? {
        return nil
    }
}

public class SFManager {
    public static let shared = SFManager()
    public var interactor: SFManagerInteractorProtocol?
    public var jrInteractor: SFManagerJRInteractorProtocol?
    private(set) var sfConfig = SFConfig(appType: .other, environment: .production)
    private init() {}
    public var itemDictEventFired = SFThreadedDictionary<String, [String:Any]>()
    public var shouldFireGAEvent = SFThreadedDictionary<String, Bool>()
//    public var shouldFireGAEvent: Bool = true
    @available(*, deprecated, message: "use configure instead")
    public func kickOffWith(appType: SFAppType, target: SFTarget = .release, environment: SFEnvironment = .production ) {
        sfConfig = SFConfig(appType: appType, environment: environment)
    }
    
    public func configure(environment: SFEnvironment = .production ) {
       sfConfig = SFConfig(appType: .other , environment: environment)
    }
    
    /**
     Must be called only once per client (App target) like Jarvis, P4B, Paytm Money etc.
     No need to setup this bridge in multiple vertical in the same target like home, cashback, transaction summary etc.
     - parameter interactor: SFBridgeInteractor object, where all the methods will be implemented.
     */
    public func setupBridge(_ interactor: SFBridgeInteractor) {
        SFBridge.shared.setup(interactor)
    }
}


public class SFContainer {
    public let pageLayoutInfo = SFPageLayoutInfo()
    private var cacheManager : SFCacheManager?
    public typealias WriteCompletion = (_ completed: Bool) -> Swift.Void
    public typealias UpdateCompletion = (_ completed: Bool, _ updatedResponse: [String:Any]) -> Swift.Void
    
    public init(appType:SFAppType,verticalName:String, delegate: SFLayoutPresentDelegate?, dataSource: SFLayoutPresentDatasource?) {
          self.pageLayoutInfo.containerType = appType
          self.pageLayoutInfo.layoutDelegate = delegate
          self.pageLayoutInfo.layoutDatasource = dataSource
          self.pageLayoutInfo.verticalName = verticalName
      }
    
    
    public func parse(response: SFJSONDictionary, shouldFireGA:Bool = true, shouldClearGADict:Bool = true) {
        pageLayoutInfo.parse(json: response, containerType: self.pageLayoutInfo.containerType)
        let pageId = self.pageLayoutInfo.pageId
        SFManager.shared.shouldFireGAEvent["\(pageId)"] = shouldFireGA
        if shouldClearGADict {
            SFManager.shared.itemDictEventFired["\(pageId)"] = [:]
        }
    }
    
    public func updateWithStorage(bundleFileName: String, cacheFileName: String) {
        cacheManager = SFCacheManager(cacheName: cacheFileName, bundleName: bundleFileName)
    }
    
    public func refreshDataFromCache(shouldFireGA: Bool = true,shouldClearGADict:Bool = true) {
        guard let mCacheManager = self.cacheManager else { return }
        if let mJson = mCacheManager.getCacheData().dict {
            self.parse(response: mJson,shouldFireGA:shouldFireGA, shouldClearGADict: shouldClearGADict)
        }
    }
    
    public func clearCachedData() {
        guard let mCacheManager = self.cacheManager else { return }
        mCacheManager.clearCacheData()
    }
    
    public func updateDataToCache(dict: SFJSONDictionary, completion :@escaping UpdateCompletion) {
        guard let mCacheManager = self.cacheManager else { return }
        if let mJson = mCacheManager.getCacheData().dict {
            var updatedJson : [String:Any] = mJson
            if let layouts = dict["page"] as? [SFJSONDictionary], layouts.count > 0 {
                for (_,pageDict) in layouts.enumerated() {
                    if let mViews = pageDict["views"] as? [SFJSONDictionary], mViews.count > 0 {
                        for vDict in mViews {
                           findAndUpdateDict(dict: &updatedJson, with: vDict)
                        }
                    }
                }
            }
            DispatchQueue.global().async {
                mCacheManager.storeToCache(dict: updatedJson, completion: { success in
                    if(success) {
                         completion(true, updatedJson)
                    } else {
                        completion(false,[:])
                    }
                
                })
            }
 
        }
    }
    
    func findAndUpdateDict(dict:inout SFJSONDictionary, with newVDict: SFJSONDictionary) {
        if let layouts = dict["page"] as? [SFJSONDictionary], layouts.count > 0 {
            var newPageArray:[SFJSONDictionary] = []
            for (_,pageDict) in layouts.enumerated() {
                var newPageDict:SFJSONDictionary = pageDict
                if let mViews = pageDict["views"] as? [SFJSONDictionary], mViews.count > 0 {
                    var newVArray:[SFJSONDictionary] = []
                    for vDict in mViews {
                        if let vDictId =  vDict["id"] as? NSNumber, let newVDictId = newVDict["id"] as? NSNumber, let vDictType = vDict["type"] as? String, let newVDictType = newVDict["type"] as? String { // if id and type match then update
                        if vDictId == newVDictId && vDictType == newVDictType {
                             newVArray.append(newVDict) //use new value
                        } else {
                            newVArray.append(vDict) //use previous value
                         }
                        } else {
                          newVArray.append(vDict) //use previous value
                        }
                    }
                    newPageDict["views"] = newVArray
                }
                newPageArray.append(newPageDict)
            }
           dict["page"] = newPageArray
        }
    }
    
    // This will help while supporting the pagination..
    public func append(response: SFJSONDictionary) {
        pageLayoutInfo.append(json: response)
    }
    
    public func storeToCache(dict: SFJSONDictionary, completion : WriteCompletion? = nil) {
        guard let mCacheManager = self.cacheManager else { return }
        DispatchQueue.global().async {
            mCacheManager.storeToCache(dict: dict, completion: { status in
                if let comp = completion {
                    if(status) {
                        comp(true)
                    } else {
                        comp(false)
                    }
                }
            })
            
        }
    }
    
    public func getFloatingTabView() -> SFFloatingTabView? {
        guard let floatingInfo = pageLayoutInfo.floatingTabLayout else {
            return nil
        }
        
        return SFFloatingTabView.loadView(floatingInfo)
    }
    
    // sso_token and user_id is must in header
    public func loadSFApiWith(url:String, vertical:JRVertical, headers:[String:String] , body:[String:String] = [:], cache: Bool = false,
                              completion: @escaping JRSFAPICompletion) {
        
        var newHeaders : [String : String] = ["Cache-Control": "no-cache","Content-Type": "application/json",
                                              "x-app-rid": "B26769F7-B6B7-40E8-AEC4-76A72669DCCA:1580713596:01:006"]
        
        if headers.count > 0 {
            headers.forEach {
                newHeaders[$0] = $1
            }
        }
        let contextParams = SFManager.shared.jrInteractor?.getContextParams()
        let bodyWithDefParams : [String:Any] = contextParams?.merging(body) { (_, new) in new } ?? [:]
        let apiModel = JRSFApiModel(method: .post, url: url,
                                    param: bodyWithDefParams ,
                                    additionalParams: [:], header: newHeaders,
                                    verticle: vertical, userFacing: .userFacing,
                                    timeoutInterval : nil)
        
        // weak self
        JRSFServices.execute(model: apiModel) { [weak self](success, response, err) in
            DispatchQueue.main.async {
                if success, let mResp = response {
                    self?.parse(response: mResp)
                    
                    if cache {
                        self?.storeToCache(dict: mResp)
                    }
                }
                completion(success, response, err)
            }
        }
    }
}
