//
//  FilterLayoutHelper.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 23/07/19.
//

import UIKit

enum MPFilterValueResueIdentifier: String {
    case filterValueLinearRectangular = "MPFilterValueLinearRectCell"
    case filterValueCategoryTreeCell = "MPFilterValueCategoryTreeCell"
    case filterValuePriceCell = "MPFilterValuePriceCell"
}

class MPFilterLayoutHelper: NSObject {
    
    static func numberOfSectionsforFilter(_ filter: SFFilter) -> Int {
        var sectionCount = 1
        if filter.filterParam ==  SFFilterParam.brand.rawValue  {
            if filter.isSearchActive == false {
                if filter.popularbrandsCount > 0 {
                    sectionCount = sectionCount + 1
                }else{
                    return 1
                }
                if filter.nonPopularBrandCount > 0{
                    sectionCount = sectionCount + 1
                }
            }
        }
        return sectionCount
    }
    
    static func numberOfRowsforFilter(_ filter: SFFilter ,section: Int) -> Int {
        switch filter.filterType {
        case .linearRectangular:
            if filter.isSearchActive{
                return filter.filteredValues.count
            }else {
                if filter.filterParam == SFFilterParam.brand.rawValue {
                    return brandSectionRow(section: section, filter: filter)
                }else {
                    return filter.values.count
                }
            }
        case .rangeSlider: return 1
        case .tree: return filter.appliedCategoryTreeNode?.last?.completeListToDisplay.count ?? (filter.categoryTreeParent?.children.count ?? 0)
        default: return 0
        }
    }
    
    static func brandSectionRow(section: Int , filter: SFFilter) -> Int{
        if filter.popularbrandsCount == 0 {
            return filter.nonPopularBrandCount
        }
        if section == 0 {
            return 0
        }
        if section == 1 {
            return filter.popularbrandsCount
        }else {
            return filter.nonPopularBrandCount
        }
    }
    
    static func cellIdentifierForFilter(_ filter: SFFilter) -> MPFilterValueResueIdentifier? {
        switch filter.filterType {
        case .linearRectangular: return .filterValueLinearRectangular
        case .tree: return .filterValueCategoryTreeCell
        case .rangeSlider: return .filterValuePriceCell
        default: return nil
        }
    }
}
