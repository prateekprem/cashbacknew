//
//  JRTagFileExtension.swift
//  JRTagManagerDemo
//
//  Created by nasib ali on 05/08/19.
//  Copyright © 2019 nasib ali. All rights reserved.
//

import Foundation

class JRAppManagerFileManager {
    
    class func updateLocalData(_ data: Any, of file: String, completionHandler:((Bool)->Void)?) {
        storeObject(data, name: file, handler: completionHandler)
    }
    
    class func syncLocalData(fileName: String, completionHandler:(([String: Any]?)-> Void)?) {
        
        fileData(fileName) { (success, data) in
            if true == success, let dataDic = data as? [String: AnyObject] {
                completionHandler?(dataDic)
            }else{
                completionHandler?(nil)
            }
        }
    }
    
    class func bundleData(of file: String) -> Any? {
        
        if let path = Bundle.main.url(forResource: file, withExtension: "json") {
            
            do {
                let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
                return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            }catch{
                print("error \(error)")
            }
        }
        return nil
    }
    
}


extension JRAppManagerFileManager {
    
    class func unarchive(_ filePath: String, handler: ((Bool,Any?) -> Void)?) {
        
        let object = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
        handler?(true, object)
    }
    
    class func archive(_ object: Any, filePath: String, handler:((Bool)->Void)?) {
        
        let success = NSKeyedArchiver.archiveRootObject(object, toFile: filePath)
        handler?(success)
    }
    
    class func pathOf(_ fileName: String) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let cacheDirectory = paths.first {
            let filePath: String = (cacheDirectory as NSString).appendingPathComponent(fileName)
            return filePath
        }
        return nil
    }
    
    class func copyFromBundle(of file: String, handler:((Bool, Any?) -> Void)?) {
        if let bundleData = bundleData(of: file) {
            handler?(true, bundleData)
        }else{
            handler?(true, nil)
        }
    }
    
    
    class func fileData(_ name:String, handler:((Bool,Any?) -> Void)?) {
        guard let filePath = pathOf(name) else { return }
        if FileManager.default.fileExists(atPath: filePath) {
            unarchive(filePath, handler: handler)
        } else {
            copyFromBundle(of: name, handler: handler)
        }
    }
    
    
    class func storeObject(_ object: Any, name:String, handler:((Bool)->Void)?) {
        if let path = pathOf(name) {
            archive(object, filePath: path, handler: handler)
        }
    }
}

