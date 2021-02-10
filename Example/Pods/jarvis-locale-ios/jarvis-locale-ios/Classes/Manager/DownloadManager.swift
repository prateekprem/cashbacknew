//
//  DownloadManager.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 02/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    static let shared : DownloadManager = DownloadManager()
    
    func downloadAndSaveFile(forLanguageCode code: String, andRequestTuple requestTuple: JRLocalizationRequestTuple, withApiResponseFormat apiResponseFormat: APIResponseFormat, andCompletionHandler handler : @escaping(_ success : Bool)->(),_ dataTaskHandler : @escaping (_ dataTask : URLSessionDataTask)->()){
        debugPrint("Download start time : \(Date())")
        SessionServiceManager().sendRequest(requestTuple: requestTuple, withCompletionHandler: { [weak self] (success, data) in
            if success, let data = data{
                switch apiResponseFormat{
                case .jsonFormat, .defaultFormat:
                    //Expecting json response. The earlier directly writing data was not executing.
                    do{
                        if let responseData : [String : Any] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any], let jsonData = responseData["\(code)-IN"] as? [[String: Any]]{
                            var resultDict: [String: String] = [:]
                            for dic in jsonData{
                                if let key = dic["key"] as? String, let message = dic["message"] as? String {
                                    resultDict[key] = message
                                }
                            }
                            if resultDict.count > 0 {
                                self?.saveLanguageFile(forLanuageCode: code, andDict: resultDict, withCompletionHandler: { (success) in
                                    handler(success)
                                    debugPrint("Download end time (json) : \(Date())")
                                })
                            }else{
                                handler(false)
                            }
                        }else{
                            handler(false)
                        }
                    }catch{
                        handler(false)
                    }
                }
                
            }else{
                handler(false)
            }
        }) { (dataTask) in
            dataTaskHandler(dataTask)
        }
    }
    
    func downloadAndUpdateFile(forLanguageCode code: String, andRequestTuple requestTuple: JRLocalizationRequestTuple, withApiResponseFormat apiResponseFormat: APIResponseFormat, andCompletionHandler handler : @escaping(_ success : Bool)->()){
        SessionServiceManager().sendRequest(requestTuple: requestTuple, withCompletionHandler: { [weak self] (success, data) in
            if success, let data = data{
                switch apiResponseFormat{
                case .defaultFormat:
                    self?.updateFileWithDefaultFormat(forLanguageCode: code, andData: data, withCompletionHandler: { (success) in
                        handler(success)
                    })
                case .jsonFormat:
                    self?.updateFileWithJsonFormat(forLanguageCode: code, andData: data, withCompletionHandler: { (success) in
                        handler(success)
                    })
                }
            }else{
                handler(false)
            }
        }) { (dataTask) in
            //DO NOTHING
        }
    }
    
}

//MARK: Download methods
private extension DownloadManager {
    func saveLanguageFile(forLanuageCode code : String, andDict dict : [String: String], withCompletionHandler handler : @escaping(_ success : Bool)->()){
        DirectoryManager.saveLanguageFile(forLanguageCode: code, fileDate: dict, withCompletionHandler:{ (success) in
            if success{
                var langCode = code
                /* Base v2 implementation - STARTS HERE */
                if langCode == Constants.C_BASE_V2 || langCode == Constants.C_BASE{
                    langCode = Constants.C_EN
                }
                /* Base v2 implementation - ENDS HERE */
                if let locale = LanguageManager.shared.getLocale(forLanguageCode: langCode){
                    LanguageManager.shared.languageDownloaded(code: langCode, locale: locale)
                    handler(true)
                }else{
                    handler(false)
                }
            }else{
                handler(false)
            }
        })
    }
}

//MARK: Update methods
private extension DownloadManager{
    
    func updateFileWithDefaultFormat(forLanguageCode code : String, andData data : Data, withCompletionHandler handler : @escaping (_ success : Bool)->()){
        debugPrint("Updation start time : \(Date())")
        if let serverData : [String : String] = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : String]{
            if var localDic : [String : String] = NSKeyedUnarchiver.unarchiveObject(withFile: DirectoryManager.getLangaugePath(forLanguageCode: code) + "/" + Constants.C_LOCALIZABLE_STRINGS) as? [String : String]{
                for (key,value) in serverData{
                    localDic[key] = value
                }
                if localDic.count > 0 {
                    self.saveLanguageFile(forLanuageCode: code, andDict: localDic, withCompletionHandler: { (success) in
                        handler(success)
                        debugPrint("Updation end time (strings) : \(Date())")
                    })
                }else{
                    handler(false)
                }
            }else{
                handler(false)
            }
        }else{
            handler(false)
        }
    }
    
    func updateFileWithJsonFormat(forLanguageCode code : String, andData data : Data, withCompletionHandler handler : @escaping (_ success : Bool)->()){
        debugPrint("Updation start time : \(Date())")
        do{
            /* Base v2 implementation - STARTS HERE */
            var originalCode : String = code
            if code == Constants.C_BASE || code == Constants.C_BASE_V2 { originalCode = Constants.C_EN }
            /* Base v2 implementation - ENDS HERE */
            if let responseData : [String : Any] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any], let jsonData = responseData["\(originalCode)-IN"] as? [[String : Any]] {
                if var localDic : [String : String] = NSKeyedUnarchiver.unarchiveObject(withFile: DirectoryManager.getLangaugePath(forLanguageCode: code) + "/" + Constants.C_LOCALIZABLE_STRINGS) as? [String : String]{
                    for dic in jsonData{
                        if let key = dic["key"] as? String, let message = dic["message"] as? String{
                            localDic[key] = message
                        }
                    }
                    if localDic.count > 0 {
                        self.saveLanguageFile(forLanuageCode: code, andDict: localDic, withCompletionHandler: { (success) in
                            handler(success)
                            debugPrint("Updation end time (json) : \(Date())")
                        })
                    }else{
                        handler(false)
                    }
                }else{
                    handler(false)
                }
            }else{
                handler(false)
            }
        }catch{
            handler(false)
        }
    }
    
}

//TODO: Supported languages
extension DownloadManager{
    
    func downloadAndStoreSupportedLanguages(withRequestTuple requestTuple: JRLocalizationRequestTuple, andCompletionHandler completion : @escaping (_ success : Bool)->()){
        SessionServiceManager().sendRequest(requestTuple: requestTuple, withCompletionHandler: { [weak self] (success, data) in
            if success, let data = data{
                if let array = self?.ParseSupportedLanguage(ForJsonData: data){
                    DirectoryManager.saveLanguagePlistFile(fileData: array, withCompletionHandler: { (success) in
                        completion(success)
                    })
                }else{
                    let english : JRLocale = JRLocale.init(languageCode: Constants.C_EN, countryCode: "IN", name: "English")
                    let resultArr : NSMutableArray = NSMutableArray.init()
                    resultArr.add(english.getDictionary())
                    DirectoryManager.saveLanguagePlistFile(fileData: resultArr, withCompletionHandler: { (success) in
                        completion(false)
                    })
                }
            }else{
                completion(false)
            }
        }) { (dataTask) in
            
        }
    }
    
    func initlializeLanguageListWithDummyDataOnStartup(withCompletionnHandler completion : @escaping ()->()){
        if(DirectoryManager.checkIfLanguagePlistExist()){
            completion()
        }else{
            let english : JRLocale = JRLocale.init(languageCode: Constants.C_EN, countryCode: "IN", name: "English")
            let resultArr : NSMutableArray = NSMutableArray.init()
            resultArr.add(english.getDictionary())
            DirectoryManager.saveLanguagePlistFile(fileData: resultArr, withCompletionHandler: { (success) in
                debugPrint("Language list initialized with dummy data")
                completion()
            })
        }
    }
    
    private func ParseSupportedLanguage(ForJsonData data : Data)-> NSMutableArray?{
        do{
            let resultArray : NSMutableArray = NSMutableArray.init()
            
            if let dic : [String : String] = try JSONSerialization.jsonObject(with: data, options: []) as? [String : String]{
                /* This is done to maintain an order sequence at front-end side, which has to be:
                    - English, Hindi, Bangla, Telugu, Marathi, Tamil, Gujrati, Kannada, Malayalam, Punjabi, Odia
                    - Needs to be reverted once resolved from the backend.
                */
                if !dic.keys.contains("en"), let val = dic["en-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "en", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("hi"), let val = dic["hi-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "hi", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("bn"), let val = dic["bn-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "bn", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("te"), let val = dic["te-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "te", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("mr"), let val = dic["mr-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "mr", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("ta"), let val = dic["ta-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "ta", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("gu"), let val = dic["gu-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "gu", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("kn"), let val = dic["kn-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "kn", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("ml"), let val = dic["ml-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "ml", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("pa"), let val = dic["pa-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "pa", countryCode: "IN", name: val).getDictionary())
                }
                if !dic.keys.contains("or"), let _ = dic["or-IN"] {
                    resultArray.add(JRLocale.init(languageCode: "or", countryCode: "IN", name: "Odia").getDictionary()) // 'Odia' has to be hardcoded, since backend is sending 'Oriya'
                }

                for (key,value) in dic{
                    if key != "en-IN", key != "hi-IN", key != "bn-IN", key != "te-IN", key != "mr-IN", key != "ta-IN", key != "gu-IN", key != "kn-IN", key != "ml-IN", key != "pa-IN", key != "or-IN" {
                        resultArray.add(JRLocale.init(languageCode: key.components(separatedBy: "-")[0], countryCode: "IN", name: value).getDictionary())
                    }
                }
            }
            return resultArray
        }catch{}
        return nil
    }
    
}
