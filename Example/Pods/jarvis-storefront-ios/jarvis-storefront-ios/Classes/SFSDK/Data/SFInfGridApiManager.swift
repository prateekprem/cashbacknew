//
//  SFInfGridApiManager.swift
//  jarvis-locale-ios
//
//  Created by Brammanand Soni on 23/10/19.
//

import Foundation
import jarvis_utility_ios

public typealias gridServiceCompletionHandler = (_ result: Any?, _ error: Error?) -> Void

public class SFInfGridApiManager {

    public static let sharedInstance: SFInfGridApiManager = SFInfGridApiManager()
    
    private init() {
    }
    
    public func fetchGridVariants(_ item: SFLayoutItem,parentItem: SFLayoutItem , completionHandler: gridServiceCompletionHandler?) {
        guard let variantUrl =  parentItem.gridLayout?.getVariantUrlToHit(), let _: URL = URL(string: variantUrl) else {
            completionHandler?(nil, nil)
            return
        }
        var bodyParam: [String: Any] =  [String: Any]()
        var productArr = [[String:Any]]()
        var groupDict = [String:Any]()
        if let parentID = item.parentId {
            groupDict["group_id"] = parentID
        }
        productArr.append(groupDict)
        bodyParam["products"] = productArr
        
        fetch(variantUrl, method: "POST", headers: nil, bodyParams: bodyParam, completionHandler: { (result, error) in
            if error == nil, let json = result as? [String: Any] {
                let gridParser: SFGridLayoutParser = SFGridLayoutParser(json)
                item.gridLayout = gridParser
                
                let noOfItemsInARow: Int = gridParser.viewType.getNumberOfItemInACell()
                if !gridParser.items.isEmpty {
                    if item.gridItems.isEmpty || item.gridItems.last!.count == noOfItemsInARow {
                        let chunkedItem: [[SFLayoutItem]] = gridParser.items.chunked(into: noOfItemsInARow)
                        item.gridItems.append(contentsOf: chunkedItem)
                    }
                    else {
                        let noOfVacantSpace: Int = noOfItemsInARow - item.gridItems.last!.count
                        if noOfVacantSpace > 0 {
                            for _ in 0..<noOfVacantSpace {
                                if let _ = gridParser.items.first {
                                    item.gridItems[item.gridItems.count - 1].append(gridParser.items.removeFirst())
                                }
                            }
                        }
                        
                        let chunkedItem: [[SFLayoutItem]] = gridParser.items.chunked(into: noOfItemsInARow)
                        item.gridItems.append(contentsOf: chunkedItem)
                    }
                }
            }
            completionHandler?(result, error)
        })
        
    }
    
    public func fetchInfiniteGrid(_ item: SFLayoutItem,includePageCount: Bool = true, completionHandler: gridServiceCompletionHandler?) {
        guard let url: URL = URL(string: item.itemSeoUrl) else {
            completionHandler?(nil, nil)
            return
        }
        
        let completeContextDetails = SFManager.shared.interactor?.getCompleteAppContext()
        // QueryParam
        var queryParam: [String: Any] = [String:Any]()
        if includePageCount {
           queryParam["page_count"] = "\(item.gridItemPageCount)"
            queryParam["items_per_page"] = "16"
        }
        
        if let userId = completeContextDetails?["user_id"] as? String {
            queryParam["user_id"] = userId
        }
        let urlByAppendingParams = url.appendingQueryItems(queryParam)
        
        //Headers
        var headers: [String: String]?
        if let ssoToken = completeContextDetails?["sso_token"] as? String {
            headers = [String: String]()
            headers?["sso_token"] = ssoToken
        }
        
        // Body param
        var bodyParam: [String: Any]?
        if urlByAppendingParams.contain(subStr: "api_type=re") {
            bodyParam = SFManager.shared.interactor?.getRecmendedBodyDetail() ?? [String: Any]()
            if let queryDict = url.queryItemsDictionary, let currentPage = queryDict["current_page"] {
                bodyParam?["custom"] = ["current_page": currentPage]
            }
            else {
                bodyParam?["custom"] = ["current_page": "grid"]
            }
        }
        else {
            bodyParam = SFManager.shared.interactor?.getBodyDetail()
        }
        
        item.isGridItemLoading = true
        fetch(urlByAppendingParams, method: "POST", headers: headers, bodyParams: bodyParam, completionHandler: { (result, error) in
            if error == nil, var json = result as? [String: Any] {
                item.gridItemPageCount = item.gridItemPageCount + 1
                json["offline"] = item.isOfflineFlow
                let gridParser: SFGridLayoutParser = SFGridLayoutParser(json)
                gridParser.parentUrlString = urlByAppendingParams
                item.gridLayout = gridParser
                
                let noOfItemsInARow: Int = gridParser.viewType.getNumberOfItemInACell()
                if !gridParser.items.isEmpty {
                    if item.gridItems.isEmpty || item.gridItems.last!.count == noOfItemsInARow {
                        let chunkedItem: [[SFLayoutItem]] = gridParser.items.chunked(into: noOfItemsInARow)
                        item.gridItems.append(contentsOf: chunkedItem)
                    }
                    else {
                        let noOfVacantSpace: Int = noOfItemsInARow - item.gridItems.last!.count
                        if noOfVacantSpace > 0 {
                            for _ in 0..<noOfVacantSpace {
                                if let _ = gridParser.items.first {
                                    item.gridItems[item.gridItems.count - 1].append(gridParser.items.removeFirst())
                                }
                            }
                        }
                        
                        let chunkedItem: [[SFLayoutItem]] = gridParser.items.chunked(into: noOfItemsInARow)
                        item.gridItems.append(contentsOf: chunkedItem)
                    }
                }
            }
            
            completionHandler?(result, error)
        })
    }
    
    func fetch(_ urlString: String, method: String, headers: [String : String]?, bodyParams: [String : Any]?, completionHandler: @escaping (Any?, Error?) -> Void) {
        guard let urlByAppendingParams = SFManager.shared.interactor?.urlByAppendingDefaultParams(urlString), let url: URL = URL(string: urlByAppendingParams) else {
            completionHandler(nil, nil)
            return
        }
        
        // TODO: Need to change request calling if required?
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let additionalHeaders = headers {
            for (key, value) in additionalHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let params = bodyParams{
            var data: Data?
            do {
                data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.httpBody = data
            }
            catch {}
        }
        
        
        let session: URLSession = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil, let jsonData = data else {
                    completionHandler(nil, error)
                    return
                }
                
                if let response: HTTPURLResponse = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any]
                        completionHandler(jsonDict, nil)
                    }
                    catch {
                        let error: NSError = NSError(domain: "JSON parsing error", code: 0, userInfo: nil)
                        completionHandler(nil, error)
                    }
                }
                else {
                    let error: NSError = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong. Please try after some time"])
                    completionHandler(nil, error)
                }
            }
            }.resume()
    }
}
