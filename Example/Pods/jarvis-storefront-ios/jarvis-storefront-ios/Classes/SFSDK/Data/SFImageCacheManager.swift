//
//  SFImageCacheManager.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 11/12/19.
//

import Foundation
import jarvis_utility_ios

class SFImageCacheManager {
    static func modifyUrl(_ urlString: String) -> String {
        var modifiedUrlString = urlString
        if let networkType = SFManager.shared.interactor?.getNetworkType() {
            if networkType.lowercased() != "wifi" || networkType.lowercased() != "4g" {
            }
            else {
                if let url = URL(string: modifiedUrlString) {
                    let modified = url.appendingQueryItem("impolicy", value: "lq")
                    modifiedUrlString = modified
                }
            }
        }
        
        return modifiedUrlString
    }
    
    static func loadImageForMarketplace(_ imageUrlString: String) {
        guard let imageUrl = URL(string: imageUrlString) else {
            return
        }
        
        JRImageCache.shared.downloadImage(with: imageUrl, options: .retryFailed, progress: nil) { (image, error, cacheType, finished, url) in
        }
    }
}
