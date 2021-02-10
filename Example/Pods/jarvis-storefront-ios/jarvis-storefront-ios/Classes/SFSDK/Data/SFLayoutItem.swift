//
//  SFLayoutItem.swift
//  StoreFront
//
//  Created by Prakash Jha on 24/07/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import Foundation

public enum SFLayoutItemType {
    case regular
    case header
    case more
    case empty
    case showMore
}

public enum Tabbed2ItemType: String {
    case search =           "search"
    case home =             "home"
    case allProducts =      "all_products"
    case vouchers =         "vouchers"
    case stores =           "stores"
    case reviewAndRating =  "review_and_rating"
}

public class SFLayoutItem: NSObject, NSCoding {
    public private(set) var itemJsonDict: [String: Any]? // Complete Json dict of an Item
    public private(set) var itemDict: [String: Any]?
    
    public private(set) var itemId = 0
    public var viewId: Int?
   // public private(set) var itemUName: String?
    public private(set) var itemPriority = 0
    public var itemName = ""
    public var itemsubName = ""
    public private(set) var itemLevelIndex:Int = 1
    public private(set) var itemIndex:Int = 1
    
    public private(set) var itemTag = ""
    public private(set) var itemTitle = ""
    public private(set) var itemSubTitle = ""
    public private(set) var itemImageUrl = ""
    public private(set) var itemUrl = ""
    public private(set) var iconUrl: String = ""
    public private(set) var isOverlay: Bool = false
    public private(set) var isRecentServices: Bool = false
    
    public private(set) var classType: String?
    
    public private(set) var itemUrlInfo = ""
    public private(set) var itemUrlType = ""
    
    public private(set) var iconIds: [Int] = [Int]()

    public var itemNewUrl = ""
    public var itemSeoUrl = ""
    public private(set) var itemsource = ""
    
    public private(set) var offerPrice: Double?
    public private(set) var actualPrice: Double?
    public private(set) var discount: String?
    public private(set) var offerText: String?
    
    public private(set) var itemGaCategory = ""
    public private(set) var localImgName   = ""
    
    public private(set) var productId: String?
    public private(set) var parentId: String?
    public private(set) var inStock: Bool?
    public private(set) var verticalId: Int?
    
    public private(set) var layoutLabel: String?
    public private(set) var layoutLabelColor: String?
    public private(set) var layoutLabelBG: String?
    
    public var items: [SFLayoutItem] = [SFLayoutItem]()
    public var relatedCategories : [SFJSONDictionary]?
    
    public var v1OfferText:String?
    public var v1OfferSubText:String?
    public private(set) var v1RedemptionType:String?
    
    public private(set) var avgRating:Double?
    public private(set) var totalRatings:Int?
    public private(set) var totalReview:Int?
    public var isAddToCartEnabled:Bool?
    public var isOfflineFlow: Bool = false
    public var isPromo:Bool = false
    public var quantity:Int = 0
    public var maxQuantity:Int = 10000
    public var isCTAUrlClicked:Bool = false
    
    public private(set) var displayMetadata: SFJSONDictionary?
    
    // Active Orders
    public var orderId: Int? // Used to open Order details on click active order item
    public private(set) var itemStatus: Int?
    public private(set) var statusText2: String?
    public private(set) var orderItemThumbnailImageUrl: String?
    
    /** Infinite grid related Internal Variables
     - These are the vars used in infinite grid within CLP
     */
    public var gridLayout: SFGridLayoutParser?
    public var gridItems: [[SFLayoutItem]] = [[SFLayoutItem]]() // To display in Tabbed section
    public var isGridItemLoading: Bool = false
    public var gridItemPageCount: Int = 1
    public var gridBadges:[[String:Any]]?
    private var itemBrand: String?
    private var merchantID: Int?
    private var flashSale: Int = 0
    var isFlashSaleTimerShow: Bool = false
    var isFlashSaleValidUpto: String?

    var experiment:String = ""
    public var datasourceContainerInstanceID: String = ""
    public var ctCampaignId: String?
    public var ctVariantId: String?
    
    public private(set) var showBrand: Bool = false
    public private(set) var brand: String?
    
    public private(set) var tabbed2ItemType: Tabbed2ItemType?
    public private(set) var childWidgetJson: [String: Any]?
    
    // Filters
    public var originalGridItemSeoUrl:String?
    var filterUrl:String?
    
    // Internal Variables
    var isExpanded: Bool = false
    var isSelected: Bool = false
    var isItemImageCached: Bool = false
    var isLastItem: Bool = false
    var showSeparator: Bool = false
   
    public private(set) var itemType = SFLayoutItemType.regular
    public private(set) var isImpressionFired = false
    var layoutIndex = 0
    public var isItemViewType = false
    //Favourite Stores
    public private(set) var greetingMsg: String?
    public private(set) var itemFSID: String?
    public private(set) var merchantName: String?
    public private(set) var brandName: String?
    public private(set) var merchantImageName: String?
    public private(set) var itemLogoUrl = ""
    public private(set) var offerItems: [FSOffersLayout] = [FSOffersLayout]()
    public var storeItems: [FSStoresLayout] = [FSStoresLayout]()
    public private(set) var image: String?
    public private(set) var weather: String?
    public private(set) var cardNo: String?
    public private(set) var amount: String?
    public private(set) var degree: Double?
    public var isLike: Bool = false
    public var isFollowing: Bool = false
    public var likeCount = 0
    public private(set) var shareCount = 0
    public private(set) var dmsId: String?
    public private(set) var shareUrl: String?
    public private(set) var contractId: String?
    public private(set) var feedDescription: String?
    public private(set) var variants : SFJSONDictionary?
    public private(set) var attributes : SFJSONDictionary?
    public private(set) var endTime: String?
    public private(set) var startTime: String?
    public private(set) var varientItems:[SFLayoutItem] = [SFLayoutItem]()
    public var parentUrlString: String?
    public var selectedVariantName:String?

    public private(set) var sponsored: Bool?
    public private(set) var plaTrackingID: String?
    public private(set) var activeFrom: String?
    public private(set) var contextParams: [String:Any]?
    public private(set) var text1: String?
    public private(set) var labelColor: String?
    public private(set) var variantInstanceID: String?
    public private(set) var ctaLabel: String?
    public private(set) var ctaUrl: String = ""
    public private(set) var ctaUrlType = ""
    public private(set) var itemColor = ""
    public private(set) var itemInitial = ""
    
    public private(set) var altImageUrl: String?
    
    private var category: String = ""

    public func setImpressionFired() { // must set it true once get it fired at your end
        isImpressionFired = true
    }
    
    public init(dict: SFJSONDictionary) {
        super.init()
        self.itemJsonDict = dict
        self.itemDict = dict
        self.itemId       = dict.sfIntFor(key: "id")
        self.category = dict.sfStringFor(key: "category")
       // self.itemUName = dict.sfStringFor(key: "unique_name")
        self.itemIndex = dict.sfIntFor(key: "item_index")
        self.itemPriority = dict.sfIntFor(key: "priority")
        self.itemName     = dict.sfStringFor(key: "name")
        self.itemsubName = dict.sfStringFor(key: "subtitle") // why?? 2 time 'itemSubTitle'
        self.classType = dict.sfStringFor(key: "class")
        self.iconUrl = dict.sfStringFor(key: "icon_url")
        self.isOverlay = dict.booleanFor(key: "is_overlay")
        self.isRecentServices = dict.booleanFor(key: "recent_services")
        self.datasourceContainerInstanceID = dict.sfStringFor(key: "container_instance_id")
        self.itemTag    = dict.sfStringFor(key: "tag")
        self.itemTitle    = dict.sfStringFor(key: "title")
        self.itemSubTitle = dict.sfStringFor(key: "subtitle")
        self.itemImageUrl = dict.sfStringFor(key: "image_url")
        self.plaTrackingID = dict["pla_tracking_id"] as? String
        self.ctVariantId = dict.sfStringFor(key: "ct_variant_id")
        self.ctCampaignId = dict.sfStringFor(key: "ct_campaign_id")
        // Prefetch Images for marketplace according to network type
        if !itemImageUrl.isEmpty, SFManager.shared.sfConfig.sfAppType == .marketplace {
            itemImageUrl = SFImageCacheManager.modifyUrl(itemImageUrl)
            SFImageCacheManager.loadImageForMarketplace(self.itemImageUrl)
        }
        self.itemUrl      = dict.sfStringFor(key: "url")
        
        self.itemUrlInfo = dict.sfStringFor(key: "url_info")
        self.itemUrlType = dict.sfStringFor(key: "url_type")
        self.itemSeoUrl  = dict.sfStringFor(key: "seourl")
        self.itemNewUrl  = dict.sfStringFor(key: "newurl")
        if !self.itemNewUrl.isValidString() {
            self.itemNewUrl = self.itemSeoUrl
        }
        self.itemsource  = dict.sfStringFor(key: "source")
        self.quantity = dict.sfIntFor(key: "qty")
        self.maxQuantity = dict.sfIntFor(key: "max_purchasable_qty")
        self.altImageUrl = dict.sfStringFor(key: "alt_image_url")
        if let pid = dict["product_id"] as? Int {
            self.productId = "\(pid)"
        }
        
        self.contextParams = dict["contextParam"] as? [String: Any]
        let strValue =  self.contextParams?.sfStringFor(key: "discoverability")
        if strValue == "offline" {
            isOfflineFlow = true
        }
        
        self.relatedCategories = dict["related_category"] as? [SFJSONDictionary]
        self.variants = dict["variants"] as? SFJSONDictionary
        self.attributes = dict["attributes"] as? SFJSONDictionary
    
        if let varients = self.variants?["items"] as? [[String:Any]], varients.count  > 0 {
            varientItems.removeAll()
            for variantDict in varients {
                let item = SFLayoutItem(dict: variantDict)
                item.selectedVariantName = self.variantAttributeName()
                varientItems.append(item)
            }
        }
        
        if let parentId = dict["parent_id"] as? Int {
            self.parentId = "\(parentId)"
        }
        
        if let _ = dict["actual_price"] {
            isPromo = false
        }else {
            isPromo = true
        }
        
        if let itemTypeString = dict["type"] as? String, let itemType = Tabbed2ItemType(rawValue: itemTypeString) {
            tabbed2ItemType = itemType
        }
        
        if let childItemsJsonArray = dict["child_items"] as? [[String: Any]] {
            childWidgetJson = ["page": childItemsJsonArray] // added page key to direct pass to clp screen
        }
        
        itemBrand = dict.sfStringFor(key: "brand")
        merchantID = dict.sfIntFor(key: "merchant_id")
        
        if let inStk = dict["instock"] as? Bool {
            inStock = inStk
        }
        else if let inStk = dict["is_in_stock"] as? Bool {
            inStock  = inStk
        }else if let inStk = dict["stock"] as? Bool {
            inStock  = inStk
        }
        
        if let isSponsored = dict["sponsored"] as? Bool {
            sponsored  = isSponsored
        }
        
        let iconInformation = dict["group_view_id"] as? SFJSONDictionary
        if let iconInformation = iconInformation {
            if let iconIds = iconInformation["icon_view_id"] as? [Int] {
                self.iconIds = iconIds
            }
        }
        
        verticalId = dict["vertical_id"] as? Int
        offerPrice = dict["offer_price"] as? Double
        
        if let shBrnd = dict["show_brand"] as? Bool {
            showBrand = shBrnd
        }
        
        brand = dict["brand"] as? String
        
        if let cardTempate = dict["cardTemplate"] as? [String: Any], let name = cardTempate["name"] as? String {
            brandName = name
            if let merchantLogoInfo = cardTempate["merchantLogoInfo"] as? [String: Any], let imageName = merchantLogoInfo["merchantImageName"] as? String {
                merchantImageName = imageName
            }
        }
        
       
        
        if let price = dict["actual_price"] as? Double {
            actualPrice = price
        }
        else if let priceString = dict["actual_price"] as? String, let price = Double(priceString) {
            actualPrice = price
        }
        
        discount = dict["discount"] as? String
        avgRating = dict["avg_rating"] as? Double
        totalRatings = dict["total_ratings"] as? Int
        totalReview = dict["total_review"] as? Int
        isAddToCartEnabled = dict["add_to_cart"] as? Bool
        if let offersDict = dict["offers"] as? [[String: Any]], let offerDict = offersDict.first {
            let internalOfferDict = offerDict["offer"] as? [String: Any]
            offerText = internalOfferDict?["text"] as? String
            if let isFlashSaleProduct = offerDict["isFlashCode"] as? Bool , isFlashSaleProduct {
                self.flashSale = 1
            }
            if let isFlashSaleProduct = offerDict["isFlashCode"] as? Bool, let validUpto = offerDict["validUpto"] as? String {
                isFlashSaleTimerShow = isFlashSaleProduct
                isFlashSaleValidUpto = validUpto
            }
            if let v1OfferDict = offerDict["offer_v1"] as? [String: Any] {
                v1OfferText = v1OfferDict["text"] as? String
                v1OfferSubText = v1OfferDict["subtext"] as? String
                v1RedemptionType = v1OfferDict["type"] as? String
            }
        }
        
        self.itemGaCategory  = dict.sfStringFor(key: "ga_category")
        self.layoutLabel = (dict["layout"] as? SFJSONDictionary)?["label"] as? String
        self.layoutLabelColor = (dict["layout"] as? SFJSONDictionary)?["label_text_color"] as? String
        self.layoutLabelBG = (dict["layout"] as? SFJSONDictionary)?["label_bgcolor"] as? String

        self.itemStatus = dict["item_status"] as? Int
        self.statusText2 = dict["status_text2"] as? String
        self.orderItemThumbnailImageUrl = (dict["product"] as? SFJSONDictionary)?["thumbnail"] as? String
        
        if let mItems = dict["items"] as? [SFJSONDictionary], mItems.count > 0 {
            items.removeAll()
            for (index,itemDict) in mItems.enumerated() {
                var itemDictWithIndices = itemDict
                itemDictWithIndices["item_index"] = index + 1
                itemDictWithIndices["item_level"] = self.itemLevelIndex + 1
                items.append(SFLayoutItem(dict: itemDictWithIndices))
            }
        }
        
        if let gridBadges = dict["grid_badges"] as? [[String:Any]] {
            self.gridBadges = gridBadges
        }
        originalGridItemSeoUrl = itemSeoUrl
        filterUrl = itemSeoUrl
        self.itemLevelIndex = dict.sfIntFor(key: "item_level")
        
        // Favourite Stores
        self.greetingMsg  = dict.sfStringFor(key: "message")
        self.itemFSID     = dict.sfStringFor(key: "id")
        self.merchantName = dict.sfStringFor(key: "merchant_name")
        self.itemLogoUrl = dict.sfStringFor(key: "logoUrl")
        self.image = dict.sfStringFor(key: "image")
        self.weather = dict.sfStringFor(key: "weather")
        self.cardNo = dict.sfStringFor(key: "cardNo")
        self.degree = dict["deg"] as? Double
        if let totalAmount = dict["totalBalance"] as? SFJSONDictionary, let amount = totalAmount["amountInRs"] as? String {
            self.amount = amount
        }
        
        if let mOffers = dict["offers"] as? [SFJSONDictionary], mOffers.count > 0 {
            offerItems.removeAll()
            for itemDict in mOffers {
                offerItems.append(FSOffersLayout(dict: itemDict))
            }
        }
        if let mstores = dict["stores"] as? [SFJSONDictionary], mstores.count > 0 {
            storeItems.removeAll()
            for itemDict in mstores {
                storeItems.append(FSStoresLayout(dict: itemDict))
            }
        }
        
        if let isLike = dict["isLike"] as? Bool {
            self.isLike = isLike
        }
        
        if let isFollowing = dict["isFollowing"] as? Bool {
            self.isFollowing = isFollowing
        }
        
        self.likeCount = dict.sfIntFor(key: "likeCount")
        self.shareCount = dict.sfIntFor(key: "shareCount")
        self.dmsId  = dict.sfStringFor(key: "dmsId")
        self.shareUrl  = dict.sfStringFor(key: "shareUrl")
        self.contractId  = dict.sfStringFor(key: "contractId")
        self.feedDescription  = dict.sfStringFor(key: "description")
        self.displayMetadata = dict["display_metadata"] as? SFJSONDictionary
        self.activeFrom  = dict.sfStringFor(key: "activeFrom")
        self.startTime  = dict.sfStringFor(key: "start_time")
        self.endTime  = dict.sfStringFor(key: "end_time")
        
        if let ctaDict = dict["cta"] as? [String: Any], let label = ctaDict["label"] as? String, let url = ctaDict["url"] as? String {
            ctaLabel = label
            ctaUrl = url
            if let urlType = ctaDict["url_type"] as? String {
                ctaUrlType = urlType
            }
        }
        
        if let subLabel = dict["text1"] as? String {
            self.text1 = subLabel
        }
        
        if let variantID = dict["variant_instance_id"] as? String {
            variantInstanceID = variantID
        }
        
        if let labelColor = dict["labelColor"] as? String {
            self.labelColor = labelColor
        }

        self.itemColor = dict.sfStringFor(key: "imgfb_color")
        self.itemInitial = dict.sfStringFor(key: "imgfb_text")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(parentId, forKey: "parentId")
        aCoder.encode(productId, forKey: "productId")
        aCoder.encode(itemName, forKey: "itemName")
        aCoder.encode(itemImageUrl, forKey: "itemImageUrl")
        aCoder.encode(itemUrlType, forKey: "itemUrlType")
        aCoder.encode(itemSeoUrl, forKey: "itemSeoUrl")
        aCoder.encode(itemNewUrl, forKey: "itemNewUrl")
        aCoder.encode(itemUrl, forKey: "itemUrl")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        parentId = aDecoder.decodeObject(forKey: "parentId") as? String
        productId = aDecoder.decodeObject(forKey: "productId") as? String
        itemName = aDecoder.decodeObject(forKey: "itemName") as? String ?? ""
        itemImageUrl = aDecoder.decodeObject(forKey: "itemImageUrl") as? String ?? ""
        itemUrlType = aDecoder.decodeObject(forKey: "itemUrlType") as? String ?? ""
        itemSeoUrl = aDecoder.decodeObject(forKey: "itemSeoUrl") as? String ?? ""
        itemNewUrl = aDecoder.decodeObject(forKey: "itemNewUrl") as? String ?? ""
        itemUrl = aDecoder.decodeObject(forKey: "itemUrl") as? String ?? ""
    }
}


// MARK: - IP/OP
extension SFLayoutItem {
    public var categoryName: String {
        if !self.category.isEmpty {
           return self.category
        }
        return self.itemName
    }
    
    // SFLayoutItem.emptyItem
    public class var emptyItem: SFLayoutItem {
        return SFLayoutItem.customItemWith(type: .empty, title: "", localImg: "")
    }
    
    public class func customItemWith(type: SFLayoutItemType, title: String, localImg: String) -> SFLayoutItem {
        let tItem = SFLayoutItem(dict: [:])
        tItem.itemName = title
        tItem.localImgName = localImg
        tItem.itemType = type
        tItem.itemLevelIndex = 1
        tItem.itemIndex = 6
        return tItem
    }
    
    public class func customItemWith(type: SFLayoutItemType, title: String, localImg: String, imageUrl:String, seoUrl:String = "", subTitle:String = "", itemIndex: Int = 6) -> SFLayoutItem {
        let tItem = SFLayoutItem(dict: [:])
        tItem.itemName = title
        tItem.localImgName = localImg
        tItem.itemImageUrl = imageUrl
        tItem.itemType = type
        tItem.itemLevelIndex = 1
        tItem.itemIndex = itemIndex
        tItem.itemUrl = seoUrl
        tItem.itemSubTitle = subTitle
        return tItem
    }
    
    
    public func gaDataForPreviousScreenInH5() -> SFJSONDictionary{
        var itemImpressionDict = [String:Any]()
        itemImpressionDict["prev_widget_name"] = self.itemName
        itemImpressionDict["list_position"] = self.itemIndex
        return itemImpressionDict
    }
    
    public func gaImpressionParam() -> SFJSONDictionary {
        var itemImpressionDict = [String:Any]()
        itemImpressionDict["creative"] = itemGaCategory + "/" + self.itemName
        itemImpressionDict["id"] = self.itemId
        if let variantID = self.ctVariantId,!variantID.isEmpty {
            itemImpressionDict["ct_variant_id"] = variantID
        }
        if let campaignID = self.ctCampaignId,!campaignID.isEmpty {
            itemImpressionDict["ct_campaign_id"] = campaignID
        }
        
        return itemImpressionDict
    }
    
    public func gaProductImpressionParam() -> SFJSONDictionary {
        var prodImpressionDict = [String:Any]()
        prodImpressionDict["brand"] = self.itemBrand
        prodImpressionDict["dimension25"] = self.itemIndex
        prodImpressionDict["dimension31"] = self.parentId
        prodImpressionDict["dimension41"] = self.merchantID
        var flashSaleDict: [String:Any] = [String:Any]()
        flashSaleDict["flash_sale"] = self.flashSale
        prodImpressionDict["dimension79"] = flashSaleDict
        prodImpressionDict["id"] = self.itemId
        prodImpressionDict["name"] = self.itemName
        prodImpressionDict["position"] = self.itemIndex
        prodImpressionDict["price"] = self.offerPrice
        if let plaTrackingId = self.plaTrackingID {
             prodImpressionDict["dimension52"] = plaTrackingId
        }
        if let variantInstanceID = variantInstanceID, variantInstanceID.length > 0 {
            prodImpressionDict["variantInstanceId"] = variantInstanceID
        }
        if let variantID = self.ctVariantId,!variantID.isEmpty {
            prodImpressionDict["ct_variant_id"] = variantID
        }
        if let campaignID = self.ctCampaignId,!campaignID.isEmpty {
            prodImpressionDict["ct_campaign_id"] = campaignID
        }
        return prodImpressionDict

    }
    
    public func getItemIDByAppendingProductID() -> String? {
        if let pid = productId {
            return pid + "pid"
        }
        return nil
    }
    public func getGridBadgeToShow() -> (String,String)? {
        if let gridBadge = self.gridBadges , gridBadge.count > 0 , let badge = gridBadge.first as? [String: String]{
            if let badgeText = badge["text"], let badgeUrl = badge["img_url"] {
                return (badgeText,badgeUrl)
            }
        }
        return nil
    }
    
    public func shouldShowVariantView() -> Bool {
        if let variants = self.variants , let dimensions = variants["dimensions"] as? [[String:Any]], dimensions.count > 0 {
            return true
        }
        return false
    }
    
    public func shouldAllowTapOnVariants() -> Bool {
        if let variants = self.variants , let dimensions = variants["dimensions"] as? [[String:Any]], dimensions.count > 0 , let variantsObject = dimensions.first {
                if let count = variantsObject["count"] as? Int , count > 1 {
                return true
            }
        }
        return false
    }
    
    public func variantTitleName() -> String? {
        if let variants = self.variants , let dimensions = variants["dimensions"] as? [[String:Any]], dimensions.count > 0 , let variantsObject = dimensions.first {
            if let variantName = variantsObject["label"] as? String, let attributeName = self.attributes?[variantName] as? String {
                return attributeName
            }
        }
        return nil
    }
    public func variantAttributeName() -> String? {
        if let variants = self.variants , let dimensions = variants["dimensions"] as? [[String:Any]], dimensions.count > 0 , let variantsObject = dimensions.first {
            if let variantName = variantsObject["label"] as? String {
                return variantName
            }
        }
        return nil
    }
    
    public func getItemVariantDescriptionTitle() -> String? {
        if let variantName = self.selectedVariantName, let attributes = self.attributes , let title = attributes[variantName] as? String {
            return title
        }
        return nil
    }
    
    public func updateItem(_ newItem:SFLayoutItem){
            itemName = newItem.itemName
            offerPrice = newItem.offerPrice
            actualPrice = newItem.actualPrice
            discount = newItem.discount
            v1OfferText = newItem.v1OfferText
            v1OfferSubText = newItem.v1OfferSubText
            attributes = newItem.attributes
            productId = newItem.productId
            itemId = newItem.itemId
    }
    
    public func getFlagToHideFlashSaleInfo() -> Bool {
        var isPriceHideForFlashSale: Bool = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int {
            if let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                if let startTimeStr = self.startTime, let endTimeStr = self.endTime {
                    if  let startTime = dateFormatter.date(from: startTimeStr), let endTime = dateFormatter.date(from: endTimeStr) {
                        if date > startTime && date <= endTime {
                            isPriceHideForFlashSale = false
                        }
                        else {
                            isPriceHideForFlashSale = true
                        }
                    }
                }
            }
        }
        return isPriceHideForFlashSale
    }
}
