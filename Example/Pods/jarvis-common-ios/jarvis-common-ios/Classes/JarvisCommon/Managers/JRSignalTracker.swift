//
//  JRSignalTracker.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 06/06/19.
//

import UIKit
import jarvis_utility_ios

@objc public class JRSignalTracker: NSObject {
 
    /**
     * Paytm Pulse: Used to track Open application event
     * Warning: Should be only used while opening application
     */
    @objc public class func trackUserInfoForOpeningApplication(){
        if let _ = JRCommonManager.shared.applicationDelegate?.getUserIdFromJRAccount(){
            JRSignalTracker.trackCustomEvent(
                forScreen: "",
                eventName: "set_user_id",
                variables: ["dimension55":JRSignalTracker.getUserIdFromSharedAccount(),
                            "user_id":JRSignalTracker.getUserIdFromSharedAccount()]
            )
        }
    }
    
    /**
     * Paytm Pulse: Used to track userInfo for open screen event
     */
    @objc public class func trackUserInfo(forOpenScreen screenName : String){
        var userInfoDictionary = JRGoogleTrackManager.userInfo()
        if screenName.contains(find: "first_app_launch"){
            userInfoDictionary["event"] = "first_app_launch"
        }else{
            userInfoDictionary["event"] = "openScreen"
            userInfoDictionary["screenName"] = screenName
        }
        
        if screenName.contains(find: "first_app_launch"){
            userInfoDictionary["acquisition_campaign"] = "acquisition_campaign"
            userInfoDictionary["acquisition_medium"] = "acquisition_medium"
            userInfoDictionary["acquistion_source"] = "acquistion_source"
        }
        
        userInfoDictionary["device_model"] = JRUtility.platformString
        JRAnalytics.pushToSignal(event: userInfoDictionary)
    }
    
    /**
     * Paytm Pulse: Used to track userInfo for open screen event with veertical name
     */
    @objc public class func trackUserInfo(forOpenScreen screenName : String, verticalName : String){
        var userInfoDictionary = JRGoogleTrackManager.userInfo()
        userInfoDictionary["event"] = "openScreen"
        userInfoDictionary["screenName"] = screenName
        userInfoDictionary["vertical_name"] = verticalName
        userInfoDictionary["Customer_Id"] = JRSignalTracker.getUserIdFromSharedAccount()
        userInfoDictionary["device_model"] = JRUtility.platformString
        
        JRAnalytics.pushToSignal(event: userInfoDictionary)
    }
    
    /**
     * Paytm Pulse: Used to track custom event
     */
    @objc public class func trackCustomEvent(forScreen screenName : String, eventName : String, variables : [AnyHashable : Any]){
        var trackingObjects : [AnyHashable : Any] = [:]
        if "" != screenName{
            trackingObjects["screenName"] = screenName
        }
        
        if "" != eventName{
            trackingObjects["event"] = eventName
        }
        
        if variables.count > 0{
            for (key,value) in variables{
                trackingObjects[key] = value
            }
        }
        
        JRAnalytics.pushToSignal(event: trackingObjects)
    }
}

extension JRSignalTracker {
    
    private class func getUserIdFromSharedAccount() -> String{
        if let userId = JRCommonManager.shared.applicationDelegate?.getUserIdFromJRAccount(){
            return userId
        }
        return ""
    }
    
}
