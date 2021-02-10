//
//  JRCBMockUtils.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 28/12/19.
//

import Foundation

// MARK: - JRCBMockUtils
public typealias JRCBCacheReturnDictTouple = (dict: [String: Any]?, errMsg: String?)
public typealias JRCBCacheReturnJsonTouple = (data: Any?, errMsg: String?)

enum JRCBMockUtils: String {
    case kJRCBPostTransMockFile         = "CBPostTransMock"
    case kJRCBScratchByIdMockFile       = "CBScratchCardBYID"
    case kJRCBUpdateScrachMockFile      = "CBUpdateScratchCard"
    case kJRCBLanding                   = "CBLanding"
    case kJRCBScratchCardBYID_bunch     = "CBScratchCardBYID_bunch"
    case kJRCBFlipTxnResponse           = "CBFlipResponse"
    
    func getDictFromBundle() -> JRCBCacheReturnDictTouple {
        do {
            if let file = Bundle.main.url(forResource: self.rawValue, withExtension: "json") {
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
    
    func getDataFromBundle() -> JRCBCacheReturnJsonTouple {
        do {
            if let file = Bundle.main.url(forResource: self.rawValue, withExtension: "json") {
                let data = try Data(contentsOf: file)

                return (data, nil)
                
            } else {
                return (nil, "Bundle file does not exist.")
                
            }
        } catch {
            return (nil, error.localizedDescription)
        }
    }
}
