//
//  JRImageUtilities.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 05/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit

public class JRImageUtilities: NSObject {
    
    @objc public class func urlForImage(_ imageUrl: String, size imageSize: CGSize) -> String {
        
        let width = imageSize.width * UIScreen.main.scale
        let height = imageSize.height * UIScreen.main.scale
        if let stringToReplace = imageUrl.components(separatedBy: "/").last {
        let  width = Int(width), height = Int(height)
        let stringToAppend = "\(width)x\(height)/" + (stringToReplace)
        let url = imageUrl.replacingOccurrences(of: stringToReplace, with: stringToAppend)
        return url
        }
        return imageUrl
    }
}
