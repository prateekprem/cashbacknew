//
//  JRPPTransactionListVM.swift
//  Jarvis
//
//  Created by Pankaj Singh on 03/01/20.
//

import Foundation
import jarvis_network_ios

// MARK: - Enums

enum JRPPTransactionAPIStatus: String {
    case success = "S"
}

enum JRPCAccountingType: String {
    case CREDIT
    case DEBIT
}

enum JRPCTransactionType: String {
    case REWARD
    case REFUND
    case PAY
}

// MARK: - TransactionVM

class JRPCTransactionVM {
    
    var coinsBalance: String = JRPCConstants.kPCInvalidCoinBalance
    var loyaltyPoints: [JRPCTransactionSecModel] = []
    var pagination: JRPPPaginator?
    
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
    
    func fetchTransactionList(data: (String , [String: Any]), completion: @escaping completionType) {
        let request = JRPaytmCoinsAPI.getTransactionList(url: data.0, bodyParam: data.1)
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
                    self.processTransactionAPIResponse(responseData, completion)
                default:
                    DispatchQueue.main.async {
                        completion(JRPCNetworkHandler.unknownError())
                    }
                }
                
            }
        }
    }
    
    private func processTransactionAPIResponse(_ data: Data, _ completion: @escaping completionType) {
        do {
            let decoder = JSONDecoder()
            let transactionModel = try decoder.decode(JRPPTransactionListModel.self, from: data)
            if transactionModel.response?.result?.resultStatus == JRPPTransactionAPIStatus.success.rawValue {
                if let points = transactionModel.response?.loyaltyPoints {
                    self.parseLoyalityPoints(points: points)
                }
                if let pagination = transactionModel.response?.paginator {
                    self.pagination = pagination
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                if let resultMsg = transactionModel.response?.result?.resultMsg {
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
    
    private func parseLoyalityPoints(points: [JRPPLoyaltyPoint]) {
        for coin in points {
            if let timestamp = coin.dateStringInfo {
                
                if let index = self.loyaltyPoints.firstIndex(where: { (model) -> Bool in
                    return model.dateString == timestamp.date
                }) {
                    var array = self.loyaltyPoints[index].transactionList
                    array.append(coin)
                    self.loyaltyPoints[index].transactionList = array
                } else {
                    let model = JRPCTransactionSecModel(dateString: timestamp.date, transactionList: [coin])
                    self.loyaltyPoints.append(model)
                }
            }
        }
    }
}

// MARK: - Transaction Section Model

struct JRPCTransactionSecModel {
    var dateString: String = ""
    var transactionList: [JRPPLoyaltyPoint] = []
}


// MARK: - JRPPBalanceAPIModel
struct JRPPTransactionListModel: Codable {
    let response: JRPPResponse?
}

// MARK: - Response
struct JRPPResponse: Codable {
    let result: JRPPResult?
    let loyaltyPoints: [JRPPLoyaltyPoint]?
    let paginator: JRPPPaginator?
    let activeBalance, exchangeRate: JRPCGenericString?
}

// MARK: - LoyaltyPoint
struct JRPPLoyaltyPoint: Codable {
    let extendedInfo: JRPCExtendedInfo?
    let accountingAmount: JRPCGenericString?
    let accountingTimeStamp: String?
    let accountingType: String?
    let activeBalance: JRPCGenericString?
    let orderID: String?
    let successful: Bool?
    let transactionType: String?
    let expiryTime: String?
    var dateStringInfo: (time: String, date: String)? {
        if let timeStamp = accountingTimeStamp, let formattedDate = JRPCUtilities.change(dateString: timeStamp) {
            let dateTimeArray = formattedDate.split(separator: ",")
            if dateTimeArray.count == 2 {
                return (String(dateTimeArray[0]), String(dateTimeArray[1]))
            }
        }
        return nil
    }
    enum CodingKeys: String, CodingKey {
        case accountingAmount, accountingType, activeBalance
        case orderID = "orderId"
        case accountingTimeStamp = "accountingTimestamp"
        case successful, transactionType, expiryTime
        case extendedInfo = "extendInfo"
    }
}

// MARK: - Paginator
struct JRPPPaginator: Codable {
    let pageNum, pageSize, totalPage, totalCount: Int?
}

// MARK: - Result
struct JRPPResult: Codable {
    let resultStatus, resultMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case resultStatus
        case resultMsg
    }
}

struct JRPCExtendedInfo: Codable {
    let offerName: String?
    let displayName: String?
    let shortDescription: String?
    let offerIconImage: String?
}

class JRPCGenericString: Codable {
    let value: String
    
    static func decode(from container: SingleValueDecodingContainer) throws -> String {
        if let value: Bool = try? container.decode(Bool.self) {
            return String(value)
        }
        if let value: Int = try? container.decode(Int.self) {
            return String(value)
        }
        if let value: Double = try? container.decode(Double.self) {
            return String(value)
        }
        if let value: String = try? container.decode(String.self) {
            return value
        }
        return ""
    }
    
    public required init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        self.value = try JRPCGenericString.decode(from: container)
    }
    
    public init(stringLiteral value: String) {
        self.value = value
    }
    
}

