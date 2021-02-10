//
//  LanguageManager.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 01/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

/// User default key for one time Base64 storage migration.
let LOCALE_BASE64_MIGRATED = "localeBase64Migrated"

/// User default key for localisation base copy in user's directory on app upgrade.
let LOCALE_LAST_APP_VERSION = "localeLastAppVersion"

let CURRENT_LANGUAGE_CODE = "LanguageCode" // The key against which to store the selected language code.
let LAST_SYSTEM_LANGUAGE_CODE = "lastSystemLanguageCode" //Last system language code, compare this with currennt. if diff changne the lanng at startup
public let LANGUAGE_CHANGE_NOTIFICATION : String = "changeLanguageNotification"

@objc public class LanguageManager: NSObject {
    
    @objc public static let shared : LanguageManager = LanguageManager()
    @objc public var availableLocales : [JRLocale] {
        return getAvailableLangauges()
    }
    @objc public var availableArrangedLocales : [JRLocale] {
        return getArrangedLanguageSequence()
    }
    @objc public var isDynamicLanguageEnabled : Bool = false
    private var localDic : [String : String] = [String : String]()
    
    public override init() {
        super.init()
        //self.availableLocales = getAvailableLangauges()
    }
    
    public func setLanguage(withLanugageCode code : String){
        if let _ = getLocale(forLanguageCode: code){
            //set language
            UserDefaults.standard.setValue(code, forKey: CURRENT_LANGUAGE_CODE)
            UserDefaults.standard.synchronize()
        }else{
            setDefaultLanguage()
        }
        
        //Reset cache
        localDic = [String : String]()
        initialiseCache()
        
        NotificationCenter.default.post(name: Notification.Name.init(LANGUAGE_CHANGE_NOTIFICATION), object: nil)
    }
    
    public func getCurrentLocale() -> JRLocale?{
        if let languageCode = UserDefaults.standard.value(forKey: CURRENT_LANGUAGE_CODE) as? String{
            return getLocale(forLanguageCode: languageCode)
        }
        return nil
    }
    
    public func getLocale(forLanguageCode languageCode: String) -> JRLocale?{
        for locale in self.availableLocales{
            if locale.languageCode == languageCode{
                return locale
            }
        }
        return nil
    }
    
    @objc public func getLocalizedString(withKey key : String) -> String{
        return getLocalizedString(forKey: key)
    }
    
    public func checkIfLanguageDownloaded(forLanguageCode languageCode : String) -> Bool{
        return checkIfLanguageFileExists(forLanguage: languageCode)
    }
    
    public func downloadLanguage(forLanguageCode code: String, andRequestTuple requestTuple : JRLocalizationRequestTuple,withApiResponseFormat apiResponseFormat : APIResponseFormat = .jsonFormat, withCompletionHandler handler : @escaping(_ success : Bool)->(),_ dataTaskHandler : @escaping (_ dataTask : URLSessionDataTask)->()){
        DownloadManager.shared.downloadAndSaveFile(forLanguageCode: code, andRequestTuple: requestTuple, withApiResponseFormat: apiResponseFormat, andCompletionHandler: { (success) in
            handler(success)
        }) { (dataTask) in
            dataTaskHandler(dataTask)
        }
    }
    
    public func updateLanguage(forLanguageCode code : String, andRequestTuple requestTuple : JRLocalizationRequestTuple, withApiResponseFormat apiResponseFormat : APIResponseFormat = .jsonFormat, withCompletionHandler handler : @escaping(_ success : Bool)->()){
        /* BASE V2 Implemenntation - STARTS HERE */
        var langCode = code
        if langCode == Constants.C_EN{
            langCode = Constants.C_BASE_V2
        }
        /* BASE V2 Implemenntation - ENDS HERE */
        DownloadManager.shared.downloadAndUpdateFile(forLanguageCode: langCode, andRequestTuple: requestTuple, withApiResponseFormat: apiResponseFormat) { (success) in
            handler(success)
        }
    }
    
    public func downloadSupportedLanguages(withRequestTuple requestTuple : JRLocalizationRequestTuple, withCompletionHandler handler :@escaping (_ success : Bool)->()){
        DownloadManager.shared.downloadAndStoreSupportedLanguages(withRequestTuple: requestTuple) { (success) in
            handler(success)
        }
    }
}

//MARK: Internal
extension LanguageManager{
    func setDefaultLanguage(){
        UserDefaults.standard.setValue(Constants.C_EN, forKey: CURRENT_LANGUAGE_CODE)
        UserDefaults.standard.synchronize()
    }
    
    func getLastSystemLanguageCode() -> String?{
        if let languageCode = UserDefaults.standard.value(forKey: LAST_SYSTEM_LANGUAGE_CODE) as? String{
            return languageCode
        }
        return nil
    }
    
    func setLastSystemLanguageCode(_ value : String){
        UserDefaults.standard.setValue(value, forKey: LAST_SYSTEM_LANGUAGE_CODE)
    }
    
    func checkIfLanguageAvailable(forLanguageCode languageCode : String) -> Bool{
        if let _ = getLocale(forLanguageCode: languageCode){
            return true
        }
        return false
    }
    
    func languageDownloaded(code: String, locale: JRLocale) {
        locale.isDownloaded = true
        //Initialising on the main thread to avoid multi thread issues. This may not be required but there is less visibility on update. Set language will initialise the cache.
        initialiseCache()
    }
    
    func checkIfLanguageFileExists(forLanguage code:String) -> Bool{
        let langCode = code == Constants.C_EN ? Constants.C_BASE : code
        return FileManager.default.fileExists(atPath: DirectoryManager.getLangaugePath(forLanguageCode: langCode) + "/" + Constants.C_LOCALIZABLE_STRINGS)
    }
    
    func getLocalizedString(forKey key : String) -> String{
        if LanguageManager.shared.isDynamicLanguageEnabled{
            return getTranslatedString(forKey: key, andBundle: Bundle.languageBundle)
        }else{
            return getTranslatedString(forKey: key, andBundle: Bundle.main)
        }
    }
    
    func initialiseCache() {
        guard isDynamicLanguageEnabled else {
            return
        }
        
        let bundle: Bundle = Bundle.languageBundle
        if let currentLanguageCode = UserDefaults.standard.value(forKey: CURRENT_LANGUAGE_CODE) as? String, currentLanguageCode.isEmpty == false {
            var bundleFolderName = Constants.C_BASE
            if Constants.C_EN != currentLanguageCode, let locale = getCurrentLocale() {
                bundleFolderName = locale.languageCode ?? Constants.C_BASE
            }
            /* BASE V2 Implemenntation - STARTS HERE */
            if (DirectoryManager.checkIfBasev2Exists() && bundleFolderName == Constants.C_BASE) {
                bundleFolderName = Constants.C_BASE_V2
            }
            /* BASE V2 Implementation - ENDS HERE */
            if let languageBundle = Bundle(path: bundle.bundlePath + "/\(bundleFolderName)." + Constants.C_LPROJ), let localDic : [String : String] = NSKeyedUnarchiver.unarchiveObject(withFile: languageBundle.bundlePath + "/" + Constants.C_LOCALIZABLE_STRINGS) as? [String : String] {
                self.localDic = localDic
            }
        }
    }
}

//MARK: private
private extension LanguageManager{
    func getAvailableLangauges() -> [JRLocale]{
        return DirectoryManager.getDataFromLanguagesPropertyFile()
    }
    
    func getArrangedLanguageSequence() -> [JRLocale] {
        var langArray: [JRLocale] = DirectoryManager.getDataFromLanguagesPropertyFile()

        if let currLangCode = getCurrentLocale()?.languageCode {
            var index: Int = 0
            for i in 0..<langArray.count {
                if langArray[i].languageCode == currLangCode {
                    index = i
                }
            }
            
            langArray.insert(langArray[index], at: 0)
            langArray.remove(at: index+1)
        }

        return langArray
    }
    
    func getTranslatedString(forKey key : String, andBundle bundle : Bundle) -> String{
        if key.range(of:"jr_") != nil{
            if bundle == Bundle.main{
                return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
            }else{
                /// Get value from in memory cache. It is expected to be ready at the launch time
                if let value: String = localDic[key] {
                    return value
                }
            }
        }
        //FALLBACK: - Return from main bundle
        let value = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        if key.range(of:"jr_") != nil{
            localDic[key] = value
        }
        return value
    }
}
