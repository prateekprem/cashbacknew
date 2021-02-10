//
//  GlobalConstants.swift
//  jarvis-locale-ios
//
//  Created by Abhinav Kumar Roy on 09/01/19.
//

import UIKit

@objc public class GlobalConstants : NSObject{
    
    @objc public static var JRAppStoreUpdateURL : String {
        get{
            if JRUtilityManager.shared.moduleConfig.varient == .mall{
                return "https://itunes.apple.com/in/app/paytm-mall-bazaar/id1157845438?mt=8"
            }
            return "https://itunes.apple.com/in/app/paytm-recharge-bill-payments/id473941634?mt=8"
        }
    }
    
    @objc public static var JRiPhoneAppStoreID : String{
        get{
            if JRUtilityManager.shared.moduleConfig.varient == .mall{
                return "1157845438"
            }
            return "473941634"
        }
    }
    
    @objc public static var JRClientID : String{
        get{
            if JRUtilityManager.shared.moduleConfig.environment == .staging{
              if JRUtilityManager.shared.moduleConfig.varient == .mall{
                return "mall-app"
              }
              else{
                return "market-app-staging"
              }
            }
            else{
              return "market-app"
            }
          }
        }
    
    @objc public static var JRClientSecret : String{
        get{
          if JRUtilityManager.shared.moduleConfig.environment == .staging{
            return "a83d542a-eb4d-4b8e-8eeb-9316cc0e6808"
          }
          else{
            return "9a071762-a499-4bd9-914a-4361e7c3f4bc"
          }
        }
    }
    
    @objc public static var JRAuthorizationCode : String{
        get{
          if JRUtilityManager.shared.moduleConfig.environment == .staging{
            return "Basic bWFya2V0LWFwcC1zdGFnaW5nOmE4M2Q1NDJhLWViNGQtNGI4ZS04ZWViLTkzMTZjYzBlNjgwOA=="
          }
          else{
            return "Basic bWFya2V0LWFwcDo5YTA3MTc2Mi1hNDk5LTRiZDktOTE0YS00MzYxZTdjM2Y0YmM="
          }
        }
    }
    
    @objc public static var wxEnvironmentKey : String{
        get{
            if JRUtilityManager.shared.moduleConfig.varient == .mall{
                if JRUtilityManager.shared.moduleConfig.environment == .staging{
                    return "staging"
                }else{
                    return "production"
                }
            }else{
                return "production"
            }
        }
    }
    
    @objc public static var JRBankAuthorizationCode : String{
        get{
            if JRUtilityManager.shared.moduleConfig.varient == .paytm{
                if JRUtilityManager.shared.moduleConfig.environment == .staging{
                    return "Basic bWFya2V0LWFwcC1zdGFnaW5nOmE4M2Q1NDJhLWViNGQtNGI4ZS04ZWViLTkzMTZjYzBlNjgwOA=="
                }
                return "Basic bWFya2V0LWFwcDo5YTA3MTc2Mi1hNDk5LTRiZDktOTE0YS00MzYxZTdjM2Y0YmM="
            }else{
                return ""
            }
        }
    }
    
}

