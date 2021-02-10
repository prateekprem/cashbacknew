//
//  JRCBGameProgressView.swift
//  GameProgress
//
//  Created by Prateek Prem on 13/02/20.
//  Copyright © 2020 paytm. All rights reserved.
//

import UIKit

enum TransactionStatus {
    case pendingWithOutIcon
    case pendingWithIcon
    case completedWithOutIcon
    case completedWithIcon
}

enum CellPosition {
    case first
    case last
    case middle
}

let cellWidth = 50
let leftTextWidth = 35

@IBDesignable
class JRCBGameProgressView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(JRCBGameProgressCell.nib, forCellWithReuseIdentifier: JRCBGameProgressCell.identifier)

        }
    }
    @IBOutlet weak var itemLeftLabel: UILabel!
    @IBOutlet weak var itemLeftWidth: NSLayoutConstraint!
    @IBOutlet weak var itemLeftLeading: NSLayoutConstraint!

    //var dataSource: JRCBPostTrnsactionData
    var viewModel: JRCBGameProgressVM!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(contentView)
        
        initMe()
    }
    
    private func loadViewFromNib() -> UIView {
        return UINib(nibName: "JRCBGameProgressView", bundle: Bundle.cbBundle).instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    private func initMe() {
        collectionView.isScrollEnabled = false
        collectionView.reloadData()
    }

    func show(model: JRCBPostTrnsactionData, maxWidth: CGFloat = UIScreen.main.bounds.width - 40, shouldShowIcon: Bool = true, firstItemWidth: Int = 24, isFromPostTransaction: Bool = false) {
        viewModel = JRCBGameProgressVM(with: model, maxWidth: maxWidth, shouldShowIcon: shouldShowIcon, firstItemWidth: firstItemWidth, isFromPostTransaction: isFromPostTransaction)
        if isFromPostTransaction {
            if let currTrns = model.currentTransInfo, let currStage = currTrns.stageObject {
                viewModel.totalNoOfTransaction = currStage.stage_txn_count
                viewModel.noOfSuccessfulTransaction = currStage.stage_success_txn_count
            }
        } else {
            viewModel.totalNoOfTransaction = model.total_txn_count
            viewModel.noOfSuccessfulTransaction = model.success_txn_count
        }
        viewModel.createItems()

        itemLeftLabel.text = viewModel.remainingTransactionStr
        if viewModel.remainingTransactionStr.length > 0{
            itemLeftWidth.constant = CGFloat(leftTextWidth)
            itemLeftLeading.constant = 2

        } else {
            itemLeftWidth.constant = 0
            itemLeftLeading.constant = 0
        }
        
        var fr = self.frame
        fr.size.width = viewModel.progressViewWidth + itemLeftWidth.constant 
        self.frame = fr
        contentView.frame = self.bounds
        
        contentView.setNeedsLayout()
        
        collectionView.reloadData()
    }
    
    func getwidth() -> CGFloat {
        return viewModel.progressViewWidth + itemLeftWidth.constant + itemLeftLeading.constant
    }
}

extension JRCBGameProgressView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JRCBGameProgressCell.identifier, for: indexPath) as? JRCBGameProgressCell {
            cell.show(viewModel: viewModel.items[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellVM: JRCBGameProgressCellVM = viewModel.items[indexPath.row]
        if cellVM.isFirst {
            return CGSize(width: collectionView.bounds.size.height, height: collectionView.bounds.size.height)
        }
        return CGSize(width: CGFloat(cellWidth), height: collectionView.bounds.size.height)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.init(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.init(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

class JRCBGameProgressVM {
    var isFromPostTransaction = false
    var shouldShowIcon = true
    var firstItemWidth = 0

    var dataModel: JRCBPostTrnsactionData!
    
    var maxWidth: CGFloat = 0
    var noOfItemsToBeShown: Int = 0
    
    var noOfSuccessfulTransaction: Int = 0
    
    var totalNoOfTransaction: Int = 0
    
    var progressViewWidth: CGFloat {
        get {
            return CGFloat((noOfItemsToBeShown-1) * cellWidth + firstItemWidth + 4)//left text spacing
            
        }
    }
    
    var items: [JRCBGameProgressCellVM] = [JRCBGameProgressCellVM]()
    
    var remainingTransactionStr: String {
        if totalNoOfTransaction > noOfItemsToBeShown {
            return " +" + String(totalNoOfTransaction - noOfItemsToBeShown)
        }
        return ""
    }
    
    private func getNoOfItemsToBeShown() -> Int {
        if totalNoOfTransaction != 0 {
            let itemTotalWidth = ((totalNoOfTransaction-1) * cellWidth + firstItemWidth)
            let delta = itemTotalWidth - Int(maxWidth)
            if delta <= 0 {
                return totalNoOfTransaction
            } else {
                var left = 0
                if remainingTransactionStr.length > 0 {
                    left = leftTextWidth
                }
                let itemTotalWidth = ((totalNoOfTransaction-1)*cellWidth + firstItemWidth) + left
                let delta = itemTotalWidth - Int(maxWidth)
                
                return totalNoOfTransaction - (delta/cellWidth + 1)
            }
        }
        return totalNoOfTransaction
    }
    
    init(with data: JRCBPostTrnsactionData, maxWidth: CGFloat, shouldShowIcon: Bool, firstItemWidth: Int, isFromPostTransaction: Bool) {
        dataModel = data
        self.maxWidth = maxWidth
        self.shouldShowIcon = shouldShowIcon
        self.firstItemWidth = firstItemWidth
        self.isFromPostTransaction = isFromPostTransaction
    }
    
    func createItems() {
        noOfItemsToBeShown = getNoOfItemsToBeShown()
        items.removeAll()
        var index = 0
        var postTranIndx = 0
        for var n in 1...dataModel.transactions.count {
            let cellModel = JRCBGameProgressCellVM(gamestatus: .pendingWithOutIcon, position: .middle)
            
            if index < dataModel.transactions.count {
                let tranInfo = dataModel.transactions[index] as JRCBPostTrnsactionInfo
                if tranInfo.status.lowercased() == "completed".lowercased() || tranInfo.status.lowercased() == "SUCCESS".lowercased() {
                    if shouldShowIcon {
                        if tranInfo.stageObject != nil {
                            //icon
                            cellModel.gamestatus = .completedWithIcon
                        } else {
                            // nil
                            cellModel.gamestatus = .completedWithOutIcon
                        }
                    } else {
                        cellModel.gamestatus = .completedWithOutIcon
                    }
                } else if tranInfo.status.lowercased() == "cancel".lowercased() {
                    //not to add
                    index = index+1
                    n = n-1
                    break
                } else if tranInfo.status.lowercased() == "".lowercased() {
                    // pending
                    if shouldShowIcon {
                        if tranInfo.stageObject != nil {
                            //icon
                            cellModel.gamestatus = .pendingWithIcon
                        } else {
                            // nil
                            cellModel.gamestatus = .pendingWithOutIcon
                        }
                    } else {
                        cellModel.gamestatus = .pendingWithOutIcon
                    }
                }
            }
            
            if n == 1 {
                cellModel.position = .first
            }
            
            let tranInfo = dataModel.transactions[index] as JRCBPostTrnsactionInfo
            if isFromPostTransaction && tranInfo.stage == dataModel.currentTransInfo?.stage {
                items.append(cellModel)
                if postTranIndx == 0 {
                    cellModel.position = .first
                }
                postTranIndx = postTranIndx + 1
            }
            if isFromPostTransaction == false {
                items.append(cellModel)
            }

            index = index+1
        }
        
    }
}
