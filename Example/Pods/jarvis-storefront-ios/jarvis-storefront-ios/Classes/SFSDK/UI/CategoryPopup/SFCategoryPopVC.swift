//
//  SFCategoryPopupVC.swift
//  Jarvis
//
//  Created by Chetan Agarwal on 29/11/19.
//  Copyright © 2019 One97. All rights reserved.
//

public protocol SFCategoryPopupVCDelegate: class {
    func sfSDKDidSelectCategoryPopupItem(item: SFLayoutItem, indexPath: IndexPath, type: LayoutViewType, model: JRItemViewModel)
    func sfsendCategoryPopupImpression(model: JRLayoutViewModel)
    func circularScrollEnabled() -> Bool
}

extension SFCategoryPopupVCDelegate {
     func sfSDKDidSelectCategoryPopupItem(item: SFLayoutItem, indexPath: IndexPath, type: LayoutViewType) {}
    func sfsendCategoryPopupImpression(model: JRLayoutViewModel) {}
}

public class SFCategoryPopupVC: UIViewController {
    
    //MARK: Outlet
    
    @IBOutlet weak var contentV: UIView!
    @IBOutlet weak var bgVw: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryCollectionVw: UICollectionView!
    @IBOutlet weak var pageC: UIPageControl!
    
    weak var deleagte: SFCategoryPopupVCDelegate?
    public var viewModel: SFCategoryVM!
    public var dismissCompletionHandler: (()-> Void)?
    
    public class func initializeVC(_ items: [SFLayoutViewInfo],delegate: SFCategoryPopupVCDelegate?) ->  SFCategoryPopupVC {
        let vc = UIStoryboard(name: "SFCategoryPopup", bundle: Bundle.sfBundle).instantiateViewController(withIdentifier: "SFCategoryPopupVC") as! SFCategoryPopupVC
        vc.deleagte = delegate
        vc.viewModel = SFCategoryVM(layouts: items, delegate: delegate)
        return vc
    }
    
    deinit {
        print("SFCategoryPopupVC Deinit")
    }
    
    //MARK: Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionVw.isScrollEnabled = true
        categoryCollectionVw.isPagingEnabled = true
        pageC.numberOfPages = self.viewModel.pageCount
        self.showContents()
        self.pageC.isHidden = self.viewModel.isHiddenPage
        if self.viewModel.count > 0 {
            var model:JRLayoutViewModel = self.viewModel.itemForIndexPath(indexPath: IndexPath(row: 0, section: 0))
            if self.viewModel.count > 1 && self.viewModel.enableInfiniteScroll  { //circular infinite
                model = self.viewModel.itemForIndexPath(indexPath: IndexPath(row: 1, section: 0))
            }
            self.configureTickerInformation(name: model.title)
            self.sendEmpression(model: model)
        }
    }
    public func reloadDataAfterApi() {
        if self.viewModel.count > 0 {
            var model:JRLayoutViewModel = self.viewModel.itemForIndexPath(indexPath: IndexPath(row: 0, section: 0))
            if self.viewModel.count > 1 && self.viewModel.enableInfiniteScroll  { //circular infinite
                model = self.viewModel.itemForIndexPath(indexPath: IndexPath(row: 1, section: 0))
            }
            self.configureTickerInformation(name: model.title)
            
        }
        categoryCollectionVw.reloadData()
    }
    override public func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        setupForInfiniteScrolling()
    }
    
    public func setupForInfiniteScrolling() {
        if self.viewModel.count > 1 && self.viewModel.enableInfiniteScroll  { //circular case
            categoryCollectionVw.layoutIfNeeded()
            categoryCollectionVw.scrollToItem(at:IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
            
        }
    }
    
    private func showContents() {
        bgVw.alpha = 0
        titleLbl.alpha = 0
        contentV.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bgVw.alpha = 1
            self.titleLbl.alpha = 1
            self.contentV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    
    private func hideContents() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgVw.alpha = 0
            self.titleLbl.alpha = 0
            self.contentV.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
        }, completion: { (success) in
            self.dismissCompletionHandler?()
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            if touch.view != contentV {
                self.hideContents()
            }
        }
    }
    
    func configureTickerInformation (name: String?) {
        self.titleLbl.text = name ?? ""
    }
    
}

//MARK: CollectionView Delegates

extension SFCategoryPopupVC: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model:JRLayoutViewModel = self.viewModel.itemForIndexPath(indexPath: indexPath)
        var cell: SFCategoryCollCell = SFCategoryCollCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SFCategoryCollCell", for: indexPath) as! SFCategoryCollCell
        cell.configure(model, delegate: deleagte)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoryCollectionVw.frame.size.width, height: categoryCollectionVw.frame.size.height)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = categoryCollectionVw.frame.size.width
        let currentPage: Int = Int(categoryCollectionVw.contentOffset.x / pageWidth)
        let numberOfCells = self.viewModel.count
        var currentPageControlPage = currentPage
        if (0.0 != fmodf(Float(currentPage), 1.0)) {
            currentPageControlPage = Int(currentPage) + 1
        } else {
            currentPageControlPage = Int(currentPage)
        }
        if numberOfCells > 1 && self.viewModel.enableInfiniteScroll { //case for circular infinte scroll
            let cellWidth = categoryCollectionVw.frame.size.width
            let regularContentOffset = cellWidth * CGFloat(numberOfCells - 2)
            if (scrollView.contentOffset.x >= cellWidth * CGFloat(numberOfCells - 1)) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - regularContentOffset, y: 0.0)
            } else if (scrollView.contentOffset.x < cellWidth) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + regularContentOffset, y: 0.0)
            }
            currentPageControlPage = Int((categoryCollectionVw.contentOffset.x -  pageWidth) / pageWidth)
        }
        pageC.currentPage = currentPageControlPage
        print("current page is \(pageC.currentPage)")
        self.viewModel.setCurrentPage(page: pageC.currentPage)
        let model:JRLayoutViewModel = self.viewModel.itemForIndexPath(indexPath: IndexPath(row: currentPage, section: 0))
        self.configureTickerInformation(name: model.title)
        self.sendEmpression(model: model)
    }
    
    func sendEmpression(model:JRLayoutViewModel){
        deleagte?.sfsendCategoryPopupImpression(model: model)
    }
}
