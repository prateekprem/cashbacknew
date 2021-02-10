
//
//  JROAuthSeedGenerator.swift
//  jarvis-auth-ios
//
//  Created by Alok Chaturvedi on 11/05/20.
//

import Foundation

let KEY_CLIENT_SIGNATURE = "x-client-signature"
let KEY_DEVICE_IDENTIFIER = "x-device-identifier"
let KEY_DEVICE_MANUFACTURER = "x-device-manufacturer"
let KEY_DEVICE_NAME = "x-device-name"
let KEY_PUBLIC_KEY = "x-public-key"
let KEY_EPOCH = "x-epoch"
let KEY_LATITUDE = "x-latitude"
let KEY_LONGITUDE = "x-longitude"
let KEY_AUTHORIZATION = "Authorization"
let KEY_SSOTOKEN = "session_token"

public class JROAuthSeedGenerator: NSObject {
    
    private let allowedHeaderForSignature = [KEY_AUTHORIZATION, KEY_PUBLIC_KEY, KEY_EPOCH, KEY_LATITUDE,
                                             KEY_LONGITUDE,KEY_DEVICE_IDENTIFIER,
                                             KEY_DEVICE_MANUFACTURER,KEY_DEVICE_NAME,KEY_SSOTOKEN]
    
     /**
     * Function to generate and add client signature in headers in every oauth request with **key=x-client-signature**.\
     * @param urlWithParams Complete url with query params
     * @param httpMethod HTTP method type  (POST, PUT, GET, DELETE, PATCH)
     * @param headers Headers which are being passed in request
     * @param requestBody JSON request body as a string
     */
    public func addClientSignatureInHeaders(url: String, httpMethod: String, headers: [String:String], requestBody: String?) -> [String:String] {
        
        let nsurl = URL(string:url)
        let defaultParams = nsurl?.queryDictionary
        let uri = nsurl?.path
        
        // Sort query params alphabetically
        let sortedDic = defaultParams?.sorted { (aDic, bDic) -> Bool in
            return aDic.key < bDic.key
        }
        
        let urlParams = sortedDic?.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        
        let headersKeys = headers.keys
        var commonKeys: [String] = commonElements(headersKeys, allowedHeaderForSignature)
        commonKeys = commonKeys.sorted()
        
        // Sort headers alphabetically
        var headersString: String = ""
        for (index, element) in commonKeys.enumerated() {
            if let value = headers[element] {
                if index > 0 {
                    headersString +=  "&\(element)=\(value)"
                }
                else{
                    headersString +=  "\(element)=\(value)"
                }
            }
        }
        
        // Generate seed string
        var seedString = "\(uri ?? "")|\(httpMethod)|\(urlParams ?? "")|\(headersString)"
        if let body = requestBody, body.count > 2 {
            seedString += "|\(body)"
        }
        else{
            seedString += "|"
        }
        
        // Convert seed string to lowercase and use regex to remove all whitespaces, hidden characters from entire string
        seedString = seedString.lowercased()
        seedString = seedString.replacingOccurrences(of: "[^\\x00-\\x7F]|[\\p{Cntrl}&&[^\n\t]]|\\p{C}|\\s+",
                                                     with: "",
                                                     options: .regularExpression)
        // Add signed seed string in headers
        var headersWithSeeds = headers

        let signature = AuthRSAGenerator.shared.signWithPrivateKey(seedString: seedString)
        headersWithSeeds[KEY_CLIENT_SIGNATURE] = signature
        
        return headersWithSeeds
    }
    
   private func commonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> [T.Iterator.Element]
        where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
            var common: [T.Iterator.Element] = []
            
            for lhsItem in lhs {
                for rhsItem in rhs {
                    if lhsItem == rhsItem {
                        common.append(lhsItem)
                    }
                }
            }
            return common
    }
}

 extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

extension JROAuthSeedGenerator{
    
    struct TestError: Error {
        let description: String
    }
    
    static public func privateKey(name: String) throws -> PrivateKey {
        let bundle = Bundle(for: JRAuthManager.self)
        guard let path = bundle.path(forResource: name, ofType: "pem") else {
            throw TestError(description: "Couldn't load key for provided path")
        }
        let pemString = try String(contentsOf: URL(fileURLWithPath: path))
        return try PrivateKey(pemEncoded: pemString)
    }
}
