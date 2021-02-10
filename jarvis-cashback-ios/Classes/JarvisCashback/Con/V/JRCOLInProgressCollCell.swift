//
//  JRCOLInProgressCollCell.swift
//  SampleCashback
//
//  Created by Ankit Agarwal on 02/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class JRCOLInProgressCollCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTransactionsLeft: EdgeInsetLabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var indexPath : IndexPath?
    
    func setupCell(model:JRCOMyOfferModel,showTransactionLeftLabel:Bool){
        guard let indexPath = indexPath else{return}
        let currentTransactions = model.total_txn_count
        let totalTransactionsRequired = model.stage_txn_count
        if showTransactionLeftLabel {
            lineView.isHidden = true
            imageView.isHidden = true
            lblTransactionsLeft.isHidden = false
            lblTransactionsLeft.layer.cornerRadius =  lblTransactionsLeft.bounds.height/2
            lblTransactionsLeft.layer.masksToBounds = true
            lblTransactionsLeft.text = String(format: "jr_pay_transLeft".localized, totalTransactionsRequired - currentTransactions)
        }
        else {
            if indexPath.row < currentTransactions-1{
                lineView.isHidden = false
                imageView.isHidden = false
                lblTransactionsLeft.isHidden = true
                imageView.image = UIImage.imageWith(name: "icTick1")
                lineView.backgroundColor = UIColor(red:33/255 , green: 193/255, blue:122/255 , alpha: 1.0)
            }
            else if indexPath.row == currentTransactions - 1{
                if totalTransactionsRequired == 1 {
                    lineView.isHidden = true
                } else {
                    lineView.isHidden = false
                }
                imageView.isHidden = false
                lblTransactionsLeft.isHidden = true
                imageView.image = UIImage.imageWith(name: "icTick1")
                lineView.backgroundColor = UIColor(red:226/255 , green: 235/255, blue:238/255 , alpha: 1.0)
            }
            else if indexPath.row > currentTransactions - 1 && indexPath.row != totalTransactionsRequired - 1{
                lineView.isHidden = false
                imageView.isHidden = false
                lblTransactionsLeft.isHidden = true
                imageView.image = UIImage.imageWith(name: "icTick2")
                lineView.backgroundColor = UIColor(red:226/255 , green: 235/255, blue:238/255 , alpha: 1.0)
            }
            else if indexPath.row == totalTransactionsRequired - 1{
                lineView.isHidden = true
                imageView.isHidden = false
                lblTransactionsLeft.isHidden = true
                imageView.image = UIImage.imageWith(name: "icTick2")
            }
        }
    }
}
