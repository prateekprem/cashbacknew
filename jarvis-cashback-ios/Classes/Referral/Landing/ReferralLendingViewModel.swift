//
//  ReferralLendingViewModel.swift
//  FBSDKCoreKit
//
//  Created by Abhishek Tripathi on 23/07/20.
//

import Foundation

enum ReferralCells {
    case invite
    case offers
    case tnc
    
    var identifer: String {
        switch self {
        case .offers: return "ReferralOfferCell"
        case .invite: return "ReferralInviteCell"
        case .tnc: return "TermAndConditionCell"
        }
    }
}


protocol ReferralTable {
    var section: Int {get}
    func row(section: Int) -> Int
    func data(forRow atIndexPath: IndexPath) -> ReffralViewModel
}
 
enum ReferralViewState {
    case loding
    case content
    case refreshing
    case upadeTotalBonus
    case error(_ message: String)
}



class ReferralLendingViewModel {
    
    var dataModel: JRCBReferralInfo?
    var dataSource: [[ReffralViewModel]] = []
    var cashBackImageUrl: String = ""
    var pointTitle: String = ""
    var totalPoint: Double?
    var tag: String = "referral_1"
    var bannerUrl: String = ""
    var shareUrl: String = "jr_referral_link".localized
    var utmSource: String = ""

    var observer: ((_ viewState: ReferralViewState) -> Void) = {_ in }
    
    init(tag: String, utmSource: String) {
        self.tag = tag != "" ? tag : "referral_1"
        self.utmSource = utmSource
        self.dataSource = []
    }
    
    func viewIsReady() {
        self.fetchCashbackTagOffers()
    }
    
    private func fetchCashbackTagOffers() {
        self.observer(.loding)
        JRCBServices.fetchReferralInformation(tag: self.tag) { (success, resp, error) in
            DispatchQueue.main.async {
                self.observer(.content)
                if let model = resp, let data = model["data"] as? JRCBJSONDictionary {
                    self.dataModel = JRCBReferralInfo(data)
                    self.mapInformation(self.dataModel)
                    self.observer(.refreshing)
                } else if let mErr = error {
                    self.observer(.error(mErr))
                } else {
                    self.observer(.error(JRCBConstants.Common.kDefaultErrorMsg))
                }
            }
        }
    }
    
    func mapInformation(_ info: JRCBReferralInfo?) {
        if let campaigns = info?.campaigns {
            var first: [ReferralCellViewModel] = []
            var second: [ReferralOffersCellViewModel] = []
            for index in 0..<campaigns.count {
                if index == 0 {
                    let campaign = campaigns[index]
                    var referralCode = ""
                    var referralLink = ""
                    if let link = self.dataModel?.referral_links[campaign.campaign] as? [String: String] {
                        if let referral = link["link"] {
                            referralCode = referral
                        }
                        if let shortURL = link["short_url"] {
                            referralLink = shortURL
                        }
                    }
                    
                    let info = ReferralCellViewModel(title: campaign.offer_text_override, subTitle: campaign.short_description, inviteTitle: "Share your invite", sharinglink: referralCode, imageName: campaign.offer_image_url, knowMoreUrl: campaign.tnc, campaigne: campaign.campaign, shareText: campaign.deeplink_text, shortURL: referralLink)
                    self.bannerUrl = JRCBApiType.referral_campign_image.urlString
                    self.shareUrl = campaign.deeplink_text ?? "jr_referral_link".localized
                    first.append(info)
                } else {
                    let campaign = campaigns[index]
                    let info = ReferralOffersCellViewModel(title: campaign.offer_text_override, subTitle: campaign.short_description, invite: "Share your invite", offerImage: campaign.new_offers_image_url, campaign: campaign, backGroundImageUrl: campaign.background_image_url)
                    second.append(info)
                    
                }
            }
            self.dataSource.append(first)
            self.dataSource.append(second)
            self.configureHeaders()
        }
    }
    
    func configureHeaders () {
        if let detail = self.dataModel?.bonus_detail, detail.count > 0 , let first = detail.first {
            self.totalPoint = first.total_bonus ?? 0.0
            self.pointTitle = first.bonus_tile_title ?? ""
            self.cashBackImageUrl = first.bonus_tile_icon ?? ""
        }
        self.observer(.upadeTotalBonus)
    }
    
    func getPulseLabelDict(includeCampaign: Bool) -> [String: String] {
        var labelDict = [JRCBAnalyticsEventLabel.klabel3: self.utmSource,
                         JRCBAnalyticsEventLabel.klabel4: self.tag]
        
        if includeCampaign {
            //Append campaign details
            var campaignName: String = ""
            var campaignId: String = ""
            if let campaigns = self.dataModel?.campaigns, campaigns.count > 0 {
                campaignName = campaigns[0].campaign
                campaignId = campaigns[0].campId
            }
            labelDict[JRCBAnalyticsEventLabel.klabel2] = campaignId
            labelDict[JRCBAnalyticsEventLabel.klabel1] = campaignName
        }
        
        return labelDict
    }
}


extension ReferralLendingViewModel: ReferralTable {
    
    var section: Int  {
        return self.dataSource.count
    }
    func row(section: Int) -> Int {
        return self.dataSource[section].count
    }
    
    func data(forRow atIndexPath: IndexPath) -> ReffralViewModel {
        return self.dataSource[atIndexPath.section][atIndexPath.row]
    }
    
    var isVisibale: Bool {
        if let detail = self.dataModel?.bonus_detail, detail.count > 0 , let first = detail.first, let bonus = first.total_bonus , bonus > 0.0  {
            return true
        }
        return false
    }
    
    var userList: [ReferralUser] {
        if let detail = self.dataModel?.bonus_detail, detail.count > 0 , let first = detail.first {
            return first.info ?? []
        }
        return []
    }
    
    var heightForHeader: CGFloat {
        if self.isVisibale {
            return 342
        }
        return 273
    }
    
    var isRecord: Bool {
        if let record = self.dataModel?.campaigns, record.count > 0 {
           return true
        }
        return false
    }
}

protocol ReffralViewModel {
    var title: String {get set}
    var subTitle: String {get set}
    var inviteTitle: String {get set}
    var identifier: ReferralCells {get set}
}

struct ShareViewModel {
    var name: String = ""
    var image: String = ""
    var schemaUrl: String = ""
    var shareText: String = "jr_referral_link".localized
    
    func getShareUrl(text: String) -> String {
        return self.schemaUrl + ("\(self.shareText) \(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    var canOpenUrl: Bool {
        if let url = URL(string: self.schemaUrl) {
            if UIApplication.shared.canOpenURL(url) {
                return true
            }
        }
        return false
    }
 }

class ReferralOffersCellViewModel: ReffralViewModel {
    var title: String
    var subTitle: String
    var inviteTitle: String
    var offerImage: String
    var backGroundImageUrl: String
    var identifier: ReferralCells = .offers
    var campaign: JRCBCampaign
 
    init(title: String, subTitle: String, invite: String, offerImage: String, campaign: JRCBCampaign, backGroundImageUrl: String) {
        self.title = title
        self.subTitle = subTitle
        self.inviteTitle = invite
        self.offerImage = offerImage
        self.backGroundImageUrl = backGroundImageUrl
        self.campaign = campaign
    }
}
