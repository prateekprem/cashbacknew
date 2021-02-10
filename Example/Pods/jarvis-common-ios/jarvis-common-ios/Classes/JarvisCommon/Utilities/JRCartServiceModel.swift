//
//  JRCartServiceModel.swift
//  Jarvis
//
//  Created by Shrinivasa Bhat on 25/01/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation
public enum JRProductVariantFeeTypeVisibility {
    case none
    case selectable
    case nonSelectable

    public static func feeTypeVisibility(text:String) -> JRProductVariantFeeTypeVisibility {
        var feeTypeVisibility: JRProductVariantFeeTypeVisibility = .none
        switch text {
        case "soft":
            feeTypeVisibility = .selectable
            
        case "hard":
            feeTypeVisibility = .nonSelectable
            
        default:
            break
        }
        return feeTypeVisibility
    }
}

/*
 JRCartProductPaymentOptionsModel
 
{
    "amount": 300,
    "label": "Outstanding & April",
    "displayValues": [
        {
            "label": "Outstanding",
            "value": "100"
        },
        {
            "label": "April",
            "value": "200"
        },
        {
            "label": "April Due Date",
            "value": "23-05-2017"
        },
        {
            "label": "Total Amount",
            "value": "300"
        }
    ]
}
 */

public class JRCartProductPaymentOptionsModel:NSObject {
   public var amount:Double?
   public var label:String?
   public var displayValues:[JRCartProductDisplayValue]?
    
   public init(dictionary:[String : Any]) {
        label = dictionary.getOptionalStringForKey("label")
        amount = dictionary.getOptionalDoubleKey("amount")
        
        let values = JRCartServiceModel.displayValueModels(dictionary: dictionary)
        var displayVals = values.0
        if let val = displayVals {
            displayVals = val.filter({
                if let valueStr = $0.value, (nil == Double(valueStr) || Double(valueStr)! > 0)  {
                    return true
                }
                return false
            })
        }
        displayValues = displayVals
    }
}

/*
 "dthPlanInfo": {
     "services": [
         {
             "VC No": "000021824818",
             "connectiontype": "TV1",
             "planExpiryDetails": [
                 {
                     "Show/Hide": "",
                     "amount": "275",
                     "discount": "0",
                     "packageLabel": "",
                     "packagename": "basepack",
                     "packname": "PRIME",
                     "planduration": "1",
                     "planexpirydate": "11/19/2017 12:00:00 AM",
                     "planpoid": "4115913085"
                 }
             ]
         }
      ]
 }

*/

public class JRDthPlanInfoServicesModel:NSObject {
   public var VCNo: String?
   public var connectionType: String?
   public var planExpiryDetails: [JRDthPlanExpiryDetails] = [JRDthPlanExpiryDetails]()
    
    //Used for grouping of the subscriptions
   public var addOnExpiryDetails: [JRDthPlanExpiryDetails] = [JRDthPlanExpiryDetails]()
   public var alaCartExpiryDetails: [JRDthPlanExpiryDetails] = [JRDthPlanExpiryDetails]()
   public var expanded:Bool?
    
   public init(dictionary:[String : Any], shouldExpand: Bool) {
        
        if let vcNo = dictionary.getOptionalStringForKey("VC No") {
            VCNo = vcNo
        }
        
        if let connType = dictionary.getOptionalStringForKey("connectiontype") {
            connectionType = connType
        }
        
        self.expanded = shouldExpand
        
        //Dth Plan Info
        if let dthPlanExpiryDetails = dictionary["planExpiryDetails"] as? [[String:Any]] {
            for dthPlanExpiryDetail in dthPlanExpiryDetails {
                planExpiryDetails.append(JRDthPlanExpiryDetails.init(dictionary: dthPlanExpiryDetail))
            }
            
            addOnExpiryDetails = planExpiryDetails.filter {
                return ( $0.packageName?.lowercased() == "addon")
            }
          
            alaCartExpiryDetails = planExpiryDetails.filter {
                return $0.packageName?.lowercased() == "alacart"
            }
        }
    }
}

public class JRDthPlanExpiryDetails:NSObject {
   public var showOrHide:String?
   public var amount:Double?
   public var discount:String?
   public var packageLabel:String?
   public var packageName:String?
   public var packName:String?
   public var planDuration:String?
   public var planExpiryDate:Date?
   public var planPoid:String?
   public var selected:Bool = true
    
   public init(dictionary:[String : Any]) {
        
        if let showHide = dictionary["Show/Hide"] as? String {
            showOrHide = showHide
        }
        
        if let amt = dictionary.getOptionalPriceForKey("amount") {
            amount = amt
        }
        
        if let dscnt = dictionary["discount"] as? String {
            discount = dscnt
        }
        
        if let pkgLbl = dictionary["packageLabel"] as? String {
            packageLabel = pkgLbl
        }
        
        if let pkgName = dictionary["packagename"] as? String {
            packageName = pkgName
        }
        
        if let pckName = dictionary["packname"] as? String {
            packName = pckName
        }
        
        if let plnDuration = dictionary["planduration"] as? String {
            planDuration = plnDuration
        }
        
        if let plnExpiryDate = dictionary["planexpirydate"] as? String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
            if let reviewDate = formatter.date(from: plnExpiryDate) {
                planExpiryDate = reviewDate // "\(reviewDate.monthNameFull())"
            }
        }
        
        if let plnpoid = dictionary["planpoid"] as? String {
            planPoid = plnpoid
        }
    }
}

public class JRCartProductDisplayValue {
    public var label:String?
    public var value:String?
    
    public init(dictionary:[String : Any]) {
        label = dictionary.getOptionalStringForKey("label")
        value = dictionary.getOptionalStringForKey("value")?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

   public static func configureCellWithOutNullValues(_ userinfo : [[String:Any]]?) -> [[String:Any]] {
        
        var userInformation : [[String:Any]] = [[String:Any]]()
        if let userInfo = userinfo {
            for info in userInfo {
                if let value = info["value"] as? String {
                    let string = NSString(string: value.trimmingCharacters(in: .whitespaces))
                    if string != "", false == string.isNull() {
                        userInformation.append(info)
                    }
                }
            }
        }
        
        return userInformation
    }
}

public class JRCartSavedBankAccount {
   public var accountNumber:String?
   public var ifscCode:String?
   public var name:String?
   public var trusted:String?
   public var bankName:String?
    
   public init(dictionary:[String : Any]) {
        accountNumber = dictionary.getOptionalStringForKey("accountNumber")
        ifscCode = dictionary.getOptionalStringForKey("ifscCode")
        name = dictionary.getOptionalStringForKey("name")
        trusted = dictionary.getOptionalStringForKey("trusted")
        bankName = dictionary.getOptionalStringForKey("bankName")
    }
}

public class JRCartServiceOptionUpdateValuesModel:NSObject {
    
    /*
     "billAmount": 112350,
     "billamount_editable": false,
     "displayValues": [
     {
     "label": "School Fee",
     "value": 112350
     },
     {
     "label": "School Late Fee",
     "value": 0
     },
     {
     "label": "School Opening Balance",
     "value": 0
     }
     ],
     "fee_types": "April-June"
     
     */
    fileprivate var _billAmount:Double?
    public var billAmount:Double? {
        set {
            _billAmount = newValue
            
            if let val = newValue {
                userDefinedAmountText = String(val)
            }
        }
        
        get {
            if billAmountEditable, let text = userDefinedAmountText, let amount = Double(text) {
                return amount
            }
            return _billAmount
        }
    }
    

    public var userDefinedAmountText:String?
    public var displayValues:[JRCartProductDisplayValue]?
    public var label:String?
    public var feeTypeVisibility: JRProductVariantFeeTypeVisibility = .none
    
    public private(set) var billAmountEditable = false
    public private(set) var feeTypeText:String?
    public private(set) var challanNo:String?
    public var checkBoxKey : String?
    // For UI Purpose
    public var selected:Bool = false
    
    @objc public init(dictionary:[String : Any]) {
        super.init()
        billAmount = dictionary.getDoubleKey("billAmount")
        billAmountEditable = dictionary.getOptionalBoolKey("billamount_editable") ?? true
        feeTypeText = dictionary.getOptionalStringForKey("fee_types")
        checkBoxKey = dictionary.getOptionalStringForKey("checkBoxKey")
        label = dictionary.getOptionalStringForKey("label")

        if feeTypeText == nil {
            feeTypeText = dictionary.getOptionalStringForKey("checkbox_flow_key")
        }
        
        if feeTypeText == nil {
            feeTypeText = dictionary.getOptionalStringForKey("challan_type")
        }
        
        challanNo = dictionary.getOptionalStringForKey("Challan No")
        // DisplayValues
        if let rawValues = dictionary["displayValues"] as? [[String:Any]] {
            displayValues = [JRCartProductDisplayValue]()
            
            for rawValue in rawValues {
                displayValues!.append(JRCartProductDisplayValue(dictionary: rawValue))
            }
        }
        
        // Fee Type Visibility
        if let fee_type_visibility = dictionary.getOptionalStringForKey("fee_type_visibility") {
            feeTypeVisibility = JRProductVariantFeeTypeVisibility.feeTypeVisibility(text: fee_type_visibility)
        }
    }
    
   public func validate() -> Bool {
        var validated = true
        
        if billAmountEditable {
            if userDefinedAmountText == nil || Double(userDefinedAmountText!) == nil {
                validated = false
            }
        }
        
        return validated
    }
}

/*
 "actions":
 [
     {
     "billAmount": 51600,
     "billDueDate": null,
     "bill_amount_max": null,
     "bill_amount_min": null,
     "billamount_editable": true,
     "caNumber": null,
     "course": "",
     "customerEmail": null,
     "customerName": "TANISHQ VASAN",
     "displayValues": [
         {
         "label": "Name",
         "value": "TANISHQ VASAN"
         },
         {
         "label": "Section",
         "value": ""
         },
         {
         "label": "Course",
         "value": ""
         },
         {
         "label": "Year",
         "value": ""
         },
         {
         "label": "Class",
         "value": ""
         },
         {
         "label": "Father's Name",
         "value": ""
         }
     ],
     "dob": null,
     "fatherName": "",
     "label": "customerInfo",
     "section": "",
     "studentClass": "",
     "year": ""
     }
 ]
 
 */

/**
 Model used to pass custom values in cart response
 
 Note: As many values are not used we have not parsed it
 **/

public class JRCartServiceModel: NSObject {
    
   public  var billAmount: Double? {
        if let amt = userEntered_billAmount {
            return amt
        }
        return self.server_billAmount
    }
    
   public var userEntered_billAmount: Double?
   public var server_billAmount: Double?
    
   public var bill_amount_min: Double?
   public var bill_amount_max: Double?
   public var customerBalance : String?
   public var currentMetalPrice : Double?
   public var currentMetalSellPrice :String?
   public var currentMetalPricePreTax:String?
   public var billDueDate: String?
   public var commisionableValue : String?
   public var taxAmount : String?
   public var customerName : String?
   public var customerPincode : String?
   public var kycStatus : String?
   public var billamount_editable: Bool?
   public var displayValues: [[String : String]]?
   public var displayValueModels: [JRCartProductDisplayValue]?
   public var pureSecureText : String?
   public var zeroBalText : String?
   public var purchaseExpiryTime: Int?
   public var goldQuantity : String?
   public var paymentOptionModels:[JRCartProductPaymentOptionsModel]?
   public var sellItemPrice:String?
   public var sellItemDisplayText :String?
   public var dthPlanInfoServicesModel: [JRDthPlanInfoServicesModel] = [JRDthPlanInfoServicesModel]()
   public var savedBankAccounts :[JRCartSavedBankAccount]?
   public var netWorthText: String?
   public var netWorthValue: String?
   public var netWorthFooter: String?
   public var checkBoxKey: String?
    
    @objc public init(dictionary:[String : AnyObject]) {
        super.init()
        
        server_billAmount = dictionary.getOptionalDoubleKey("billAmount")
        bill_amount_min = dictionary.getOptionalDoubleKey("bill_amount_min")
        bill_amount_max = dictionary.getOptionalDoubleKey("bill_amount_max")
        customerBalance = dictionary.getOptionalStringForKey("customerBalance")
        billDueDate = dictionary.getOptionalStringForKey("billDueDate")
        commisionableValue = dictionary.getOptionalStringForKey("preTaxAmount")
        taxAmount = dictionary.getOptionalStringForKey("taxAmount")
        kycStatus = dictionary.getOptionalStringForKey("KYCStatus")
        goldQuantity = dictionary.getOptionalStringForKey("quantity")
        customerName = dictionary.getOptionalStringForKey("customerName")
        customerPincode = dictionary.getOptionalStringForKey("customerPincode")
        purchaseExpiryTime = dictionary.getIntKey("quote_validity")
        currentMetalPrice = dictionary.getOptionalDoubleKey("currentMetalPrice")
        currentMetalSellPrice = dictionary.getOptionalStringForKey("currentMetalSellPrice")
        currentMetalPricePreTax = dictionary.getOptionalStringForKey("currentMetalPricePreTax")
        if let editable = dictionary.getOptionalBoolKey("billamount_editable") {
            billamount_editable = editable
        }
        pureSecureText = dictionary.getOptionalStringForKey("pureSecureText")
        zeroBalText = dictionary.getOptionalStringForKey("zeroBalText")
        sellItemPrice = dictionary.getOptionalStringForKey("sellItemPrice")
        sellItemDisplayText = dictionary.getOptionalStringForKey("sellItemDisplayText")
        netWorthText = dictionary.getOptionalStringForKey("netWorthText")
        netWorthValue = dictionary.getOptionalStringForKey("netWorthValue")
        netWorthFooter = dictionary.getOptionalStringForKey("netWorthFooter")
        
        if let updatedValue = dictionary["updatedValues"] as? [[String: Any]], !updatedValue.isEmpty, let updateValueDict = updatedValue.first, let checkBoxKey = updateValueDict["checkBoxKey"] as? String {
            self.checkBoxKey = checkBoxKey
        }
        
        //Display Values
        let values = JRCartServiceModel.displayValueModels(dictionary: dictionary)
        displayValueModels = values.0
        displayValues = values.1 // Raw List
        
        //Payment Options
        paymentOptionModels = paymentOptions(dictionary: dictionary)
        
        //Dth Plan Info
        if let dthPlanInfo = dictionary.getOptionalDictionaryKey("dthPlanInfo"), let services = dthPlanInfo["services"] as? [[String:Any]] {
            var counter:Int = 0
            for service in services {
                if counter == 0 {
                    dthPlanInfoServicesModel.append(JRDthPlanInfoServicesModel.init(dictionary: service,shouldExpand: true))
                } else {
                    dthPlanInfoServicesModel.append(JRDthPlanInfoServicesModel.init(dictionary: service,shouldExpand: false))
                }
                counter = 1
            }
        }
        //saved bank accounts for Gold in sell
        savedBankAccounts = getSavedBankAccounts(dictionary: dictionary)
    }
    
    public func getSavedBankAccounts(dictionary:[String:Any]?) -> [JRCartSavedBankAccount]? {
        var models = [JRCartSavedBankAccount]()
        
        if let rawModels = dictionary?["bankAccounts"] as? [[String:Any]] {
            for rawModel in rawModels {
                let model = JRCartSavedBankAccount(dictionary: rawModel)
                models.append(model)
            }
        }
        
        if models.count == 0 {
            return nil
        }
        
        return models
    }
    
    public func paymentOptions(dictionary:[String:Any]?) -> [JRCartProductPaymentOptionsModel]? {
        var models = [JRCartProductPaymentOptionsModel]()
        
        if let rawModels = dictionary?["payment_options"] as? [[String:Any]] {
            for rawModel in rawModels {
                let model = JRCartProductPaymentOptionsModel(dictionary: rawModel)
                models.append(model)
            }
        }
        
        if models.count == 0 {
            return nil
        }
        
        return models
    }
    
    public class func displayValueModels(dictionary:[String:Any]) -> ([JRCartProductDisplayValue]?, [[String : String]]?) {
        var list = [[String : String]]()
        var models = [JRCartProductDisplayValue]()
        var rawModels:[[String:String]]?
        
        if let displayValuesList = dictionary["displayValues"] as? [[String:Any]], displayValuesList.count > 0  {
            for keyValues in displayValuesList {
                if let key = keyValues["label"] as? String,let value = keyValues["value"], key.length > 0 {
                    var finalVal = value as? String
                    if finalVal == nil {
                        finalVal = String(describing: value)
                    }
                    if let finalVal = finalVal, finalVal.length > 0 {
                        list.append(["label" : key,"value": finalVal])
                    }
                }
            }
        }
        if list.count > 0 {
            rawModels = list
            let derivedList = JRCartProductDisplayValue.configureCellWithOutNullValues(list)
            for value in derivedList {
                models.append(JRCartProductDisplayValue(dictionary: value))
            }
        }
        
        if models.count == 0 {
            return (nil, rawModels)
        }
        
        return (models, rawModels)
    }
}





public class JRPriceBreakUpModel: NSObject
{
    @objc public var label:String = "";
    @objc public var value:String = "";
    
    public override init()
    {
        
    }
    
    @objc public init(dictionary:[String: AnyObject])
    {
        super.init()
        self.label = dictionary.getStringKey("label");
        self.value = NSString(format: "%f",dictionary.getDoubleKey("value")) as String;
    }
}
