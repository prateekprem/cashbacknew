//
//  JRMCoInProgressNewCell.swift
//  Jarvis
//
//  Created by nasib ali on 29/03/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

enum TransactionStageConnector {
    case lineGrey
    case lineGreen
    case lineOrange
    case lineHide
}

class JRMCoInProgressNewCell: UITableViewCell {
    
    @IBOutlet weak private var tickImageView: UIImageView!
    @IBOutlet weak private var lineView: UIView!
    @IBOutlet weak private var paymentLabel: UILabel!
    @IBOutlet weak private var wonButton: UIButton!
    var currentVM: StageViewModel?
    weak var delegate:JRCOMGameStatusCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wonButton.layer.cornerRadius = wonButton.bounds.size.height / 2
    }
    
    func configureCell(_ viewModel: StageViewModel, stageConnector: TransactionStageConnector, indexPath: IndexPath, lastStageCount: Int) {
        
        let formatter           = NumberFormatter()
        formatter.numberStyle   = .ordinal
        let transactionCount    = formatter.string(from: NSNumber(value: (lastStageCount + indexPath.row + 1))) ?? ""
        
        let totalSuccess    = viewModel.stage_success_txn_count
        let totalStageTran  = viewModel.stage_total_txn_count
        self.currentVM      = viewModel
        paymentLabel.text   = transactionCount + " " + "jr_accPay_pmntRcvd".localized
        let stageStatus     = viewModel.stage_status_enum
        wonButton.isHidden  = totalStageTran > (indexPath.row + 1)
        
        setupLine(stageConnector: stageConnector)
        
        if indexPath.row < totalSuccess {
            setupCompleted()
        }else{
            switch stageStatus {
            case .inProgress, .notStarted, .expired, .offerExpired:
                setupNotCompleted()
                break
            case .completed:
                setupCompleted()
                break
            default:
                let titleText = "\(viewModel.stage_gratification_text) >"
                wonButton.setTitle(titleText, for: .normal)
                wonButton.setTitle(titleText, for: .highlighted)
                wonButton.layer.borderWidth = 1.0
                tickImageView.image = UIImage.imageWith(name: "icTick2")
                wonButton.layer.borderColor = UIColor.init(red: 226.0/255, green: 235.0/255, blue: 238.0/255, alpha: 1).cgColor
                wonButton.backgroundColor = UIColor.white
                wonButton.setTitleColor(UIColor.init(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1), for: .normal)
                break
            }
        }
    }
    
    func setupLine(stageConnector: TransactionStageConnector) {
        
        switch stageConnector {
        case .lineGrey:
            lineView.backgroundColor = UIColor.init(red: 102.0/255, green: 102.0/255, blue: 102.0/255, alpha: 0.1)
        case .lineGreen:
            lineView.backgroundColor = UIColor.init(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1)
        case .lineOrange:
            lineView.backgroundColor = UIColor.init(red: 245.0/255, green: 161.0/255, blue: 9.0/255, alpha: 1)
        default:
            lineView.isHidden = true
        }
    }
    
    func setupCompleted() {
        
        let titleText = "\(self.currentVM?.stage_gratification_text ?? "") >"
        wonButton.setTitle(titleText, for: .normal)
        wonButton.setTitle(titleText, for: .highlighted)
        wonButton.layer.borderWidth = 1.0
        wonButton.layer.borderColor = UIColor.init(red: 226.0/255, green: 235.0/255, blue: 238.0/255, alpha: 1).cgColor
        wonButton.backgroundColor = UIColor.white
        tickImageView.image = UIImage.imageWith(name: "icTick")
        
        let tasksCount = self.currentVM?.tasksVM.count ?? 0
        if tasksCount > 0 {
            let taskVM = self.currentVM?.tasksVM[0]
            if taskVM?.gratification_processed == true {
                wonButton.setTitleColor(UIColor.init(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1), for: .normal)
                wonButton.setTitleColor(UIColor.init(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1), for: .highlighted)
            }else {
                wonButton.setTitleColor(UIColor.init(red: 245.0/255, green: 161.0/255, blue: 9.0/255, alpha: 1), for: .normal)
                wonButton.setTitleColor(UIColor.init(red: 245.0/255, green: 161.0/255, blue: 9.0/255, alpha: 1), for: .highlighted)
            }
        }
    }
    
    func setupNotCompleted() {
        wonButton.setTitle(self.currentVM?.stage_gratification_text, for: .normal)
        wonButton.setTitle(self.currentVM?.stage_gratification_text, for: .highlighted)
        wonButton.layer.borderWidth = 0.0
        wonButton.backgroundColor = UIColor.init(red: 102.0/255, green: 102.0/255, blue: 102.0/255, alpha: 0.1)
        wonButton.setTitleColor(UIColor.init(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1), for: .normal)
        tickImageView.image = UIImage.imageWith(name: "icTick2")
    }
    
    @IBAction func wonButtonClick(_ sender: UIButton) {
        
        guard let currentVM = currentVM else { return }
        let tasksCount = currentVM.tasksVM.count
        if tasksCount > 0, currentVM.stage_status_enum == .completed {
            let taskVM = currentVM.tasksVM[0]
            
            if taskVM.redemptionType == .crosspromo, let crossPromoData = taskVM.crosspromoDataVM.first {
                let siteID = crossPromoData.site_id
                let voucherCode = crossPromoData.cross_promo_code
                self.delegate?.openVoucherDetailView(siteID: siteID, promoCode: voucherCode, model: nil)
            }
            else if taskVM.redemptionType == .deal, let dealData = taskVM.dealDataVM.first {
                self.delegate?.openVoucherDetailView(siteID: nil, promoCode: nil, model: dealData)
            }
            else if taskVM.redemptionType == .coins {
                self.delegate?.openMerchantPointsPassbook()
            }
            else {
                self.delegate?.didTappedStatusButton(title:currentVM.stage_gratification_text, description:taskVM.redemption_text, rrn:taskVM.rrn_no, isGratificationProcessed:taskVM.gratification_processed)
            }
        }
    }
}
