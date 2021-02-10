//
//  JRCBPostTransactionView.swift
//  jarvis-auth-ios
//
//  Created by Rahul Kamra on 12/06/19.
//

import UIKit

public protocol JRCBPostTrxViewDelegate: class {
    func reloadDataWithUpdatedHeight(height: CGFloat)
}

public class JRCBPostTransactionView: UIView {
    
    private var viewModel : JRCBPostTransactionVM = JRCBPostTransactionVM()
    
    @IBOutlet weak private var containerView  : UIView!
    @IBOutlet weak private var collectionView : UICollectionView!
    @IBOutlet weak private var customLayout   : UICollectionViewFlowLayout!
   
    private(set) weak var delegate: JRCBPostTrxViewDelegate?
    private let CONSTANT_HEIGHT      : CGFloat = 100
    private var collectionViewHeight : CGFloat = 100
    private var tempHeight           : CGFloat = 100
    private var trxID                : String?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }

    private func loadViewFromNib() {
        UINib(nibName: JRCBPostTransactionView.identifier, bundle: Bundle.cbBundle).instantiate(withOwner: self, options: nil)
        containerView.frame = bounds
        addSubview(containerView)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        registerXib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    public func sendRequiredData(delegate: JRCBPostTrxViewDelegate, transactionID: String,
                                 transactionType: PostTransactionType, verticalID: String,
                                 categoryID: String, merchantCat: String) {
        self.delegate = delegate
        if trxID != transactionID {
            trxID = transactionID
            viewModel.setRequiredParams(transactionID: transactionID, transactionType: transactionType, verticalID: verticalID, categoryID: categoryID, merchantCat: merchantCat)
            
            self.hitStoreFront()
        }
    }

   private func hitStoreFront() {
        self.viewModel.fetchStoreFrontData(completion: {[weak self] (isSuccess) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates(nil, completion: {[weak self] (result) in
                    self?.delegate?.reloadDataWithUpdatedHeight(height: self?.tempHeight ?? (self?.CONSTANT_HEIGHT ?? 100))
                    self?.collectionViewHeight = self?.tempHeight ?? (self?.CONSTANT_HEIGHT ?? 100)
                    self?.collectionView.reloadData()
                })
            }
        })
    }
    
    private func redirectToGivenDeeplink(indexPath: IndexPath) {
        JRCashbackManager.shared.cbEnvDelegate.cbRedirectToGivenSFItemWith(indx: indexPath.row, verticalId: viewModel.verticalID ?? "")
    }
}

extension JRCBPostTransactionView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func registerXib() {
        self.collectionView.register(JRCBShimmerPromotionCell.nib, forCellWithReuseIdentifier: JRCBShimmerPromotionCell.identifier)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection(section: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JRCBShimmerPromotionCell.identifier, for: indexPath) as? JRCBShimmerPromotionCell {
            if viewModel.postTransactionCellVM.count >= indexPath.row + 1 {
                cell.configureCell(data: viewModel.postTransactionCellVM[indexPath.row], state: viewModel.postTransactionState)
            } else {
                cell.configureCell(data: nil, state: viewModel.postTransactionState)
            }
            return cell
        }

        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: collectionViewHeight)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth = Int(UIScreen.main.bounds.width - 40)
        let totalCellWidth = cellWidth * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (self.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.postTransactionState {
        case .promotionState:
            UIApplication.dismissTopVCIfItIsPresented(){ (dismissed) in
                self.redirectToGivenDeeplink(indexPath: indexPath)
            }
        default:
            break
        }
    }
    
    func calculateCellHeight(index: Int) -> CGFloat {
        switch viewModel.postTransactionState {
        case .scratchState:
            return 500
        default:
            return CONSTANT_HEIGHT
        }
    }
}
