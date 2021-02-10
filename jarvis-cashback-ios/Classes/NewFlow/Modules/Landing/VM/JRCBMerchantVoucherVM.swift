//
//  JRCBMerchantVoucherVM.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 07/04/20.
//

import UIKit

struct JRCBAPIPageInfo {
    var isNextPage: Bool = true
    var pageNumber: Int = 1
    var pageSize: Int = 10
    var apiInProgress: Bool = false
}

class JRCBMerchantVoucherVM {
    
    private(set) var dataSource = [JRCBGridBaseInfo]()
    private(set) var filterViewModel: JRCOVoucherFilterVM = JRCOVoucherFilterVM()
    private(set) var apiInProgress = true

    private(set) var pageInfo = JRCBAPIPageInfo()
   
    var selectedFilterIds: String = ""
    var sortingStyle: String = SortingStyle.normal.rawValue
    var showExpiredVouchers: String = VoucherStatus.active.statusId
    
    func resetData() {
        self.pageInfo.pageNumber = 1
        self.dataSource.removeAll()
    }

    // MARK: - VOUCHERS API
    func fetchMyVouchers(completion: JRCBVMCompletion?) {
        self.apiInProgress = true
        let mParam: JRCBJSONDictionary = [
            "page": "\(pageInfo.pageNumber)",
            "size": pageInfo.pageSize,
            "filter[category]": "\(selectedFilterIds)",
            "sort": "\(sortingStyle)",
            "filter[status]": "\(showExpiredVouchers)",
            "locale": "\(Locale.current.identifier)",
            "filter[is_merchant]": "true","filter[type]": "VOUCHER",
            "filter[client]": "PROMO"]

        
        JRCBServices.serviceGetVoucherList(params: mParam) { [weak self] (voucherModel, error) in
            self?.apiInProgress = false
            
            if let vm = voucherModel {
                self?.parse(response: vm)
                completion?(true, "")
                
            } else if let err = error {
                completion?(false, err.localisedDesc())
                
            } else {
                completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
            }
        }
    }
    
    private func parse(response: JRCOMyVoucherResponseModel) {
        if self.pageInfo.pageNumber == 1 {
            self.dataSource.removeAll()
        }
        self.pageInfo.pageNumber = self.pageInfo.pageNumber + 1
        self.createBaseInfoFromVoucherModel(voucherModel: response)
    }
    
    private func createBaseInfoFromVoucherModel(voucherModel: JRCOMyVoucherResponseModel) {
        if let voucherlist = voucherModel.response?.voucherList, voucherlist.count > 0 {
            
            self.pageInfo.isNextPage = voucherModel.response?.isNext ?? false
            
            for voucher in voucherlist {
                let baseInfo = JRCBGridBaseInfo(dict: [:], index: voucherlist.count)
                baseInfo.metaData = voucher
                baseInfo.title = voucher.title ?? ""
                baseInfo.subTitle = voucher.savingsText ?? ""
                baseInfo.offerIconImage = voucher.icon ?? ""
                self.dataSource.append(baseInfo)
            }
        }
    }
}
