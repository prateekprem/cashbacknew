//
//  JRCOVoucherFilterVM.swift
//  Jarvis
//
//  Created by Nikita Maheshwari on 05/04/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

class JRCOFilterList {
    private(set) var id: Int = 0
    private(set) var filterName: String = ""
    private(set) var count: Int = 0
    private(set) var isSelected: Bool = false
    private(set) var isApplied: Bool = false

    init(data: JRCOFilterListModel) {
        if let id = data.id {
            self.id = id
        }
        if let filterName = data.displayName {
            self.filterName = filterName.capitalizingFirstLetter()
        }
        if let count = data.count {
            self.count = count
        }
        if self.filterName.lowercased() == VoucherStatus.active.statusTitle.lowercased() {
            self.isSelected = true
            self.isApplied = true
        }
    }
    
    func setFilterData(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func resetIsSelected(isApplied: Bool) {
        self.isSelected = isApplied
    }
    
    func setIsApplied(isSelected: Bool) {
        self.isApplied = isSelected
    }
}

//section model
class JRCOSectionDataSource {
    private(set) var displayName: String = ""
    private(set) var filterType: FilterSelectionType = .MultiSelect
    private(set) var filterList: [JRCOFilterList] = [JRCOFilterList]()
    
    init(data: JRCOFilterItemModel) {
        if let displayName = data.displayName {
            self.displayName = displayName.capitalizingFirstLetter()
        }
        if let filterType = data.displayFilterType {
            if filterType == "anyOneOption" {
                self.filterType = .SingleSelect
            }
            else {
                self.filterType = .MultiSelect
            }
        }
        if let items = data.items {
            filterList = items.map { (filterData) -> JRCOFilterList in
                return JRCOFilterList.init(data: filterData)
            }
        }
    }
    
    func resetOtherIndexes(ids: Int, completion: () -> Void) {
        
        filterList = filterList.map { list in
            if ids != list.id {
                list.setFilterData(isSelected: false)
            }
            else {
                list.setFilterData(isSelected: true)
            }
            return list
        }
        completion()
    }
    
}


// view model
class JRCOVoucherFilterVM {
    
    private(set) var sectionDataSource: [JRCOSectionDataSource] = [JRCOSectionDataSource]()
    var selectedFilterIds: Set<Int> = Set<Int>()
    var active_Or_Expired_FilterID: String = VoucherStatus.active.statusId
    var active_Or_Expired_FilterName: String = VoucherStatus.active.statusTitle
    
    init() {
        
    }
    
    func getFilterList(isMerchant: Bool = false, completion: @escaping (Bool, JRCBError?) -> Void) {
        let params : JRCBJSONDictionary = ["locale": "\(Locale.current.identifier)", "is_merchant": isMerchant ? "true":"false","type": isMerchant ? "VOUCHER":"DEAL,VOUCHER","client_id":isMerchant ? "PROMO":"DEAL,PROMO"]
       
        JRCBServices.serviceGetFilterList(params: params) {[weak self] (filterListModel, error) in
            if error == nil && filterListModel != nil {
                self?.parseDataFromModel(model: filterListModel?.facets,isMerchant: isMerchant)
                completion(true, nil)
            }
            else{
                completion(false, error)
            }
        }
    }
    
    func parseDataFromModel(model: [JRCOFilterItemModel]?,isMerchant: Bool = false) {
        if let data = model {
            
            let filterData = data.filter { (model) -> Bool in
                if isMerchant == false && model.field == "status" {
                    return false
                }
                return true
            }
            
            sectionDataSource = filterData.map({ (filter) -> JRCOSectionDataSource in
                return JRCOSectionDataSource.init(data: filter)
            })
        }
    }
    
    func showHeader(section: Int) -> Bool {
        if sectionDataSource[section].filterList.count > 0 {
            return true
        }
        return false
    }
    
    func numberOfSections() -> Int {
        return sectionDataSource.count
    }
    
    func numberOfRows(section: Int) -> Int {
        return sectionDataSource[section].filterList.count
    }
    
    func getSelectedcategoryId() -> String {
        let ids = selectedFilterIds.map { (data) -> String in
            return "\(data)"
            }.joined(separator: ",")
        return ids
    }
    
    func resetNotAppliedFilters() {
        for sectionData in sectionDataSource {
            let _ = sectionData.filterList.map { data in
                data.resetIsSelected(isApplied: data.isApplied)
            }
        }
    }
    
    func resetAllFilters() {
        for sectionData in sectionDataSource {
            if sectionData.filterType == .MultiSelect {
                let _ = sectionData.filterList.map { data in
                    data.setIsApplied(isSelected: false)
                    data.resetIsSelected(isApplied: false)
                }
            }
            else if sectionData.filterType == .SingleSelect {
                let _ = sectionData.filterList.map { data in
                    if data.filterName.lowercased() == VoucherStatus.active.statusTitle.lowercased() {
                        data.resetIsSelected(isApplied: true)
                        data.resetIsSelected(isApplied: true)
                    }
                    else {
                        data.resetIsSelected(isApplied: false)
                        data.resetIsSelected(isApplied: false)
                    }
                }
            }
        }
    }
    
    func setAppliedFilters() {
        for sectionData in sectionDataSource {
            
            let _ = sectionData.filterList.map { data in
                
                if sectionData.filterType == .MultiSelect {
                    if data.isSelected {
                        selectedFilterIds.insert(data.id)
                    }
                    else{
                        selectedFilterIds.remove(data.id)
                    }
                }
                else{
                    if data.isSelected {
                        active_Or_Expired_FilterID = String(data.id)
                        active_Or_Expired_FilterName = data.filterName
                    }
                }
                data.setIsApplied(isSelected: data.isSelected)
            }
        }
    }
}
