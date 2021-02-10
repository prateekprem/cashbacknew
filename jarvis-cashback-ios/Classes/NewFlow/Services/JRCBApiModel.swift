//
//  JRCBApiModel.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 15/04/20.
//

import UIKit
import jarvis_network_ios // for JRCBApiModel

public typealias JRCBJSONDictionary = [String: Any]

public class JRCBApiBaseModel {
    private(set) var apiType: JRCBApiType
    public private(set) var param: JRCBJSONDictionary?
    public private(set) var body : Any?
    public private(set) var apiUrlString: String?
    public private(set) var reqMethod: RequestMethodType  = .get
    
    public var apiHeader: [String: String]? {
        return apiType.header
    }
    
    init(type:JRCBApiType, param: JRCBJSONDictionary?,
         body : Any? = nil, appendUrlExt: String) {
         self.apiType = type
         self.apiUrlString = type.urlStrWith()
        
        if !JRCashbackManager.shared.shouldMock {
            self.param   = param
            self.body    = body
            if appendUrlExt.count > 0 {
                self.apiUrlString = type.urlStrWith(appendExt: appendUrlExt)
            }
            
            if type == .pathPostTxnStoreFrontUrl {
                self.apiUrlString = JRCBCommonBridge.urlByAppendingDefaultParam(urlStr: self.apiUrlString)
            }
            
            self.reqMethod = type.reqMethod
        }
    }
    
    public func update(urlString: String) {
        self.apiUrlString = urlString
    }
    
    public func update(method: RequestMethodType) {
        self.reqMethod = method
    }
}


public class JRCBApiModel: JRCBApiBaseModel {
    public private(set) var encodingStyle = JRBodyEncodingStyle.jsonEncoded // try this private
    public private(set) var dType: JRDataType = .Json
    
    var bodyEncoding: JRParameterEncoding {
        return JRParameterEncoding.urlAndJsonEncoding(bodyEncodingStyle: self.encodingStyle)
    }
    
    override init(type:JRCBApiType, param: JRCBJSONDictionary?,
         body : Any? = nil, appendUrlExt: String) {
        super.init(type: type, param: param, body:body, appendUrlExt: appendUrlExt)
        self.dType = type.dataType
    }
    

    func update(dataType: JRDataType) {
        self.dType = dataType
    }
    
    func updateEncoding(style: JRBodyEncodingStyle) {
        self.encodingStyle = style
    }
}


public class JRCBError: Error {
    public private(set) var title: String?
    public private(set) var message: String?
    public private(set) var anError: Error?
    
    public func localisedDesc() -> String {
        if let aMsg = message { return aMsg }
        return self.localizedDescription
    }
    
    class var defaultError: JRCBError {
        return JRCBError(aTitle: "jr_co_default_msg_title".localized, aMessage: "jr_co_default_msg".localized)
    }
    
    class var networkError: JRCBError {
        return JRCBError(aTitle: "jr_co_default_msg_title".localized, aMessage: "jr_ac_noInternetMsg".localized)
    }
    
    init(aTitle: String?, aMessage: String?) {
        self.title = aTitle
        self.message = aMessage
    }
    
    init(err: Error) {
        self.anError = err
        self.message = err.localizedDescription
    }
}
