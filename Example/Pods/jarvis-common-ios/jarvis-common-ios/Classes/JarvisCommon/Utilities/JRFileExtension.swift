//
//  JRFileExtension.swift
//  Jarvis
//
//  Copyright © 2016 One97. All rights reserved.
//
private let homePageAnimationURL  = "homePageAnimationURL"
open class JRFileExtension: NSObject {
    
    open func dataFromJSONFile(filePath: String) -> NSData?
    {
        guard let data = openJSONFile(fileName: filePath) else
        {
            return nil
        }
        return data
    }
    
    open func dictionaryFromJSONFile(filePath: String) -> [String: AnyObject]?
    {
        guard let jsonData = openJSONFile(fileName: filePath) else
        {
            return nil
        }
        return jsonData.dictionary()
    }
    
    open func openJSONFile(fileName: String) -> NSData?
    {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else
        {
            return nil
        }
        return NSData(contentsOfFile:filePath)
    }
    
    open class func isURLImage(url:URL) -> Bool {
        let urlExtension: String = url.pathExtension
        if (urlExtension == "json") {
            return false
        }
        return true
    }
}

//MARK:- Archive/Cache/JSON
extension JRFileExtension {
    /// Reads JSON from main bundle if not found in the documents directory and copies it into the documents directory. A different thread is used for reading.
    ///
    /// - Parameters:
    ///   - page: Name of the file.
    ///   - handler: Optional handler to be called with read status and JSON. It is always called on main thread.
    open class func cacheForPage(page:String, handler:((Bool,Any?) -> Void)?) {
        JRCommonManager.shared.operationQSerial.addOperation { () -> Void in
            let paths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            var json: Any?
            var success: Bool = false
            if let cacheDirectory = paths.first {
                let seversFilePath: String = (cacheDirectory as NSString).appendingPathComponent(page+".json")
                if FileManager.default.fileExists(atPath: seversFilePath) {
                    do {
                        if let jsondata = try? Data.init(contentsOf: URL(fileURLWithPath: seversFilePath)) {
                            json = try JSONSerialization.jsonObject(with: jsondata, options: .mutableLeaves)
                            success = true
                        }
                    }catch{}
                } else {
                    if let path = Bundle.main.path(forResource: page, ofType: "json") {
                        if let data = try? Data.init(contentsOf: URL(fileURLWithPath: path)) {
                            do {
                                try? data.write(to: URL(fileURLWithPath: seversFilePath), options: [.atomic])
                                json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                                success = true
                            }catch {}
                            
                        }
                    }
                }
            }
            if let handler = handler {
                DispatchQueue.main.async {
                    handler(success, json)
                }
            }
        }
    }
    
    /// Writes JSON into the documents directory. A different thread is used for writing.
    ///
    /// - Parameters:
    ///   - json: A JSON object to be stored.
    ///   - forPage: Name of the file.
    ///   - handler: Optional handler to be called with write status. It is always called on main thread.
    open class func storeCache(json:Any, forPage:String, handler:((Bool) -> Void)?) {
        JRCommonManager.shared.operationQSerial.addOperation { () -> Void in
            var fileWritten: Bool = false
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            if let cacheDirectory = paths.first {
                let seversFilePath = (cacheDirectory as NSString).appendingPathComponent(forPage+".json")
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    fileWritten = ((try? jsonData.write(to: URL(fileURLWithPath: seversFilePath), options: [.atomic])) != nil)
                }catch {}
            }
            
            if let handler = handler {
                DispatchQueue.main.async {
                    handler(fileWritten)
                }
            }
        }
    }
    
    /// Unarchives and returns the root object. Copies from main bundle if not found in the documents directory. NSKeyedUnarchiver.
    ///
    /// - Parameters:
    ///   - name: Name of the file. If the file is not found in the douments directory then it will be searched in the main bundle and copied into the documents directory if found.
    ///   - synchronous: If true then it uses the current thread and calls the handler. In case of false a different thread will be used and the handler will be called in main queue.
    ///   - handler: Optional handler to be called with status and the root object.
    @objc open class func object(_ name:String, synchronous:Bool, handler:((Bool,Any?) -> Void)?) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let cacheDirectory = paths.first {
            let filePath: String = (cacheDirectory as NSString).appendingPathComponent(name)
            let fileSaved: Bool = FileManager.default.fileExists(atPath: filePath)
            
            /// It copies the file from bundle if needed
            let copyFromBundleClosure = { () -> Bool in
                var copied: Bool = false
                if let path = Bundle.main.path(forResource: name, ofType: nil) {
                    let objData = try? Data.init(contentsOf: URL(fileURLWithPath: path))
                    if let objData = objData {
                        copied = ((try? objData.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil)
                    } else {
                        //Should never happen.
                    }
                }
                return copied
            }
            
            func syncUnarchive(filePath: String, handler: ((Bool,Any?) -> Void)?) {
                let object: Any? = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
                handler?(true, object)
            }
            
            func asyncUnarchive(filePath: String, handler: ((Bool,Any?) -> Void)?) {
                let object: Any? = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
                if let handler = handler {
                    DispatchQueue.main.async {
                        handler(true, object)
                    }
                }
            }
            
            if synchronous {
                if fileSaved {
                    syncUnarchive(filePath: filePath, handler: handler)
                } else {
                    if copyFromBundleClosure() {
                        syncUnarchive(filePath: filePath, handler: handler)
                    }
                }
            } else {
                JRCommonManager.shared.operationQSerial.addOperation { () -> Void in
                    if fileSaved {
                        asyncUnarchive(filePath: filePath, handler: handler)
                    } else {
                        if copyFromBundleClosure() {
                            asyncUnarchive(filePath: filePath, handler: handler)
                        } else {
                            if let handler = handler {
                                DispatchQueue.main.async {
                                    handler(false, nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Arcives root object into the documents directory. NSKeyedArchiver
    ///
    /// - Parameters:
    ///   - object: Should coform to NSCoding.
    ///   - name: Name of the file.
    ///   - synchronous: If true then it uses the current thread and calls the handler. In case of false a different thread will be used and the handler will be called in main queue.
    ///   - handler: Optional handler to be called with write status.
    open class func storeObject(_ object:Any, name:String, synchronous:Bool, handler:((Bool)->Void)?) {
        var fileWritten = false
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let cacheDirectory = paths.first {
            let filePath = (cacheDirectory as NSString).appendingPathComponent(name)
            
            if synchronous {
                fileWritten = NSKeyedArchiver.archiveRootObject(object, toFile: filePath)
                handler?(fileWritten)
            } else {
                JRCommonManager.shared.operationQSerial.addOperation { () -> Void in
                    fileWritten = NSKeyedArchiver.archiveRootObject(object, toFile: filePath)
                    
                    if let handler = handler {
                        DispatchQueue.main.async {
                            handler(fileWritten)
                        }
                    }
                }
            }
        } else {
            // Should never happen.
            if let handler = handler {
                if synchronous {
                    handler(fileWritten)
                } else {
                    DispatchQueue.main.async {
                        handler(fileWritten)
                    }
                }
            }
        }
    }
    
    open class func clearfile(file: String) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return  }
        let path = documentDirectoryUrl.appendingPathComponent(file).absoluteString
        do {
            try? FileManager.default.removeItem(atPath: path)
        } catch (let error){
            print("ERROR DESCRIPTION: \(error)")
        }
    }
}
