//
//  JRAuthManager.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 11/05/20.
//

import UIKit

public class JRAuthManager {
    static let kAuthBundle = Bundle.init(for: JRAuthManager.self)
    static let kAuthStoryboard = UIStoryboard.init(name: "LoginUI", bundle: kAuthBundle)
    static let kDIYAccountBlockUnblockStoryboard = UIStoryboard.init(name: "DIYAccountBlockUnblock", bundle: kAuthBundle)
    static let kAuthPopupStoryboard = UIStoryboard.init(name: "JRAuthLoginPopup", bundle: kAuthBundle)
    static let kEmailUpdateStoryboard = UIStoryboard.init(name: "EmailUpdate", bundle: kAuthBundle)
    static let kAuthAppAlreadyLaunched = "RootHomeView"
    
    public class var isAppAlreadyLaunched : Bool {
        return UserDefaults.standard.bool(forKey: kAuthAppAlreadyLaunched)
    }
    
    class func setApp(launched: Bool) {
        UserDefaults.standard.set(launched, forKey: kAuthAppAlreadyLaunched)
        UserDefaults.standard.synchronize()
    }
}
