//
//  MPFilterVM.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 23/07/19.
//

import UIKit

public class MPFilterVM: NSObject {
    
    private(set) var filtersToDisplay: [SFFilter] = [SFFilter]()
    var shouldShowTableSearch:Bool = false
    var reloadFilter: (() -> Void)?
    var reloadFiltervalueRow: ((Int, Int) -> Void)?
    public var selectedItem: SFLayoutItem!{
        didSet{
            selectedItem.filterUrl = selectedItem.itemSeoUrl
        }
    }
    private var userActionPerformedRows:[Int:[Int]] =  [Int:[Int]]()
    private var needToConstructFilterUrl = true
    var showIndicator:(()-> (Void))?
    var hideIndicator:(()-> (Void))?
    private var lastSelectedFilterKeyIDBeforeReloadFilter:String?
    public var selectedFilterKeyIndex:Int = 0 {
        didSet{
            if let filter = filtersToDisplay[existed:selectedFilterKeyIndex] {
                shouldShowTableSearch = (filter.filterType == .linearRectangular)
                lastSelectedFilterKeyIDBeforeReloadFilter = filter.filterParam
            }
        }
    }
    
    var gridLayout: SFGridLayoutParser
    
    public init(gridlayout: SFGridLayoutParser) {
        gridLayout = gridlayout
        super.init()
        initialiseFilters()
    }
    
    private func initialiseFilters(){
        createFiltersToDisplay()
        checkSelectedFiltersAndApply()
    }
    
    private func createFiltersToDisplay(){
        
        let truncatedFilterArray = gridLayout.filters.filter { $0.filterType != .unknown && $0.filterType != .boolean && $0.values.count > 0 }
        let truncatedFrontEndFilterArray = gridLayout.frontendFilters.filter { $0.categoryTreeParent != nil }
        let copyArr = truncatedFrontEndFilterArray + truncatedFilterArray
        if copyArr.count > 0 {
            filtersToDisplay = copyArr.map{$0.copy()} as! [SFFilter]
        }
    }
    
    private func checkSelectedFiltersAndApply() {
        for (index,filter) in filtersToDisplay.enumerated() {
            if filter.filterParam == lastSelectedFilterKeyIDBeforeReloadFilter {
                selectedFilterKeyIndex = index
            }
            switch(filter.filterType) {
            case .linearRectangular: for filterValue in filter.values {
                if SFFilter.ifFilterExistInAppliedFilter(value:filterValue.filterValueID ,appliedFiltersArray:filter.appliedFiltersArray){
                    filterValue.isSelected = true
                    filter.selectedFilteredValues.append(filterValue)
                }
                }
            case .rangeSlider:
                filter.selectedFilteredValues = filter.appliedFiltersArray
            case .tree:
                if let url = selectedItem?.filterUrl, let filterParam = filter.filterParam{
                    var isValuePresent: Bool = false
                    let queryParams = url.getQueryStringParameter(param: filterParam)
                    var array = queryParams.components(separatedBy: ",")
                    for valueInUrl in array {
                        isValuePresent = false
                        if let allAppliedNodes = filter.appliedCategoryTreeNode {
                            for nodes in allAppliedNodes  {
                                if let filterID = nodes.filterValueID {
                                    if valueInUrl == String(describing: filterID){
                                        isValuePresent = true
                                        break
                                    }
                                }
                            }
                            if !isValuePresent {
                                array.removeObject(valueInUrl)
                            }
                        }
                    }
                    if array.count == 0 {
                        if let allAppliedNodes = filter.appliedCategoryTreeNode, allAppliedNodes.count > 0 , let selectedNodeValue = allAppliedNodes.last {
                            if let filterID = selectedNodeValue.catParentID {
                                array.append(String(describing: filterID))
                            }
                        }
                    }
                    let newQueryparam = array.count > 0 && (array.first != "") ? array.joined(separator:",") : nil
                    let filterDict = [filterParam:newQueryparam]
                    if let url = URL(string: url) {
                        let modifiedUrl = url.appendingQueryItems(filterDict)
                        selectedItem?.filterUrl = modifiedUrl
                    }
                }
            default: break
            }
        }
    }
    
    func clearAllTappedFilters() {
        guard let urlString: String = selectedItem.originalGridItemSeoUrl, let url: URL = URL(string: urlString) else {
            return
        }
        selectedFilterKeyIndex = 0
        selectedItem?.filterUrl = selectedItem.originalGridItemSeoUrl
        fetchFiltersFromServerAndRefreshView(url)
    }
    
    private func fetchFiltersFromServerAndRefreshView(_ url:URL){
        let completeContextDetails = SFManager.shared.interactor?.getCompleteAppContext()
        // QueryParam
        var queryParam: [String: Any] = ["noProducts" : 1]
        if let userId = completeContextDetails?["user_id"] as? String {
            queryParam["user_id"] = userId
        }
        
        let modifiedUrl = url.appendingQueryItems(queryParam)
        
        //Headers
        var headers: [String: String]?
        if let ssoToken = completeContextDetails?["sso_token"] as? String {
            headers = [String: String]()
            headers?["sso_token"] = ssoToken
        }
        
        // Body param
        var bodyParam: [String: Any]?
        if modifiedUrl.contain(subStr: "api_type=re") {
            bodyParam = SFManager.shared.interactor?.getRecmendedBodyDetail() ?? [String: Any]()
            if let url = URL(string: modifiedUrl), let queryDict = url.queryItemsDictionary, let currentPage = queryDict["current_page"] {
                bodyParam?["custom"] = ["current_page": currentPage]
            }
            else {
                bodyParam?["custom"] = ["current_page": "grid"]
            }
        }
        else {
            bodyParam = SFManager.shared.interactor?.getBodyDetail()
        }

        showIndicator?()
        SFInfGridApiManager.sharedInstance.fetch(modifiedUrl, method: "POST", headers: headers, bodyParams: bodyParam) { [weak self] (result, error) in
            if error == nil, let json = result as? [String: Any] {
                self?.hideIndicator?()
                self?.needToConstructFilterUrl = false
                let gridParser: SFGridLayoutParser = SFGridLayoutParser(json)
                self?.gridLayout = gridParser
                self?.initialiseFilters()
                self?.reloadFilter?()
                self?.userActionPerformedRows.removeAll()
            }
        }
    }
    
    func checkAndRefreshFilters(section:Int) {
        selectedFilterKeyIndex = section
        if shouldPerformNetworkRequest() {
            constructFilterUrlForSelectedItem()
            if let urlString  = selectedItem?.filterUrl , let url = URL(string: urlString){
                needToConstructFilterUrl = false
                fetchFiltersFromServerAndRefreshView(url)
            }
        }else {
            reloadFilter?()
        }
    }
    
    private func shouldPerformNetworkRequest() -> Bool {
        return userActionPerformedRows.keys.count > 0
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (existed index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


// Filter Key Table View Data Source
extension MPFilterVM {
    
    var numberOfFilterKeySections:Int {
        return filtersToDisplay.count
    }
    var numberOfFilterKeyRows:Int {
        return 1
    }
    
    func getFilterKeyCellReueseId() -> String {
        return "filterKeyCell"
    }
}

// Filter Value Table View Data Source
extension MPFilterVM {
    var numberOfFilterValueSections:Int {
        if let selectedFilter: SFFilter = filtersToDisplay[existed: selectedFilterKeyIndex]{
            return MPFilterLayoutHelper.numberOfSectionsforFilter(selectedFilter)
        }
        return 0
    }
    
    func numberOfFilterValueRowsForFilter(index :Int, section: Int) -> Int{
        if let selectedFilter: SFFilter = filtersToDisplay[existed: index]{
            return MPFilterLayoutHelper.numberOfRowsforFilter(selectedFilter,section:section )
        }
        return 0
    }
    
    func getFilterValueCellReuseIdForFilter(index :Int) -> MPFilterValueResueIdentifier? {
        if let selectedFilter: SFFilter = filtersToDisplay[existed: index] {
            return MPFilterLayoutHelper.cellIdentifierForFilter(selectedFilter)
        }
        return nil
    }
}

//Search Functionality on Filters
extension MPFilterVM {
    
    func createFilteredListForSearchText(_ searchText:String?) {
        if let filter = filtersToDisplay[existed:selectedFilterKeyIndex] {
            if let searchText = searchText, searchText.count > 0 {
                filter.isSearchActive = true
                switch(searchText.count){
                case _ where searchText.count < 3 : filter.filteredValues =  filter.values.filter() {$0.name?.lowercased().beginsWith(searchText.lowercased()) == true}
                default : filter.filteredValues = filter.values.filter() {$0.name?.lowercased().contains(searchText.lowercased()) == true}
                }
            } else  {
                filter.isSearchActive = false
            }
        }
    }
    
    func setFilterValueSelected(index:IndexPath){
        if let filter = filtersToDisplay[existed:selectedFilterKeyIndex] {
            needToConstructFilterUrl = true
            var indexForValue:Int = index.row
            if filter.filterType == SFFilterType.tree {
               // selectionDoneOnTreeCategory(index: index, filter: filter)
            }
            if filter.filterParam == SFFilterParam.brand.rawValue && filter.isSearchActive == false {
                indexForValue = indexForBrand(indexPath: index,filter: filter)
            }
            if let value = filter.isSearchActive ? filter.filteredValues[existed:index.row] : filter.values[existed:indexForValue]{
                value.isSelected = !value.isSelected
                if value.isSelected {
                    filter.selectedFilteredValues.append(value)
                }else {
                    filter.selectedFilteredValues.removeObject(value)
                }
                reloadFiltervalueRow?(index.section,index.row)
            }
            updateUserActionRowData(index:index.row)
        }
    }
    
    func selectionDoneOnTreeCategory(index:IndexPath, filter: SFFilter, selectedNode: SFFilterTreeCategoryNode?){
        if let selectedNodeValue = selectedNode{
            needToConstructFilterUrl = true
            selectedNodeValue.isSelected = !selectedNodeValue.isSelected
            updateUserActionRowData(index:index.row)
            if selectedNodeValue.isSelected {
                filter.selectedTreeFilteredValues.append(selectedNodeValue)
            }else {
                filter.selectedTreeFilteredValues.removeObject(selectedNodeValue)
                if let url = selectedItem?.filterUrl ,let filterParam = filter.filterParam , let filterID = selectedNodeValue.filterValueID{
                    let queryParams = url.getQueryStringParameter(param: filterParam)
                    var array = queryParams.components(separatedBy: ",")
                    array.removeObject(String(describing: filterID))
                    if array.count == 0 {
                        if let filterID = selectedNodeValue.catParentID {
                            array.append(String(describing: filterID))
                        }
                    }
                    let newQueryparam = array.count > 0 && (array.first != "") ? array.joined(separator:",") : nil
                    let filterDict = [filterParam:newQueryparam]
                    if let url = URL(string: url) {
                        let modifiedUrl = url.appendingQueryItems(filterDict)
                        selectedItem?.filterUrl = modifiedUrl
                        if let urlString  = selectedItem?.filterUrl , let url = URL(string: urlString){
                            fetchFiltersFromServerAndRefreshView(url)
                        }
                        return
                    }
                }
            }
            checkAndRefreshFilters(section: index.section)
        }
    }
    private func indexForBrand(indexPath:IndexPath, filter: SFFilter) -> Int {
        if indexPath.section == MPBrandFilterSection.otherBrand.rawValue {
            return indexPath.row +  filter.popularbrandsCount
        }
        return indexPath.row
    }
    
    // Method to store the activity on each row
    //userActionPerformedRows : Tells the row numbers on which new acitivty has been performed
    private func updateUserActionRowData(index:Int){
        if let selectedRowArray = userActionPerformedRows[selectedFilterKeyIndex] ,selectedRowArray.count > 0  {
            
            var updatedSelectedRowArray = selectedRowArray
            if selectedRowArray.contains(index){
                updatedSelectedRowArray.removeObject(index)
            }else {
                updatedSelectedRowArray.append(index)
            }
            userActionPerformedRows[selectedFilterKeyIndex] = updatedSelectedRowArray
            if updatedSelectedRowArray.count == 0 {
                userActionPerformedRows.removeValue(forKey: index)
            }
        } else{
            let rowArray = [index]
            userActionPerformedRows[selectedFilterKeyIndex] = rowArray
        }
    }
}

// MARK: Filter URL construction
extension MPFilterVM {
    func applyFilterAndModifySeoUrl() {
        if needToConstructFilterUrl {
            constructFilterUrlForSelectedItem()
        }
        selectedItem?.itemSeoUrl = selectedItem?.filterUrl ?? ""
        selectedItem?.gridItemPageCount = 1
    }
    
    private func constructFilterUrlForSelectedItem(){
        for filter in filtersToDisplay {
            switch filter.filterType {
            case .linearRectangular: selectedItem?.filterUrl = urlForLinearRectFilters(filter: filter) ?? selectedItem?.filterUrl
            case .rangeSlider: selectedItem?.filterUrl = urlForRangeSliderFilters(filter: filter) ?? selectedItem?.filterUrl
            case .tree: selectedItem?.filterUrl = urlForTreeCategoryFilter(filter: filter) ?? selectedItem?.filterUrl
            default: break
            }
        }
    }
    
    private func urlForTreeCategoryFilter(filter: SFFilter) -> String? {
        if let filterParam = filter.filterParam {
            var appendNewNodes:Bool = false
            var queryParams:String = ""
            if let node = filter.selectedTreeFilteredValues.last {
                if node.isLeafNode{
                    // append the category ID in server filrer
                    if let appliedNodes = filter.appliedCategoryTreeNode , appliedNodes.count > 0,let alreadyAppliedNode = appliedNodes.last {
                        if alreadyAppliedNode.isLeafNode {
                            appendNewNodes = true
                        }
                    }
                    if let url = selectedItem?.filterUrl  , let nodeID = node.filterValueID {
                        queryParams = url.getQueryStringParameter(param: filterParam)
                        if queryParams.length > 0 && appendNewNodes {
                            queryParams = queryParams + "," + String(describing: nodeID)
                        }else {
                            queryParams = String(describing: nodeID)
                        }
                    }
                }else {
                    if let filterID = node.filterValueID {
                        queryParams = String(describing: filterID)
                    }
                }
                return addRemoveQueryParam(queryParams,filterParam: filterParam)
            }
        }
        return nil
    }
    
    private func urlForRangeSliderFilters(filter: SFFilter) -> String? {
        if let filterParam = filter.filterParam {
            var queryParams:String = ""
            for values in filter.selectedFilteredValues {
                if let minPrice = values.minPrice, let maxPrice = values.maxPrice{
                    queryParams = "\(minPrice),\(maxPrice)"
                }
            }
            return addRemoveQueryParam(queryParams,filterParam: filterParam)
        }
        return nil
    }
    
    private func urlForLinearRectFilters(filter: SFFilter) -> String? {
        if let filterParam = filter.filterParam {
            var queryParams:String = ""
            for values in filter.selectedFilteredValues {
                if let id = values.filterValueID{
                    if queryParams.count == 0 {
                        queryParams = String(describing: id)
                    } else {
                        queryParams = queryParams + "," + String(describing: id)
                    }
                }
            }
            return addRemoveQueryParam(queryParams, filterParam:filterParam)
        }
        return nil
    }
    
    private func addRemoveQueryParam(_ queryParams: String,filterParam: String) -> String?{
        var filterQueryDict = [String:Any?]()
        if queryParams.count > 0 {
            filterQueryDict[filterParam] = queryParams
        }else {
            filterQueryDict = [filterParam: nil]
        }
        return constructFilterUrl(with: filterQueryDict)
    }
    
    private func constructFilterUrl(with filterDict: [String:Any?])-> String? {
        if let urlString = selectedItem?.filterUrl , let url = URL(string: urlString) {
            let modifiedUrl = url.appendingQueryItems(filterDict)
            return modifiedUrl
        }
        return nil
    }
}

// MARK: Price value updation
extension MPFilterVM {
    func priceValueSelected(min:Int , max : Int) {
        if let filter = filtersToDisplay[existed:selectedFilterKeyIndex] {
            if filter.filterType == .rangeSlider {
                let value = SFFilterValue(["min": min, "max" : max])
                filter.selectedFilteredValues = [value]
            }
            userActionPerformedRows[selectedFilterKeyIndex] = [1]
            checkAndRefreshFilters(section: selectedFilterKeyIndex)
        }
    }
}
