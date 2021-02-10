//
//  JRNetworkUtilityObjc.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 28/05/19.
//

import UIKit
import jarvis_network_ios

@objc public class JRNetworkUtilityObjc : NSObject {
    
    @objc public static func apiFailureApologizyMethod(apiUrl: String?)-> String {
        var errorMessage: String = "\("jr_ac_issueFacingMessage".localized)"
        if let message = apiUrl {
            errorMessage.append(message)
        }
        return errorMessage
    }
    
    @objc public static func showNoNetworkAlert(){
        JRAlertViewWithBlock.showAlertView("jr_ac_noInternetTitle".localized, message: "jr_ac_noIntConnectionDetailMsg".localized, cancelButtonTitle: "jr_ac_OK".localized, otherButtonTitles: nil, handler: nil)
    }
    
    @objc public static func isNetworkReachable() -> Bool{
        return JRNetworkUtility.isNetworkReachable()
    }
    
    @objc public static func someThingWentWrongError() -> NSError? {
        return JRNetworkUtility.customError(withDomain: "jr_ac_errors".localized, code: 400, localizedDescriptionMessage: "jr_ac_facingTechnicalIssue".localized, localizedFailureReasonErrorMessage: "jr_ac_somethingWentWrongWithExclaimation".localized)
    }
    
    @objc public static func retryWithoutAlert(completion: @escaping ()->() ) {
        JRNetworkUtility.retryIfNotReachableWithoutAlert(handler: completion)
    }
    
    @objc public static func jrNetworkReachableNotification() -> String {
        return JRNetworkReachableNotification
    }
    
}

