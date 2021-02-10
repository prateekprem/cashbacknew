//
//  SFLayoutInfo.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

public class SFLayoutInfo {
    private(set) var layouts = [SFLayoutViewInfo]()
    public var gaKey:String = "" //GA related
    public var contextParams: [String:Any]?
    
    init(dict: SFJSONDictionary, additionalInfo:[String:Any] = [String:Any](),
         delegate: SFLayoutPresentDelegate?, datasource: SFLayoutPresentDatasource?, containerType:SFAppType ) {
        if let mViews = dict["views"] as? [SFJSONDictionary], mViews.count > 0 {
            for mDict in mViews {
                var additionalValueDict = mDict
                additionalValueDict["contextParam"] = additionalInfo["contextParam"]
                additionalValueDict["page_id"] = additionalInfo["page_id"]
                additionalValueDict["verticalName"] = additionalInfo["verticalName"]
                let myLayout = SFLayoutViewInfo(dict: additionalValueDict, delegate: delegate, datasource: datasource, containerType:containerType)
                
                if let gaKey = additionalInfo["ga_key"] as? String{
                    myLayout.gaKey = gaKey
                }
                if let context = additionalInfo["contextParam"] as? [String: Any]{
                    myLayout.contextParams = context
                }
                
                if let pos = additionalInfo["position"] as? Int {
                    myLayout.viewPosition = pos
                }
                if myLayout.isValid {
                    self.layouts.append(myLayout)
                }
            }
        }
    }
}

// will play the role of section
public class SFLayoutViewInfo {
    public private(set) var vId       = 0     // id
    public private(set) var vType     = ""    // layout
    public private(set) var vTitle    = ""
    public private(set) var vSubTitle = ""
    public private(set) var vName     = ""
    public private(set) var vImageUrl = ""
    public private(set) var vSeoUrl   = ""
    public private(set) var vUrlType = ""
    public private(set) var vSeeAllSeoUrl = ""
    public private(set) var viewTag: String = ""
    public private(set) var classType: String?
    public private(set) var vPriority = 0
    public private(set) var hasMore: Bool = false
    public var vItems = [SFLayoutItem]()
    public private(set) var viewItems = [SFLayoutItem]()
    public private(set) var storeInfo: SFStoreInfo?
    public private(set) var reviewRatingInfo: SFReviewRatingInfo?
    public private(set) var vDataSourcesInfos = [SFLayoutDataSourceInfo]()
    public var gaKey:String = "" //GA related
    public private(set) var layoutVType = LayoutViewType.none
    private(set) var cellId: String?
    public private(set) var cellPresentInfo = SFTableCellPresentInfo(height: 0)
    public var contextParams: [String:Any]?
    public private(set) var isBGActive: Bool = false
    public private(set) var pageId = 0
    public private(set) var verticalName:String = ""
    public private(set) var metaLayoutInfo: SFMetaLayoutInfo?
    public private(set) var grayLineSeparator: Bool = false
    public private(set) var iconContainerSize: String?
    
    //Internal vars
    public private(set) var hideTabbedView: Bool = false // Used for child clp controller to hide infinite grid top tab view (Storeled journey)
    public var viewPosition:Int = 1
    public var isExpanded: Bool = false
    public var isfeedFollowed: Bool = false
    public var storeSelectedIndex: Int = 0
    public var isDealDataAlreadyFetched: Bool = false
    public private(set) var autoScroll = false
    public private(set) var dwellTime:Double = 6.0
    public private(set) var numRowsShown:Int = 0
    public private(set) var viewAllImage:String = ""
    public private(set) var viewLessImage:String = ""
    public private(set) var viewAllLabel:String?
    public private(set) var viewLessLabel:String?
    public private(set) var itemImages = [String?]()
    internal var pDelegate: SFLayoutPresentDelegate?
    internal var pDatasource: SFLayoutPresentDatasource?
    public var isDealDataAlreadyExpanded:Bool = false
    public var dealsInitialIndex:Int = 0
    public private(set) var vEndTime: String?
    public var actualtemCount: Int = 0
    public var containerType:SFAppType = .other
    
    var bannerIndex:Int = 0
    
    public func tCellIdFor(row: Int = -1) -> String? {
        if layoutVType == .tabbed1 {
            var selectedItem: SFLayoutItem?
            for item in vItems {
                if item.isSelected {
                    selectedItem = item
                    break
                }
            }
            
            if let selectedItem = selectedItem {
                if selectedItem.gridItems.isEmpty {
                    return SFTabbed1ErrorTableCell.cellId
                }
                
                if let vType = selectedItem.gridLayout?.viewType {
                    switch vType {
                    case .list, .largeList:
                        return SFTabbed1xnTableCell.cellId
                    case .deals:
                        return SFDealsGridTableCell.cellId
                    case .freeDeals:
                        return SFFreeDealsGridTableCell.cellId
                    default:
                        break
                        // rest case will be grid bydefault and cell id will be returned as cellId
                    }
                }
            }
        }
        
        if self.layoutVType.shouldAddCustomHeader, row == 0 {
            if let firstItem = vItems.first, firstItem.itemType == .header {
                return layoutVType.headerCellId
            }
        }
        return cellId
    }
    
    // only for searching...
    public init(title: String, items: [SFLayoutItem], layoutType: LayoutViewType) {
        self.vTitle        = title
        self.vItems        = items
        self.layoutVType   = layoutType
        self.setupTypeConfig()
    }
    
    init(dict: SFJSONDictionary, delegate: SFLayoutPresentDelegate?, datasource: SFLayoutPresentDatasource?, containerType:SFAppType ) {
        self.containerType = containerType
        self.pDelegate = delegate
        self.pDatasource = datasource
        self.vId = dict.sfIntFor(key: "id")
        self.vType = dict.sfStringFor(key: "type")
        self.vTitle = dict.sfStringFor(key: "title")
        self.vSubTitle = dict.sfStringFor(key: "subtitle")
        self.vName = dict.sfStringFor(key: "name")
        self.vImageUrl = dict.sfStringFor(key: "image_url")
        // Prefetch Images for marketplace according to network type
        if !vImageUrl.isEmpty, containerType == .marketplace {
            vImageUrl = SFImageCacheManager.modifyUrl(vImageUrl)
            SFImageCacheManager.loadImageForMarketplace(vImageUrl)
        }
        self.vSeoUrl = dict.sfStringFor(key: "seourl")
        self.vUrlType = dict.sfStringFor(key: "url_type")
        self.vSeeAllSeoUrl = dict.sfStringFor(key: "see_all_seourl")
        self.viewTag = dict.sfStringFor(key: "view_tag")
        self.vPriority = dict.sfIntFor(key: "priority")
        self.classType = dict.sfStringFor(key: "class")
        self.autoScroll = dict.sfBooleanFor(key: "auto_scroll")
        self.dwellTime = dict["dwell_time"] as? Double ?? 6
        self.numRowsShown = dict.sfIntFor(key: "no_of_rows")
        self.viewAllImage = dict.sfStringFor(key: "viewall_image")
        self.viewLessImage = dict.sfStringFor(key: "viewless_image")
        self.viewAllLabel = dict.sfStringFor(key: "viewall_label")
        self.viewLessLabel = dict.sfStringFor(key: "viewless_label")
        if let clImages = dict["item_images"] as? [String?] {
            self.itemImages = clImages
        }
        if let isMore = dict["has_more"] as? Bool {
            self.hasMore = isMore
        }
        
        if let isBGActive = dict["is_bg_active"] as? Bool {
            self.isBGActive = isBGActive
        }
        
        if let metaDict: SFJSONDictionary = dict["meta_layout"] as? SFJSONDictionary {
            metaLayoutInfo = SFMetaLayoutInfo(dict: metaDict)
        }
        
        if let grayLine = dict["grey_line_separator"] as? Bool {
            self.grayLineSeparator = grayLine
        }
        
        iconContainerSize = dict["container_size"] as? String
        
        self.pageId   = dict.sfIntFor(key: "page_id")
        self.verticalName = dict.sfStringFor(key: "verticalName")
        if let hideTab = dict["hide_tabbed1_tab"] as? Bool {
            hideTabbedView = hideTab
        }
        
        if let mDSItems = dict["datasources"] as? [SFJSONDictionary], mDSItems.count > 0 {
            for dsDict in mDSItems {
                self.vDataSourcesInfos.append(SFLayoutDataSourceInfo(dict: dsDict))
            }
        }
               
        if let mItems = dict["items"] as? [SFJSONDictionary], mItems.count > 0 {
            for (index, itemDict) in mItems.enumerated() {
                var itemDictWithIndices = itemDict
                itemDictWithIndices["item_index"] = index + 1
                itemDictWithIndices["item_level"] = 1
                itemDictWithIndices["contextParam"] = dict["contextParam"]
                itemDictWithIndices["container_instance_id"] = self.datasourceContainerInstanceID
                let item: SFLayoutItem = SFLayoutItem(dict: itemDictWithIndices)
                item.viewId = vId
                item.isLastItem = index == (mItems.count - 1)
                if self.vType == LayoutViewType.carouselReco4x.rawValue || self.vType == LayoutViewType.carouselRecoV2.rawValue {
                    if SFUtilsManager.isValidCarouselReco4xItem(itemId: item.itemId, title: item.itemTitle , ctaLabel: item.ctaLabel ?? "") {
                        self.vItems.append(item)
                    }
                } else {
                    self.vItems.append(item)
                }
            }
        }
        
        if let viewItems = dict["viewItems"] as? [SFJSONDictionary], viewItems.count > 0 {
            for (index,itemDict) in viewItems.enumerated() {
                var itemDictWithIndices = itemDict
                itemDictWithIndices["item_index"] = index + 1
                self.viewItems.append(SFLayoutItem(dict: itemDictWithIndices))
            }
        }
        for item in self.viewItems {
            item.isItemViewType = true
        }
        if let storeInfoDict = dict["store_info"] as? [String: Any] {
            storeInfo = SFStoreInfo(dict: storeInfoDict)
        }
        
        if let ratingReviewInfo = dict["review_rating"] as? [String: Any] {
            reviewRatingInfo = SFReviewRatingInfo(dict: ratingReviewInfo)
        }
        actualtemCount = self.vItems.count
        if let vSFType = LayoutViewType(rawValue: self.vType) {
            self.layoutVType = vSFType
            self.setupTypeConfig()
            self.checkForHeaderItem()
        }
        self.vEndTime = dict.sfStringFor(key: "end_time")
    }
    
    private func checkForHeaderItem() {
        if self.layoutVType.shouldAddCustomHeader, isValid {
            let headerItem = SFLayoutItem.customItemWith(type: .header, title: self.vTitle, localImg: "")
            self.vItems.insert(headerItem, at: 0)
        }
    }
    
    public func updateLayoutViewType(layout: LayoutViewType) {
        self.layoutVType = layout
    }
    
    public var heightForItemHeader: CGFloat {
        switch self.layoutVType {
        case .row1xn: return 50
        case .tree1: return 60
        case .deals2xn : return 85
        case .listSmallTi:
            if vTitle.isValidString() || vSubTitle.isValidString() {
                return UITableView.automaticDimension
            }
            return 0
        default:
            return 0
        }
    }
    
    public var numberOfRows: Int {
        if self.layoutVType == .tabbed1 {
            var selectedItem: SFLayoutItem?
            for item in vItems {
                if item.isSelected {
                    selectedItem = item
                    break
                }
            }
            
            if let selectedItem = selectedItem, !selectedItem.gridItems.isEmpty {
                return selectedItem.gridItems.count
            }
            else {
                return 1
            }
        }
        else if self.layoutVType.shouldPresentInRow {
            switch self.layoutVType {
            case .tree1:
                if !isExpanded {
                    return 1 // Tree1 header cell only
                }
            case .row1xn:
                return vItems.count > 4 ? 4 : vItems.count
            case .deals2xn:
                if self.isDealDataAlreadyExpanded {
                    return vItems.count
                }else {
                    return self.dealsInitialIndex
                }
            default:
                break
            }
            return vItems.count
        }
        return 1
    }
    
    public func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if self.layoutVType.shouldAddCustomHeader && indexPath.row < vItems.count {
            let item = vItems[indexPath.row]
            if item.itemType == .header {
                return self.heightForItemHeader
            }
        }
        return cellPresentInfo.cellHeight
    }
    
    public var heightForHeader: CGFloat {
        switch self.layoutVType {
        case .tabbed1:
            let gridLayout = getSelectedItem()?.gridLayout
            if !hideTabbedView, let layout = gridLayout, layout.isFiltersPresent() {
                return 100
            }
            else if hideTabbedView, let layout = gridLayout, !layout.isFiltersPresent() { // None of Tab and filter present
                return 0
            }
            return 50
        default:
            return 0
        }
    }
    
    var isValid: Bool {
        if self.containerType == .consumerApp {
            if self.layoutVType == .none {return false}
        }
        if vId == 0 { return false }
        if self.layoutVType.ignoreValidation { return true }
        if let dataS = self.pDatasource, dataS.sfSDKShouldIgnore(layoutId: self.vId) { return false }
        if let dataS = self.pDatasource, dataS.sfSDKShouldIgnore(type: self.layoutVType) { return false }
        if let dataS = self.pDatasource, !dataS.sfSDKShouldSupportLayout(type: self.layoutVType) { return false }
        if let dataS = self.pDatasource, dataS.sfSDKShouldIgnoreItemCountValidationFor(type: self.layoutVType) { return true }

        switch layoutVType {
        case .carouselBs2: return vItems.count >= 4
        case .rowBs1:      return vItems.count >= 5
        case .collage5x:   return vItems.count >= 5
        case .collage3x:   return vItems.count >= 3
        case .row1xn:      return vItems.count >= 3
        case .row2xn:      return vItems.count >= 4
        case .row3xn:      return vItems.count >= 6
        default: break
        }
        return self.vItems.count > 0
    }
    
    func getSelectedItem() -> SFLayoutItem? {
        var selectedItem: SFLayoutItem?
        for item in vItems {
            if item.isSelected {
                selectedItem = item
                break
            }
        }
        return selectedItem
    }
    
    func setupTypeConfig() {
        if let preInfo = self.pDatasource?.sfSDKLayoutPresentInfoFor(type: layoutVType) {
            self.cellPresentInfo = preInfo
        } else {
            self.cellPresentInfo = SFTableCellPresentInfo(height: self.layoutVType.defaultHeight)
        }
        
        self.cellPresentInfo.evaluteCorrectRowCountWith(itemCount: self.vItems.count)
        self.cellId = layoutVType.cellId
    }
    
    public func itemsWith(limit: Int, index: Int, addEmpty: Bool = true) -> [SFLayoutItem] {
        var mItemList = [SFLayoutItem]()
        
        for i in 0..<limit {
            if self.vItems.count > i {
                let theItem = self.vItems[i]
                theItem.layoutIndex = index
                mItemList.append(theItem)
                
            } else if addEmpty {
                let theItem = SFLayoutItem.emptyItem
                theItem.layoutIndex = index
                mItemList.append(theItem)
            }
        }
        return mItemList
    }
    
    public func gaDataForPreviousScreenInH5(item: SFLayoutItem, isHomeCLP: Bool = false) -> SFJSONDictionary {
        var itemParamDict = item.gaDataForPreviousScreenInH5()
        itemParamDict["prev_screen_name"] = self.gaKey
        itemParamDict["prev_screen_type"] = isHomeCLP ? "home": "clp"
        itemParamDict["prev_screen_title"] = self.vTitle
        itemParamDict["prev_widget_type"] = self.vType
        itemParamDict["prev_ga_key"] = self.gaKey
        if item.experiment.length > 0 {
            itemParamDict["prev_ga_key"] = self.gaKey + "-infinite grid"
            itemParamDict["tabbedGridExperiment"] = item.experiment
        }
        itemParamDict["recoId"] = datasourceContainerInstanceID
        itemParamDict["list_id_type"] = vId
        return itemParamDict
    }
    
    public func gaPromotionImpressionParamFor(item: SFLayoutItem) -> SFJSONDictionary {
        var itemParam = item.gaImpressionParam()
        if self.containerType == .consumerApp {
            itemParam["name"] = "/-\(self.vType)"
        }
        else {
            if self.layoutVType == .tree1 {
                if item.itemType == SFLayoutItemType.header {
                    itemParam["name"] = self.gaKey + "-" + self.vTitle +  "-L1-" + self.vType
                }else if item.itemLevelIndex == 1  {
                    itemParam["name"] = self.gaKey + "-" + self.vTitle +  "-L2-" + self.vType
                }else {
                    itemParam["name"] = self.gaKey + "-" + self.vTitle +  "-L3-" + self.vType
                }
            }else {
                if item.itemType != SFLayoutItemType.header {
                    itemParam["name"] = self.gaKey + "-" + self.vTitle + "- " + self.vType
                }
            }
        }
        if(item.isItemViewType) {
            itemParam["position"] = "slot_" + String(describing:item.itemIndex) + "_" + String(describing: self.viewPosition) + "_" +  String(describing: self.viewItems.count)
        } else {
             itemParam["position"] = "slot_" + String(describing:item.itemIndex) + "_" + String(describing: self.viewPosition) + "_" +  String(describing: self.actualtemCount)
        }
       
        itemParam["dimension40"] = datasourceContainerInstanceID
        itemParam["view_id"] = self.vId
        if viewTag.isValidString() {
            itemParam["view_tag"] = viewTag
        }
        itemParam["storefront_id"] = self.pageId
        if(!self.vTitle.isEmpty) {
            itemParam["title"] = self.vTitle
        }
        if let context = self.contextParams,let reqId = context["request_id"] as? String  {
            itemParam["request_id"] = reqId
        }
        return itemParam
    }
    
    public func gaProductImpressionParamFor(item: SFLayoutItem) -> SFJSONDictionary {
        var productDict = item.gaProductImpressionParam()
        var fromCart = ""
        var infiniteGrid = ""
        if self.layoutVType == .tree1 {
            if item.itemType == SFLayoutItemType.header {
                productDict["name"] = self.gaKey + "-" + self.vTitle +  "-L1"
                
            }else {
                productDict["name"] = self.gaKey + "-" + self.vTitle +  "-L2"
            }
            productDict["position"] = item.layoutIndex
        }else if self.layoutVType == .itemInCart {
            fromCart = "-cart_widget"
        }else if self.layoutVType == .tabbed1 {
            infiniteGrid = "--infinite_grid"
        }
        
        var listType = self.gaKey + "-" + self.vTitle + fromCart + infiniteGrid
        if infiniteGrid.length > 0 {
            listType = self.gaKey + "-" + infiniteGrid
        }
        if item.experiment.length > 0 {
            listType = listType + "_experimentName=\(item.experiment)"
        }
        productDict["dimension24"] = listType
        productDict["list"] = productDict["dimension24"]
        productDict["dimension38"] = self.vId
        productDict["dimension40"] = datasourceContainerInstanceID
        productDict["dimension67"] = self.vType
        productDict["dimension70"] = self.viewPosition
        productDict["view_id"] = self.vId
        if viewTag.isValidString() {
            productDict["view_tag"] = viewTag
        }
        productDict["storefront_id"] = self.pageId
        if(!self.vTitle.isEmpty) {
            productDict["title"] = self.vTitle
        }
        if let context = self.contextParams,let reqId = context["request_id"] as? String  {
            productDict["request_id"] = reqId
        }
        return productDict
    }
    
    public var datasourceContainerInstanceID: String {
        get  {
            var mInstId = ""
            if let dsInfo = self.vDataSourcesInfos.first, let instId = dsInfo.containerInstanceId {
                mInstId = instId
            }
            return mInstId
        }
    }
}

public class SFMetaLayoutInfo {
    public private(set) var bgImageUrl: String?
    public private(set) var bgColor: String?
    public private(set) var bgGradient: [String]?
    
    init(dict: SFJSONDictionary) {
        bgImageUrl = dict["bg_image_url"] as? String
        bgColor = dict["bg_color"] as? String
        bgGradient = dict["bg_gradient"] as? [String]
    }
}

public class SFStoreInfo {
    public private(set) var name            : String?
    public private(set) var locality        : String?
    public private(set) var city            : String?
    public private(set) var logo            : String?
    public private(set) var logoUrl         : String?
    public private(set) var coverPic        : String?
    public private(set) var seeAllStoresUrl : String?
    public var isFollowing : Bool = false
    
    init(dict: SFJSONDictionary) {
        name = dict["name"] as? String
        locality = dict["locality"] as? String
        city = dict["city"] as? String
        logo = dict["logo"] as? String
        logoUrl = dict["logoUrl"] as? String
        coverPic = dict["coverPic"] as? String
        seeAllStoresUrl = dict["see_all_stores"] as? String
        if let follow = dict["isFollowing"] as? Bool {
            isFollowing = follow
        }
    }
}

public class SFReviewRatingInfo {
    public private(set) var totalReviews: Int?
    public private(set) var avgRating: Double?
    public private(set) var totalRatings: Int?
    public private(set) var entityIdentifier: String?
    public private(set) var getAllReviewURL: String?
    public private(set) var ratingDict: [String: Any]?
    
    init(dict: SFJSONDictionary) {
        totalReviews = dict["totalReview"] as? Int
        avgRating = dict["avgRating"] as? Double
        totalRatings = dict["totalRatings"] as? Int
        entityIdentifier = dict["entityIdentifier"] as? String
        getAllReviewURL = dict["seourl"] as? String
        if let tempDict = dict["levelToRateCount"] as? [String: Any] {
            var ratingsDict: [String:Any] = [String:Any]()
            for (key, value) in tempDict {
                ratingsDict[key] = value
            }
            ratingDict = ratingsDict
        }
    }
}

public class SFLayoutDataSourceInfo {
    public private(set) var containerInstanceId: String?
    public private(set) var type        : String?
    public private(set) var containerId : String?
    public private(set) var listId      : String?
    
    init(dict: SFJSONDictionary) {
        containerInstanceId = dict["container_instance_id"] as? String
        type        = dict["type"] as? String
        containerId = dict["container_id"] as? String
        listId      = dict["list_id"] as? String
    }
}


