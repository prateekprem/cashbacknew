//
//  JRCBDeepLinkVM.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 11/06/20.
//

import Foundation

class JRCBDeepLinkVM {
    private(set) var screen: JRCBDeepLinkScreen = .cbConsumerLanding
    let instanceId : Int
    let txnNumber : Int
    var takeToBase: Bool = false
    
    init(instId: Int, screen: JRCBDeepLinkScreen,
         txnNumber: Int = -1, takeToBase: Bool = false) {
        self.screen = screen
        self.instanceId = instId
        self.txnNumber = txnNumber
        self.takeToBase = takeToBase
    }
    
    private var mLandingVC : UIViewController? {
        if !self.takeToBase { return nil }
        if JRCashbackManager.shared.config.cbVarient == .merchantApp {
            let landingVC = JRCBMerchLandingVC.newInstance
            return landingVC
        }
        let landingVC = JRCBLandingVC.newInstance
        return landingVC
    }
    
    func fetchData(completion: @escaping ([UIViewController]?, JRCBCustomErrorModel?) -> Void) {
        switch screen {
        case .cbMyOfferDetail, .cbCompletion :
            self.getGameDetail(completion: completion)
            
        case .cbTopOffer, .cbCampaigndetails, .cbSupercashCampaign :
            self.getCampaignDetail(completion: completion)
            
        case .cbMyOfferDetailMerchant:
            self.getMerchantGameDetailWith(completion: completion)
            
        case .cbMerchantCampaignDetail :
            self.getMerchantCampaignDetailWith(completion: completion)
            
        default: break
        }
    }
    
    private func appendLandingIn(vcs: [UIViewController]) -> [UIViewController] {
        if let landingVC = self.mLandingVC {
            var allVc = vcs
            allVc.insert(landingVC, at: 0)
            return allVc
        }
        return vcs
    }
    
    private func getMerchantGameDetailWith(completion: @escaping ([UIViewController]?, JRCBCustomErrorModel?) -> Void) {
        let aModel = JRCBApiModel(type: .pathCBMerchantGameListV2, param: nil, appendUrlExt: "/\(instanceId)")
        JRCBServiceManager.executeAPI(model: aModel) { (isSuccess, response, error) in
            guard let resp = response as? JRCBJSONDictionary else {
                if let mErr = error as NSError? {
                    completion(nil, JRCBCustomErrorModel(title: mErr.localizedFailureReason, message: mErr.localizedDescription))
                    
                } else {
                    completion(nil, JRCBServiceManager.genericCustomError)
                }
                return
            }
            
            let offerVM =  JRMCOMyOfferViewModel(dict: resp)
            if offerVM.game_status_enum == .initialized {
                let vc = JRMCOActivateOfferVC.instance(viewModel: offerVM)
                completion(self.appendLandingIn(vcs: [vc]), nil)
                
            } else {
                let vcs = self.merchantInProressVCsWith(model: offerVM)
                completion(self.appendLandingIn(vcs: vcs), nil)
            }
        }
    }
    
    private func getMerchantCampaignDetailWith(completion: @escaping ([UIViewController]?, JRCBCustomErrorModel?) -> Void) {
        
        let aModel = JRCBApiModel(type: .pathCBMerchantGameListV2, param: nil, appendUrlExt: "/campaign-games/\(instanceId)")
        JRCBServiceManager.executeAPI(model: aModel) { (isSuccess, response, error) in
            guard let resp = response as? JRCBJSONDictionary else {
                if let mErr = error {
                    completion(nil, JRCBCustomErrorModel(title: JRCBConstants.Common.kDefaultErrorMsg, message: mErr.localizedDescription))
                } else {
                    completion(nil, JRCBServiceManager.genericCustomError)
                }
                return
            }
            
            
            if let dataDict = resp["data"] as? JRCBJSONDictionary {
                if let newOfferResponseDict = dataDict["campaign"] as? JRCBJSONDictionary {
                    let newOfferVM = JRMCONewOfferViewModel(dict: newOfferResponseDict)
                    //open campaign detail screen
                    let vc = JRMCOActivateOfferVC.instance(viewModel: newOfferVM)
                    completion(self.appendLandingIn(vcs: [vc]), nil)
                    return
                }
                
                if let myOfferResponseDict = dataDict["supercashGame"] as? JRCBJSONDictionary {
                    let myOfferVM = JRMCOMyOfferViewModel(dict: myOfferResponseDict)
                    //open Game detail screen
                    if myOfferVM.game_status_enum == .initialized {
                        let vc = JRMCOActivateOfferVC.instance(viewModel: myOfferVM)
                        completion(self.appendLandingIn(vcs: [vc]), nil)
                    } else {
                        let vcs = self.merchantInProressVCsWith(model: myOfferVM)
                        completion(self.appendLandingIn(vcs: vcs), nil)
                    }
                    return
                }
                
            } else {
                if let newOfferResponseDict = resp["campaign"] as? JRCBJSONDictionary {
                    let newOfferVM = JRMCONewOfferViewModel(dict: newOfferResponseDict)
                    let vc = JRMCOActivateOfferVC.instance(viewModel: newOfferVM)
                    completion(self.appendLandingIn(vcs: [vc]), nil)
                    return
                }
                
                if let myOfferResponseDict = resp["supercashGame"] as? JRCBJSONDictionary {
                    let myOfferVM = JRMCOMyOfferViewModel(dict: myOfferResponseDict)
                    
                    if myOfferVM.game_status_enum == .initialized {
                        let vc = JRMCOActivateOfferVC.instance(viewModel: myOfferVM)
                        completion(self.appendLandingIn(vcs: [vc]), nil)
                        
                    } else {
                        let vcs = self.merchantInProressVCsWith(model: myOfferVM)
                        completion(self.appendLandingIn(vcs: vcs), nil)
                    }
                    return
                }
            }
            
            completion(nil, JRCBServiceManager.genericCustomError)
        }
    }
    
    private func getGameDetail(completion: @escaping ([UIViewController]?, JRCBCustomErrorModel?) -> Void) {
        JRCBServices.fetchGameDetailData(gameId: instanceId) { (success, response, error) in
            guard error == nil else {
                completion(nil, JRCBCustomErrorModel(title: JRCBConstants.Common.kDefaultErrorMsg, message: error?.localizedDescription))
                return
            }
            
            if let dataDict = response?["data"] as? JRCBJSONDictionary {
                let model = JRCBPostTrnsactionData(dict: dataDict)
                let vc = JRCBGameDetailsVC.newInstance
                let gameVM = JRCBGameDetailsVM(postTransData: model)
                vc.viewModel = gameVM
                completion(self.appendLandingIn(vcs: [vc]), nil)
                
            } else if let errorArr = response?["errors"] as? [JRCBJSONDictionary], errorArr.count > 0 {
                let errorModel = JRCBCustomErrorModel(dict: errorArr[0])
                completion(nil, errorModel)
                
            } else {
                completion(nil, JRCBCustomErrorModel(title: JRCBConstants.Common.kDefaultErrorMsg, message: error?.localizedDescription))
            }
        }
    }
    
    
    private func getCampaignDetail(completion: @escaping ([UIViewController]?, JRCBCustomErrorModel?) -> Void) {
        JRCBServices.fetchCampaignDetailData(campaignId: instanceId) { (success, response, error) in
            guard error == nil else {
                completion(nil, JRCBCustomErrorModel(title: JRCBConstants.Common.kDefaultErrorMsg, message: error?.localizedDescription))
                return
            }
            //Parse Response into Model
            if let dataDict = response?["data"] as? JRCBJSONDictionary {
                if let campaignDict = dataDict["campaign"] as? JRCBJSONDictionary {
                    let model = JRCBCampaign(dict: campaignDict)
                    if self.screen == .cbSupercashCampaign {
                        let vc = JRCBGameDetailsVC.newInstance
                        let gameVM = JRCBGameDetailsVM(campaignData: model)
                        vc.viewModel = gameVM
                        completion(self.appendLandingIn(vcs: [vc]), nil)
                    } else {
                        DispatchQueue.main.async {
                            let vc = JRCBNewOfferDetailsVC.instance(model: model)
                            completion(self.appendLandingIn(vcs: [vc]), nil)
                        }
                    }
                }
                else if let supercashDict = dataDict["supercash_game"] as? JRCBJSONDictionary {
                    let model = JRCBPostTrnsactionData(dict: supercashDict)
                    let vc = JRCBGameDetailsVC.newInstance
                    let gameVM = JRCBGameDetailsVM(postTransData: model)
                    vc.viewModel = gameVM
                    completion(self.appendLandingIn(vcs: [vc]), nil)
                }
                
            } else if let errorArr = response?["errors"] as? [JRCBJSONDictionary], errorArr.count > 0 {
                let errorModel = JRCBCustomErrorModel(dict: errorArr[0])
                completion(nil, errorModel)
            } else {
                let err = JRCBCustomErrorModel(title: JRCOConstant.kOfferNotFound, message: JRCOConstant.kCheckOtherOffers)
                completion(nil, err)
            }
        }
    }
    
    
    private func merchantInProressVCsWith(model: JRMCOMyOfferViewModel) -> [UIViewController] {
        let vc = JRMCOInProgressVC.instance(myOfferVM: model)
        if txnNumber < 0 {
            return [vc]
        }
        
        let task = model.getStageVMForIndex(index: txnNumber).tasksVM[0]
        switch task.redemptionType {
        case .crosspromo:
            let pCode = task.crosspromoDataVM.first?.cross_promo_code ?? ""
            let sID = Int(task.crosspromoDataVM.first?.site_id ?? "0") ?? 0
            
            let input = JRCBVoucherDetailInput(promoCode: pCode, site_id: sID)
            return [input.detailVC(), vc]
            
        case .deal:
                let voucherDVC = JRCBDeelsNVoucherDetailVC.newInstance
                voucherDVC.updateWith(dealModel: task.dealDataVM.first)
                return [voucherDVC, vc]                       
            
        case .cashback, .goldback,.coins:
            return [vc]
        }
    }
}
