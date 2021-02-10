//
//  JRCBGridVC.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 23/01/20.
//

import UIKit

class JRCBGridVC: JRCBStrechableHeaderGridBaseVC {
    
    @IBOutlet weak private var statusV: UIView!
    // nav
    @IBOutlet weak private var navInsideV: UIView!
    @IBOutlet weak private var navTitleLbl: UILabel!
      
    private var gridHeader: JRCBGridHeaderV?
    @IBOutlet weak private var collectV   : UICollectionView!
    @IBOutlet weak private var emptyView: UIView!
    @IBOutlet weak private var emptyLabel: UILabel!
    
    private let vModel = JRCBGridViewModel()
    
    var gridType: JRCBGridViewType = .tUnknown
    
    private let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
    
    class var newInstance : JRCBGridVC {
        let vc = JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBGridVC") as! JRCBGridVC
        return vc
    }
    
    class func gridVCWith(offerTag: String, type: JRCBGridViewType, extraParam: JRCBJSONDictionary = JRCBJSONDictionary()) -> JRCBGridVC {
        let gridVC = JRCBGridVC.newInstance
        let aType = type
        var hInfo = aType.defaultHeaderInfo
        hInfo.set(subTtl: offerTag)
        if let hImgUrl = extraParam["headerImg"] as? String, !hImgUrl.isEmpty {
            hInfo.set(imgUrl: hImgUrl)
        }
        gridVC.setGrid(type: aType, headerInfo: hInfo)
        gridVC.isCBFromDeeplink = true
        gridVC.setPage(param: ["offer_tag": offerTag])
        gridVC.setExtra(param: extraParam)
        return gridVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JRCBNotificationName.notifRemoveScreatchCard.addObserverTo(object: self,
                                                                   selector: #selector(self.removeScratchCardBy(_:)), obj: nil)
        JRCBNotificationName.notifCampainActivated.addObserverTo(object: self,
                                                                   selector: #selector(self.refreshCampainCardBy(_:)), obj: nil)

        emptyView.isHidden = true
        self.vModel.set(param: self.pageParam)
        collectV.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")

        (collectV.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectV.bounds.width, height: 50)
        
        self.updateHeader()
        
        if (self.gridType == .tVouchers || self.gridType == .tDeals),
            let collLayout = collectV.collectionViewLayout as? JRCBGridCollFlowLayout {
            collLayout.maxHeight += 90
            collLayout.totalHeight += 90
        }
        
        showLoaderAnimation()
        fetchDataCall()
    }
    
    func setGrid(type: JRCBGridViewType, headerInfo: JRCBGridViewHeaderDisplay) {
           self.gridType = type
           self.vModel.setGrid(type: type)
           self.vModel.setHeader(info: headerInfo)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func removeScratchCardBy(_ notification: Notification?) {
        guard let aInfo = notification?.userInfo as? [String: String] else { return }
        print("removeScratchCardBy")
        if let mScratchId = aInfo["sId"], !mScratchId.isEmpty {
            if self.vModel.removeScratchCardWith(sId: mScratchId) {
                DispatchQueue.main.async {
                    self.collectV.reloadData()
                }
            }
        }
    }
    
    @objc private func refreshCampainCardBy(_ notification: Notification?) {
        guard let aInfo = notification?.userInfo as? [String: String] else { return }
        print("remove campId : ")
        if let mCampId = aInfo["campId"], !mCampId.isEmpty {
            if self.vModel.refreshCampainCardWith(cId: mCampId) {
                DispatchQueue.main.async {
                    self.collectV.reloadData()
                }
            }
        }
    }
    
    private func updateHeader() {
        let hDisplay = vModel.headerDisplay
        let subTitleStr = hDisplay.subTtl.replacingOccurrences(of: "\n", with: " ")
        self.navTitleLbl.text = subTitleStr
        self.emptyLabel.text = self.vModel.emptyText
    }
        
    // MARK: - API Hit Fetch Data
    private func fetchDataCall(isNextPageAPI: Bool = false) {
        if isNextPageAPI {
            self.footerView.startAnimating()
        } else {
            startLoaderAnimation()
        }
        vModel.fetchData() {[weak self] (success, errMsg) in
            DispatchQueue.main.async {
                if isNextPageAPI {
                    self?.footerView.stopAnimating()
                } else {
                    self?.stopLoaderAnimation()
                }
                if success {
                    self?.reloadCollData()
                    
                } else {
                    JRAlertPresenter.shared.presentSnackBar(title: JRCBConstants.Common.kDefaultErrorTitle, message: errMsg ?? JRCBConstants.Common.kDefaultErrorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                }
            }
        }
    }
    
    func reloadCollData() {
        if vModel.apiInProgress {
            collectV.isScrollEnabled = false
            emptyView.isHidden = true
            return
        }
        if vModel.dataSource.count > 0 {
            emptyView.isHidden = true
            
        } else {
            emptyView.isHidden = false
            self.view.bringSubviewToFront(emptyView)
        }
        collectV.isScrollEnabled = true
        collectV.reloadData()
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
    
    private func moveToScratchCarrosal(indexP: IndexPath, gratification: JRCBGratification, configIndex: Int = -1) {
        JRCBScratchCardContainerFullScreen.display(gratification: gratification, fromController: self)
    }
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension JRCBGridVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId = JRCBGridCampaignCollCell.identifier
        var baseInfo: JRCBGridBaseInfo?
        if vModel.dataSource.count > indexPath.row {
            let bInfo = vModel.dataSource[indexPath.row]
            baseInfo = bInfo
            if let identifier = vModel.getCollectionCellIdentifier(type: bInfo.cellType) {
                cellId = identifier
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! JRCBGridCollBaseCell
        if let bInfo = baseInfo {
            cell.loadData(info: bInfo)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if vModel.dataSource.count > indexPath.row {
            let baseInfo = vModel.dataSource[indexPath.row]
            switch self.gridType {
            case .tAllScratchCard, .tAllLockedCard:
                if let scratchInfo = baseInfo.metaData as? JRCBLandingScratchCardInfo {
                    switch scratchInfo.sType {
                    case .sTypeUnscratchCard:
                        if let metaModel = scratchInfo.unscratchedCardData {
                            let cardType = JRCBCardType.getCardTypeForScratchCard(modelData: metaModel)
                            if cardType != .unknown {
                                self.moveToScratchCarrosal(indexP: indexPath,
                                                           gratification: JRCBGratification(redumpInfo: metaModel), configIndex: baseInfo.cardConfig.rawValue)
                            }
                        }
                    case .sTypeActiveOffer:
                        if let metaModel = scratchInfo.activeOfferData {
                            let vc = JRCBGameDetailsVC.newInstance
                            vc.isPresented = true
                            vc.viewModel = JRCBGameDetailsVM(postTransData: metaModel, bgImage: scratchInfo.bgImage)
                            self.present(vc, animated: true, completion: nil)
                        }
                    case .sTypeLockdCard:
                        if let metaModel = scratchInfo.lockedCardData {
                            let cardType = JRCBCardType.getCardTypeForScratchCard(modelData: metaModel)
                            if cardType != .unknown {
                                self.moveToScratchCarrosal(indexP: indexPath,
                                                           gratification: JRCBGratification(redumpInfo: metaModel), configIndex: baseInfo.cardConfig.rawValue)
                            }
                        }
                        
                    case .sTypeNew_Offer:
                        if let metaModel = scratchInfo.newOfferData {
                            let vc = JRCBGameDetailsVC.newInstance
                            vc.isPresented = true
                            vc.viewModel = JRCBGameDetailsVM(campaignData: metaModel)
                            self.present(vc, animated: true, completion: nil)
                        }
                    case .sTypeUnknown:
                        break
                    }
                }
                
            case .tCategoryOffers:
                if let catData = baseInfo.metaData as? JRCBCampaign {
                    let vc = JRCBNewOfferDetailsVC.instance(model: catData)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .tOfferTag:
                if let catData = baseInfo.metaData as? JRCBCampaign {
                    let vc = JRCBNewOfferDetailsVC.instance(model: catData)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    if let gameData = baseInfo.metaData as? JRCBPostTrnsactionData {
                        let vc = JRCBGameDetailsVC.newInstance
                        vc.isPresented = true
                        vc.viewModel = JRCBGameDetailsVM(postTransData: gameData)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            default : break
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
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "gridHeaderView", for: indexPath) as? JRCBGridHeaderV else {
                    fatalError("Invalid view type")
            }
            headerView.setupHeader(vModel: self.vModel)
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
extension JRCBGridVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkNavVisibility()
        let vm = self.vModel
        if vm.apiInProgress { return }
        if !vm.isNextPage { return }
        
        let offset: CGFloat = 20.0
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            fetchDataCall(isNextPageAPI: true)
        }
    }
    
    private func checkNavVisibility() {
        let offset = self.collectV.contentOffset
        let shMoveUp = offset.y > 100
        UIView.animate(withDuration: 0.1) {
            self.navInsideV.alpha = shMoveUp ? 1.0 : 0
            self.statusV.alpha = shMoveUp ? 1.0 : 0
        }
    }
}

// MARK: - Collection View Footer View
public class CollectionViewFooterView: UICollectionReusableView {
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}




class JRCBStrechableHeaderGridBaseVC: JRCBBaseVC {
    let width = UIScreen.main.bounds.width
    var headerH: CGFloat = 180

    var collectionLayoutSz: CGSize {
        let value = width * 0.4
        let multiplier: CGFloat = 1.17
        let heightVal = value * multiplier
        return CGSize(width: value, height: heightVal)
    }
    
    var collectionEdgeInset : UIEdgeInsets {
        let value = (width * 0.2) * 0.4
        return UIEdgeInsets(top: 10, left: value, bottom: 10, right: value)
    }
}

