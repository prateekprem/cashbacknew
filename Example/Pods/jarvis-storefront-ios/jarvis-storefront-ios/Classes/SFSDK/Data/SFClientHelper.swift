//
//  SFClientHelper.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 23/12/20.
//

import Foundation

/**
 Use this class for exposing public helper methods to clients
 */

public class SFClientHelper {
    /**
     Use this method to update recent item names, which is being filtered from "recent-list" widget items to show. (For example search screen uses this method to update recents)
     */
    public class func updateRecentItemName(itemName: String) {
        SFUtilsManager.saveRecentItemName(name: itemName)
    }
    
    public class func resetRecents() {
        SFUtilsManager.resetRecentNames()
    }
}
