//
//  SFItemTracker.swift
//  jarvis-storefront-ios
//
//  Created by Romit Kumar on 10/08/20.
//

import Foundation
import UIKit

class SFItemTracker: NSObject {
    static let shared = SFItemTracker()
    
    private var gaBatchCount = 1
    private var queue = DispatchQueue(label: "com.paytm.sfItemTracker", attributes: .concurrent)
    private var pageName: String = ""
    private var verticalName: String = ""
    private var customerID:String = ""
    private let promoQueue = DispatchQueue(label: "promoGAQueue")
    private let productQueue = DispatchQueue(label: "productGAQueue")
    private var forceSendPromoGA:Bool = false
    private var forceSendProductGA:Bool = false
    
    private override init() {
        super.init()
        if let userID = SFUtilsManager.getUserId() {
            customerID = userID
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func willResignActive(_ notification: Notification) {
        forceSendAllGA()
    }
    
    private func forceSendAllGA() {
        forceSendPromoGA = true
        forceSendPromoGA = true
        if promoArray.count > 0 {
            promoQueue.async() {
                self.sendPromoImpressionTracking()
            }
        }
        
        if productArray.count > 0 {
            productQueue.async {
                self.sendProductImpressionTracking()
            }
        }
    }
    private var promoArray:[[String:Any]] = [[String:Any]](){
        didSet{
            promoQueue.async() {
                self.sendPromoImpressionTracking()
            }
        }
    }
    
    private var productArray:[[String:Any]] = [[String:Any]](){
        didSet{
            productQueue.async {
                self.sendProductImpressionTracking()
            }
        }
    }
    
    func setBatchCount(_ count: Int) {
        queue.sync(flags: .barrier) {
            gaBatchCount = count
        }
    }
    
    func getBatchCount() -> Int {
        return queue.sync {
            gaBatchCount
        }
    }
    
    func logPromotionImpressionForItem(dict:[String:Any], verticalName:String,pageName:String){
        promoQueue.async() {
            self.verticalName = verticalName
            self.pageName = pageName
            self.promoArray.append(dict)
            //print("appending promo :: count \(self.promoArray.count)")
        }
    }
    
    func logProductImpressionForItem(dict:[String:Any], verticalName:String,pageName:String){
        productQueue.async() {
            self.verticalName = verticalName
            self.pageName = pageName
            //print("appending product:: count \(self.productArray.count)")
            self.productArray.append(dict)
        }
    }
    
    func logPromotionClickForItem(dict:[String:Any], verticalName:String,pageName:String){
         promoQueue.async() {
            var promoClickArr: [[String:Any]] = [[String:Any]]()
            promoClickArr.append(dict)
            var promotionDict: [String:Any] = [String:Any]()
            promotionDict["promotions"] = promoClickArr
            var promoViewDict: [String:Any] = [String:Any]()
            promoViewDict["promoClick"] = promotionDict
            var gaDict = [String:Any]()
            gaDict["event"] = "promotionClick"
            gaDict["ecommerce"] = promoViewDict
            gaDict["screenName"] = pageName
            if let userID = SFUtilsManager.getUserId() {
                self.customerID = userID
            }
            gaDict["Customer_Id"] = self.customerID
            gaDict["vertical_name"] = verticalName
            SFBridge.shared.interactor?.trackStorefrontEvents(gaDict)
        }
        forceSendAllGA()
    }
    
    func logProductClickForItem(dict:[String:Any], verticalName:String,pageName:String){
        promoQueue.async() {
            var prodClickArr: [[String:Any]] = [[String:Any]]()
            prodClickArr.append(dict)
            let dim24 = dict["dimension24"] as? String
            var productDict: [String:Any] = [String:Any]()
            productDict["products"] = prodClickArr
            
            
            var actionField: [String:Any] = [String:Any]()
            actionField["list"] = dim24 ?? ""
            productDict["actionField"] = actionField
            
            var promoViewDict: [String:Any] = [String:Any]()
            promoViewDict["click"] = productDict
            
            var gaDict = [String:Any]()
            gaDict["event"] = "click"
            gaDict["eventName"] = "productClick"
            gaDict["ecommerce"] = promoViewDict
            gaDict["screenName"] = pageName
            if let userID = SFUtilsManager.getUserId() {
                self.customerID = userID
            }
            gaDict["Customer_Id"] = self.customerID
            gaDict["vertical_name"] = verticalName
            SFBridge.shared.interactor?.trackStorefrontEvents(gaDict)
        }
        
        forceSendAllGA()
    }
    
    private func sendProductImpressionTracking() {
        if productArray.count >= getBatchCount() {
            let slicedArrayForGA = productArray[0..<getBatchCount()]
            let productsForGA = Array(slicedArrayForGA)
            sendProductGA(slicedArrayForGA: productsForGA)
            if self.productArray.indices.contains(self.getBatchCount() - 1) {
                self.productArray.removeSubrange(0..<self.getBatchCount())
            }
            //print("remove product elements")
            
        }else if forceSendProductGA {
            sendPromoGA(slicedArrayForGA: self.productArray)
            forceSendProductGA = false
            self.productArray.removeAll()
            //print("remove product elements")
        }
    }
    
    private func sendProductGA(slicedArrayForGA: [[String:Any]]){
      
        var productDict: [String:Any] = [String:Any]()
        productDict["impressions"] = slicedArrayForGA
        productDict["currencyCode"] = "INR"
        var gaDict = [String:Any]()
        gaDict["event"] = "productImpression"
        gaDict["ecommerce"] = productDict
        gaDict["screenName"] = pageName
        if let userID = SFUtilsManager.getUserId() {
            customerID = userID
        }
        gaDict["Customer_Id"] = self.customerID
        gaDict["vertical_name"] = self.verticalName
        SFBridge.shared.interactor?.trackStorefrontEvents(gaDict)
    }
    
    private func sendPromoImpressionTracking() {
        if promoArray.count >= getBatchCount() {
            let slice = promoArray[0..<getBatchCount()]
            let promosForGA = Array(slice)
            sendPromoGA(slicedArrayForGA: promosForGA)
            if self.promoArray.indices.contains(self.getBatchCount() - 1) {
                self.promoArray.removeSubrange(0..<self.getBatchCount())
            }
            //print("remove promo ")
        }else {
            if forceSendPromoGA {
                sendPromoGA(slicedArrayForGA: self.promoArray)
                self.promoArray.removeAll()
                forceSendPromoGA = false
            }
        }
    }
    
    private func sendPromoGA(slicedArrayForGA: [[String:Any]]){
        guard slicedArrayForGA.count > 0 else {
            return
        }
        var promotionDict: [String:Any] = [String:Any]()
        promotionDict["promotions"] = slicedArrayForGA
        var promoViewDict: [String:Any] = [String:Any]()
        promoViewDict["promoView"] = promotionDict
        var gaDict = [String:Any]()
        gaDict["event"] = "promotionImpression"
        gaDict["ecommerce"] = promoViewDict
        gaDict["screenName"] = pageName 
        if let userID = SFUtilsManager.getUserId() {
            customerID = userID
        }
        gaDict["Customer_Id"] = customerID
        gaDict["vertical_name"] = self.verticalName
        SFBridge.shared.interactor?.trackStorefrontEvents(gaDict)
    }
}
