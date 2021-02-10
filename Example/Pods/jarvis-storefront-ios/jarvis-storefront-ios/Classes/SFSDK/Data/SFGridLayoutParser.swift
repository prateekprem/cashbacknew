//
//  SFGridLayoutParser.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/10/19.
//

import Foundation

enum SFFilterParam: String {
    case brand = "brand"
}

enum SFFilterType: String {
    case unknown = "unknown"
    case tree = "tree"
    case linearRectangular = "linear-rectangular"
    case rangeSlider = "range-slider"
    case boolean = "boolean"
}

public enum GridViewType {
    case grid       // grid, gridsl, griddl
    case largeGrid  // largegridsl, largegriddl
    case list       // list, listsl, listdl
    case largeList  // largelistsl, largelistdl, listfmcg
    case deals      // dealsgrid
    case freeDeals  // freedealsgrid
    
    //Undefined types: foodlist, foodlistwithdescription, collections
    
    public func getNumberOfItemInACell() -> Int {
        switch self {
        case .list, .largeList, .deals, .freeDeals:
            return 1
        case .grid, .largeGrid:
            return 2
        }
    }
}

public class SFGridLayoutParser: NSObject {
    public var items: [SFLayoutItem] = [SFLayoutItem]()
    public var hasMore: Bool = false
    var filters: [SFFilter] = [SFFilter]()
    var frontendFilters: [SFFilter] = [SFFilter]()
    public var sortingKeys: [SFSortingValue] = [SFSortingValue]()
    public var viewType: GridViewType = .grid
    public var parentUrlString: String?
    public var variantRenderUrl: String?

    init(_ dict: [String: Any]) {
        var addTocart: Bool = false
        if let isAddTocart = dict["add_to_cart"] as? Bool, isAddTocart {
            addTocart = isAddTocart
        }
        if let itemsDictArray = dict["grid_layout"] as? [[String: Any]] {
            items.removeAll()
            for itemDict in itemsDictArray {
                let item = SFLayoutItem(dict: itemDict)
                if addTocart {
                    item.isAddToCartEnabled = true
                }
                item.experiment = dict.sfStringFor(key: "experiment")
                item.parentUrlString = self.parentUrlString
                item.isOfflineFlow = dict["offline"] as? Bool ?? false
                items.append(item)
            }
        }
        
        if let hasMoreResults = dict["has_more"] as? Bool {
            hasMore = hasMoreResults
        }
        if let renderUrl = dict["render_url"] as? String {
            variantRenderUrl = renderUrl
        }
        
        if let vType = dict["view_type"] as? String {
            if vType.lowercased() == "grid" || vType.lowercased() == "gridsl" || vType.lowercased() == "griddl" {
                viewType = .grid
            }
            else if vType.lowercased() == "largegridsl" || vType.lowercased() == "largegriddl" {
                viewType = .largeGrid
            }
            else if vType.lowercased() == "list" || vType.lowercased() == "listsl" || vType.lowercased() == "listdl" {
                viewType = .list
            }
            else if vType.lowercased() == "largelistsl" || vType.lowercased() == "largelistdl" || vType.lowercased() == "listfmcg" {
                viewType = .largeList
            }
            else if vType.lowercased() == "dealsgrid" {
                viewType = .deals
            }
            else if vType.lowercased() == "freedealsgrid" {
                viewType = .freeDeals
            }
        }
        
        if let filtersDictArray = dict["filters"] as? [[String: Any]] {
            filters.removeAll()
            for filterDict in filtersDictArray {
                let filter = SFFilter(filterDict)
                if filter.filterType != .unknown {
                    filters.append(filter)
                    filter.parseSelectedFilters()
                }
            }
        }
        
        if let frontendFiltersDictArray = dict["frontend_filters"] as? [[String: Any]], !frontendFiltersDictArray.isEmpty {
            frontendFilters.removeAll()
            for filterDict in frontendFiltersDictArray {
                let filter = SFFilter(filterDict)
                frontendFilters.append(filter)
            }
        }
        
        if let sortingKeysArray = dict["sorting_keys"] as? [[String: Any]], !sortingKeysArray.isEmpty {
            sortingKeys.removeAll()
            let defaultParam =  dict["default_sorting_param"] as? String
            for sortingDict in sortingKeysArray {
                let sortingValue: SFSortingValue = SFSortingValue(sortingDict)
                if sortingValue.name == "Price"{
                    let sortingValue1: SFSortingValue = SFSortingValue(sortingDict)
                    sortingValue1.name = "Price Low To High"
                    sortingValue1.defaultValue = "sort_price=0"
                    sortingKeys.append(sortingValue1)
                    let sortingValue2: SFSortingValue = SFSortingValue(sortingDict)
                    sortingValue2.name = "Price High To Low"
                    sortingValue2.defaultValue = "sort_price=1"
                    sortingKeys.append(sortingValue2)
                    if defaultParam != nil && (defaultParam == sortingValue1.defaultValue) {
                        sortingValue1.isSelected = true
                    } else if defaultParam != nil && (defaultParam == sortingValue2.defaultValue) {
                        sortingValue2.isSelected = true
                    }
                    
                } else {
                    sortingKeys.append(sortingValue)
                    if defaultParam != nil && (defaultParam == sortingValue.defaultValue
                        ){
                        sortingValue.isSelected = true
                    }
                }
            }
        }
    }
    
    func isFiltersPresent() -> Bool {
        return !sortingKeys.isEmpty || !frontendFilters.isEmpty || !filters.isEmpty
    }
    
    public func getVariantUrlToHit() -> String? {
        if let gridUrl = self.parentUrlString , let renderUrl = self.variantRenderUrl{
            let gridArray = gridUrl.components(separatedBy: CharacterSet(charactersIn:"?"))
            let renderArray = renderUrl.components(separatedBy: CharacterSet(charactersIn:"?"))
            if (gridArray.count > 1 && renderArray.count > 1){
                 return renderArray[0] + "?" + gridArray[1]
            }
        }
        return nil
    }
}

public class SFFilter: NSObject, NSCopying {
    
    let filterDict:[String: Any]!
    var filterType: SFFilterType = .unknown
    let title: String?
    let filterParam: String?
    var values: [SFFilterValue] = [SFFilterValue]()
    var filteredValues: [SFFilterValue] = [SFFilterValue]()
    var isSearchActive:Bool = false
    var categoryTreeParent: SFFilterTreeCategoryNode?
    var appliedCategoryTreeNode:[SFFilterTreeCategoryNode]?
    var selectedFilteredValues:[SFFilterValue] =  [SFFilterValue]()
    var selectedTreeFilteredValues:[SFFilterTreeCategoryNode] = [SFFilterTreeCategoryNode]()
    var appliedFiltersArray:[SFFilterValue] = [SFFilterValue]()
    var popularbrandsCount:Int = 0
    var nonPopularBrandCount:Int = 0
    
    init(_ dict: [String: Any]) {
        if let typeString = dict["type"] as? String, let type = SFFilterType(rawValue: typeString) {
            filterType = type
        }
        filterDict = dict
        title = dict["title"] as? String
        filterParam = dict["filter_param"] as? String
        super.init()
        if filterType == .rangeSlider{
            if let appliedRangeFiltersDict = dict["applied_range"] as? [String:Any], appliedRangeFiltersDict.keys.count > 0 {
                let filterValue: SFFilterValue = SFFilterValue(appliedRangeFiltersDict)
                appliedFiltersArray.append(filterValue)
            }
        }else {
            if let appliedFilters = dict["applied"] as? [[String:Any]], appliedFilters.count > 0 {
                appliedFiltersArray.removeAll()
                for valueDict in appliedFilters {
                    let filterValue: SFFilterValue = SFFilterValue(valueDict)
                    appliedFiltersArray.append(filterValue)
                }
            }
        }
        if let valuesDictArray = dict["values"] as? [[String: Any]] {
            values.removeAll()
            for valueDict in valuesDictArray {
                let filterValue: SFFilterValue = SFFilterValue(valueDict)
                values.append(filterValue)
            }
            if filterParam == SFFilterParam.brand.rawValue {
                let popularBrands = values.filter { $0.isPopularBrand == true}
                let nonPopularBrands = values.filter { $0.isPopularBrand == nil}
                let combinedSortedArray = popularBrands + nonPopularBrands
                values = combinedSortedArray
                popularbrandsCount = popularBrands.count
                nonPopularBrandCount = nonPopularBrands.count
            }
            
        }else if let valuesDict = dict["values"] as? [String: Any],valuesDict.keys.count > 0{
            var appliedArrFromServer: [[String: Any]]?
            categoryTreeParent = SFFilterTreeCategoryNode(["name" : "Root"])
            if let valuesDictArr = dict["applied"] as? [[String: Any]] {
                appliedArrFromServer = valuesDictArr
            }
            
            createTreeDataStructureForCategory(parentDict: valuesDict, parentNode:categoryTreeParent!, appliedArrayFromServer: appliedArrFromServer)
            if let appliedNode = appliedCategoryTreeNode?.last {
                appliedNode.getAllParent(node: appliedNode)
                appliedNode.getAllSiblingsOfNode(node: appliedNode)
            }
        }
    }
    
    func createTreeDataStructureForCategory(parentDict:[String:Any]?, parentNode: SFFilterTreeCategoryNode, appliedArrayFromServer:[[String:Any]]?){
        if let parentDict = parentDict , parentDict.keys.count > 0 {
            if let cats = parentDict["cats"] as? [[String:Any]] {
                for value in cats {
                    let childNode = SFFilterTreeCategoryNode(value)
                    parentNode.add(child: childNode)
                    if let appliedArray = appliedArrayFromServer {
                        for appliedDict in appliedArray {
                            if let selectedValue = appliedDict["id"] as? Int {
                                if selectedValue == childNode.filterValueID{
                                    if (appliedCategoryTreeNode == nil) {
                                        appliedCategoryTreeNode = [SFFilterTreeCategoryNode]()
                                    }
                                    appliedCategoryTreeNode?.append(childNode)
                                    childNode.isSelected = true
                                    childNode.isLeafNode = appliedDict["isLeaf"] as?  Bool ?? false
                                }
                            }
                        }
                    }
                    createTreeDataStructureForCategory(parentDict: value, parentNode: childNode, appliedArrayFromServer: appliedArrayFromServer)
                }
            }else {
                parentNode.isLeafNode = true
            }
        }
    }
    
    static func ifFilterExistInAppliedFilter(value:Any?, appliedFiltersArray: [SFFilterValue]) -> Bool{
        if let selectedValue = value as? String {
            for filter in appliedFiltersArray {
                if let selectedID = filter.filterValueID as? String, selectedID == selectedValue {
                    return true
                }
            }
        }else if let selectedValue = value as? Int {
            for filter in appliedFiltersArray {
                if let selectedID = filter.filterValueID as? Int, selectedID == selectedValue {
                    return true
                }
            }
        }
        
        return false
    }
    
    func parseSelectedFilters(){
        switch(filterType) {
        case .linearRectangular: for filterValue in values {
            if SFFilter.ifFilterExistInAppliedFilter(value:filterValue.filterValueID ,appliedFiltersArray:appliedFiltersArray){
                filterValue.isSelected = true
                selectedFilteredValues.append(filterValue)
            }
            }
        case .rangeSlider:
            selectedFilteredValues = appliedFiltersArray
            
        default: break
        }
    }
    
    func displayNameOfFilterOnCLP() -> String {
        var value = "All"
        if filterType == SFFilterType.linearRectangular {
            if(selectedFilteredValues.count) > 1{
                value = String(describing: selectedFilteredValues.count)
            }else if selectedFilteredValues.count == 1 , let filterValue = selectedFilteredValues.first {
                value = filterValue.name ?? value
            }
        }else if filterType == SFFilterType.rangeSlider {
            if selectedFilteredValues.count > 0 {
                let selectedValue = selectedFilteredValues[0]
                if let minPrice = selectedValue.minPrice, let maxPrice = selectedValue.maxPrice {
                    value = "\(rupeeSymbol)\(String(describing: minPrice))" + "-\(rupeeSymbol)\(String(describing: maxPrice))"
                }
            }
        }else if filterType == SFFilterType.tree{
            if let nodes = appliedCategoryTreeNode , nodes.count == 1 ,let lastSelectedNode = nodes.last, let name = lastSelectedNode.catName{
                value = name
            }else if let nodes = appliedCategoryTreeNode {
                value = String(describing: nodes.count)
            }
        }
        return value
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = SFFilter(filterDict)
        return copy
    }
    
    //MARK: Sort url
    public class func modifyUrlForAppliedSort(value:SFSortingValue, item:SFLayoutItem?) -> String?{
        if let sort = getSelectedSort(item: item) , let selectedSortFromServer = sort.defaultValue,let url = item?.itemSeoUrl, let newValue = value.defaultValue {
            if url.contain(subStr: selectedSortFromServer){
                return url.replacingOccurrences(of: selectedSortFromServer, with: newValue)
            }
            else if let url = item?.itemSeoUrl,let newValue = value.defaultValue{
                if url.contains(find: "?"){
                    return url + "&" + newValue
                }else {
                    return url + "?" + newValue
                }
            }
        }
        return item?.itemSeoUrl
    }
    
    public class func modifyOriginalGridItemSeoUrlForSort(value:SFSortingValue, item:SFLayoutItem?) -> String?{
        if let sort = getSelectedSort(item: item), let selectedSortFromServer = sort.defaultValue,let url = item?.originalGridItemSeoUrl, let newValue = value.defaultValue {
            if url.contain(subStr: selectedSortFromServer){
                return url.replacingOccurrences(of: selectedSortFromServer, with: newValue)
            }
            else if let url = item?.originalGridItemSeoUrl,let newValue = value.defaultValue{
                if url.contains(find: "?"){
                    return url + "&" + newValue
                }else {
                    return url + "?" + newValue
                }
            }
        }
        return item?.originalGridItemSeoUrl
    }
    
    private class func getSelectedSort(item: SFLayoutItem?) -> SFSortingValue? {
        if let sortingValues = item?.gridLayout?.sortingKeys, !sortingValues.isEmpty {
            for sortingValue in sortingValues {
                if sortingValue.isSelected {
                    return sortingValue
                }
            }
        }
        return nil
    }
}

class SFFilterTreeCategoryNode:NSObject,NSCopying {
    
    var isSelected: Bool = false
    var isLeafNode:Bool = false
    var showCross:Bool = false
    var siblings:[SFFilterTreeCategoryNode] = [SFFilterTreeCategoryNode]()
    var completeParentList:[SFFilterTreeCategoryNode] = [SFFilterTreeCategoryNode]()
    var filterValueID: Int?
    let catName:String?
    let catParentID:Int?
    let catCount:Int?
    var children:[SFFilterTreeCategoryNode] = [SFFilterTreeCategoryNode]()
    weak var parent:SFFilterTreeCategoryNode?
    var completeListToDisplay:[SFFilterTreeCategoryNode] {
        if isLeafNode {
            return completeParentList + siblings
        }else {
            showCross = true
            return completeParentList + children
            
        }
    }
    
    let filterTreeValueDict:[String: Any]!
    
    init(_ dict: [String:Any]) {
        filterValueID = dict["id"] as? Int
        catName = dict["name"] as? String
        catParentID = dict["parent_id"] as? Int
        catCount = dict["count"] as? Int
        filterTreeValueDict = dict
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = SFFilterTreeCategoryNode(filterTreeValueDict)
        return copy
    }
    
    func add(child: SFFilterTreeCategoryNode) {
        children.append(child)
        child.parent = self
    }
    
    func getAllParent(node: SFFilterTreeCategoryNode?){
        if node != nil && node?.parent != nil{
            node?.parent?.showCross = true
            if node?.isLeafNode == false {
                node?.showCross = true
            }
            getAllParent(node: node?.parent)
            if node?.filterValueID != filterValueID || node?.isLeafNode == false{
                completeParentList.append(node!)
            }
        }
    }
    
    func getAllSiblingsOfNode(node: SFFilterTreeCategoryNode?){
        siblings = parent?.children ?? []
        
    }
    
    func printTree(_ indent: String = "") {
        
        print(indent + (self.catName ?? ""))
        
        for child in children {
            child.printTree(indent + "    ")
        }
    }
}

class SFFilterValue: NSObject,NSCopying {
    var isSelected: Bool = false
    var filterValueID: Any?
    var name: String?
    var count: Int?
    var minPrice:Int?
    var maxPrice:Int?
    var filterValuePrefix:String?
    var isPopularBrand:Bool? // specifically for brand
    let filterValueDict:[String: Any]!
    var colorCode:String? = nil
    
    init(_ dict: [String: Any]) {
        if let color = dict["color_code"] as? String {
            colorCode = color
        }
        if let filterId = dict["id"] as? Int {
            filterValueID = filterId
        }else if let filterId = dict["id"] as? String {
            filterValueID = filterId
        }
        name = dict["name"] as? String
        count = dict["count"] as? Int
        minPrice = dict["min"] as? Int
        maxPrice = dict["max"] as? Int
        filterValuePrefix = dict["filter_value_prefix"] as? String
        isPopularBrand = dict["popular"] as? Bool
        filterValueDict = dict
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = SFFilterValue(filterValueDict)
        return copy
    }
}

public class SFSortingValue: NSObject {
    var name: String?
    var urlParam: String?
    var defaultValue: String?
    
    // Internal Vars
    var isSelected: Bool = false
    
    init(_ dict: [String: Any]) {
        name = dict["name"] as? String
        urlParam = dict["urlParams"] as? String
        defaultValue = dict["default"] as? String
    }
}
