//
//  JRCBMerchLandingVC.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 31/01/20.
//

import UIKit
import jarvis_network_ios

enum TypeOfOffers : Int{
    case NewOffers
    case MyOffers
    case None
}

enum JRCBMerchLandingType : Int{
    case typeOffer
    case typeVoucher
}

class JRCBMerchLandingVC: JRCBBaseVC {
    @IBOutlet weak private var table      : UITableView!
    @IBOutlet weak private var collectContainV : UIView!
    @IBOutlet weak private var collectV   : UICollectionView!
    @IBOutlet private var sectionFooter   : UIView!
    @IBOutlet weak private var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak private var expiredOfferBtn   : UIButton!
    @IBOutlet weak private var segmentControl: UISegmentedControl!
    @IBOutlet weak private var btnFilter: UIButton!
    @IBOutlet weak private var voucherEmptyV: UIView!
    @IBOutlet weak private var voucherEmptyLbl: UILabel!
    @IBOutlet weak private var backBtn    : UIButton!
    @IBOutlet weak private var pointContainV: UIView!
    @IBOutlet weak private var pointContH: NSLayoutConstraint!
    
    let transition = JRCOPresentAnimator()
    var transitingFrame = CGRect.zero
    var merchantViewModel : JRCBLandingMerchantVModel = JRCBLandingMerchantVModel()
    private let voucherVModel = JRCBMerchantVoucherVM()
    let merchantDispatchGroup = DispatchGroup()
    
    var refreshOnAppear = false
    
    private var lType = JRCBMerchLandingType.typeOffer
    private let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    class var newInstance : JRCBMerchLandingVC {
        let vc = JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBMerchLandingVC") as! JRCBMerchLandingVC
        return vc
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        JRCBManager.userMode = .Merchant
        segmentControl.fallBackToPreIOS13Layout()

        self.setUpTable()
        self.checkGridVisibility()
        self.startWith()
        
        JRCBNotificationName.notifMerchantOfferActivated.addObserverTo(object: self, selector: #selector(self.refreshCampainCardBy(_:)), obj: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        if refreshOnAppear {
            self.refreshPage()
            refreshOnAppear = false
        }
    }
    
    @objc private func refreshCampainCardBy(_ notification: Notification?) {
        guard let aInfo = notification?.userInfo as? [String: String] else { return }
        if let mCampId = aInfo["offer_id"], !mCampId.isEmpty {
            self.refreshOnAppear = true
        }
    }
    
    private func startWith(offerType: TypeOfOffers = .NewOffers,
                 offerTag: String = "",
                 isFromCategoryDeeplink: Bool = false) {
        let reset = self.merchantViewModel.arrayNewOffersVM.count == 0 || self.merchantViewModel.arrayMyOffersVM.count == 0
        self.callMerchantAPI(resetOffers: reset)
        self.reloadTable()
        self.fetchVouchers()
    }
    
    // MARK: - Private Methods
    private func setUpTable() {
        table.estimatedRowHeight = 91.0
        table.rowHeight = UITableView.automaticDimension
        table.register(UINib(nibName: "JRMCOLandingSectionHeader", bundle: Bundle.cbBundle), forHeaderFooterViewReuseIdentifier: "JRMCOLandingSectionHeader")
        
        self.collectV.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (self.collectV.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectV.bounds.width, height: 50)
        self.collectV.register(Bundle.nibWith(name: JRCBGridVoucherCollCell.identifier), forCellWithReuseIdentifier: JRCBGridVoucherCollCell.identifier)
    }
    
    override func networkStatusChanged() {
        super.networkStatusChanged()
    }
    
    private func callMerchantAPI(resetOffers : Bool) {
        self.callMerchantNewOfferAPI(resetNewOffers: resetOffers)
        self.callMerchantMyOfferAPI(resetMyOffers: resetOffers)
        notify()
    }
    
    private func refreshPage() {
        self.callMerchantAPI(resetOffers: true)
    }
    
    func setLandingType(lType: JRCBMerchLandingType) {
        self.lType = lType
    }
    
    private func notify() {
        merchantDispatchGroup.notify(queue: .main) { [weak self] in
            if let newOfferCount = self?.merchantViewModel.getMerchantNewOfferDataCount(),
                let myOfferCount = self?.merchantViewModel.arrayMyOffersVM.count,
                newOfferCount+myOfferCount == 0 {
                self?.table.reloadData()
                
            } else {
                self?.reloadTable()
            }
        }
    }
    
    @IBAction func didTapViewExpiredOffers(_ sender: UIButton) {
        merchantViewModel.setExpiredOfferBtnState()
        self.callMerchantMyOfferAPI(resetMyOffers: false)
        merchantDispatchGroup.notify(queue: .main) { [weak self] in
            self?.reloadTable()
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewPointClicked(_ sender: Any) {
        let deepLink = JRCBRemoteConfig.kCBMerchantPointsDeeplink.strValue
        JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(deepLink, isAwaitProcessing: false)
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.btnFilter.isHidden = true
            self.lType = .typeOffer
            
        } else if sender.selectedSegmentIndex == 1 {
            self.btnFilter.isHidden = false
            self.lType = .typeVoucher
        }
        self.checkGridVisibility()
    }
    
    @IBAction func btnFIlterClicked(_ sender: Any) {
        if voucherVModel.filterViewModel.sectionDataSource.count == 0 {
            getFilters()
        } else {
            pushFilterScreen()
        }
    }
    
    private func pushFilterScreen() {
        let labelsArray = ["event_label": "",
                           "event_label2": JRCOConstant.GA_SCREENTYPE_MYVOUCHER,
                           "event_label3": ""]
        
        JRCBAnalytics(screen: .screen_CashbackOfferVouchersListing, vertical: .vertical_MyVoucherCashback,
                      eventType: .eventCustom, category: .cat_MyVoucher,
                      action: .act_FilterClicked, labels: labelsArray).track()
        
        let vc = JRCBVoucherFilterVC.newInstance
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.filterListViewModel = voucherVModel.filterViewModel
        self.present(vc, animated: true, completion: nil)
    }
    
    private func checkVoucherLoading() {
        if self.lType == .typeVoucher {
            self.checkVoucherEmptyState()
            if self.voucherVModel.pageInfo.isNextPage {
                self.footerView.startAnimating()
                return
            }
        }
        self.footerView.stopAnimating()
    }
    
    private func checkVoucherEmptyState() {
        var isEmpty = false
        if voucherVModel.dataSource.count == 0, !self.voucherVModel.apiInProgress {
            isEmpty = true
        }
        
        self.collectV.isHidden = isEmpty
        self.voucherEmptyV.isHidden = !isEmpty
    }
    
    private func checkGridVisibility() {
        let isVoucher = self.lType == .typeVoucher
        self.collectContainV.isHidden = !isVoucher
        self.table.isHidden = isVoucher
        self.btnFilter.isHidden = !isVoucher
        if isVoucher {
            self.segmentControl.selectedSegmentIndex = 1
            self.checkVoucherLoading()
        }
    }
    
    private func pushToMerchantInProressVC(_ model:JRMCOMyOfferViewModel) {
        let vc = JRMCOInProgressVC.instance(myOfferVM: model)
        self.navigationController?.pushViewController(vc,animated:true)
    }
    
    private func getEmptyCell(isReset: Bool, indexPath: IndexPath, cashbackType: CBConsumerType) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "JRCOLEmptyCell", for: indexPath) as? JRCOLEmptyCell else { return UITableViewCell() }
        cell.animationView.removeFromSuperview()
        
        if isReset {
            cell.noOffersView.isHidden = true
            cell.noOffersLabel.text = ""
            cell.contentView.addSubview(cell.animationView)
            JRCBLoaderAnimationView().infinitePlay(viewAnimate: cell.animationView)
            
        } else {
            cell.noOffersView.isHidden = false
            let cnt = self.merchantViewModel.arrayMyOffersVM.count + self.merchantViewModel.arrayNewOffersVM.count
            cell.configureCellForCashbackType(currentSectionType: merchantViewModel.configArray[indexPath.section], isEmpty: cnt == 0)
            cell.animationView.removeFromSuperview()
        }
        return cell
    }
}

// MARK: - API
extension JRCBMerchLandingVC {
    
    private func fetchVouchers(isNextPageAPI: Bool = false) {
        voucherVModel.fetchMyVouchers() {[weak self] (success, errMsg) in
            DispatchQueue.main.async {
                self?.checkVoucherLoading()
                if success {
                    self?.collectV.reloadData()
                    
                } else {
                    JRAlertPresenter.shared.presentSnackBar(title: JRCBConstants.Common.kDefaultErrorTitle, message: errMsg ?? JRCBConstants.Common.kDefaultErrorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                }
            }
        }
    }
    
    private func getFilters() {
        voucherVModel.filterViewModel.getFilterList(isMerchant: true, completion: { [weak self] (success, error) in
            DispatchQueue.main.async {
                if let error = error{
                    if !JRAlertPresenter.shared.presenting {
                        JRAlertPresenter.shared.presentSnackBar(title: error.title ?? "", message: error.message ?? JRCBConstants.Common.kDefaultErrorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                    }
                }
                else{
                    self?.pushFilterScreen()
                }
            }
        })
    }
    
    
    private func callMerchantNewOfferAPI(resetNewOffers:Bool) {
        if self.merchantViewModel.inProgressNewOfferAPI { return }
        
        merchantDispatchGroup.enter()
        if resetNewOffers {
            merchantViewModel.isResetNewOffer = true
            merchantViewModel.arrayNewOffersVM.removeAll()
            merchantViewModel.pageNumberNewOffer = 0
            reloadTable()
        }
        merchantViewModel.fetchMerchantNewOffers { [weak self] (success, error) in
            defer { self?.merchantDispatchGroup.leave() }
            self?.merchantViewModel.isResetNewOffer = false
            if success {
                print("Did finish fetching Merchant New Offers")
            } else {
                if let error = error {
                    if !JRAlertPresenter.shared.presenting {
                        JRAlertPresenter.shared.presentSnackBar(title: error.localizedFailureReason, message: error.localizedDescription, autoDismiss: true, actions: nil, dismissHandler: nil)
                        return
                    }
                }
            }
        }
    }
    
    private func callMerchantMyOfferAPI(resetMyOffers:Bool) {
        if self.merchantViewModel.inProgressMyOfferAPI { return }
        
        merchantDispatchGroup.enter()
        if resetMyOffers {
            merchantViewModel.isResetMyOffer = true
            merchantViewModel.arrayMyOffersVM.removeAll()
            merchantViewModel.pageNumberMyOffer = 1
            merchantViewModel.hasExpiredOffers = false
            reloadTable()
        }
        merchantViewModel.fetchMerchantMyOffers { [weak self] (success, error) in
            defer { self?.merchantDispatchGroup.leave() }
            self?.merchantViewModel.isResetMyOffer = false
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if success {
                    print("Did finish fetching Merchant My offers")
                    
                } else {
                    if let error = error {
                        if !JRAlertPresenter.shared.presenting {
                            JRAlertPresenter.shared.presentSnackBar(title: error.localizedFailureReason, message: error.localizedDescription, autoDismiss: true, actions: nil, dismissHandler: nil)
                        }
                        return
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension JRCBMerchLandingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return merchantViewModel.configArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let secType = merchantViewModel.configArray[section]
        if secType == .newOffer {
            return merchantViewModel.getNumberOfMerchantRowsAccordingToOfferType(.NewOffers)
        }
        return merchantViewModel.getNumberOfMerchantRowsAccordingToOfferType(.MyOffers)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSectionType = merchantViewModel.configArray[indexPath.section]
        if currentSectionType == .newOffer {
            if merchantViewModel.arrayNewOffersVM.count == 0 {
                let cell = getEmptyCell(isReset: merchantViewModel.isResetNewOffer, indexPath: indexPath, cashbackType: .Merchant)
                return cell
                
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCONewOfferCell", for: indexPath) as? JRMCONewOfferCell else {return UITableViewCell()}
            cell.delegate = self
            cell.show(dataSource: merchantViewModel)
            return cell
        }
        
        if merchantViewModel.arrayMyOffersVM.count == 0 {
            let cell = getEmptyCell(isReset: merchantViewModel.isResetMyOffer, indexPath: indexPath, cashbackType: .Merchant)
            return cell
        }
        let dataVM = merchantViewModel.arrayMyOffersVM[indexPath.row]
        let status = dataVM.game_status_enum
        switch status {
        case .completed,.denied,.expired,.unacked,.offerExpired :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCOLCompletedCell", for: indexPath) as? JRMCOLCompletedCell else {return UITableViewCell()}
            cell.setDataInCell(viewModel: dataVM)
            return cell
        case .inProgress, .initialized:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCOLInProgressCell", for: indexPath) as? JRMCOLInProgressCell else {return UITableViewCell()}
            cell.offerActivateDelegate = self
            cell.setDataInCell(viewModel: dataVM)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat { return 25 }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat { return 30.0 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JRMCOLandingSectionHeader") as? JRMCOLandingSectionHeader else {
            return UIView()
        }
        
        let newOfferCount = self.merchantViewModel.getMerchantNewOfferDataCount()
        let myOfferCount = self.merchantViewModel.arrayMyOffersVM.count
        
        if newOfferCount+myOfferCount == 0 { return UIView() }
        
        let secType = merchantViewModel.configArray[section]
        let txtKey = secType == .newOffer ? "jr_co_new_offers" : "jr_co_my_offers"
        headerView.setHeaderTitle(titleText: txtKey.localized)
        return headerView
    }
    
    private func reloadTable() {
        activityIndicator.isHidden = true
        expiredOfferBtn.isHidden = !(merchantViewModel.hasExpiredOffers && !merchantViewModel.isExpiredOfferTapped)
        
        if merchantViewModel.hasMoreMyOffer || merchantViewModel.hasExpiredOffers {
            table.tableFooterView = sectionFooter
        } else {
            table.tableFooterView = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.performWithoutAnimation {
                self.table.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = merchantViewModel.configArray.count > 0 ? merchantViewModel.configArray[indexPath.section] : .newOffer
        if sectionType == .newOffer {
            if merchantViewModel.arrayNewOffersVM.count == 0 {
                return UITableView.automaticDimension
            }
            return 200.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Handle didSelect for Merchant Cells
        if merchantViewModel.configArray.indices.contains(indexPath.section) {
            let sectionType = merchantViewModel.configArray[indexPath.section]
            if sectionType == .myOffer {
                if merchantViewModel.arrayMyOffersVM.count > indexPath.row {
                    if merchantViewModel.arrayMyOffersVM[indexPath.row].game_status_enum == .initialized {
                        let rect = tableView.rectForRow(at: indexPath)
                        self.transitingFrame = tableView.convert(rect, to: tableView.superview)
                        
                        let vc = JRMCOActivateOfferVC.instance(viewModel: merchantViewModel.arrayMyOffersVM[indexPath.row])
                        vc.transitioningDelegate = self
                        vc.delegate = self
                        vc.isPresented = true
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    } else {
                        let vc = JRMCOInProgressVC.instance(myOfferVM: merchantViewModel.arrayMyOffersVM[indexPath.row])
                        self.navigationController?.pushViewController(vc,animated:true)
                    }
                }
            }
        }
    }
    

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.merchantViewModel.inProgressMyOfferAPI { return }
        if !merchantViewModel.hasMoreMyOffer { return }
        
        let headerHeight = table.tableHeaderView?.bounds.height ?? 0
        let footerHeight = table.tableFooterView?.bounds.height ?? 0
        if ((table.contentOffset.y + table.frame.size.height + headerHeight + footerHeight + 10) >= table.contentSize.height) {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            merchantViewModel.loadMoreData()
            self.callMerchantMyOfferAPI(resetMyOffers: false)
            notify()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.voucherVModel.apiInProgress { return }
        if !voucherVModel.pageInfo.isNextPage { return }
        
        let offset: CGFloat = 20.0
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            self.fetchVouchers(isNextPageAPI: true)
        }
    }
}

extension JRCBMerchLandingVC :JRMCONewOfferCellDelegate {
    func didSelectMerchantNewOffer(indexPath:IndexPath) {
        let firstRowIndex = IndexPath(row: 0, section: 0)
        let rect = table.rectForRow(at: firstRowIndex)
        self.transitingFrame = table.convert(rect, to: table.superview)
        let vc = JRMCOActivateOfferVC.instance(viewModel: merchantViewModel.arrayNewOffersVM[indexPath.row])
        vc.transitioningDelegate = self
        vc.delegate = self
        vc.isPresented = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func didTapActivateNewOffer(viewModel:JRMCOMyOfferViewModel) {
        pushToMerchantInProressVC(viewModel)
    }
}

extension JRCBMerchLandingVC: JRMCOActivateNewOfferVCDelegate {
    func campaignSucceessFullyActivated(_ model: JRMCOMyOfferViewModel) {
        pushToMerchantInProressVC(model)
    }
}

extension JRCBMerchLandingVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = self.transitingFrame
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}


// MARK: - FIlter VC Delegate
extension JRCBMerchLandingVC: JRCOVoucherFilterProtocol {
    func selectedfilters(categoryId: String, active_Or_ExpiredId: String, active_Or_ExpiredName: String) {
        voucherVModel.selectedFilterIds = categoryId
        voucherVModel.showExpiredVouchers = active_Or_ExpiredId
        voucherVModel.resetData()
        fetchVouchers()
    }
}


// MARK :- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension JRCBMerchLandingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.voucherVModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if voucherVModel.dataSource.count > indexPath.row {
            let baseInfo = voucherVModel.dataSource[indexPath.row]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JRCBGridVoucherCollCell.identifier, for: indexPath) as? JRCBGridVoucherCollCell {
                cell.loadData(info: baseInfo)
                return cell
            }
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ww = collectionView.frame.width/2.0-22.5
        return CGSize(width: ww, height: max(160, 225))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 10, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if voucherVModel.dataSource.count > indexPath.row {
            let baseInfo = voucherVModel.dataSource[indexPath.row]
            if let voucher = baseInfo.metaData as? JRCOVoucherListModel {
                let input = JRCBVoucherDetailInput(promoCode: voucher.promocode, site_id: voucher.siteId ?? 0, client_id: voucher.client ?? "",type: voucher.redemptionType ?? "")
                self.navigationController?.pushViewController(input.detailVC(), animated: true)
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
        return UICollectionReusableView()
    }
}
