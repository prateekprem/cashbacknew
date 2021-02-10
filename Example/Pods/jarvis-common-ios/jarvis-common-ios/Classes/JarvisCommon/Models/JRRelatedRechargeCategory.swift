//
//  JRRelatedRechargeCategory.swift
//  Jarvis
//
//  Created by Sandeep Chhabra on 02/08/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import jarvis_locale_ios

@objc public class JRRelatedRechargeCategory: NSObject,NSCoding {
    @objc public var name : String!
    @objc public var url : String!
    @objc public var value : String!
    @objc public var selected = false
    
    
    @objc public convenience init(name: String, url: String) {
        self.init()
        self.name = name
        self.url = url
    }
    
    @objc public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        if let name = aDecoder.decodeObject(forKey: "name") as? String{
            self.name = name
        }
        if let value = aDecoder.decodeObject(forKey: "value") as? String{
            self.value = value
        }
        if let url = aDecoder.decodeObject(forKey: "url") as? String{
            self.url = url
        }
    }
    
    @objc public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(url, forKey: "url")
    }
    
    private func setWithDictionary(_ dict: [AnyHashable: Any]) {
        name =  dict.getStringKey("label")
        url =  dict.getStringKey("url")
        value =  dict.getStringKey("value")
        if let selected = dict["selected"] as? Bool {
            self.selected = selected
        }
    }
    
    @objc public convenience init(dictionary dict: [AnyHashable: Any]) {
        self.init()
        setWithDictionary(dict)
    }
}


@objc public class JRCircle: NSObject {
    @objc public var name: String?
    @objc public var filterName: String?
    @objc public var service: String?
    @objc public var paytype: String?
    @objc public var products: Array<JRDigitalProduct>?
    @objc public var operatorAlert: Bool = false
    @objc public var remindable: Int = 0
    
    @objc public var schedulable: Bool = false
    @objc public var isSchedulable: Bool {
        return schedulable
    }
    
    public func hasSpecialRecharge() -> Bool {
        //assume that if for a single circle if we have 2 objects,then the operator supports special recharge
        var haveSpecialRecharge: Bool = false
        if products?.count == 2  {   haveSpecialRecharge = true  }
        
        return haveSpecialRecharge
    }
    
    public func specialRechargeTypeProduct() -> JRDigitalProduct? {
        let typePredicate: NSPredicate = NSPredicate(format: "typeFilterName like[c] %@", "Special Recharge")
        let filteredProducts: [JRDigitalProduct]? = products?.filter {
            typePredicate.evaluate(with: $0)
        }
        return filteredProducts?.last
    }
    
    public func topUpTypeProduct() -> JRDigitalProduct? {
        let typePredicate: NSPredicate = NSPredicate(format: "typeFilterName like[c] %@", "Talktime Topup")
        let filteredProducts: [JRDigitalProduct]? = products?.filter {
            typePredicate.evaluate(with: $0)
        }
        return filteredProducts?.last
    }
    
}


//used for electricity recharge type
@objc open class JRRechargeInputFieldInfo: NSObject {
    @objc open var titleText: String?
    @objc open var displayTitleText: String?
    @objc open var subTitleText: String?
    @objc open var regEx: String?
    @objc open var keyName: String?
    @objc open var isGenericKeyboard: Bool = false
    @objc open var min: UInt = 0
    @objc open var max: UInt = 0
    @objc open var message: String?
    @objc open var configKey: String?
    @objc open var showPhoneBook: Bool = false
    @objc open var readOnly: Bool = false
    @objc open var keyboardType: NSString?
    
    
    public init(dictionary: [AnyHashable: Any]?) {
        super.init()
        setWithDictionary(dictionary)
    }
    
    open func setWithDictionary(_ dict: [AnyHashable: Any]?) {
        if let displayTitle: String = dict?["display_title"] as? String {
            displayTitleText = displayTitle
        } else {
            displayTitleText = NSLocalizedString("STD Code & Landline Number") //Localization may not work
        }
        
        titleText = dict?["title"] as? String
        subTitleText = dict?["sub_title"] as? String
        regEx = dict?["regex"] as? String
        
        if let configKey = dict?["config_key"] as? String {
            keyName = configKey
        } else {
            keyName = "recharge_number"
        }
        
        isGenericKeyboard = dict?.getOptionalBoolKey("isAlphanumeric") ?? false
        
        min = 0
        if let mini = dict?["min"] as? UInt {
            min = mini
        } else if let mini = dict?["min"] as? Double {
            min = UInt(mini)
        } else if let mini = dict?["min"] as? String {
            min = UInt(mini) ?? 0
        } else if let mini = dict?["min"] as? Int {
            min = UInt(mini)
        }
        
        max = UInt.max
        if let maxim = dict?["max"] as? UInt {
            max = maxim
        } else if let maxim = dict?["max"] as? Double {
            max = UInt(maxim)
        } else if let maxim = dict?["max"] as? String {
            max = UInt(maxim) ?? 0
        } else if let maxim = dict?["max"] as? Int {
            max = UInt(maxim)
        }
        
        message = dict?.getOptionalStringForKey("message")
        configKey = dict?["config_key"] as? String
    }
    
}

@objc open class JRDigitalProduct: NSObject {
    
    @objc open var productType: String? //mobile,dth,datacard,tollcard
    @objc open var name: String? //the name that we are using to display in UI
    @objc open var filterName: String?
    @objc open var brand: String?
    @objc open var convenienceFee: UInt = 0
    @objc open var operatorImageUrl: String?
    @objc open var regEx: String?
    @objc open var caption: String?
    @objc open var status: Bool = false
    @objc open var circle: String?
    @objc open var filterCircleName: String?
    @objc open var productId: String?
    @objc open var dealsMessage: String?
    @objc open var type: String? //top up or special recharge
    @objc open var typeFilterName: String? //top up or special recharge Config Keys
    @objc open var error: JRError?
    @objc open var configurations: [JRDigitalProduct]?
    @objc open var shortDesc: String? //used as placeholder text
    @objc open var minimumRechargeAmount: UInt = 0
    @objc open var maximumRechargeAmount: UInt = 0
    @objc open var inputFieldsArray: [JRRechargeInputFieldInfo]?
    @objc open var formFieldsArray: [JRRechargeInputFieldInfo]?
    @objc open var softBlock: Bool = false
    @objc open var prefetch: Bool = false
    @objc open var hardBlockError: Bool = false
    @objc open var softBlockError: Bool = false
    @objc open var fetchVodafoneBill: Bool = false
    @objc open var oneTwoOneOffer: Bool = false
    @objc open var dynamicPlan: Bool = false
    @objc open var one2oneOfferText: String?
    @objc open var one2oneCategoryLabelText: String?
    @objc open var one2oneDesclaimer: String?
    @objc open var service: String?
    @objc open var paytype: String?
    @objc open var operatorAlert: Bool = false
    @objc open var remindable: Int = 0
    
    @objc open var schedulable: Bool = false
    @objc open var isSchedulable: Bool {   return schedulable  }
    
    @objc open weak var parent: AnyObject? //pointer to the parent product
    @objc open var circles: Array<JRCircle>?
    
    public init(dictionary: [AnyHashable: Any]?) {
        super.init()
        setWithDictionary(dictionary)
    }
    
    open func setWithDictionary(_ dict: [AnyHashable: Any]?) {
        productType = dict?["product_type"] as? String
        name = dict?["name"] as? String
        filterName = dict?["filterName"] as? String
        brand = dict?["brand"] as? String
        regEx = dict?["regEx"] as? String
        convenienceFee = UInt(dict?.getOptionalIntForKey("convenience_fee") ?? 0)
        operatorImageUrl = dict?["image"] as? String
        if let configs = dict?["configurations"] as? [AnyHashable: Any], let captn = configs["caption"] as? String {
            caption = captn
        } else {
            caption = nil
        }
        
        status = dict?.getOptionalBoolKey("status") ?? false
        softBlock = dict?.getOptionalBoolKey("softblock") ?? false
        circle = dict?["circle"] as? String
        filterCircleName = dict?["filterCircle"] as? String
        productId = dict?.getOptionalStringForKey("product_id")
        dealsMessage = dict?.getOptionalStringForKey("deals_message")
        schedulable = dict?.getOptionalBoolKey("schedulable") ?? false
        fetchVodafoneBill = tempGetOptionalBoolKey("voda_fetchbill", dict: dict) ?? false
        service = dict?["service"] as? String
        paytype = dict?["paytype"] as? String
        
        operatorAlert = dict?.getOptionalBoolKey("operator_alert") ?? false
        
        remindable = dict?.getOptionalIntForKey("remindable") ?? 0
        
        /* In V2 Response
         hardblock or softblock
         0 : I'ts a softblock and we can proceed.
         1:  I'ts a hardblock and we cannot proceed.
         */
        
        if let errorDict = dict?["error"] as? [AnyHashable: Any],
            let _ = errorDict["proceed"] {
            let errProceed: Bool = errorDict.getOptionalBoolKey("proceed") ?? false
            softBlock = !errProceed
            status = errProceed
        }
        
        //TODO: looks weird. considering self.productId
        if productId == nil || productId?.isEmpty == true {
            productId = dict?.getOptionalStringForKey("product_id")
        }
        
        type = dict?["type"] as? String
        typeFilterName = dict?["typeFilterName"] as? String
        shortDesc = dict?["short_desc"] as? String
        
        // prefetch and fetch_amt being used interchangable. So if anyone is enabled consider prefetch var as enabled.
        if dict?.getOptionalBoolKey("prefetch") == true ||
            dict?.getOptionalBoolKey("fetch_amt") == true ||
            dict?.getOptionalBoolKey("fetch_amount") == true {
            prefetch = true
        } else {
            prefetch = false
        }
        oneTwoOneOffer = tempGetOptionalBoolKey("One2One_offer", dict: dict) ?? false
        dynamicPlan = dict?.getOptionalBoolKey("dynamic_plan") ?? false
        one2oneOfferText = dict?["One2One_offer_text"] as? String
        one2oneCategoryLabelText = dict?["dynamic_plan_category_label"] as? String
        one2oneDesclaimer = dict?["One2One_offer_disclaimer"] as? String
        
        if let array = dict?["input_fields"] as? [[AnyHashable: Any]] {
            var fields: [JRRechargeInputFieldInfo] = [JRRechargeInputFieldInfo]()
            for item in array {
                //create input field array
                let info: JRRechargeInputFieldInfo = JRRechargeInputFieldInfo(dictionary: item)
                fields.append(info)
            }
            inputFieldsArray = fields;
        }
        
        if let array = dict?["form_fields"] as? [[AnyHashable: Any]] {
            var fields: [JRRechargeInputFieldInfo] = [JRRechargeInputFieldInfo]()
            for item in array {
                //create input field array
                let info: JRRechargeInputFieldInfo = JRRechargeInputFieldInfo(dictionary: item)
                fields.append(info)
            }
            formFieldsArray = fields;
        }
        
        minimumRechargeAmount = UInt(dict?.getOptionalIntForKey("min_amount") ?? 0)
        if let max: Int = dict?.getOptionalIntForKey("max_amount") {
            maximumRechargeAmount = UInt(max)
        } else {
            maximumRechargeAmount = UInt.max
        }
        
        if let errDict = dict?["error"] as? [AnyHashable: Any] {
            error = JRError(dictionary: errDict)
        }
        
        if let configs = dict?["configurations"] as? [AnyHashable: Any],
            let products = configs["products"] as? [[AnyHashable: Any]] {
            var productsArray: [JRDigitalProduct] = [JRDigitalProduct]()
            for obj in products {
                let operatorObj: JRDigitalProduct = JRDigitalProduct(dictionary: obj)
                operatorObj.parent = self
                productsArray.append(operatorObj)
            }
            
            configurations = productsArray;
            circles = groupedCircles()
        }
    }
    
    open func groupedCircles() -> [JRCircle]
    {
        //Circles contains array of products.
        //group circles
        var circleArray: [JRCircle] = [JRCircle]()
        guard let configurations = configurations  else {
            return circleArray
        }
        
        let sortedConfigurations: [JRDigitalProduct] = configurations.sorted { (product1, product2) -> Bool in
            guard let circle1 = product1.circle else {
                return false
            }
            guard let circle2 = product2.circle else {
                return true
            }
            return circle1 < circle2
        }
        
        for product in sortedConfigurations {
            let circleNamePredicate: NSPredicate = NSPredicate(format: "circle like[c] %@", product.circle ?? "")
            let groupedCircles: [JRDigitalProduct] = configurations.filter { circleNamePredicate.evaluate(with: $0) }
            
            let circle: JRCircle = JRCircle()
            circle.name = product.circle
            circle.filterName = product.filterCircleName
            circle.products = groupedCircles
            circle.service = product.service
            circle.paytype = product.paytype
            circle.operatorAlert = product.operatorAlert
            circle.schedulable = groupedCircles.first?.isSchedulable ?? false
            circle.remindable = product.remindable
            
            circleArray.append(circle)
        }
        return circleArray
    }
    
    public func rechargeProducts(forCircle circle: String?) -> [JRDigitalProduct]?
    {
        //ASSUMPTION: if circle name is nil ,then return the default config object
        //NOTE: since this is a common method for child and parent digital product objects,call this only for parent object
        guard let configurations = configurations,
            configurations.isEmpty == false else {
                return nil
        }
        guard let circle = circle, circle.lowercased() != "all" else {
            return configurations
        }
        
        let circleNamePredicate: NSPredicate = NSPredicate(format:"name like[c] %@", circle)
        let filteredCircles: [JRCircle]? = circles?.filter { circleNamePredicate.evaluate(with: $0) }
        return filteredCircles?.last?.products
    }
    
    public func hasCircle(_ circle: String?) -> Bool {
        let circleNamePredicate: NSPredicate = NSPredicate(format: "name like[c] %@", circle ?? "")
        let filteredArray: [JRCircle]? = circles?.filter { circleNamePredicate.evaluate(with: $0) }
        
        return filteredArray?.isEmpty == false ? true : false
    }
    
    public func isSpecialRechargeIsThereForCircle(_ circle: String?) -> Bool {
        guard let circle = circle, circle.lowercased() != "all" else {
            return configurations?.count == 2 ? true : false
        }
        
        let circleNamePredicate: NSPredicate = NSPredicate(format:"name like[c] %@", circle)
        let circleObj: JRCircle? = circles?.filter { circleNamePredicate.evaluate(with: $0) }.last
        return circleObj?.hasSpecialRecharge() ?? false
    }
    
    public func getProductForTopUpRechargeTypeForCircle(_ circle: String?) -> JRDigitalProduct? {
        guard let circle = circle, circle.lowercased() != "all" else {
            let typePredicate: NSPredicate = NSPredicate(format:"type like[c] %@", "Talktime Topup")
            let filteredConfig: [JRDigitalProduct]? = configurations?.filter { typePredicate.evaluate(with: $0) }
            return filteredConfig?.last
        }
        
        
        let circleNamePredicate: NSPredicate = NSPredicate(format: "name like[c] %@", circle)
        let filteredCircles: [JRCircle]? = circles?.filter { circleNamePredicate.evaluate(with: $0) }
        return filteredCircles?.last?.topUpTypeProduct()
    }
    
    public func getProductForSpecialRechargeTypeForCircle(_ circle: String?) -> JRDigitalProduct? {
        guard let circle = circle, circle.lowercased() != "all" else {
            let typePredicate: NSPredicate = NSPredicate(format: "type like[c] %@", "Special Recharge")
            let filteredConfigs: [JRDigitalProduct]? = configurations?.filter { typePredicate.evaluate(with: $0) }
            return filteredConfigs?.last
        }
        
        
        let circleNamePredicate: NSPredicate = NSPredicate(format: "name like[c] %@", circle)
        let filteredCircles:[JRCircle]? = circles?.filter { circleNamePredicate.evaluate(with: $0) }
        return filteredCircles?.last?.specialRechargeTypeProduct()
    }
    
    //TODO:- Enhance the existing utility version to handle this.
    func tempGetOptionalBoolKey(_ key: String, dict: [AnyHashable: Any]?) -> Bool? {
        guard let dict: [AnyHashable: Any] = dict else {
            return nil
        }
        if let y: Bool = dict[key] as? Bool {
            return y
        }
        if let y: Int = dict.getOptionalIntForKey(key) {
            return Bool(y)
        }
        if let y: String = dict.getOptionalStringForKey(key), y.isEmpty == false {
            if y == "0" || y.lowercased() == "false" {
                return false
            } else if y == "1" || y.lowercased() == "true" {
                return true
            } else {
                return false
            }
        }
        return nil
    }
}

