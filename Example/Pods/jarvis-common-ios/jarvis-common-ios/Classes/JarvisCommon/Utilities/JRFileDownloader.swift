//
//  JRFileDownloader.swift
//  Jarvis
//
//  Created by Ayush Goel on 03/11/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit

open class JRFileDownloader: NSObject
{
    @objc open class func loadFileAsync(_ url: URL, completion:@escaping (_ data:Data?, _ error:NSError?) -> Void)
    {
        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request: URLRequest = URLRequest(url: url)
        if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
            request.addValue(ssoToken, forHTTPHeaderField: "sso_token")
        }
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                if let response = response as? HTTPURLResponse
                {
                    if response.statusCode == 200
                    {
                        completion(data, nil)
                        return
                    }
                }
            }
            
            completion(nil, error as NSError?)
        })
        
        task.resume()
    }}
