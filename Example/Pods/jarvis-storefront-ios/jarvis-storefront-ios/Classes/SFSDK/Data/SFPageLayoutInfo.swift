//
//  SFPageLayoutInfo.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import Foundation

public class SFPageLayoutInfo { // we should display all views rather than all layouts
    
    public private(set) var pageId      = 0
    public private(set) var pageName    = ""
    public private(set) var apiVer      = 0
    public private(set) var gaCat       = ""
    public private(set) var gaKey       = ""
    public private(set) var contextParams: [String:Any]?
    public private(set) var entityType: String?
    public private(set) var entityIdentifier: String?
    
    public private(set) var allLayouts  = [SFLayoutViewInfo]() // this list should be displayed
    public private(set) var popupLayouts  = [SFLayoutViewInfo]() // this list should be displayed for popups
    public private(set) var carouselRecoLayout : SFLayoutViewInfo? // this list should be displayed for carousel icon 4x inside smart icon header v2
    internal var layoutDelegate: SFLayoutPresentDelegate?
    internal var layoutDatasource: SFLayoutPresentDatasource?
    private var homeLayoutInfos = [SFLayoutInfo]() // won't display directly
    static let popupViews: [LayoutViewType] = [.interstitial, .scratchcardPopup, .flashPopup]
    public private(set) var floatingTabLayout: SFLayoutViewInfo?
    public var containerType    = SFAppType.other
    public var verticalName:String = ""
    
    private func evaluteLayouts() {
        var mList = [SFLayoutViewInfo]()
        var popupList = [SFLayoutViewInfo]()
        carouselRecoLayout = nil
        var position = 0
        floatingTabLayout = nil
        let hasSmartHeaderv2 = self.homeLayoutInfos.reduce(false) { (partialResult, mLayout) in
           if  let layout = mLayout.layouts.first {
                return (partialResult ||  (layout.layoutVType == .smartIconHeaderV2))
           } else {
            return partialResult
           }
        }
        for mLayout in self.homeLayoutInfos {
            if containerType == .consumerApp {
                for item in mLayout.layouts {
                    if (mLayout.layouts.count > 0)  {
                        if mLayout.layouts[0].isValid {
                            position = position + 1
                            item.viewPosition = position
                        }
                    }
                }
            }
            if let layout = mLayout.layouts.first, layout.layoutVType == .carouselReco4x, hasSmartHeaderv2 {
                carouselRecoLayout = layout
            } else if let layout = mLayout.layouts.first, layout.layoutVType == .recentsList {
                let filteredItems: [SFLayoutItem] = SFUtilsManager.filteredRecentItems(items: layout.vItems)
                if !filteredItems.isEmpty {
                    layout.vItems = filteredItems
                    mList.append(contentsOf: mLayout.layouts)
                }
            }
            else {
                mList.append(contentsOf: mLayout.layouts)
            }
            if let layout = mLayout.layouts.first, SFPageLayoutInfo.popupViews.contains(layout.layoutVType) {
                popupList.append(contentsOf: mLayout.layouts)
            }
            
            if let layout = mLayout.layouts.first, layout.layoutVType == .floatingTab, !layout.vItems.isEmpty {
                floatingTabLayout = layout
            }
        }
        self.allLayouts = mList
        self.popupLayouts = popupList
    }
    
    private func layoutsFrom(json:SFJSONDictionary) -> [SFLayoutInfo] {
        var aList = [SFLayoutInfo]()
        if let mLayouts = json["page"] as? [SFJSONDictionary], mLayouts.count > 0 {
            for (index,dict) in mLayouts.enumerated() {
                var additionalInfoDict = [String:Any]()
                additionalInfoDict["ga_key"] = self.gaKey
                additionalInfoDict["position"] = index + 1
                additionalInfoDict["contextParam"] = contextParams
                additionalInfoDict["page_id"] = self.pageId
                additionalInfoDict["verticalName"] = self.verticalName
                let layInfo = SFLayoutInfo(dict: dict, additionalInfo: additionalInfoDict, delegate: self.layoutDelegate, datasource: self.layoutDatasource, containerType: containerType )
                aList.append(layInfo)
            }
        }
        return aList
    }
    
    func parse(json: SFJSONDictionary, containerType:SFAppType) {
        self.containerType = containerType
        self.pageId   = json.sfIntFor(key: "page_id")
        self.pageName = json.sfStringFor(key: "page_name")
        self.apiVer   = json.sfIntFor(key: "api_version")
        self.gaCat    = json.sfStringFor(key: "ga_category")
        self.gaKey    = json.sfStringFor(key: "ga_key")
        self.contextParams = json["context"] as? [String: Any]
        self.entityType = json["entity_type"] as? String
        if let idInt = json["entity_identifier"] as? Int {
            self.entityIdentifier = "\(idInt)"
        }
        else {
            self.entityIdentifier = json["entity_identifier"] as? String
        }
        
        let theList = self.layoutsFrom(json: json)
        if theList.count > 0 {
            homeLayoutInfos = theList
             self.evaluteLayouts()
        }
    }

    func append(json: SFJSONDictionary) {
        let theList = self.layoutsFrom(json: json)
        if theList.count > 0 {
            homeLayoutInfos.append(contentsOf: theList)
            self.evaluteLayouts()
        }
    }
}
