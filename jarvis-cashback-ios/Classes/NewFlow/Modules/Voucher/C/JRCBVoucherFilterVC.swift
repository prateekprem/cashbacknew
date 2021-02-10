//
//  JRCBVoucherFilterVC.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 05/08/20.
//

import UIKit

protocol JRCOVoucherFilterProtocol {
    func selectedfilters(categoryId: String, active_Or_ExpiredId: String, active_Or_ExpiredName: String)
}

class JRCBVoucherFilterVC: JRCBBaseVC {
    
    @IBOutlet weak private var table: UITableView!
    @IBOutlet weak private var resetBtn: UIButton!
    @IBOutlet weak private var submitBtn: UIButton!
    @IBOutlet weak private var headerTitle: UILabel!

    
    var filterListViewModel: JRCOVoucherFilterVM!
    var delegate: JRCOVoucherFilterProtocol?
    
   
    class var newInstance : JRCBVoucherFilterVC {
        return JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBVoucherFilterVC") as! JRCBVoucherFilterVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if JRCBManager.userMode == .Merchant {
            headerTitle.text = "jr_CB_Filters".localized
        }
        else {
            headerTitle.text = "jr_CB_Deal_Voucher_Filters".localized
        }
        
        table.estimatedRowHeight = 62
        table.rowHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 52
        
        let nibName = UINib(nibName: "JRCOVoucherFilterHeader", bundle: Bundle.cbBundle)
        table.register(nibName, forHeaderFooterViewReuseIdentifier: "JRCOVoucherFilterHeader")
        resetBtn.roundCorner(1, UIColor(hex: "00C4FF"), 8, true)
        submitBtn.roundCorner(0, nil, 8, true)
    }
    
    @IBAction func closeClisked(_ sender: UIButton) {
        filterListViewModel.resetNotAppliedFilters()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: UIButton) {
        filterListViewModel.resetAllFilters()
        filterListViewModel.setAppliedFilters()
        delegate?.selectedfilters(categoryId: filterListViewModel.getSelectedcategoryId(), active_Or_ExpiredId: filterListViewModel.active_Or_Expired_FilterID, active_Or_ExpiredName: filterListViewModel.active_Or_Expired_FilterName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        let labelsArray = ["event_label": "",
                           "event_label2": JRCOConstant.GA_SCREENTYPE_MYVOUCHER,
                           "event_label3": ""]
        JRCBAnalytics(screen: .screen_CashbackOfferVouchersListing, vertical: .vertical_MyVoucherCashback,
                      eventType: .eventCustom, category: .cat_MyVoucher,
                      action: .act_ApplyFilterClicked, labels: labelsArray).track()
        
        filterListViewModel.setAppliedFilters()
        
        delegate?.selectedfilters(categoryId: filterListViewModel.getSelectedcategoryId(), active_Or_ExpiredId: filterListViewModel.active_Or_Expired_FilterID, active_Or_ExpiredName: filterListViewModel.active_Or_Expired_FilterName)
        self.dismiss(animated: true, completion: nil)
    }
}


extension JRCBVoucherFilterVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterListViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterListViewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let secData = filterListViewModel.sectionDataSource[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: JRCBVoucherFilterCell.cellId, for: indexPath) as! JRCBVoucherFilterCell
        cell.show(data: secData.filterList[indexPath.row], selType: secData.filterType)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if filterListViewModel.showHeader(section: section) {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JRCOVoucherFilterHeader") as! JRCOVoucherFilterHeader
            headerView.set(title: filterListViewModel.sectionDataSource[section].displayName)
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if filterListViewModel.showHeader(section: section) { return UITableView.automaticDimension }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secData = filterListViewModel.sectionDataSource[indexPath.section]
        let cellData = secData.filterList[indexPath.row]
        
        if secData.filterType == .MultiSelect {
            cellData.setFilterData(isSelected: !cellData.isSelected)
            UIView.performWithoutAnimation {
                self.table.reloadRows(at: [indexPath], with: .none)
            }
        } else {
            UIView.performWithoutAnimation {
                filterListViewModel.sectionDataSource[indexPath.section].resetOtherIndexes(ids: cellData.id, completion: {[weak self] in
                    self?.table.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                })
            }
            cellData.setFilterData(isSelected: true)
        }
    }
}

// MARK: - JRCBVoucherFilterCell
class JRCBVoucherFilterCell: UITableViewCell {
    @IBOutlet weak private var checkImageV: UIImageView!
    @IBOutlet weak private var filterNmLbl: UILabel!
    
    class var cellId:  String { return "kJRCBVoucherFilterCell" }
        
    func show(data: JRCOFilterList, selType: FilterSelectionType) {
        filterNmLbl.text = data.filterName
        let selected = data.isSelected
        
        if selType == .MultiSelect {
            let imageNm = selected ? "checkBoxFilledCO" : "checkBoxUnFilledCO"
            checkImageV.image = UIImage.imageWith(name: imageNm)
            
        } else {
            let imageNm = selected ? "radioActiveCO" : "radioUnselectCO"
            checkImageV.image = UIImage.imageWith(name: imageNm)
        }
    }
}

