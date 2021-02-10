//
//  JRTag.swift
//  JRTagManagerDemo
//
//  Created by nasib ali on 05/08/19.
//  Copyright © 2019 nasib ali. All rights reserved.
//

import Foundation

class JRAppManagerContainer {
    
    private lazy var group: DispatchGroup = DispatchGroup()
    private var container: JRThreadedDictionary<String, Any>?
    private var metaData = [String: Any]() {
        didSet{
            pageNumber = 1
        }
    }
    private var apiCallInProcess: Bool = false
    private var pageNumber: Int = 1 {
        didSet {
            if oldValue < pageNumber {
                self.fetchRemoteTag(repeatApi: true)
            }
        }
    }
    
    var configurator: JRAppManagerConfigurator
    
    private var tagJSON: [String : Any] {
        
        var containerJSON: [String : Any] = [String : Any]()
        containerJSON[ConstantKeys.list] = container?.unthreaded
        containerJSON[ConstantKeys.metaData] = metaData
        return containerJSON
    }
    
    private var version: Int {
        return metaData.getString(ConstantKeys.currentVersion).intValue
    }
    
    private var hasNext: Bool {
        if let value = metaData.getString(ConstantKeys.hasNext).boolValue {
            return value
        }
        return false
    }
    
    private var intervalTime: Int {
        if let str = container?.getOptionalString(ConstantKeys.intervalTime) {
            return str.intValue
        }
        return 0
    }
    
    private var shouldHitAPI: Bool {
        if let storedTime = UserDefaults.standard.value(forKey: ConstantKeys.lastApiCallTime) as? Date {
            let diff: Int = Int(Date().timeIntervalSince(storedTime)) * 1000
            let timeInterval: Int = intervalTime
            return diff >= timeInterval
        }
        return true
    }
    
    init(with configurator: JRAppManagerConfigurator) {
        
        self.configurator = configurator
        NotificationCenter.default.addObserver(self, selector: #selector(fetchRemoteTag),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    
    private func updateContainer(with data: [String: Any], completionHandler: (()-> Void)?) {
        
        let deleteDic = data[ConstantKeys.deletedList] as? [String: Any]
        if let dataDic = data[ConstantKeys.list] as? [String: Any], let metaDataDic = data[ConstantKeys.metaData] as? [String: Any] {
            
            if container == nil {
                container = JRThreadedDictionary(dataDic, type: .concurrent)
            }else{
                dataDic.forEach { (key, value) in
                    container?[key] = value
                }
            }
            
            completionHandler?()
            
            if let deletedKey = deleteDic {
                deletedKey.forEach { (key, value) in
                    container?[key] = nil
                }
            }
            
            if metaDataDic.getString(ConstantKeys.hasNext).boolValue == true {
                pageNumber += 1
                updateLastApiCall(isRemoved: true)
            }else{
                metaData = metaDataDic
            }
            
            JRAppManagerFileManager.updateLocalData(tagJSON, of: configurator.localFileName, completionHandler: nil)
        }else{
            completionHandler?()
        }
    }
    
    @objc private func fetchRemoteTag(repeatApi: Bool = false) {
        
        if !(repeatApi || shouldHitAPI) || apiCallInProcess { return }
        
        self.apiCallInProcess = true
        let queryParam: String = "version=\(self.version)&pageno=\(pageNumber)&pagesize=\(200)&namespace=\(configurator.nameSpace)"
        
        JRAppManagerServices.callTagApi(configurator, quaryParams: queryParam) { [weak self] data in
            
            self?.apiCallInProcess = false
            self?.updateLastApiCall()
            if let dataDic = data as? [String: Any], dataDic.count > 0 {
                self?.updateContainer(with: dataDic, completionHandler: nil)
            }
        }
    }
    
    private func updateLastApiCall(isRemoved: Bool = false) {
        
        let userDefault = UserDefaults.standard
        if isRemoved {
            userDefault.removeObject(forKey: ConstantKeys.lastApiCallTime)
        }else{
            userDefault.set(Date(), forKey: ConstantKeys.lastApiCallTime)
        }
        userDefault.synchronize()
    }
    
    func getValue(_ key: String) -> String? {
        return container?.getOptionalString(key)
    }
}

//public interface for tag container
extension JRAppManagerContainer {
    
    func stringValue(forKey key: String) -> String? {
        return getValue(key)
    }
    
    func boolValue(forKey key: String) -> Bool? {
        return getValue(key)?.boolValue
    }
    
    func doubleValue(forKey key: String) -> Double? {
        return getValue(key)?.doubleValue
    }
    
    func intValue(forKey key: String) -> Int? {
        return getValue(key)?.intValue
    }
    
    func checkAndSyncTags(completionHandler: (()-> Void)?) {
        
        JRAppManagerFileManager.syncLocalData(fileName: configurator.localFileName) { [weak self] data in
            self?.group.enter()
            if let dataDic = data {
                self?.updateContainer(with: dataDic) {
                    self?.group.leave()
                }
            }else{
                self?.group.leave()
            }
        }
        
        group.notify(queue: .global()) { [weak self] in
            completionHandler?()
            self?.fetchRemoteTag()
        }
    }
    
    func update(_ value: String, for key: String, handler: (() -> Void)? = nil) {
        container?[key] = value
        JRAppManagerFileManager.updateLocalData(tagJSON,
                                                of: configurator.localFileName, completionHandler: nil)
        handler?()
    }
}

extension String {
    
    var boolValue: Bool? {
        switch self {
        case "TRUE", "YES", "1", "SUCCESS", "true":
            return true
        case "FALSE", "NO", "0", "FAIL", "false":
            return false
        default:
            return nil
        }
    }
    
    var intValue: Int {
        if let value = Int(self) {
            return value
        }
        return 0
    }
    
    var doubleValue: Double {
        if let value = Double(self) {
            return value
        }
        return 0
    }
}
