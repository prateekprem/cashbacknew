//
//  DirectoryManager.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 02/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

let LANGUAGE_BUNDLE_NAME = "Languages/Language.bundle"

class DirectoryManager: NSObject {
    
    private static var languageBundle : Bundle? = nil
    
    static func getLanguageBundle() -> Bundle{
        if nil == languageBundle{
            createLangaugeBundle()
            return languageBundle!
        }else{
            return languageBundle!
        }
    }
    
    static func getLangaugePath(forLanguageCode code : String) -> String{
        let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return (dir as NSString).appendingPathComponent("\(LANGUAGE_BUNDLE_NAME)/\(code)." + Constants.C_LPROJ)
    }
    
    static func saveLanguageFile(forLanguageCode code : String, fileDate dataToSave : [String: String], withCompletionHandler completion : (_ success : Bool)->()){
        let langPath = getLangaugePath(forLanguageCode: code) + "/" + Constants.C_LOCALIZABLE_STRINGS
        if(!FileManager.default.fileExists(atPath: langPath)){
            do{
                _ = try FileManager.default.createDirectory(atPath: langPath.replacingOccurrences(of: "/" + Constants.C_LOCALIZABLE_STRINGS, with: ""), withIntermediateDirectories: true, attributes: nil)
                FileManager.default.createFile(atPath: langPath, contents: nil, attributes: nil)
            }catch{
                debugPrint("Failed to create dir with error: \(error)")
                completion(false)
                return
            }
        }
        NSKeyedArchiver.archiveRootObject(dataToSave, toFile: langPath)
        completion(true)
    }
    
    static func copyBaseLanguageBundleToDocumentDirectory(withCompletionHandler completion : (_ success : Bool)->()){
        if let basePath = Bundle.main.path(forResource: Constants.C_BASE, ofType: Constants.C_LPROJ){
            let stringsPath = basePath + "/" + Constants.C_LOCALIZABLE_STRINGS
            
            let directoryPath = getLangaugePath(forLanguageCode: Constants.C_BASE) + "/" + Constants.C_LOCALIZABLE_STRINGS
            do{
                var baseNeedsCopy: Bool = false
                let currVer: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
                if FileManager.default.fileExists(atPath:directoryPath) {
                    if let fileSize = try? FileManager.default.attributesOfItem(atPath: directoryPath)[.size] as? UInt, fileSize == 0 {
                        //Check for empty file
                        baseNeedsCopy = true
                    } else {
                        //Check for app upgrade. Avoiding stale copy of base locale in documents dir.
                        if let savedVer: String = UserDefaults.standard.string(forKey: LOCALE_LAST_APP_VERSION) {
                            if let currVer: String = currVer,
                                currVer != savedVer {
                                baseNeedsCopy = true
                            }
                        } else {
                            baseNeedsCopy = true
                        }
                    }
                } else {
                    _ = try FileManager.default.createDirectory(atPath: directoryPath.replacingOccurrences(of: "/" + Constants.C_LOCALIZABLE_STRINGS, with: ""), withIntermediateDirectories: true, attributes: nil)
                    FileManager.default.createFile(atPath: directoryPath, contents: nil, attributes: [:])
                    baseNeedsCopy = true
                }
                
                var baseDict: [String: String]? = nil
                if baseNeedsCopy {
                    if let localDict : [String: String] = NSDictionary.init(contentsOfFile: stringsPath) as? [String: String] {
                        NSKeyedArchiver.archiveRootObject(localDict, toFile: directoryPath)
                        baseDict = localDict
                        if let tempAppVersion: String = currVer {
                            UserDefaults.standard.set(tempAppVersion, forKey: LOCALE_LAST_APP_VERSION)
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
                
                /* BASE V2 Implemenntation - STARTS HERE */
                // Required to support dynamic text updation
                // Basev2 will be created and cloned only once from Base file
                // Update will happen dynamically from the server
                var base2NeedsCopy: Bool = false
                let baseV2Path = getLangaugePath(forLanguageCode: Constants.C_BASE_V2) + "/" + Constants.C_LOCALIZABLE_STRINGS
                if FileManager.default.fileExists(atPath: baseV2Path) {
                    //Check for empty file
                    if let fileSize = try? FileManager.default.attributesOfItem(atPath: baseV2Path)[.size] as? UInt, fileSize == 0 {
                        base2NeedsCopy = true
                    }
                } else {
                    _ = try FileManager.default.createDirectory(atPath: baseV2Path.replacingOccurrences(of: "/" + Constants.C_LOCALIZABLE_STRINGS, with: ""), withIntermediateDirectories: true, attributes: nil)
                    FileManager.default.createFile(atPath: baseV2Path, contents: nil, attributes: [:])
                    base2NeedsCopy = true
                }
                
                if base2NeedsCopy {
                    if let tempBaseDict: [String: String] = baseDict {
                        NSKeyedArchiver.archiveRootObject(tempBaseDict, toFile: baseV2Path)
                    } else if let localDict : [String: String] = NSDictionary.init(contentsOfFile: stringsPath) as? [String: String] {
                        NSKeyedArchiver.archiveRootObject(localDict, toFile: baseV2Path)
                    }
                }
                /* BASE V2 Implemenntation - ENDS HERE */
                
                if let baseLocale = LanguageManager.shared.getLocale(forLanguageCode: Constants.C_EN){
                    baseLocale.isDownloaded = true
                }
                completion(true)
            }catch{
                debugPrint("Failed with error: \(error)")
                completion(false)
            }
        }else{
            completion(false)
        }
    }
    
    static func migrateBase64Storage() {
        if UserDefaults.standard.bool(forKey: LOCALE_BASE64_MIGRATED) == false {
            do {
                //This may not be true for a fresh install
                let langBundlePath: String = getBundlePath()
                if FileManager.default.fileExists(atPath: langBundlePath), let langBundleURL: URL = URL(string: langBundlePath) {
                    var currentLang: String? = nil
                    if let currLang = UserDefaults.standard.value(forKey: CURRENT_LANGUAGE_CODE) as? String {
                        currentLang = currLang
                    }
                    
                    let langBundles: [URL] = try FileManager.default.contentsOfDirectory(at: langBundleURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                    for langBundle in langBundles {
                        let langPath: String = langBundle.appendingPathComponent(Constants.C_LOCALIZABLE_STRINGS).relativePath
                        if langPath.contains(Constants.C_BASE_V2 + "." + Constants.C_LPROJ) {
                            //Migrate server english file.
                            if FileManager.default.fileExists(atPath: langPath) {
                                migrateBase64Locale(filePath: langPath)
                            }
                        } else if langPath.contains(Constants.C_BASE + "." + Constants.C_LPROJ) {
                            //Copy english from main bundle
                            if FileManager.default.fileExists(atPath: langPath) {
                                if let baseBundlePath = Bundle.main.path(forResource: Constants.C_BASE, ofType: Constants.C_LPROJ) {
                                    let stringsPath = baseBundlePath + "/" + Constants.C_LOCALIZABLE_STRINGS
                                    if let tempDict: [String: String] = NSDictionary.init(contentsOfFile: stringsPath) as? [String: String] {
                                        NSKeyedArchiver.archiveRootObject(tempDict, toFile: langPath)
                                    }
                                }
                            }
                        } else if let currLang: String = currentLang, currLang.isEmpty == false,
                            langPath.contains(currLang + "." + Constants.C_LPROJ) {
                            //Migrate current language
                            if FileManager.default.fileExists(atPath: langPath) {
                                migrateBase64Locale(filePath: langPath)
                            }
                        } else {
                            //Delete other language
                            if FileManager.default.isDeletableFile(atPath: langBundle.relativePath) {
                                try FileManager.default.removeItem(at: langBundle)
                            }
                        }
                    }
                }
                UserDefaults.standard.set(true, forKey: LOCALE_BASE64_MIGRATED)
                UserDefaults.standard.synchronize()
            } catch {
                debugPrint("Base64 migration failed: \(error)")
            }
        }
    }
    
    static func checkIfBasev2Exists() -> Bool{
        if FileManager.default.fileExists(atPath: getLangaugePath(forLanguageCode: Constants.C_BASE_V2) + "/" + Constants.C_LOCALIZABLE_STRINGS){
            return true
        }
        return false
    }
    
    static func getDataFromLanguagesPropertyFile() -> [JRLocale]{
        //Updated logic to fetch data from documents directory
        let plistUrl : String = DirectoryManager.getLangaugePlistPath() + "/" + LANGUAGE_PLIST_NAME
        if let array : [[String : Any]] = NSArray(contentsOfFile: plistUrl) as? [[String : Any]]{
            var localeArray : [JRLocale] = [JRLocale]()
            for dict in array{
                localeArray.append(JRLocale.init(withDictionary: dict))
            }
            if localeArray.count > 0 { return localeArray } else { return getFallbackLanguages() }
        }else{
            return getFallbackLanguages()
        }
        /*
        if let urlString = Bundle.main.path(forResource: "Languages", ofType: "plist"),let array = NSArray(contentsOfFile: urlString) as? [[String : Any]]{
            var localeArray : [JRLocale] = [JRLocale]()
            for dict in array{
                localeArray.append(JRLocale.init(withDictionary: dict))
            }
            if localeArray.count > 0 { return localeArray } else { return getFallbackLanguages() }
        }else{
           return getFallbackLanguages()
        }
         */
    }
    
    static func getFallbackLanguages() -> [JRLocale]{
        let english : JRLocale = JRLocale.init(languageCode: Constants.C_EN, countryCode: "IN", name: "English")
        return  [english]
    }
}

//MARK: private
private extension DirectoryManager {
    static func getBundlePath() -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return (dir as NSString).appendingPathComponent(LANGUAGE_BUNDLE_NAME)
    }
    
    static func createLangaugeBundle(){
        let path = getBundlePath()
        var isDir : ObjCBool = true
        if (!FileManager.default.fileExists(atPath: path, isDirectory: &isDir)) {
            do {
                _ = try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                debugPrint("Failed to create dir with error: \(error)")
            }
        }
        languageBundle = Bundle(path: getBundlePath()) ?? nil
    }
    
    static func migrateBase64Locale(filePath: String) {
        if let tempDict: [String: String] = NSDictionary.init(contentsOfFile: filePath) as? [String: String] {
            var decodedDict: [String: String] = [:]
            for (key, value) in tempDict {
                if var tempKey: String = key.fromBase64(), var tempValue: String = value.fromBase64() {
                    decodedDict[replaceJunk(fromString: &tempKey)] = replaceJunk(fromString: &tempValue)
                }
            }
            NSKeyedArchiver.archiveRootObject(decodedDict, toFile: filePath)
        }
    }
    
    static func replaceJunk(fromString str : inout String) -> String{
        str = str.replacingOccurrences(of: "\\n", with: "\n")
        str = str.replacingOccurrences(of: "\\t", with: "\t")
        str = str.replacingOccurrences(of: "\\r", with: "\r")
        str = str.replacingOccurrences(of: "\\u20B9", with: "₹")
        return str
    }
}

//MARK: Supported Languages
extension DirectoryManager{
    
    static var LANGUAGE_PLIST_PATH = "Languages"
    static var LANGUAGE_PLIST_NAME = "Languages.plist"
    
    static func getLangaugePlistPath() -> String{
        let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return (dir as NSString).appendingPathComponent(LANGUAGE_PLIST_PATH)
    }
    
    static func checkIfLanguagePlistExist() -> Bool{
        let langPath = getLangaugePlistPath() + "/" + LANGUAGE_PLIST_NAME
        if FileManager.default.fileExists(atPath: langPath) {
            return true
        }
        return false
    }
    
    static func saveLanguagePlistFile(fileData dataToSave: NSMutableArray, withCompletionHandler completion : (_ success : Bool)->()){
        let langPath = getLangaugePlistPath() + "/" + LANGUAGE_PLIST_NAME
        if(!FileManager.default.fileExists(atPath: langPath)){
            do{
                _ = try FileManager.default.createDirectory(atPath: langPath.replacingOccurrences(of: "/" + LANGUAGE_PLIST_NAME, with: ""), withIntermediateDirectories: true, attributes: nil)
                FileManager.default.createFile(atPath: langPath, contents: nil, attributes: nil)
            }catch{
                debugPrint("Failed to create plist dir with error: \(error)")
                completion(false)
                return
            }
        }
        dataToSave.write(toFile: langPath, atomically: true)
        completion(true)
    }
}
