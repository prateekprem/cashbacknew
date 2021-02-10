//
//  Ext_URL.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

public extension URL {
    
    /**
     Add, update, or remove a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     - parameter value: the value to replace the query string parameter, nil will remove item
     
     - returns: the URL with the mutated query string
     */
    func appendingQueryItem(_ name: String, value: Any?) -> String {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteString
        }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { $0.name.lowercased() != name.lowercased() } ?? []
        
        // Skip if nil value
        if let value = value {
            urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
        }
        
        return urlComponents.string ?? absoluteString
    }
    
    /**
     Add, update, or remove a query string parameters from the URL
     
     - parameter url:   the URL
     - parameter values: the dictionary of query string parameters to replace
     
     - returns: the URL with the mutated query string
     */
    func appendingQueryItems(_ contentsOf: [String: Any?]) -> String {
        guard var urlComponents = URLComponents(string: absoluteString), !contentsOf.isEmpty else {
            return absoluteString
        }
        
        let keys = contentsOf.keys.map { $0.lowercased() }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { !keys.contains($0.name.lowercased()) } ?? []
        
        urlComponents.queryItems?.append(contentsOf: contentsOf.compactMap {
            guard let value = $0.value else { return nil } //Skip if nil
            return URLQueryItem(name: $0.key, value: "\(value)")
        })
        
        return urlComponents.string ?? absoluteString
    }
    
    /**
     Removes a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     
     - returns: the URL with the mutated query string
     */
    func removeQueryItem(_ name: String) -> String {
        return appendingQueryItem(name, value: nil)
    }
    
    static func getUrlWithParam(url: String, params: [String : String]?)-> URL? {
        var components = URLComponents(string: url)
        if let params = params {
            var queryItems = [URLQueryItem]()
            if let previousQueryItems = components?.queryItems {
                queryItems.append(contentsOf: previousQueryItems)
            }
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
            components?.queryItems = queryItems
        }
        return components?.url
    }
    
    var queryItemsDictionary: [String: String]? {
        
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return nil
        }
        
        var queryItemsDictionary = [String: String]()
        queryItems.forEach { queryItemsDictionary[$0.name] = $0.value }
        return queryItemsDictionary
    }
    
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }

}
