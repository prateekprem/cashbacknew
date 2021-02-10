//
//  JRCBTnCVM.swift
//  jarvis-cashback-ios
//
//  Created by Siddharth Suneel on 06/02/20.
//

import Foundation

class JRCBTnCVM {
    private var tncModel: JRCBTnCModel?
    private var model: JRCBOfferDetailModel?
    
    init(model: JRCBOfferDetailModel) {
        self.model = model
    }
    
    func getTnCModelData() -> JRCBTnCModel? {
        return tncModel
    }
    
    func getOfferDetailModelData() -> JRCBOfferDetailModel? {
        return model
    }
    
    func getTnCData(completion: @escaping ((Bool?, Error?) -> Void) ) {
        guard let url = model?.termsUrl else {
            completion(false, nil)
            return
        }
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathCustomAPI, param: nil, appendUrlExt: "")
        apiModel.update(urlString: url)
        JRCBServiceManager.execute(apiModel: apiModel) { [weak self] (success, resp, err) in
            
            if err == nil, let response = resp?.getDictionaryKey("data") {
                self?.tncModel = JRCBTnCModel(dict: response)
                completion(true, nil)
            }
        }
    }
}
