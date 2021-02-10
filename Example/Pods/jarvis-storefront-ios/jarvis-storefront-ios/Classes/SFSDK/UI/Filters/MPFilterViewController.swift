//
//  MPFilterViewController.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 22/07/19.
//

import UIKit
import jarvis_utility_ios
public class MPFilterViewController: UIViewController {
    @IBOutlet weak private var shadowView: UIView!{
        didSet{
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: -1);
            shadowView.layer.shadowOpacity = 0.1
            let shadowPath: UIBezierPath = UIBezierPath(roundedRect: shadowView.layer.bounds, cornerRadius: 0)
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    private var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var applyButton: UIButton!{
        didSet{
            applyButton.layer.cornerRadius = 6
            applyButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak private var filterValuesTableView: UITableView!{
        didSet{
            filterValuesTableView.estimatedRowHeight = 100
            filterValuesTableView.rowHeight = UITableView.automaticDimension
            filterValuesTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak private var filterKeyTableView: UITableView!{
        didSet{
            filterKeyTableView.estimatedRowHeight = 100
            filterKeyTableView.rowHeight = 40
            filterKeyTableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet private var searchView: MPFilterSearchView!
    public var filterViewModel:MPFilterVM!
    public var applyFiltersOnItem:((SFLayoutItem) -> Void)?
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        viewModelBlockConfiguration()
        searchBarBlockConfiguration()
    }
    
    @IBAction func clearAllClicked(_ sender: Any){
        filterViewModel.clearAllTappedFilters()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        filterViewModel.applyFilterAndModifySeoUrl()
        applyFiltersOnItem?(filterViewModel.selectedItem)
        self.dismiss(animated: true, completion: nil)
    }
    
    public static func getFilterVC() -> MPFilterViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "MPFilter", bundle: Bundle.sfBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filterVC") as! MPFilterViewController
        return vc
    }
}

//MARK: Table View Dele
extension MPFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func brandSectionViewFor(section:Int) -> UIView?{
        let view = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 42))
        view.backgroundColor = UIColor.white
        let label = UILabel.init(frame: CGRect(x: 12.0, y: 0.0, width: 150, height: 50))
        if section == 1 {
            label.text = SFConstants.brandFilterPopular
        }else {
            label.text =  SFConstants.brandFilterOther
        }
        let seperator = UILabel.init(frame: CGRect(x: 12.0, y: 45.0, width: UIScreen.main.bounds.size.width, height: 0.5))
        seperator.backgroundColor = UIColor(hex: "BFC5CB")
        view.addSubview(seperator)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        view.addSubview(label)
        return view
    }
    
    public func tableView(_ tableView:UITableView,viewForHeaderInSection section: Int )-> UIView? {
        if tableView == filterValuesTableView {
            if section == 0 {
                if filterViewModel.shouldShowTableSearch{
                    return searchView
                }
            }else {
               if let filter = (filterViewModel.filtersToDisplay[existed:filterViewModel.selectedFilterKeyIndex])?.filterParam, filter == SFFilterParam.brand.rawValue  {
                    return brandSectionViewFor(section: section)
                }
            }
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)-> CGFloat {
        if tableView == filterValuesTableView && filterViewModel.shouldShowTableSearch {
            return 50
        }else if tableView == filterValuesTableView && section > 0 {
             return 50
        }
        return 0.0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filterKeyTableView {
            return filterViewModel.numberOfFilterKeyRows
        } else {
            return filterViewModel.numberOfFilterValueRowsForFilter(index: filterViewModel.selectedFilterKeyIndex,section: section)
        }
   }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filterKeyTableView {
            if let filterKeyCell =  tableView.dequeueReusableCell(withIdentifier: filterViewModel.getFilterKeyCellReueseId()) as? MPFilterKeyCell {
                filterKeyCell.configureKey(filter: filterViewModel.filtersToDisplay[indexPath.section])
                filterKeyCell.setCellSelectionState(selected: (indexPath.section == filterViewModel.selectedFilterKeyIndex))
                return filterKeyCell
            }
        }else if tableView == filterValuesTableView{
            if let identifier = filterViewModel.getFilterValueCellReuseIdForFilter(index: filterViewModel.selectedFilterKeyIndex){
                switch(identifier) {
                case MPFilterValueResueIdentifier.filterValueLinearRectangular:
                    if let linearRectCell = tableView.dequeueReusableCell(withIdentifier:identifier.rawValue) as? MPFilterValueLinearRectCell {
                        if let filter = filterViewModel.filtersToDisplay[existed: filterViewModel.selectedFilterKeyIndex] {
                            if filter.isSearchActive {
                                linearRectCell.configureCell(value: filter.filteredValues[existed:indexPath.row])
                            }else {
                                if filter.filterParam == SFFilterParam.brand.rawValue {
                                    return configureBrandCell(linearRectCell: linearRectCell, indexPath: indexPath, filter: filter)
                                }else {
                                    linearRectCell.configureCell(value: filter.values[existed:indexPath.row])
                                }
                            }
                        }
                        return linearRectCell
                    }
                    
                case MPFilterValueResueIdentifier.filterValueCategoryTreeCell:
                    if let treeCell = tableView.dequeueReusableCell(withIdentifier:identifier.rawValue) as? MPFilterValueCategoryTreeCell {
                        if let filter = filterViewModel.filtersToDisplay[existed: filterViewModel.selectedFilterKeyIndex] {
                            if let appliedFilters = filter.appliedCategoryTreeNode , appliedFilters.count > 0 {
                                treeCell.configureCell(treeNode: appliedFilters.last?.completeListToDisplay[existed:indexPath.row],filter:filter)
                                treeCell.crossClickedblock = { [weak self] (node) in
                                    if node.parent != nil {
                                        self?.filterViewModel.selectionDoneOnTreeCategory(index: indexPath, filter: filter, selectedNode: node.parent!)
                                    }
                                    
                                }
                            }else{
                                treeCell.configureCell(treeNode: filter.categoryTreeParent?.children[existed:indexPath.row],filter:filter)
                            }
                        }
                        return treeCell
                    }
                    
                case MPFilterValueResueIdentifier.filterValuePriceCell:
                    if let priceCell = tableView.dequeueReusableCell(withIdentifier:identifier.rawValue) as? MPFilterValuePriceCell {
                        if let filter = filterViewModel.filtersToDisplay[existed: filterViewModel.selectedFilterKeyIndex] {
                            priceCell.configurePriceCell(filter: filter)
                            priceCell.priceValueUpdatedBlock = {[weak self] (minPrice, maxPrice) in
                                self?.filterViewModel.priceValueSelected(min: minPrice, max: maxPrice)
                            }
                            priceCell.showAlert = { [weak self] (message) in
                                self?.showAlert(message)
                                priceCell.configurePriceCell(filter: filter)
                            }
                        }
                        return priceCell
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    private func configureBrandCell(linearRectCell:MPFilterValueLinearRectCell , indexPath:IndexPath, filter: SFFilter) -> MPFilterValueLinearRectCell {
        var index = indexPath.row
        if indexPath.section == MPBrandFilterSection.otherBrand.rawValue {
            index = filter.popularbrandsCount + indexPath.row
        }
        linearRectCell.configureCell(value: filter.values[existed:index])
        return linearRectCell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == filterKeyTableView {
            return filterViewModel.numberOfFilterKeySections
        }else {
            return filterViewModel.numberOfFilterValueSections
        }
    }
    
    public func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        if tableView == filterKeyTableView {
            if indexPath.section == filterViewModel?.selectedFilterKeyIndex{
                return
            }
            filterViewModel.checkAndRefreshFilters(section: indexPath.section)
            if let filterTitle = (filterViewModel.filtersToDisplay[existed:filterViewModel.selectedFilterKeyIndex])?.title {
                searchView.setPlaceholder(filterTitle)
            }
            
            if let filterType = (filterViewModel.filtersToDisplay[existed:filterViewModel.selectedFilterKeyIndex])?.filterType , filterType == .rangeSlider {
               filterValuesTableView.separatorStyle = .none
            }else {
                filterValuesTableView.separatorStyle = .singleLine
            }
            
            
        }else if tableView == filterValuesTableView {
            if let filter = filterViewModel.filtersToDisplay[existed: filterViewModel.selectedFilterKeyIndex], filter.filterType == .tree {
                if let appliedNode = filter.appliedCategoryTreeNode?.last {
                    let selectedNode = appliedNode.completeListToDisplay[indexPath.row]
                    if selectedNode.showCross == true {
                        return
                    }
                    filterViewModel.selectionDoneOnTreeCategory(index: indexPath, filter: filter, selectedNode: selectedNode)
                }else{
                    if let selectedNode = filter.categoryTreeParent?.children[indexPath.row]{
                        filterViewModel.selectionDoneOnTreeCategory(index: indexPath, filter: filter, selectedNode: selectedNode)
                    }
                }
            }else {
                filterViewModel.setFilterValueSelected(index: indexPath)
            }
        }
    }
}

//Mark: View Model Block Implementation
extension MPFilterViewController{
    private func viewModelBlockConfiguration(){
        filterViewModel.reloadFilter = { [weak self] in
            self?.searchView.hideKeyBoard()
            self?.filterValuesTableView.setContentOffset(.zero, animated: true)
            if let selectedFilterKeyIndex = self?.filterViewModel.selectedFilterKeyIndex, let filter = self?.filterViewModel.filtersToDisplay[existed: selectedFilterKeyIndex], filter.filterType == .linearRectangular {
                var positionToIndex:Int = 0
                if let numberOfSection = self?.filterViewModel.numberOfFilterValueSections {
                    if numberOfSection > 1 {
                        positionToIndex = numberOfSection
                    }
                }
                if let index = self?.filterViewModel.selectedFilterKeyIndex , let noOfFilters = self?.filterViewModel.numberOfFilterValueRowsForFilter(index: index,section: positionToIndex) {
                    
                    if noOfFilters <= 10 {
                        self?.filterViewModel.shouldShowTableSearch = false
                    }
                    else {
                        self?.filterViewModel.shouldShowTableSearch = true
                    }
                }
            }
            
            self?.filterKeyTableView.reloadData()
            self?.filterValuesTableView.reloadData()
            if let numberOfSection = self?.filterViewModel.numberOfFilterValueSections {
                if numberOfSection > 1 {
                    let topIndex = IndexPath(row: 0, section: 1)
                    self?.filterValuesTableView.scrollToRow(at: topIndex, at: .middle, animated: true)
                }else if (numberOfSection > 0 && self?.filterValuesTableView.numberOfRows(inSection: 0) ?? 0 > 0) {
                    let topIndex = IndexPath(row: 0, section: 0)
                    self?.filterValuesTableView.scrollToRow(at: topIndex, at: .top, animated: true)
                }
            }
        }
        
        filterViewModel.reloadFiltervalueRow = { [weak self] (section,row) in
            let indexPathToReload = IndexPath(row: row, section: section)
            self?.filterValuesTableView?.reloadRows(at: [indexPathToReload], with: .automatic)
        }
        filterViewModel.showIndicator  = {[weak self] in
            self?.showActivityIndicatorInCenter()
        }
        filterViewModel.hideIndicator  = {[weak self] in
            self?.hideActivityIndicator()
        }
    }
}

//MARK: Search Bar Block Implementation
extension MPFilterViewController {
    private func searchBarBlockConfiguration(){
        searchView.refreshListWithSearchText = {[weak self] (searchText) in
            self?.filterViewModel.createFilteredListForSearchText(searchText)
            self?.filterValuesTableView.reloadData()
        }
    }
}

// Activity indicator
extension MPFilterViewController {
    func configureActivityIndicator() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activityIndicator!.style = .gray
            activityIndicator!.hidesWhenStopped = true
        }
    }
    
    func showActivityIndicatorInCenter() {
        if let indicator = activityIndicator {
            self.view.bringSubviewToFront(indicator)
            indicator.center = self.view.center
            self.view.addSubview(indicator)
            indicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
    }
}
