//
//  JRAppManagerDataInteractor.swift
//  jarvis-common-ios
//
//  Created by Nasib Ali on 13/11/19.
//

import Foundation

public enum JRAppManagerError : String, Error {
    case urlEncodingFailed = "URL encoding failed."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

class JRAppManagerDataInteractor {
    
    class func loadAppManager(_ url: String, _ headers: [String: String], completionHandler: @escaping ((_ data: Any?,_ response: URLResponse?,_ error: Error?)->Void)) {
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        do {
            let request = try self.buildRequest(url, with: headers)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                do {
                    if let data = data {
                        let data = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers])
                        completionHandler(data, response, error)
                    }else{
                        completionHandler(nil, response, error)
                    }
                }catch{
                    completionHandler(nil, response, error)
                }
            }
            task.resume()
        }catch{
            completionHandler(nil, nil, error)
        }
    }
    
    class func url(from str: String) throws -> URL {
        do {
            guard let url = URL.init(string: str) else {
                throw JRAppManagerError.urlEncodingFailed
            }
            return url
        } catch {
            throw error
        }
    }
    
    class func buildRequest(_ url: String, with headers: [String: String]) throws -> URLRequest {
        
        do {
            let url = try self.url(from: url)
            var request = URLRequest(url: url)
            self.add(headers, in: &request)
            return request
        } catch {
            throw error
        }
    }
    
    class func add(_ headers: [String: String], in request: inout URLRequest) {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
