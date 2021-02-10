//
//  JRCBServiceManager.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 25/12/19.
//

import Foundation
import jarvis_network_ios

typealias JRCBServiceCompletion = (_ sucess: Bool, _ response: [String: Any]?, _ error: Error?) -> Swift.Void
public typealias JRCBServiceBlock = (_ sucess: Bool, _ response: Any?, _ error: Error?) -> Swift.Void // this should be used

class JRCBServiceManager {
    
    // depricate this
    class func execute(apiModel: JRCBApiModel, completion: @escaping JRCBServiceCompletion) {
        JRCBServiceManager.executeAPI(model: apiModel) { (sucess, response, error) in
            completion(sucess, response as? [String : Any], error)
        }
    }
    
    class func executeAPI(model: JRCBApiModel, isJson: Bool = true, completion: @escaping JRCBServiceBlock) {
        JRCBServiceManager.executeAPI(type: JRDataType.self, model: model, isJson: isJson, completion: completion)
    }
    
    class func executeAPI<T: Codable>(type: T.Type?, model: JRCBApiModel, isJson: Bool = true, completion: @escaping JRCBServiceBlock) {
        if let delegate = JRCashbackManager.shared.cashbackDelegate {
            delegate.executeAPI(type: type, model: model, isJson: isJson, completion: completion)
        } else {
            JRCBServiceManager.hitAPI(type: type, model: model,isJson:isJson, completion: completion)
        }
    }
     
    // this func should not be called directly, might skip the delegation...
    class func hitAPI<T: Codable>(type: T.Type?, model: JRCBApiModel, isJson: Bool = true, completion: @escaping JRCBServiceBlock) {
        let hRequest = JRCBServiceRequest.cashbackApi(apiModel: model)
        let router = JRRouter<JRCBServiceRequest>()
        router.request(type: type, hRequest) { (data, response, error) in
            // process response
            JRCBServiceManager.process(data: data, response: response, error: error, inJson: isJson, completion: completion)
        }
    }
    
    private class func process(data: Any?, response: URLResponse?, error: Error?, inJson: Bool, completion: JRCBServiceBlock?) {
        guard let block = completion else { return }
        
        let isResp = data != nil
        if isResp { print(data!) }
        
        if inJson {
            if let mResp = data as? [String: Any] {
                block(isResp, mResp, error)
                
            } else if let mResp = data {
                block(isResp, ["data": mResp], error) // must check this should not be the case
                
            } else {
                block(isResp, nil, error)
            }
            
        } else if let err = error {
            block(isResp, data, err)
            
        } else {
            block(isResp, data, JRCBServiceManager.genericError)
        }
    }
}


extension JRCBServiceManager {
    class var genericError : NSError {
        let failTitle = "jr_co_default_msg_title".localized
        let failMessage = "jr_co_default_msg".localized
        
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: failTitle,
                                                            NSLocalizedDescriptionKey: failMessage])
        return error
    }
    
    class var genericCustomError: JRCBCustomErrorModel {
        return JRCBCustomErrorModel(title: "jr_co_default_msg_title".localized, message: "jr_co_default_msg".localized)
    }
}
