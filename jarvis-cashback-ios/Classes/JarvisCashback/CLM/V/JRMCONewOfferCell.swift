//
//  JRMCONewOfferCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 17/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

protocol JRMCONewOfferCellDelegate: class {
    func didSelectMerchantNewOffer(indexPath:IndexPath)
    func didTapActivateNewOffer(viewModel:JRMCOMyOfferViewModel)
}

class JRMCONewOfferCell: UITableViewCell {
    
    @IBOutlet weak private var newOffersCollectionView: UICollectionView!
    weak var delegate: JRMCONewOfferCellDelegate?
    private var viewModel : JRCBLandingMerchantVModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func show(dataSource : JRCBLandingMerchantVModel) {
        viewModel = dataSource
        newOffersCollectionView.reloadData()
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension JRMCONewOfferCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayNewOffersVM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JRMCOLNewOfferCollCell", for: indexPath) as? JRMCOLNewOfferCollCell else{return UICollectionViewCell()}
        
        cell.setupCell(model: viewModel.arrayNewOffersVM[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 40.0, height: collectionView.bounds.height - 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectMerchantNewOffer(indexPath: indexPath)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let cellWidth: Float = Float(self.bounds.size.width - 30.0)
        let currentOffsetX: Float = Float(scrollView.contentOffset.x)
        let targetOffsetX: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        if targetOffsetX > currentOffsetX {
            newTargetOffset = ceilf(currentOffsetX / cellWidth) * cellWidth
        }
        else {
            newTargetOffset = floorf(currentOffsetX / cellWidth) * cellWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if (newTargetOffset > Float(scrollView.contentSize.width)){
            newTargetOffset = Float(Float(scrollView.contentSize.width))
        }
        
        targetContentOffset.pointee.x = CGFloat(scrollView.contentOffset.x)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y),
                                    animated: true)
    }
}

extension JRMCONewOfferCell : JRMCOActivateNewOfferCellDelegate {
    func activateBtnTapped(_ viewModel:JRMCOMyOfferViewModel) {
        self.delegate?.didTapActivateNewOffer(viewModel:viewModel)
    }
}
