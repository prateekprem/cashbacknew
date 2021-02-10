//
//  JRGoogleTrackManager.swift
//  jarvis-common-ios
//
//  Created by Shivam Jaiswal on 21/12/20.
//

import UIKit

@objcMembers public class JRGoogleTrackManager: NSObject {

    public class func dimensionDict() -> [AnyHashable : Any]? {
        return JRGoogleTrackManagerSequencer.dimensionDict
    }

    public class func pushDataToGoogleTrackManager(withObject object: [AnyHashable : Any]?) {
        pushSynchrounouslyDataToGoogleTrackManager(withObject: object)
    }

    public class func pushSynchrounouslyDataToGoogleTrackManager(withObject object: [AnyHashable : Any]?) {
        JRGoogleTrackManager.push(object)
    }

    public class func push(_ object: [AnyHashable : Any]?) {
        guard let object = object else { return }
        JRAnalytics.logEvent(object)
    }

    public class func trackCustomEventforScreen(_ screenName: String?, eventName: String?, variables: [AnyHashable : Any]?) {
        var trackingObjects: [AnyHashable: Any] = [AnyHashable: Any]()
        if let screenName = screenName, !screenName.isEmpty {
            trackingObjects["screenName"] = screenName
        }
        
        if let eventName = eventName, !eventName.isEmpty {
            trackingObjects["event"] = eventName
        }
        
        if let variables = variables, !variables.isEmpty {
            trackingObjects += variables
        }
        
        JRGoogleTrackManager.pushDataToGoogleTrackManager(withObject: trackingObjects)
    }

    public class func userInfo() -> [AnyHashable : Any] {
        var userInfoDictionary = [AnyHashable: Any]()
        userInfoDictionary["Device_Brand"] = "Apple"
        userInfoDictionary["Device_Name"] = UIDevice.current.name
        userInfoDictionary["Custom_Device_ID"] = UIDevice.current.identifierForVendor?.uuidString.toBase64()
        userInfoDictionary["Advertising_ID"] = JRAPIManager.sharedManager().getIDFAIdentifier()
        
        if let appDelegate = JRCommonManager.shared.applicationDelegate, appDelegate.getIsLoggedInFromJRAccount() {
            userInfoDictionary["Customer_Id"] = JRGoogleTrackManager.getUserIdFromSharedAccount()
            userInfoDictionary["Contact_Number"] = appDelegate.getMobileFromJRAccount().toBase64()
            userInfoDictionary["user_email"] = appDelegate.getEmailIdFromJRAccount().toBase64()
        }
        return userInfoDictionary
    }

    public class func getUserIdFromSharedAccount() -> String? {
       return JRCommonManager.shared.applicationDelegate?.getUserIdFromJRAccount()
    }

    //Tracking UserInfo with screen name  And event as openScreen
    //used mainly for home / grid / Order summary/ PDP
    public class func trackUserInfo(forOpenScreen screenName: String?) {
        guard let screenName = screenName else { return }
        
        var userInfoDictionary = [AnyHashable: Any]()
        userInfoDictionary +=  userInfo()
        
        if screenName.contains("first_app_launch") {
            userInfoDictionary["event"] = "first_app_launch"
        } else {
            userInfoDictionary["event"] = "openScreen"
            userInfoDictionary["screenName"] = screenName
        }

        if screenName.contains("first_app_launch") {
            var info: [AnyHashable : Any] = [:]
            info["acquisition_campaign"] = "acquisition_campaign"
            info["acquisition_medium"] = "acquisition_medium"
            info["acquistion_source"] = "acquistion_source"
            userInfoDictionary += info
        }
        
        userInfoDictionary["device_model"] = JRUtility.platformString
        JRGoogleTrackManager.pushDataToGoogleTrackManager(withObject: userInfoDictionary)
    }

    public class func trackUserInfo(forOpenScreen screenName: String?, verticalName name: String?) {
        var userInfoDictionary: [AnyHashable: Any] = [:]
        userInfoDictionary += userInfo()
        userInfoDictionary["event"] = "openScreen"
        userInfoDictionary["screenName"] = screenName
        userInfoDictionary["vertical_name"] = name
        userInfoDictionary["Customer_Id"] = self.getUserIdFromSharedAccount()
        userInfoDictionary["device_model"] = JRUtility.platformString
        JRGoogleTrackManager.pushDataToGoogleTrackManager(withObject: userInfoDictionary)
    }

    public class func trackUserInfoForOpeningApplication() {
        JRGoogleTrackManager.trackCustomEventforScreen("", eventName: "set_user_id", variables: [
            "dimension55": getUserIdFromSharedAccount() ?? "",
            "user_id": getUserIdFromSharedAccount() ?? ""
        ])
    }
}
