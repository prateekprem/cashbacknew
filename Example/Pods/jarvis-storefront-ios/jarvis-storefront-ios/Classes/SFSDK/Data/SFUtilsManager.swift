//
//  File.swift
//  jarvis-storefront-ios
//
//  Created by Samar Gupta on 28/01/20.
//

import Foundation

class SFUtilsManager {
    
    class func getHours(counter: Int) -> String {
        let hours = counter/3600
        if hours >= 10 {
            return "\(hours)"
        }
        else {
            return "0\(hours)"
        }
    }
    
    class func getMinutes(counter: Int) -> String {
        let minutes = (counter % 3600)/60
        if minutes >= 10 {
            return "\(minutes)"
        }
        else {
            return "0\(minutes)"
        }
    }
    
    class func getSeconds(counter: Int) -> String {
        let seconds = (counter % 3600) % 60
        if seconds >= 10 {
            return "\(seconds)"
        }
        else {
            return "0\(seconds)"
        }
    }
    
    class func isValidCarouselReco4xItem(itemId: Int, title: String, ctaLabel: String) -> Bool {
        if let cancelledRecoItems = self.getCancelledRecoItems(), cancelledRecoItems.count > 0, itemId != 0 {
            let cancelledRecos: Set<String> = Set(cancelledRecoItems)
            let hashKey: String = self.cancelledRecoHashKey(itemId: itemId, title: title, ctaLabel: ctaLabel)
            return !cancelledRecos.contains(hashKey)
        }
        return true
    }
    
    class func cancelledRecoHashKey(itemId: Int, title: String, ctaLabel: String) -> String {
        return "\(itemId)\(title)\(ctaLabel)"
    }
    
    class func getCancelledRecoItems() -> [String]? {
        if isUserLoggedIn(), let userId: String = getUserId(), userId.isValidString(), let cancelledRecoItems: [String] = UserDefaults.standard.object(forKey: "CancelledRecoItems_\(userId)") as? [String] {
            return cancelledRecoItems
        }
        
        return nil
    }
    
    class func setCancelledRecoItems(array: [String]) {
        if let userID = getUserId(), !userID.isEmpty {
            UserDefaults.standard.set(array, forKey: "CancelledRecoItems_\(userID)")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getUserId() -> String? {
        return SFBridge.shared.interactor?.getUserId()
    }
    
    class func isUserLoggedIn() -> Bool {
        if let isLoggedIn: Bool = SFBridge.shared.interactor?.isUserLoggedIn() {
            return isLoggedIn
        }
        
        return false
    }
    
    // App Manager
    class func string(forKey key: String) -> String? {
        return SFBridge.shared.interactor?.string(forKey: key)
    }
    
    class func value<T>(forKey key: String) -> T? {
        return SFBridge.shared.interactor?.value(forKey: key)
    }
    
    // Recents item for Recents-list widget
    class func filteredRecentItems(items: [SFLayoutItem]) -> [SFLayoutItem] {
        let savedRecentNames = getRecentItemsNames()
        if !savedRecentNames.isEmpty {
            var filteredItems: [SFLayoutItem] = [SFLayoutItem]()
            for name in savedRecentNames {
                let matchedItems = items.filter { (layoutItem) -> Bool in
                    let itemName = layoutItem.itemName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    return itemName.caseInsensitiveCompare(name) == .orderedSame
                }
                if !matchedItems.isEmpty {
                    filteredItems.append(contentsOf: matchedItems)
                }
            }
            
            return filteredItems
        }
        
        return []
    }
    
    class func saveRecentItemName(name: String) {
        let trimmedName = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            var savedNames = getRecentItemsNames()
            if savedNames.contains(trimmedName) {
                savedNames.removeObject(trimmedName)
                savedNames.insert(trimmedName, at: 0)
            }
            else {
                savedNames.insert(trimmedName, at: 0)
                if savedNames.count > 12 {
                    savedNames.removeLast()
                }
            }
            
            UserDefaults.standard.setValue(savedNames, forKey: "kRecentItemNames")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getRecentItemsNames() -> [String] {
        if let savedNames: [String] = UserDefaults.standard.object(forKey: "kRecentItemNames") as? [String] {
            return savedNames
        }
        return []
    }
    
    class func resetRecentNames() {
        UserDefaults.standard.removeObject(forKey: "kRecentItemNames")
        UserDefaults.standard.synchronize()
    }
}

