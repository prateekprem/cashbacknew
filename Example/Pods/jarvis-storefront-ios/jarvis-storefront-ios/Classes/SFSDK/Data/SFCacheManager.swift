//
//  SFCacheManager.swift
//  StoreFront
//
//  Created by Prakash Jha on 06/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import Foundation

public typealias JRHCacheReturnTouple = (dict: [String: Any]?, errMsg: String?)

public class SFCacheManager {
    private(set) var cacheName: String
    private(set) var bundleName: String 
    
    init(cacheName: String, bundleName: String) {
        self.cacheName = cacheName
        self.bundleName = bundleName
    }
    
    private var cacheFilePath : URL? {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectoryUrl.appendingPathComponent(cacheName)
    }
    
    private func retrieveFromJsonFile() -> JRHCacheReturnTouple {
        guard let filePath = self.cacheFilePath else {
            return (nil, "Bundle file does not exist.")
        }
        
        do {
            let data = try Data(contentsOf: filePath, options: [])
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return (json as? [String: Any], nil)
            
        } catch {
            return (nil, error.localizedDescription)
        }
    }
    
    private func getDictFromBundle() -> JRHCacheReturnTouple {
        do {
            if let file = Bundle.main.url(forResource: bundleName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return (json as? [String: Any], nil)
                
            } else {
                return (nil, "Bundle file does not exist.")
                
            }
        } catch {
            return (nil, error.localizedDescription)
        }
    }
}

// MARK: - Public methods
extension SFCacheManager {
    public func storeToCache(dict: [String: Any], completion: (_ completed: Bool) -> Swift.Void) {
        guard let filePath = self.cacheFilePath, JSONSerialization.isValidJSONObject(dict) == true  else { return }
        print(filePath)
        do {
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                try data.write(to: filePath, options: [])
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print(error)
            completion(false)
        }
    }
    
    public func clearCacheData() {
        guard let filePath = self.cacheFilePath else { return }
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
            print("ERROR DESCRIPTION: \(error)")
        }
    }
    
    public func getCacheData() -> JRHCacheReturnTouple {
        let cacheTouple = self.retrieveFromJsonFile()
        if let _ = cacheTouple.dict {
            return cacheTouple
        }
        return self.getDictFromBundle()
    }
}

