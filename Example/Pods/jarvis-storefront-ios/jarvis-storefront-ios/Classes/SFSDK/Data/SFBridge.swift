//
//  SFBridge.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 15/10/20.
//

import Foundation
import jarvis_locale_ios

public protocol SFBridgeInteractor {
    // User Info
    func isUserLoggedIn() -> Bool
    func getUserId() -> String?
    
    // App Manager
    func string(forKey key: String) -> String?
    func value<T>(forKey key: String) -> T?
    
    // Analytics
    func trackStorefrontEvents(_ data: [String: Any])
}

public extension SFBridgeInteractor {
    func string(forKey key: String) -> String? {
        return nil
    }
    
    func value<T>(forKey key: String) -> T? {
        return nil
    }
}

class SFBridge {
    static let shared: SFBridge = SFBridge()
    
    public private (set) var interactor: SFBridgeInteractor?
    
    func setup(_ interactor: SFBridgeInteractor) {
        self.interactor = interactor
        addObserver()
    }
    
    // MARK: Private Methods
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name.init(LANGUAGE_CHANGE_NOTIFICATION), object: nil)
    }
    
    @objc private func languageChanged() {
        SFClientHelper.resetRecents()
    }
}
