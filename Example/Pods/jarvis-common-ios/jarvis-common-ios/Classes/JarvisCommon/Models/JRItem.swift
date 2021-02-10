//
//  JRItem.swift
//  jarvis-auth-ios
//
//  Created by Gulshan Kumar on 22/12/20.
//

import Foundation
import jarvis_utility_ios

@objc(JRItem)
@objcMembers public class JRItem: NSObject, NSCoding {

    public var itemDescription: String?
    weak var parent: JRItem?
    
    //@property (nonatomic, copy) NSString *createdOn;
    
    @objc public var url: String = ""
    @objc public var imageUrl: String?
    @objc public var offerPrice: String?
    @objc public var actualPrice: String?
    public var urlType: String = ""
    @objc public var items: [JRItem] = []
    @objc public var name: String = ""
    public var titleText: String?
    public var subTitleText: String?
    public var tag: String?
    public var vertical: String?
    
    @objc public var categoryId: NSNumber?
    @objc public var productID: String?
    var complexProductID: String?
    public var seoURL: String?
    @objc public var parentId: String?
    @objc public var brand: String?
    @objc public var category: String?
    var category_Name: String?
    public var ga_category: String?
    @objc public var listId = 0.0
    var tnc: [AnyHashable]?
    var showBottomTab = false
    var selectedImageUrl: String?
    public var unSelectedImageUrl: String?
    @objc public var layoutType: String?

    ////used for prepaid and postpaid recharges
    public var relatedCategories: [AnyHashable]?
    public var label: String?
    //
    //// These two properties are using to show Tag labels in Catalog View
    var tagLabelName: String?
    var tagLabelColor: UIColor?
    //
    var imageSize = CGSize.zero
    var inStock = false
    public var discount: String?
    //
    var expanded = false
    
    private var _selected = false
    var selected: Bool {
        get {
            return _selected
        }
        set {
            _selected = newValue
            JRItem.selectedItem = self
        }
    }

    private var _opened = false
    var opened: Bool {
        get {
            return _opened
        }
        set {
            self._opened = newValue
            if newValue == false {
                for child in self.items {
                    child.opened = false
                    child.expanded = false
                }
            }
        }
    }
    
    var level = 0
    //GTM releated
    public var isGTMTracked = false
    @objc public var positionInList = 0
    @objc public var source: String?
    @objc public var isSmartIcon = false
    //Video Ad
    @objc public var layoutInfo: NSDictionary?
    // Layout related
    public var displayMetadata: [AnyHashable : Any]?
    //midgar changes
    @objc public var datasourceContainerID = 0.0
    @objc public var datasourceListID = 0.0
    @objc public var datasourceContainerInstanceID: String?

    @objc public var datasourceType: String?
    var weight: NSNumber?
    public var itemId: NSNumber?
    var sequence = 0
    public var viewIds: [NSNumber]?
    var tickerId: [NSNumber]?
    // Changes related to Store Front -> Home
    public var isCTAUrlClicked = false
    public var itemCTAUrl: String?

    static var selectedItem:JRItem?
    static var itemLevel:Int = 0
    static var sequenceNo:Int = 0

    public class func unSelectTheLastSelctedItem() {
        JRItem.selectedItem?.selected = false
    }

    public func setWithDictionary(dictionary: [AnyHashable: Any]) {
        self.brand = dictionary["brand"] as? String

        var children: [JRItem] = []
        var index = 1

        if let items = dictionary["items"] as? [[AnyHashable: Any]] {
            for item in items {
                // Ignoging "mobile-postpaid" and "datacard-postpaid" Since which is
                // included in prepaid views only
                let urlTp = item["url_type"] as? String

                if (urlTp == "mobile-postpaid") || (urlTp == "datacard-postpaid") {
                } else {
                    JRItem.itemLevel += 1
                    let child = JRItem(dictionary: item)
                    child.parent = self
                    child.positionInList = index
                    index += 1
                    children.append(child)
                    JRItem.itemLevel -= 1
                }
            }
        }



        self.items = children
        self.level = JRItem.itemLevel
        if let str = dictionary["name"] as? String {
            self.name = str
        }

        self.titleText = dictionary["title"] as? String
        self.subTitleText = dictionary["subtitle"] as? String
        self.vertical = dictionary["vertical"] as? String
        self.ga_category = dictionary["ga_category"] as? String
        self.itemDescription = dictionary["description"] as? String
        
        if let urlStr = dictionary["url"] as? String {
            self.url = urlStr
        }

        if self.url.isEmpty {
            if let urlStr = dictionary["seourl"] as? String {
                self.url = urlStr
            }
        }
        self.seoURL = dictionary["seourl"] as? String
        //    self.createdOn = [dictionary[@"created_on"] validObjectValue];
        self.categoryId = dictionary["category_id"] as? NSNumber
        self.itemId = dictionary["id"] as? NSNumber

        self.displayMetadata = dictionary["display_metadata"] as? [AnyHashable: Any]

        if let type = dictionary["url_type"]  as? String {
            self.urlType = type
        }

        if let iconInformation = dictionary["group_view_id"] as? [AnyHashable: Any]   {
            let arrView = iconInformation["icon_view_id"] as? [NSNumber]
            let arrTickers = iconInformation["ticker_view_id"] as? [NSNumber]
            if let ids = arrView {
                viewIds = ids
                tickerId = arrTickers //TODO: GK Check the ticker Id setting in .h file
            }
        }

        if JRCommonManager.shared.moduleConfig.varient == JRVarient.paytm && JRCommonManager.shared.applicationDelegate != nil {
            let urlContainsFastagProductId = self.url.contains(JRCommonManager.shared.applicationDelegate!.fastagProductIdFromTollPDPManager())
            if self.urlType == JRCommonManager.shared.applicationDelegate?.geturlTypeProductFromJRDeeplinkHandler() &&
                urlContainsFastagProductId {
                self.urlType = JRCommonManager.shared.applicationDelegate!.getUrlTypeFastagFromJRDeepLinkHandler()
            }
        }

        let isCategoryIdNotAvailable = self.categoryId == nil || self.categoryId!.stringValue.isEmpty
        if isCategoryIdNotAvailable, let isCacheUpdated = JRCommonManager.shared.applicationDelegate?.getCatalogCacheUpdatedFromJrServer(),
            isCacheUpdated && self.isURLTypeFromRechargeAndPay(itemName: self.name) {
            self.categoryId = self.performFetchingOfCategoryId(self.urlType, forArray: JRCommonManager.shared.applicationDelegate?.getCatalogItemsFromJrServer() ?? [], andName: self.name)
        }

        // Some carousel item having only id as property
        self.categoryId = self.categoryId != nil ? self.categoryId : dictionary["id"] as? NSNumber
        self.complexProductID = dictionary["complex_product_id"] as? String

        if let parentId = dictionary["parent_id"] as? String {
            self.parentId = parentId
        } else if let parentId = dictionary["parent_id"] as? NSNumber {
            self.parentId = parentId.stringValue
        } else if let pid = dictionary["id"] as? String {
            self.parentId = pid
        } else if let pid = dictionary["id"] as? NSNumber  {
            self.parentId = pid.stringValue
        }
        
        /**
         *  Keeping it numeric causes problems in swift class.
         */
        let productID = dictionary["product_id"].isNotNil() ? dictionary["product_id"] : dictionary["id"]
        if let pid = productID as? NSNumber {
            self.productID = String(format:"%@", pid)
        } else if let pid = productID as? String {
            self.productID = String(format:"%@", pid)
        }

        var priceValue = dictionary["offer_price"]
        if let price = priceValue as? NSNumber
        {
            self.offerPrice = String(format:"%f", price.floatValue)
        }
        else if let price = priceValue as? String
        {
            self.offerPrice = price
        }

        priceValue = dictionary["actual_price"]
        if  let price = priceValue as? NSNumber
        {
            self.actualPrice = String(format:"%f", price.floatValue)
        }
        else if let price = priceValue as? String
        {
            self.actualPrice = price
        }

        self.imageUrl = dictionary["image_url"] as? String
        self.selectedImageUrl = dictionary["image_url"] as? String
        self.unSelectedImageUrl = dictionary["alt_image_url"] as? String

        self.tag = dictionary["tag"] as? String
        self.label = dictionary["label"] as? String
        self.tagLabelName = (dictionary["tag_label_name"] as? String)?.capitalized
        self.category = dictionary["category"] as? String

        // #00ff00 color in HEXCODE string
        var colorValue:String = "ff0000"
        if let color = dictionary["tag_label_color"] as? String, !color.isEmpty {
            colorValue = color
        }

        self.tagLabelColor = UIColor(hexString:colorValue)


        self.tnc = dictionary["tnc"] as? [AnyHashable]
        if let shouldShowBotttomTab = dictionary["show_bottom_nav"] as? NSNumber {
            self.showBottomTab = shouldShowBotttomTab.boolValue
        }
        else if let shouldShowBotttomTab = dictionary["show_bottom_nav"] as? NSString {
            self.showBottomTab = shouldShowBotttomTab.boolValue
        }
        else {
            self.showBottomTab = true
        }

        if (self.urlType == "my_orders") || (self.urlType == "cart") { // Forcing myorders and cart not to show bottom tab bar because of not loggedin case issue.
            self.showBottomTab = false
        }

        //   self.tnc = @[
        //     @"Flat ₹500 Cashback on flight bookings",
        //     @"Minimum trasaction value is ₹3500.",
        //     @"Offer is valid three times per user.",
        //     @"Cashback will be credited within 24 hours of the transaction.",
        //     @"The user needs to have verified mobile number on Paytm to get cash back.",
        //     @"Cancelled orders will not be eligible.",
        //     @"Paytm reserves its absolute right to withdraw and/or alter any terms and conditions of the offer at any time without prior notice." ];

        let data: [AnyHashable]? = dictionary["related_category"] as? [AnyHashable]
        if let relatedCategory = data,  !relatedCategory.isEmpty {
            var tempArray: [AnyHashable] = [AnyHashable]()

            let prepaidCategory:JRRelatedRechargeCategory = JRRelatedRechargeCategory(name: self.label ?? "", url: self.url)
            tempArray.append(prepaidCategory)

            for category in relatedCategory {
                if let categoryDict = category as? [AnyHashable : Any] {
                    tempArray.append(JRRelatedRechargeCategory(dictionary: categoryDict))
                }
            }
            self.relatedCategories = tempArray
        }
        else
        {
            self.relatedCategories = nil
        }

        if let value =  dictionary["stock"] as? Bool  {
            self.inStock = value
        }

        var height:CGFloat = 0.0
        if let h = dictionary["img_height"] as? CGFloat {
            height = h
        }

        var width:CGFloat = 0.0
        if let w = dictionary["img_width"] as? CGFloat {
            width = w
        }


        height = (height == 0.0) ? 400.0 : height
        width = (width == 0.0) ? 400.0 : width
        self.imageSize = CGSize(width: width, height: height)

        if let discount = dictionary["discount"] as? NSNumber {
            self.discount = discount.stringValue
        } else if let discount = dictionary["discount"] as? String {
            self.discount = discount
        }

        if let aPrice = self.actualPrice, let oPrice = self.offerPrice, let aPriceInt = Int(aPrice), let oPriceInt = Int(oPrice),  aPriceInt <= oPriceInt {
            self.discount = ""
        }

        if (self.discount == "0") {  self.discount = "" }


        self.source = dictionary["source"] as? String

        self.layoutInfo = dictionary["layout"] as? NSDictionary

        //Setting Weight for item
        let weightDict:NSDictionary? = ((dictionary["metadata"] as? NSDictionary)?["category_weights"] as? [Any])?.first as? NSDictionary
        self.weight = weightDict?["weight"] as? NSNumber
        self.sequence = JRItem.sequenceNo + 1
    }
    
    @objc public override init() {
        super.init()
    }

    @objc public init(dictionary: [AnyHashable: Any]) {
        super.init()
        
        setWithDictionary(dictionary: dictionary)
    }
    
    public required init?(coder: NSCoder) {
        super.init()

        let aDecoder = coder
        self.itemDescription = aDecoder.decodeObject(forKey: "itemDescription") as? String

        var decodeLength = 0
        if let bytes = aDecoder.decodeBytes(forKey: "url", returnedLength: &decodeLength) {
            url = String.stringArchiveDecode(data: Data(bytes: bytes, count: decodeLength)) ?? ""
        }

        //@property (nonatomic, copy) NSString *createdOn;
        if let decodeBytes = aDecoder.decodeBytes(forKey: "imageUrl", returnedLength: &decodeLength) {
            let data = Data(bytes: decodeBytes, count: decodeLength)
            self.imageUrl = String.stringArchiveDecode(data: data)
        }

        self.offerPrice = aDecoder.decodeObject(forKey: "offerPrice") as? String
        self.actualPrice = aDecoder.decodeObject(forKey: "actualPrice") as? String
        
        if let type = aDecoder.decodeObject(forKey: "urlType") as? String {
             self.urlType = type
        }

        self.viewIds = aDecoder.decodeObject(forKey: "viewIds") as? [NSNumber]
        self.tickerId = aDecoder.decodeObject(forKey: "tickerId") as? [NSNumber]


        if let items = aDecoder.decodeObject(forKey: "items") as? [JRItem] {
            self.items = items
        }

        if let str = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = str
        }
        self.tag = aDecoder.decodeObject(forKey: "tag") as? String
        self.vertical = aDecoder.decodeObject(forKey: "vertical") as? String

        self.parent = aDecoder.decodeObject(forKey: "parent") as? JRItem

        self.categoryId = aDecoder.decodeObject(forKey: "categoryId") as? NSNumber
        self.itemId = aDecoder.decodeObject(forKey: "id") as? NSNumber
        self.productID = aDecoder.decodeObject(forKey: "productID") as? String
        self.parentId = aDecoder.decodeObject(forKey: "parentId") as? String
        self.brand = aDecoder.decodeObject(forKey: "brand") as? String
        self.category = aDecoder.decodeObject(forKey: "category") as? String

        self.category_Name = aDecoder.decodeObject(forKey: "category_Name") as? String
        self.ga_category = aDecoder.decodeObject(forKey: "ga_category") as? String
        self.listId = aDecoder.decodeDouble(forKey: "listId")

        //
        ////used for prepaid and postpaid recharges
        self.relatedCategories = aDecoder.decodeObject(forKey: "newrelatedCategories") as? [AnyHashable]
        self.label = aDecoder.decodeObject(forKey: "label") as? String

        //
        //// These two properties are using to show Tag labels in Catalog View
        self.tagLabelName = aDecoder.decodeObject(forKey: "tagLabelName") as? String
        self.tagLabelColor = aDecoder.decodeObject(forKey: "tagLabelColor") as? UIColor

        //
        self.imageSize = aDecoder.decodeCGSize(forKey: "imageSize")
        self.inStock = aDecoder.decodeBool(forKey: "inStock")
        self.discount = aDecoder.decodeObject(forKey: "discount") as? String

        //
        self.expanded = aDecoder.decodeBool(forKey: "expanded")
        self.selected = aDecoder.decodeBool(forKey: "selected")
        self.opened = aDecoder.decodeBool(forKey: "opened")
        self.level = aDecoder.decodeInteger(forKey: "level")

        //GTM releated
        self.isGTMTracked = aDecoder.decodeBool(forKey: "isGTMTracked")
        self.positionInList = aDecoder.decodeInteger(forKey: "positionInList")
        self.weight = aDecoder.decodeObject(forKey: "weight") as? NSNumber

        self.source = aDecoder.decodeObject(forKey: "source") as? String
        self.isSmartIcon = aDecoder.decodeBool(forKey: "isSmartIcon")

        // Layout related
        self.layoutInfo = aDecoder.decodeObject(forKey: "layoutInfo") as? NSDictionary
        self.layoutType = aDecoder.decodeObject(forKey: "layoutType") as? String

        //midgar changes
        self.datasourceContainerID = aDecoder.decodeDouble(forKey: "datasourceContainerID")
        self.datasourceListID = aDecoder.decodeDouble(forKey: "datasourceListID")
        self.datasourceContainerInstanceID = aDecoder.decodeObject(forKey: "datasourceContainerInstanceID") as? String
        self.datasourceType = aDecoder.decodeObject(forKey: "datasourceType") as? String
        self.sequence = aDecoder.decodeInteger(forKey: "sequence")
    }


    public func encode(with coder: NSCoder) {
        let aCoder = coder
        aCoder.encode(self.itemDescription, forKey:"itemDescription")

        if let data = String.stringArchiveEncode(string: self.url) {
            data.withUnsafeBytes { bytes in
                aCoder.encodeBytes(bytes, length: data.count, forKey:"url") //TODO: GK
            }
        }

        //@property (nonatomic, copy) NSString *createdOn;
        if let urlStr = self.imageUrl, let data = String.stringArchiveEncode(string: urlStr) {
            data.withUnsafeBytes { bytes in
               aCoder.encodeBytes(bytes, length: data.count, forKey:"imageUrl")
            }
        }


        aCoder.encode(self.offerPrice, forKey:"offerPrice")
        aCoder.encode(self.actualPrice, forKey:"actualPrice")
        aCoder.encode(self.urlType, forKey:"urlType")

        aCoder.encode(self.items, forKey:"items")
        aCoder.encode(self.name, forKey:"name")
        aCoder.encode(self.tag, forKey:"tag")
        aCoder.encode(self.vertical, forKey:"vertical")

        aCoder.encode(self.viewIds, forKey:"viewIds")
        aCoder.encode(self.tickerId, forKey:"tickerId")

        aCoder.encode(self.parent, forKey:"parent")

        aCoder.encode(self.categoryId, forKey:"categoryId")
        aCoder.encode(self.itemId, forKey:"id")
        aCoder.encode(self.productID, forKey:"productID")
        aCoder.encode(self.parentId, forKey:"parentId")
        aCoder.encode(self.brand, forKey:"brand")
        aCoder.encode(self.category, forKey:"category")

        aCoder.encode(self.getCategoryName(), forKey:"category_Name")
        aCoder.encode(self.ga_category, forKey:"ga_category")
        aCoder.encode(self.listId, forKey:"listId")

        //
        ////used for prepaid and postpaid recharges
        aCoder.encode(self.relatedCategories, forKey:"newrelatedCategories")
        aCoder.encode(self.label, forKey:"label")

        //
        //// These two properties are using to show Tag labels in Catalog View
        aCoder.encode(self.tagLabelName, forKey:"tagLabelName")
        aCoder.encode(self.tagLabelColor, forKey:"tagLabelColor")

        //
        aCoder.encode(self.imageSize, forKey:"imageSize")
        aCoder.encode(self.inStock, forKey:"inStock")
        aCoder.encode(self.discount, forKey:"discount")

        //
        aCoder.encode(self.expanded, forKey:"expanded")
        aCoder.encode(self.selected, forKey:"selected")
        aCoder.encode(self.opened, forKey:"opened")
        aCoder.encode(self.level, forKey:"level")

        //GTM releated
        aCoder.encode(self.isGTMTracked, forKey:"isGTMTracked")
        aCoder.encode(self.positionInList, forKey:"positionInList")
        aCoder.encode(self.weight, forKey:"weight")

        aCoder.encode(self.source, forKey:"source")
        aCoder.encode(self.isSmartIcon, forKey:"isSmartIcon")

        // Layout related
        aCoder.encode(self.layoutInfo, forKey:"layoutInfo")
        aCoder.encode(self.layoutType, forKey:"layoutType")

        //midgar changes
        aCoder.encode(self.datasourceContainerID, forKey:"datasourceContainerID")
        aCoder.encode(self.datasourceListID, forKey:"datasourceListID")
        aCoder.encode(self.datasourceContainerInstanceID, forKey:"datasourceContainerInstanceID")
        aCoder.encode(self.datasourceType, forKey:"datasourceType")
        aCoder.encode(self.sequence, forKey:"sequence")

    }

    public func parentOfLevel(_ level: Int) -> JRItem? {
        var item:JRItem?
        if self.level != level {
            item = self.parent?.parentOfLevel(level)
        }
        else
        {
            return self
        }
        return item
    }

    public func ancestors() -> [AnyHashable]? {
        var ancestors: [AnyHashable] = []

        for level in 0...level {
            if let parent = parentOfLevel(level) {
                ancestors.append(parent)
            }
        }
        return ancestors
    }

    public func pathFromAncestors() -> String? {
        var path = ""
        for level in 0...level {
            let item = parentOfLevel(level)
            if let name = item?.name {
                path = path + "->\(name)"
            }
        }
        return path
    }

//    func isSelectedItem() -> Bool {
//        guard let item = JRCommonManager.shared.applicationDelegate?.getSelectedItemFromJRServer() else { return false }
//        if items != nil && !items!.isEmpty {
//            return false
//        }
//
//        if (item.categoryId?.intValue == categoryId?.intValue) && (categoryId != nil) {
//            return true
//        }
//
//        let itemUrlString =  item.url
//        let currentItemUrl = (url is NSString) ? item.url : ""
//        if (item.name == name) && itemUrlString?.count == 0 {
//            return true
//        } else if (item.name == name) && (itemUrlString as NSString?)?.range(of: currentItemUrl ?? "").length != nil && !(self.items?.isEmpty) {
//            return true
//        }
//
//        return false
//    }


    public class func homePageItem(fromJsonDictionary dictionary: [AnyHashable : Any]?) -> JRItem? {
        if let array = dictionary?["items"] as? [AnyHashable] , let dict = array.first as? [AnyHashable: Any] {
            return JRItem(dictionary: dict)
        }
        return nil
    }

    public class func items(fromJsonDictionary dictionary: [AnyHashable : Any]?) -> [JRItem]? {
        var itemsArray: [JRItem]? = nil
        if let dictionary = dictionary {
            itemsArray = [JRItem]()
            let array = dictionary["items"] as? [AnyHashable]

            var index = 1
            for itemDict in array ?? [] {
                guard let itemDict = itemDict as? [AnyHashable : Any] else {
                    continue
                }
                let item = JRItem(dictionary: itemDict)
                item.positionInList = index
                index += 1
                itemsArray?.append(item)
            }
        }

        return itemsArray
    }

    public func gridDetail() -> JRGridDetail? {
        let details = JRGridDetail()
        details.imageUrl = imageUrl
        details.name = name

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        if let oPrice = self.offerPrice {
            details.offerPrice = numberFormatter.number(from: oPrice)
        }

        if let aPrice = self.actualPrice {
            details.actualPrice = numberFormatter.number(from: aPrice)
        }

        //We are fixing image size for seller store main page grid.
        //Hence this values are allways zero.
        details.imageSize = self.imageSize
        details.discount = discount

        details.inStock = true

        return details
    }

    public func getCategoryName() -> String {
        if let categoryName = self.category, !categoryName.isEmpty {
            return categoryName
        }
        return name
    }

    public func categoryTreefromParentWithIndex(_ index:Int) -> String {
        var key:String = ""
        if let parent = self.parent {
            key = parent.categoryTreefromParentWithIndex(index)
        } else {
            return String(format:"L%ld_%@",index + 1, name)
        }

        if !key.isEmpty {
            key = key.appending("/")
        }

        return String(format:"%@%@",key, name)
    }

    public func categoryTree() -> String {
        var key:String = ""
        if self.parent != nil, let value = self.parent?.categoryTreefromParentWithIndex(self.level) {
            key = value
        }
        if !key.isEmpty {
            key = key.appending("/")
        }
        return String(format:"%@%@",key, name)
    }

    public func performFetchingOfCategoryId(_ urlType:String?, forArray itemsArray: [JRItem], andName name:String) -> NSNumber? {
        for item:JRItem in itemsArray {

            if item.urlType == urlType {
                return item.categoryId
            }
            
            if item.items.count > 0 {
                return self.performFetchingOfCategoryId(urlType, forArray: item.items, andName:name)
            }
        }
        return nil
    }

    public func isURLTypeFromRechargeAndPay(itemName: String) -> Bool {
        let itemsList: [String] = ["Mobile","Electricity","DTH","Gas","Datacard","Metro","Landline","Education","Insurance","Water","Landline/Broadband","Broadband"]
        return itemsList.contains(itemName)
    }

    public class func getCreativeNameForGA(item:JRItem!) -> String! {
        return item.name
    }

    public class func getPromotionsDictForItem(item: JRItem, withSlot slot:Int) -> NSDictionary {
        var datasourceContainerInstanceID: String = ""
        if item.datasourceContainerInstanceID != nil {
            datasourceContainerInstanceID = item.datasourceContainerInstanceID!
        }
        var itemId:String = ""
        if item.itemId != nil {
            itemId = item.itemId!.stringValue
        }

        var name : String = item.name
        if let type = item.layoutType , type.count > 0 {
            name = String(format:"%@_%@", name, type)
        }

        var creativeName: String = ""
        if let name = JRItem.getCreativeNameForGA(item: item) {
            creativeName = name
        }

        let promotionsDict = ["dimension40": datasourceContainerInstanceID,
                              "id": itemId,
                              "name":  name ,
                              "creative" : creativeName,
                              "position" : NSNumber(value: slot)

        ] as [AnyHashable: Any]

        return promotionsDict as NSDictionary
    }

}


extension Optional {

    func isNil() -> Bool {
        return self == nil
    }

    func isNotNil() -> Bool {
        return !isNil()
    }
}
