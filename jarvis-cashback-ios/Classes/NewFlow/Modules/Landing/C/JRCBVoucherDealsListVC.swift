//
//  JRCBVoucherDealsListVC.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 13/08/20.
//

import UIKit

class JRCBVoucherDealsListVC: JRCBStrechableHeaderGridBaseVC {

    @IBOutlet weak private var statusV: UIView!
    // nav
    @IBOutlet weak private var navInsideV: UIView!
    @IBOutlet weak private var navTitleLbl: UILabel!
    @IBOutlet weak private var segmentCntVH: NSLayoutConstraint!
    @IBOutlet weak private var dotImageView: UIImageView! {
        didSet {
            dotImageView.roundedCorners(radius: 5.5)
        }
    }

    @IBOutlet weak var customSegmentControl: CustomSegmentedControl!{
        didSet{
            customSegmentControl.setButtonTitles(buttonTitles: ["jr_CB_Active".localized,"jr_CB_Expire".localized])
            customSegmentControl.selectorViewColor = UIColor.init(red: 74, green: 171, blue: 231)
            customSegmentControl.selectorTextColor = UIColor.init(red: 32, green: 47, blue: 81)
            customSegmentControl.textColor = UIColor.init(red: 150, green: 169, blue: 190)
            if let font =  UIFont(name: "Helvetica-Bold", size: 16.0)  {
                customSegmentControl.setButtonFont(buttonFont: font)
            }
            
            customSegmentControl.setIndex(index: 0)
            
        }
    }
    private let buttonBar = UIView()

    //Filter...
    private var selectedFilterIds: String = ""
    private var showExpiredVouchers: String = ""
    private var isFilterApplied = false

    
    @IBOutlet weak private var btnFilter: UIButton!
    
    
    private var gridHeader: JRCBVoucherDealListHeaderV?
    @IBOutlet weak private var collectV   : UICollectionView!
    @IBOutlet weak private var emptyView: UIView!
    @IBOutlet weak private var emptyLabel: UILabel!
    
    private let voucherVModel = JRCBGridViewModel()
    private var dealVModel = JRCBGridViewModel()
    private let expiredvoucherVModel = JRCBGridViewModel()

    var gridType: JRCBGridViewType = .tVouchers
    
    private let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
    
    class var newInstance : JRCBVoucherDealsListVC {
        return JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBVoucherDealsListVC") as! JRCBVoucherDealsListVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerH = 270
        customSegmentControl.delegate = self
        voucherVModel.setGrid(type: .tVouchers)
        voucherVModel.setHeader(info: voucherVModel.gridType.defaultHeaderInfo)
        
         expiredvoucherVModel.setGrid(type: .tExpiredVoucher)
        
        emptyView.isHidden = true
        self.getViewModel().set(param: self.pageParam)
        collectV.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (collectV.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectV.bounds.width, height: 50)
        
        self.collectV.register(Bundle.nibWith(name: JRCBGridVoucherCollCell.identifier), forCellWithReuseIdentifier: JRCBGridVoucherCollCell.identifier)
        
        self.updateHeader()
        
        if let collLayout = collectV.collectionViewLayout as? JRCBGridCollFlowLayout {
            collLayout.maxHeight += 90
            collLayout.totalHeight += 90
        }
        
        showLoaderAnimation()
        fetchDataCall()
        
        
    }
    
    @IBAction func btnFilterAction(_ sender: Any) {
        self.btnFIlterClicked()
    }
    
    
    func segmentControlChanged(index: Int) {
        let sIndex = index
        
        self.gridType = sIndex == 0 ? .tVouchers :.tExpiredVoucher
        customSegmentControl.setIndex(index: sIndex)
        self.gridHeader?.updateSegmentIndex(index: sIndex)
        
        if sIndex == 0 {
            getViewModel().showExpiredVouchers  =  VoucherStatus.active.statusId
            
        } else {
            getViewModel().showExpiredVouchers  =  VoucherStatus.expired.statusId
        }
        self.showExpiredVouchers = getViewModel().showExpiredVouchers
        
        if self.getViewModel().dataSource.count == 0, !self.getViewModel().apiHitCompleted {
            
            if self.gridType == .tExpiredVoucher {
                expiredvoucherVModel.filterViewModel = voucherVModel.filterViewModel
            }
            else {
                voucherVModel.filterViewModel = expiredvoucherVModel.filterViewModel
            }
            getViewModel().selectedFilterIds = self.selectedFilterIds
            getViewModel().showExpiredVouchers = self.showExpiredVouchers
            self.fetchDataCall()
        }

        else  if isFilterApplied {
            applyFilter()
            isFilterApplied = false
        }
        
        self.reloadPageData(errMsg: nil)
    }
        
    func btnFIlterClicked() {
        if getViewModel().filterViewModel.sectionDataSource.count == 0 {
            getFilters()
        } else {
            pushFilterScreen()
        }
    }
    
    private func updateHeader() {
        let hDisplay = voucherVModel.headerDisplay
        self.segmentCntVH.constant = 70
        self.statusV.backgroundColor = UIColor.Grid.headerBlue
        self.navInsideV.backgroundColor = UIColor.Grid.headerBlue
        
        let subTitleStr = hDisplay.subTtl.replacingOccurrences(of: "\n", with: " ")
        self.navTitleLbl.text = subTitleStr
        self.emptyLabel.text = self.getViewModel().emptyText
    }
        
    // MARK: - API Hit Fetch Data
    private func fetchDataCall(isNextPageAPI: Bool = false) {
        if isNextPageAPI {
            self.footerView.startAnimating()
        } else {
            startLoaderAnimation()
        }
        getViewModel().fetchData() {[weak self] (success, errMsg) in
            DispatchQueue.main.async {
                if isNextPageAPI {
                    self?.footerView.stopAnimating()
                } else {
                    self?.stopLoaderAnimation()
                }
                self?.reloadPageData(errMsg: errMsg)
            }
        }
    }
    
    
    private func reloadPageData(errMsg: String?) {
        let vm = self.getViewModel()
        
        if vm.apiInProgress {
            collectV.isScrollEnabled = false
            emptyView.isHidden = true
            return
        }
        
        if vm.dataSource.count > 0 {
            emptyView.isHidden = true
            
        } else {
            emptyView.isHidden = false
            self.view.bringSubviewToFront(emptyView)
            
            self.emptyLabel.text = vm.emptyText
            if let eMsg = errMsg, eMsg.count > 0 {
                emptyLabel.text = eMsg
            }
        }
        
        collectV.isScrollEnabled = true
       
        collectV.reloadData()
        
    }
    
    private func getFilters() {
        getViewModel().filterViewModel.getFilterList(completion: { [weak self] (success, error) in
            DispatchQueue.main.async {
                if let error = error {
                    if !JRAlertPresenter.shared.presenting {
                        JRAlertPresenter.shared.presentSnackBar(title: error.title ?? "", message: error.message ?? JRCBConstants.Common.kDefaultErrorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                    }
                } else {
                    self?.pushFilterScreen()
                }
            }
        })
    }
    
    private func pushFilterScreen() {
        let labelsArray = ["event_label": "",
                           "event_label2": JRCOConstant.GA_SCREENTYPE_MYVOUCHER,
                           "event_label3": ""]
        
        JRCBAnalytics(screen: .screen_CashbackOfferVouchersListing, vertical: .vertical_MyVoucherCashback,
                      eventType: .eventCustom, category: .cat_MyVoucher,
                      action: .act_FilterClicked, labels: labelsArray).track()
        
         let vc =  JRCBVoucherFilterVC.newInstance
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.filterListViewModel = getViewModel().filterViewModel
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showLoaderAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.view.addSubview(animationView)
        animationView.center = self.view.center
    }

    private func stopLoaderAnimation() {
        animationView.stop()
        animationView.isHidden = true
    }
    
    private func startLoaderAnimation() {
        self.view.bringSubviewToFront(animationView)
        animationView.isHidden = false
        animationView.play()
    }
    
    private func getViewModel() -> JRCBGridViewModel {
        if self.gridType == .tExpiredVoucher  {
            return expiredvoucherVModel
        }
        else {
            return voucherVModel
        }
    }
    
    private func moveToScratchCarrosal(indexP: IndexPath, gratification: JRCBGratification, configIndex: Int = -1) {
        JRCBScratchCardContainerFullScreen.display(gratification: gratification, fromController: self)
    }
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension JRCBVoucherDealsListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getViewModel().dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JRCBGridVoucherCollCell.identifier, for: indexPath) as! JRCBGridVoucherCollCell
        if getViewModel().dataSource.count > indexPath.row {
            let bInfo = getViewModel().dataSource[indexPath.row]
             cell.loadData(info: bInfo)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if getViewModel().dataSource.count > indexPath.row {
            let baseInfo = getViewModel().dataSource[indexPath.row]
            switch self.gridType {
            case .tVouchers, .tExpiredVoucher:
                if let voucher = baseInfo.metaData as? JRCOVoucherListModel {
                    var input = JRCBVoucherDetailInput(promoCode: voucher.promocode, site_id: voucher.siteId ?? 0, client_id: voucher.client ?? "",type: voucher.redemptionType ?? "")
                    
                    self.navigationController?.pushViewController(input.detailVC(), animated: true)
                }
                
            case .tDeals:
                break
                
            default :
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "voucherDealListHeaderV", for: indexPath) as? JRCBVoucherDealListHeaderV else {
                    fatalError("Invalid view type")
            }
            headerView.delegate = self
            headerView.setupHeader(vModel: self.voucherVModel)
            self.gridHeader = headerView
            return headerView
        }
        return UICollectionReusableView()
    }
    
    
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
          return collectionLayoutSz
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                           insetForSectionAt section: Int) -> UIEdgeInsets {
           return self.collectionEdgeInset
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: collectionView.bounds.width, height: headerH)
       }
}

// MARK: - UIScrollView Delegate
extension JRCBVoucherDealsListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkNavVisibility()
        
        let vm = self.getViewModel()
        if vm.apiInProgress { return }
        if !vm.isNextPage { return }
        
        let offset: CGFloat = 20.0
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            guard JRCBCommonBridge.isNetworkAvailable else {
                collectV.isScrollEnabled = false
                self.showNoNetworkToast()
                collectV.isScrollEnabled = true

                return
            }
            fetchDataCall(isNextPageAPI: true)
        }
    }
    
    private func checkNavVisibility() {
        let offset = self.collectV.contentOffset
        let shMoveUp = offset.y > 100
        UIView.animate(withDuration: 0.1) {
            self.navInsideV.alpha = shMoveUp ? 1.0 : 0
            //self.statusV.alpha = shMoveUp ? 1.0 : 0
        }
    }
    
    private func applyFilter() {
        dotImageView.isHidden = self.selectedFilterIds.length == 0
        gridHeader?.showDotView(isShow: self.selectedFilterIds.length > 0)
        getViewModel().selectedFilterIds = self.selectedFilterIds
        getViewModel().showExpiredVouchers = self.showExpiredVouchers
        getViewModel().resetData()
        fetchDataCall()
    }
}

// MARK: - FIlter VC Delegate
extension JRCBVoucherDealsListVC: JRCOVoucherFilterProtocol {
    func selectedfilters(categoryId: String, active_Or_ExpiredId: String, active_Or_ExpiredName: String) {

        self.selectedFilterIds = categoryId
        isFilterApplied = true
        self.applyFilter()

    }
}

extension JRCBVoucherDealsListVC: JRCBVoucherDealListHeaderVDeleagte {
    
    func filterBtnClicked() { self.btnFIlterClicked() }
    
    func segmentChnaged(index: Int) {
        self.segmentControlChanged(index: index)
    }
}

extension JRCBVoucherDealsListVC: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        self.segmentControlChanged(index: index)
    }
}
