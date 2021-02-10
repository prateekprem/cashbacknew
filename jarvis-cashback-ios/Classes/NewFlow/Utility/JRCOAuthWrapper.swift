//
//  JRCOAuthWrapper.swift
//  Jarvis
//
//  Created by nasib ali on 08/05/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

class JRCOAuthWrapper {
    class var isSDMerchant: Bool {
        return JRCashbackManager.shared.cbEnvDelegate.cbIsSDMerchant()
    }
    class var ssoToken: String? {
        return JRCashbackManager.shared.cbEnvDelegate.cbGetSsoToken()
    }
    class var usrIdEitherBlank: String {
        return JRCashbackManager.shared.cbEnvDelegate.cbGetUserId() ?? ""
    }
    
    class var profilePic: String? {
        return JRCashbackManager.shared.cbEnvDelegate.cbGetUserPicture()
    }
    
    class var merchantID: String {
      return  JRCashbackManager.shared.cbEnvDelegate.cbGetMerchantID() ?? ""
    }
    
    class var authUMP: String {
       return JRCashbackManager.shared.cbEnvDelegate.cbGetAuthUMP() ?? "app-3320-jmd-678-9b3"
    }
}
