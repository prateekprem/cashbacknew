//
//  JRPCRewardVM.swift
//  Jarvis
//
//  Created by Pankaj Singh on 27/01/20.
//  Copyright © 2020 One97. All rights reserved.
//

import Foundation
import jarvis_network_ios
import jarvis_utility_ios

// MARK: - JRPCRewardVM

class JRPCRewardVM {
    
    var coinsBalance: String = JRPCConstants.kPCInvalidCoinBalance
    var rewards: [JRPCRewardsModel] = []
    var orderId: String?
    
    typealias completionType = (Error?) -> Void
    
    func fetchCoinBalance(data: (String , [String: Any]), completion: @escaping completionType) {
        let request = JRPaytmCoinsAPI.fetchBalance(url: data.0, bodyParam: data.1)
        let router = JRRouter<JRPaytmCoinsAPI>()
        router.request(type: JRDataType.self, request) { [weak self] (responseObject , response, error) in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(JRPCNetworkHandler.requestNotValid())
                }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
            } else {
                guard let responseData = responseObject as? Data else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.fetchBalanceError())
                    }
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.fetchBalanceError())
                    }
                    return
                }
                
                switch statusCode {
                case 200:
                    self.processFetchBalanceResponse(responseData, completion)
                default:
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.fetchBalanceError())
                    }
                }
                
            }
        }
    }
    
    private func processFetchBalanceResponse(_ data: Data, _ completion: @escaping completionType) {
        do {
            let decoder = JSONDecoder()
            let fetchBalanceModel = try decoder.decode(JRPPTransactionListModel.self, from: data)
            if fetchBalanceModel.response?.result?.resultStatus == JRPPTransactionAPIStatus.success.rawValue {
                self.coinsBalance = fetchBalanceModel.response?.activeBalance?.value ?? JRPCConstants.kPCInvalidCoinBalance
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                if let resultMsg = fetchBalanceModel.response?.result?.resultMsg {
                    DispatchQueue.main.async {
                        completion(NSError(domain: resultMsg, code: JRPCConstants.kPCErrorMessageCode,
                                           userInfo: ["NSLocalizedDescription": resultMsg]))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                }
            }
        } catch let error {
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func fetchRewards(data: (String , [String: Any]), completion: @escaping completionType) {
        let request = JRPaytmCoinsAPI.getRewardsList(url: data.0, bodyParam: data.1)
        let router = JRRouter<JRPaytmCoinsAPI>()
        router.request(type: JRDataType.self, request) { [weak self] (responseObject , response, error) in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(JRPCNetworkHandler.requestNotValid())
                }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
            } else {
                guard let responseData = responseObject as? Data else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                    return
                }
                switch statusCode {
                case 200:
                    self.processFetchRewardsResponse(responseData, completion)
                default:
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                }
                
            }
        }
    }
    
    private func processFetchRewardsResponse(_ data: Data, _ completion: @escaping completionType) {
        do {
            let decoder = JSONDecoder()
            let rewardsModel = try decoder.decode(JRPCRewardsAPIModel.self, from: data)
            self.rewards = rewardsModel.rewards ?? []
            DispatchQueue.main.async {
                completion(nil)
            }
        } catch let error {
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func checkout(data: (String , [String: Any]), completion: @escaping completionType) {
        let request = JRPaytmCoinsAPI.checkout(url: data.0, bodyParam: data.1)
        let router = JRRouter<JRPaytmCoinsAPI>()
        router.request(type: JRDataType.self, request) { [weak self] (responseObject , response, error) in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(JRPCNetworkHandler.requestNotValid())
                }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
            } else {
                guard let responseData = responseObject as? [String: Any] else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                    return
                }
                switch statusCode {
                case 200:
                    if let status = responseData.getOptionalStringForKey("status"), status.lowercased() == "success", let orderId = responseData.getOptionalStringForKey("ORDER_ID"), let paymentPayload = responseData.getOptionalDictionaryKey("paymentPayload"), !orderId.isEmpty, let pgUrlToHit = responseData.getOptionalStringForKey("pgUrlToHit"), !pgUrlToHit.isEmpty {
                        
                        self.payment(data:(pgUrlToHit, ["paymentPayload": paymentPayload, "orderId": orderId]), completion: completion)
                        
                    } else {
                        DispatchQueue.main.async {
                            completion(self.getCheckOutError(dict: responseData))
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        completion(self.getCheckOutError(dict: responseData))
                    }
                }
                
            }
        }
    }
    
    func payment(data: (String , [String: Any]), completion: @escaping completionType) {
        let request = JRPaytmCoinsAPI.payment(url: data.0, bodyParam: data.1)
        let router = JRRouter<JRPaytmCoinsAPI>()
        router.request(type: JRDataType.self, request) { [weak self] (responseObject , response, error) in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(JRPCNetworkHandler.requestNotValid())
                }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
            } else {
                guard let responseData = responseObject as? [String: Any] else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                    return
                }
                switch statusCode {
                case 200:
                    if let status = responseData.getOptionalStringForKey("status"), status.lowercased() == "success", let orderId = responseData.getOptionalStringForKey("ORDER_ID"), !orderId.isEmpty {
                        self.orderId = orderId
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(self.getCheckOutError(dict: responseData))
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        completion(self.getCheckOutError(dict: responseData))
                    }
                }
                
            }
        }
    }
    
    func getCheckOutError(dict: [String: Any]) -> NSError {
        if let error = dict.getOptionalStringForKey("error"), !error.isEmpty {
            return NSError(domain: error, code: 5004,
                           userInfo: ["NSLocalizedDescription": error])
        }
        if let error = dict.getOptionalDictionaryKey("error") {
            let message = error.getOptionalStringForKey("message")
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : message ?? "jr_ins_kdefaultErrorMsg".localized])
            return error
        }
        if let error = dict.getOptionalStringForKey("message"), !error.isEmpty {
            return NSError(domain: error, code: 5004,
                           userInfo: ["NSLocalizedDescription": error])
        }
        return JRPCNetworkHandler.unknownError()
    }
}

struct JRPCRewardsAPIModel: Codable {
    
    let rewards: [JRPCRewardsModel]?
    enum CodingKeys: String, CodingKey {
        case rewards = "grid_layout"
    }
    
}

struct JRPCRewardsModel: Codable {
    let productID: JRPCGenericString?
    let imageURL: String?
    let attributes: JRPCAttributes?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case imageURL = "image_url"
        case attributes
    }
}

struct JRPCAttributes: Codable {
    let redemptionPoints: JRPCGenericString?
    enum CodingKeys: String, CodingKey {
        //case redemptionPoints = "redemption_points"
        case redemptionPoints = "points_price"
    }
}
