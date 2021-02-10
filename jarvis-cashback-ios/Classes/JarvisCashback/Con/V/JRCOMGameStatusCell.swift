//
//  JRCOMGameStatusCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 21/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

protocol JRCOMGameStatusCellDelegate:class {    
    func didTappedStatusButton(title:String, description:String, rrn:String, isGratificationProcessed:Bool)
    func openVoucherDetailView(siteID: String?, promoCode: String?, model: Any?)
    func openMerchantPointsPassbook()
}

class JRCOMGameStatusCell: UITableViewCell {
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var statusButton: UIButton!
    weak var delegate:JRCOMGameStatusCellDelegate?
    var currentVM: StageViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        statusButton.layer.cornerRadius = statusButton.bounds.size.height / 2
    }
    
    //MARK: Private Methods
    private func setup() {
        selectionStyle = .none
        statusButton.titleLabel?.numberOfLines = 1
        statusButton.titleLabel?.adjustsFontSizeToFitWidth = true
        statusButton.titleLabel?.lineBreakMode = .byClipping
    }
    
    private func configureCellUI(viewModel: StageViewModel) {
        let stageStatus = viewModel.stage_status_enum
        
        switch stageStatus {
        case .inProgress, .notStarted, .expired, .offerExpired:
            statusButton.setTitle("  \(viewModel.stage_gratification_text)  ", for: .normal)
            statusButton.setTitle("  \(viewModel.stage_gratification_text)  ", for: .highlighted)
            statusButton.layer.borderWidth = 0.0
            statusButton.backgroundColor = UIColor.init(red: 102.0/255, green: 102.0/255, blue: 102.0/255, alpha: 0.1)
            statusButton.setTitleColor(UIColor.init(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1), for: .normal)
            break
        case .completed:
            let titleText = "  \(viewModel.stage_gratification_text) >  "
            statusButton.setTitle(titleText, for: .normal)
            statusButton.setTitle(titleText, for: .highlighted)
            statusButton.layer.borderWidth = 1.0
            statusButton.layer.borderColor = UIColor.init(red: 226.0/255, green: 235.0/255, blue: 238.0/255, alpha: 1).cgColor
            statusButton.backgroundColor = UIColor.white
            
            let tasksCount = viewModel.tasksVM.count
            if tasksCount > 0 {
                let taskVM = viewModel.tasksVM[0]
                if taskVM.gratification_processed == true {
                    statusButton.setTitleColor(UIColor.init(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1), for: .normal)
                    statusButton.setTitleColor(UIColor.init(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1), for: .highlighted)
                }else {
                    statusButton.setTitleColor(UIColor.init(red: 245.0/255, green: 161.0/255, blue: 9.0/255, alpha: 1), for: .normal)
                    statusButton.setTitleColor(UIColor.init(red: 245.0/255, green: 161.0/255, blue: 9.0/255, alpha: 1), for: .highlighted)
                }
            }
            break
        default:
            let titleText = "\(viewModel.stage_gratification_text) >  "
            statusButton.setTitle(titleText, for: .normal)
            statusButton.setTitle(titleText, for: .highlighted)
            statusButton.layer.borderWidth = 1.0
            statusButton.layer.borderColor = UIColor.init(red: 226.0/255, green: 235.0/255, blue: 238.0/255, alpha: 1).cgColor
            statusButton.backgroundColor = UIColor.white
            statusButton.setTitleColor(UIColor.init(red: 30.0/255, green: 196.0/255, blue: 118.0/255, alpha: 1), for: .normal)
            break
        }
    }
    
    //MARK: Public Methods
    func setDataInCell(stageViewModel: StageViewModel) {
        currentVM = stageViewModel
        configureCellUI(viewModel: stageViewModel)
        setNeedsLayout()
    }
    
    //MARK: IBActions
    @IBAction func didTappedStatusButton(_ sender: UIButton) {
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
            else {
                self.delegate?.didTappedStatusButton(title:currentVM.stage_gratification_text, description:taskVM.redemption_text, rrn:taskVM.rrn_no, isGratificationProcessed:taskVM.gratification_processed)
            }
        }
    }
}
