//
//  JRInterpretDataUtility.swift
//  Jarvis
//
//  Created by Shwetabh Singh on 26/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

extension Data {
    func jsonData() -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [.allowFragments, .mutableContainers])
            return json
        } catch _ {
            return self
        }
    }
    
    func objectData<T:Codable>() -> (T?, Error?) {
        do {
            let responseObject = try T.self.decode(from: self)
            return (responseObject, nil)
        }
        catch let error {
            return (nil, error)
        }
    }

}

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension Dictionary where Key == String, Value == Any {
    func stringWithKeyValuePairsAsGETParams() -> String {
        
        var arguments = [String]()
        for (key, value) in self {
            arguments.append(("\(key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")=\((value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"))
        }
        return arguments.joined(separator: "&")
    }
    
    func getOptionalDictionaryKey(key:Key) -> [String: Any]? {
        if let y = self[key] as? [String: Any] {
            return y
        }
        return nil
    }
}

extension URL {
    func append(params: [String : Any])-> URL? {
        
        guard !params.isEmpty, var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        var queryItems = [URLQueryItem]()
        if let previousQueryItems = components.queryItems {
            queryItems.append(contentsOf: previousQueryItems)
        }
        for (key, value) in params {
            var queryItem: URLQueryItem
            if value is Int {
                queryItem = URLQueryItem(name: key, value: String(value as! Int))
            } else if value is String {
                queryItem = URLQueryItem(name: key, value: (value as! String))
            } else {
                continue
            }
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
        return components.url
        
    }
}

extension String {
    /// Returns a percent encoded string
    var percentEncodedString: String {
        let charSet = CharacterSet.init(charactersIn: "!*'\"();:@&=+$,/?%#[]% ").inverted
        return self.addingPercentEncoding(withAllowedCharacters: charSet) ?? ""
    }
}

extension UIApplication {
    public class func topVC(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topVC(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topVC(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topVC(base: presented)
        }
        return base
    }
}
