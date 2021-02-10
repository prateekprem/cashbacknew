//
//  ReferralLendingViewModel.swift
//  FBSDKCoreKit
//
//  Created by Abhishek Tripathi on 23/07/20.
//

import Foundation

enum ReferralMoreOfferCells {
    case invite
    case offers
    
    var identifer: String {
        switch self {
        case .offers: return "ReferralOfferCell"
        case .invite: return "ReferralInviteCell"
        }
    }
}
 

enum ReferralMoreOfferViewState {
    case loding
    case content
    case refreshing
     case error(_ message: String)
}



class ReferralMoreOfferViewModel {
    
    var dataModel: JRCBCampaign!
    var dataSource: [[ReffralViewModel]] = []
    var headerImage: String = ""
    var backImage: String = ""
    var referTag: String = ""
    var utmSource: String = ""
    var model: JRCBCampaign!
    
    var observer: ((_ viewState: ReferralMoreOfferViewState) -> Void) = {_ in }
    var shareText: String = "jr_referral_link".localized
    
    init(model: JRCBCampaign, tag: String = "", utmS: String = "") {
        self.model = model
        self.referTag = tag
        self.utmSource = utmS
        self.mapInformation(model)
    }
    
    func mapInformation(_ info: JRCBCampaign) {
        self.dataModel = info
        var firstSection: [ReferralCellViewModel] = []
        let infoObject = ReferralCellViewModel(title: info.offer_text_override, subTitle: info.short_description, inviteTitle: "Invite", sharinglink: "", imageName: "",type: ReferralCellType.detail, knowMoreUrl: info.tnc,keyword: info.offer_keyword, campaigne: info.campaign, shareText: info.deeplink_text)
        
        shareText = info.deeplink_text ?? "jr_referral_link".localized
        firstSection.append(infoObject)
        dataSource.append(firstSection)
     }
    
    func viewIsReady() {
        /*
        self.observer(.loding)
        JRCBServices.fetchlinkInformation(campaigne: self.dataModel.campaign) { (sucess, resp, error) in
            DispatchQueue.main.async {
                self.observer(.content)
                if let model = resp, let data = model["data"] as? JRCBJSONDictionary {
                    if let info: ReferralCellViewModel = self.dataSource[0][0] as? ReferralCellViewModel, let link = data["link"] as? String {
                        info.hashCode = link
                         self.observer(.refreshing)
                    }
                } else if let mErr = error {
                    self.observer(.error(mErr))
                } else {
                    self.observer(.error(JRCBConstants.Common.kDefaultErrorMsg))
                }
            }
            
        }
        */
        
        self.hitTermsAndConditionsApi(tncLink: self.dataModel.tnc)
    }
    
    fileprivate func hitTermsAndConditionsApi(tncLink:String){
        self.observer(.loding)
        let aModel = JRCBApiModel(type: .pathCustomAPI, param: nil, body: nil, appendUrlExt: "")
        aModel.update(urlString: tncLink)
        JRCBServiceManager.executeAPI(model: aModel) { [weak self] (isSuccess, response, error) in
            
            DispatchQueue.main.async{
                self?.observer(.content)
                guard let resp = response as? JRCBJSONDictionary else {
                    var errr: NSError?
                    if let err = error {
                        errr = err as NSError
                    } else {
                        errr = JRCBServiceManager.genericError as NSError?
                    }
                    
                    if let anErr = errr {
                        self?.observer(.error(anErr.localizedDescription))
                    }
                    
                    return
                }
                
                let model = JRCOTNCModel(dict: resp)
                let tncViewModel = TermAndConditionViewModel(title: model.terms_title, subTitle: model.terms, inviteTitle: "")
                self?.dataSource.append([tncViewModel])
                self?.observer(.refreshing)
              }
        }
    }
    
    func getPulseLabelDict(includeCampaign: Bool) -> [String: String] {
        var labelDict = [JRCBAnalyticsEventLabel.klabel3: self.utmSource,
                         JRCBAnalyticsEventLabel.klabel4: self.referTag]
        
        if includeCampaign {
            //Append campaign details
            labelDict[JRCBAnalyticsEventLabel.klabel2] = self.model.campId
            labelDict[JRCBAnalyticsEventLabel.klabel1] = self.model.campaign
        }
        
        return labelDict
    }
 }
 

extension ReferralMoreOfferViewModel: ReferralTable {
    
    var section: Int  {
        return self.dataSource.count
    }
    func row(section: Int) -> Int {
        return self.dataSource[section].count
    }
    
    func data(forRow atIndexPath: IndexPath) -> ReffralViewModel {
        return self.dataSource[atIndexPath.section][atIndexPath.row]
    }
}

 
