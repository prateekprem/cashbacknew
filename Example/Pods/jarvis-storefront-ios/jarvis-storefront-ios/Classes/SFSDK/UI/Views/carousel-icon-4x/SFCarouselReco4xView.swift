//
//  SFCarouselReco4xView.swift
//  jarvis-storefront-ios
//
//  Created by Romit Kumar on 28/08/20.
//

import UIKit

class SFCarouselReco4xView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectV: CardCollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalCountView: UIView!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    
    var screenWidth = UIScreen.main.bounds.width
    weak var layout : SFLayoutViewInfo?
    private(set) var index = 0 // must set this
    private(set) var rowIndex = 0 // must set this
    private(set) var indexPath: IndexPath?
    internal var mList = [SFLayoutItem]()
    var collectCellId: String { return "kSFCarouselReco4xCollCell" }
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFCarouselReco4xTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFCarouselReco4xCollCell") }
    private var tableIndex = IndexPath()
    var recoRemovedObserver: (() -> Void)?
    var lineSpacing:CGFloat = -83
    var isExpanded:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SFCarouselReco4xView", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.contentView = nibView
        self.contentView.frame = self.bounds
        self.contentView.backgroundColor = UIColor.clear
        self.addSubview(self.contentView)
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        collectV.dataSource = self
        collectV.delegate = self
        collectV.decelerationRate = UIScrollView.DecelerationRate.fast
        collectV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
    
    public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        self.layout = info
        self.indexPath = indexPath
        self.index = indexPath.section
        self.rowIndex = indexPath.row
        self.configureList()
        self.tableIndex = indexPath
        setScrollEnable()
        collectV.reloadData()
        deferReload()
    }
    
    func configureList() {
        guard let mLayout = self.layout else { return }
        mList = mLayout.vItems
        totalCountLabel.text = "\(mList.count)"
    }
    
    func deferReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
            //time should be greater than time for remove animation
            self.collectV.reloadData()
        })
    }
    
    func setScrollEnable() {
        if !isExpanded {
            collectV.isScrollEnabled = false
        } else {
            collectV.isScrollEnabled = true
        }
        if let mLayout = self.layout {
            if mLayout.layoutVType == .carouselRecoV2 {
                collectV.isScrollEnabled = false
            }
        }
    }
    
    func expandRecoCells(shouldExpand:Bool = true) {
        if shouldExpand == false {
            isExpanded = false //force close
        } else {
            isExpanded = !isExpanded
        }
        setScrollEnable()
        collectV.performBatchUpdates({
        }) { (finished) in
            self.collectV.reloadData()
        }
    }
    
    
    public func logImpressionForItem(item: SFLayoutItem?){
        guard let mLayout = self.layout, let itemToLog = item , let viewInfoToLog = self.layout else { return }
        
        guard let delegate = mLayout.pDelegate else { return }
        delegate.sfLogImpressionForItem(item: itemToLog, viewInfo: viewInfoToLog)
    }
    
}

extension SFCarouselReco4xView : RecoCellActionDelegate {
    func preventInteractions(_ shouldPrevent: Bool) {
        if shouldPrevent {
            collectV.isUserInteractionEnabled = false
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.collectV.isUserInteractionEnabled = true
             })
        }
    }
}

extension SFCarouselReco4xView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as! SFCarouselReco4xCollCell
        if let mLayout = self.layout, collectCellId.count > 0 {
            cell.layout = self.layout
            cell.show(item: mList[indexPath.row], cellConfig: mLayout.cellPresentInfo)
            cell.layer.zPosition = CGFloat(mList.count - indexPath.row)
            cell.setContentViewOpacity(isExpanded:isExpanded,index:indexPath.row)
            cell.isExpanded = isExpanded
            cell.interactionDelegate = self
            cell.recoRemovedObserver = { [weak self] (itemId, title, ctaLabel) in
                guard let strongSelf = self else {
                    return
                }
                if let index = strongSelf.mList.firstIndex(where: { (item) -> Bool in
                    return item.itemId == itemId && item.itemTitle == title && item.ctaLabel == ctaLabel
                }) {
                    strongSelf.collectV.performBatchUpdates({
                        strongSelf.mList.remove(at: index)
                        let deletionIndexPath: IndexPath = IndexPath(item: index, section: 0)
                        if strongSelf.collectV.cellForItem(at: deletionIndexPath) != nil {
                            strongSelf.collectV.deleteItems(at: [deletionIndexPath])
                        }
                        // if strongSelf.mList.count == 0 {
                        strongSelf.recoRemovedObserver?()
                        // }
                    }, completion: nil)
                   
                }
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let _ = self.layout, collectCellId.count > 0 {
            if !isExpanded && indexPath.row > 0 {
                return
            }
            logImpressionForItem(item: mList[indexPath.row])
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let ww = screenWidth - 30
            let height:CGFloat = 90.0
            if let cell = collectV.cellForItem(at: indexPath) as? SFCarouselReco4xCollCell {
               cell.setContentViewOpacity(isExpanded:isExpanded,index:indexPath.row)
           }
            if !isExpanded {
               
                if index <= 2 {
                    let reducedWidth = ww - 30 * CGFloat(indexPath.row)/3
                    return CGSize(width: reducedWidth, height: height)
                }
                    return CGSize(width: 0, height: 0)
            }
            return CGSize(width: ww, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            if isExpanded {
                return 10
            }
            return -85
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let mLayout = self.layout {
            return mLayout.cellPresentInfo.collectInterimSpace
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.layout?.pDelegate, let mLayout = self.layout, let _ =  self.layout?.layoutVType else { return }
        if isExpanded || mList.count == 1 {
              if let delegate = mLayout.pDelegate {
                let item = mList[indexPath.row]
                delegate.sfDidClickCTA(item: item)
                var trackingDict: [String:Any] = [String:Any]()
                trackingDict = mLayout.gaPromotionImpressionParamFor(item: item)
                if mLayout.verticalName.isValidString() {            SFItemTracker.shared.logPromotionClickForItem(dict: trackingDict, verticalName: mLayout.verticalName, pageName: mLayout.gaKey)
                }
            }
            return
        }
        delegate.expandReco(recoRemovedObserver: recoRemovedObserver, recoInfo: mLayout, indexPath: self.tableIndex)
    }
}

class CardCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        var sectionCardViews: [UIView] = []
        self.subviews.forEach { (subview) in
            if let decorationView = subview as? SFCarouselReco4xCollCell {
                sectionCardViews.append(decorationView)
            }
        }
        sectionCardViews.forEach { (decorationView) in
            self.sendSubviewToBack(decorationView)
        }
    }
}


