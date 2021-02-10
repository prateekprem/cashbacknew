//
//  JRCBNewOfferDetailsVM.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/01/20.
//

import Foundation

class JRCBNewOfferDetailsVM {
    
    private var dataModel: JRCBCampaign
    
    init(model: JRCBCampaign) {
        dataModel = model
    }
    
    func getDataModel() -> JRCBCampaign {
        return dataModel
    }
}
