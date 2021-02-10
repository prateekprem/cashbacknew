//
//  SFCategoryCollCell.swift
//  Jarvis
//
//  Created by Chetan Agarwal on 29/11/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit


class SFCategoryCollCell: UICollectionViewCell {
    
    @IBOutlet weak var itemsCollVw: UICollectionView!
    
    let cellCountInRow:CGFloat = 3.0
    
    var viewModel: JRLayoutViewModel!
    
    weak var layoutDelegate: SFCategoryPopupVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCollectionViewCells()
    }
    private func registerCollectionViewCells() {
        let cell: UINib = UINib(nibName : "SFCategoryPopupItemCell", bundle : Bundle.sfBundle)
        self.itemsCollVw.register(cell, forCellWithReuseIdentifier: "SFCategoryPopupItemCell")
        itemsCollVw.isScrollEnabled = false
        itemsCollVw.dataSource = self
        itemsCollVw.delegate = self
    }
    
    func configure(_ information: JRLayoutViewModel, delegate: SFCategoryPopupVCDelegate?) {
        self.viewModel = information
        layoutDelegate = delegate
        self.itemsCollVw.reloadData()
    }
}

//MARK:- Collection View Delegates
extension SFCategoryCollCell:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model:JRItemViewModel = self.viewModel.itemForIndexPath(indexPath: indexPath)
        var cell: SFCategoryPopupItemCell = SFCategoryPopupItemCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SFCategoryPopupItemCell", for: indexPath) as! SFCategoryPopupItemCell
        cell.shouldShowGrid = false
        cell.item = model.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < self.viewModel.items.count {
            let model:JRItemViewModel = self.viewModel.itemForIndexPath(indexPath: indexPath)
            layoutDelegate?.sfSDKDidSelectCategoryPopupItem(item: model.item, indexPath: indexPath, type: viewModel.type, model: model)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (itemsCollVw.frame.size.width/cellCountInRow), height: 110 )
    }
}
