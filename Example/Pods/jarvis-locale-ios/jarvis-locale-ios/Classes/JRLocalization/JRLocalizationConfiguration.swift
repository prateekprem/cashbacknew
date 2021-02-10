//
//  JRLocalizationConfiguration.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 01/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public class JRLocalizationConfiguration: NSObject {
    
    @objc public class func setDefaultConfiguration(isDynamicLanguageBundleEnabled : Bool = false){
        JRLocalizationConfiguration.initializeLanguageManager(withDynamicLanguageEnabled: isDynamicLanguageBundleEnabled)
    }
    
    @objc public class func setDymamicLanguageEnabled(isDynamicLanguageEnabled : Bool = false){
        LanguageManager.shared.isDynamicLanguageEnabled = isDynamicLanguageEnabled
    }
}

//MARK: Private
private extension JRLocalizationConfiguration {
    
    static func initializeLanguageManager(withDynamicLanguageEnabled dynamicLangEnabled: Bool){
        let languageManager : LanguageManager = LanguageManager.shared
        
        DirectoryManager.migrateBase64Storage()
        
        //Initlialize dummmy language list
        DownloadManager.shared.initlializeLanguageListWithDummyDataOnStartup {
            //Copy Base Language.strings to Document Directory
            DirectoryManager.copyBaseLanguageBundleToDocumentDirectory { (success) in
                if success{
                    languageManager.isDynamicLanguageEnabled = dynamicLangEnabled
                    let systemLang = Locale.preferredLanguages[0].components(separatedBy: "-")[0]
                    if let lastSystemLang = languageManager.getLastSystemLanguageCode(), systemLang != lastSystemLang,languageManager.checkIfLanguageAvailable(forLanguageCode: systemLang), languageManager.checkIfLanguageDownloaded(forLanguageCode: systemLang){
                        
                        //Set language, It also initialises the cache.
                        languageManager.setLanguage(withLanugageCode: systemLang)
                        
                        //Set system language
                        languageManager.setLastSystemLanguageCode(systemLang)
                    } else {
                        //Set system language
                        languageManager.setLastSystemLanguageCode(systemLang)
                        if let _ = languageManager.getCurrentLocale()?.languageCode{
                            
                        }else{
                            //fallback : set default language
                            languageManager.setDefaultLanguage()
                        }
                        
                        //Load cache
                        if languageManager.isDynamicLanguageEnabled {
                            languageManager.initialiseCache()
                        }
                    }
                }else{
                    // error while copying : disable language framework | Try next time when app opens
                    setDymamicLanguageEnabled(isDynamicLanguageEnabled: false)
                }
            }
        }
    }
    
}
