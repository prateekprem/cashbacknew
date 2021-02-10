//
//  JRTagServiceManager.swift
//  JRTagManagerDemo
//
//  Created by nasib ali on 01/08/19.
//  Copyright © 2019 nasib ali. All rights reserved.
//

import Foundation

extension Array {
    func toDictionary<K:Hashable, V>(transform:(_ element: Iterator.Element) -> (key:K, value:V)) -> [K : V] {
        return self.reduce(into: [K : V]()) { (accu, current) in
            let kvp = transform(current)
            accu[kvp.key] = kvp.value
        }
    }
}

class JRAppManagerServices {
    
    private class func header(for auth: String) -> [String: String] {
        var headers: [String: String] = [String: String]()
        headers["AUTHORIZATION_VALUE"] = auth
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    class func callTagApi(_ requestConfig: JRAppManagerConfigurator, quaryParams: String, completionHandler:((Any?)-> Void)?) {
        let url = requestConfig.baseURL + "?" + quaryParams
        JRAppManagerDataInteractor.loadAppManager(url, header(for: requestConfig.authKey)) { (data, response, error) in
            parseResponse(data, completionHandler: completionHandler)
        }
    }
    
    class func parseResponse(_ data: Any?, completionHandler:((Any?)-> Void)?) {
        guard let dataDic = data as? [String: Any], let status = dataDic[ConstantKeys.status] as? Int, status == 200 else {
            completionHandler?(nil)
            return
        }
        
        if  let response = dataDic[ConstantKeys.response] as?  [String: Any]  {
            completionHandler?(parseInAcceptable(response))
        }
    }
    
    class func convertArrayInDic(_ array: [[String: Any]]) -> [String: Any] {
        
        let dic: [String: Any] = array.toDictionary { item in
            guard let key = item[ConstantKeys.key] as? String, let value = item[ConstantKeys.value] else {
                return ("", "")
            }
            return  (key, value)
            }
        return dic as [String: Any]
    }
    
    class func parseInAcceptable(_ requestDic: [String: Any]?) -> [String: Any] {

        var dic = [String: Any]()
        dic[ConstantKeys.metaData] = requestDic?[ConstantKeys.metaData]
        if let tempData = requestDic?[ConstantKeys.list] as? [[String: Any]] {
            dic[ConstantKeys.list] = convertArrayInDic(tempData)
        }
        
        if let deletedData = requestDic?[ConstantKeys.deletedList] as? [[String: Any]] {
            dic[ConstantKeys.deletedList] = convertArrayInDic(deletedData)
        }
        return dic
    }
}
