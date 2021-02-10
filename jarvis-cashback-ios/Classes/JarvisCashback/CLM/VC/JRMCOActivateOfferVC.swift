//
//  JRMCOActivateMyOfferVC.swift
//  jarvis-auth-ios
//
//  Created by Nikita Maheshwari on 12/08/19.
//

import UIKit

public protocol JRMCOActivateNewOfferVCDelegate: class {
    func campaignSucceessFullyActivated(_ model: JRMCOMyOfferViewModel)
}

class JRMCOActivateOfferVC: JRCBBaseVC {
    @IBOutlet weak private var offerTableView  : UITableView!
    @IBOutlet weak private var tableHeaderView : JRMCOActivateNewOfferHeader!
    @IBOutlet weak private var tableFooterView : JRMCOActivateNewOfferFooter!
    @IBOutlet weak private var headerBackgroundImage: UIImageView!
    @IBOutlet weak private var blurView  : UIView!
    @IBOutlet weak private var navTitle  : UILabel!
    
    private var viewModel: JRMCOActivateOfferVM!
    weak var delegate : JRMCOActivateNewOfferVCDelegate?
    
    static func instance(viewModel: Any) -> JRMCOActivateOfferVC {
        let vc = JRCBStoryboard.stbMerchant.instantiateViewController(withIdentifier: "JRMCOActivateOfferVC") as! JRMCOActivateOfferVC
        vc.viewModel = JRMCOActivateOfferVM.init(viewModel: viewModel)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        let labelsArray = ["MID": "",
                           "campaignId": "\(viewModel.campaignID)"]
        JRCBAnalytics(screen: .screen_CashbackMerchantActivateNewOffer, vertical: .vertical_Cashback,
                      eventType: .eventCustom, category: .cat_CashbackOffers, action: .act_None,
                      labels: labelsArray).track()
    }
    
    private func setupUI() {
        
        offerTableView.tableHeaderView = tableHeaderView
        offerTableView.tableFooterView = tableFooterView
        
        navTitle.isHidden = true
  
        tableFooterView.setupCell(viewModel)
        tableFooterView.delegate = self
        tableHeaderView.setupCell(viewModel)

        navTitle.text = viewModel.headerTitle
        blurView.isHidden = viewModel.isDeeplink
       
        if let backgroundImageUrl = URL(string: viewModel.headerBackgroundImage) {
            headerBackgroundImage.jr_setImage(with: backgroundImageUrl)
        }else{
            headerBackgroundImage.image = nil
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        if self.isPresented {
            self.dismiss(animated: true, completion: {
                JRCashbackManager.shared.cbEnvDelegate.cbBackBtnClicked(controller: .newofferDetail)
            })
        } else {
            self.navigationController?.popViewController(animated: true)
            JRCashbackManager.shared.cbEnvDelegate.cbBackBtnClicked(controller: .newofferDetail)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension JRMCOActivateOfferVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.offersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.getRowForIndex(row: indexPath.row) {
        case .offerDetails:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCOActivateNewOfferDetailsCell", for: indexPath) as? JRMCOActivateNewOfferDetailsCell else {
                return UITableViewCell()
            }
            cell.setupCell(viewModel, row : indexPath.row)
            return cell
            
        case .clockView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCOActivateNewOfferClockCell", for: indexPath) as? JRMCOActivateNewOfferClockCell else {
                return UITableViewCell()
            }
            cell.setupCell(viewModel, row : indexPath.row)
            return cell
        case .activaterBtn:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCOActivateNewOfferButtonCell", for: indexPath) as? JRMCOActivateNewOfferButtonCell else {
                return UITableViewCell()
            }
            cell.setupCell(viewModel, row : indexPath.row)
            cell.delegate = self
            return cell
        case .stageDetail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCOActivateNewOfferStageCell", for: indexPath) as? JRMCOActivateNewOfferStageCell else {
                return UITableViewCell()
            }
            cell.setupCell(viewModel, row : indexPath.row)
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navTitle.isHidden = scrollView.contentOffset.y < 67
    }
}


extension JRMCOActivateOfferVC: ActivateNewMerchantOfferCellProtocol {
    func hitActivateMerchantOfferApi(completion: @escaping (JRMCOMyOfferViewModel, Bool, NSError?) -> Void) {
        viewModel.activateMerchantOffers { (model,success, error) in
            DispatchQueue.main.async {
                if success{
                    completion(model, true, nil)
                    JRCBNotificationName.notifMerchantOfferActivated.fireMeWith(userInfo: ["offer_id": model.offer_id])
                    
                } else if let error = error {
                    JRAlertPresenter.shared.presentSnackBar(title: error.localizedFailureReason, message: error.localizedDescription, autoDismiss: true, actions: nil, dismissHandler: nil)
                }
            }
        }
    }
    
    func didTapMerchantViewMoreButton() {
        let tncPopupView = JRCODetailsPopup(frame: self.view.frame)
        self.view.addSubview(tncPopupView)
        tncPopupView.showOfferDetailPopUpInMerchant(shortDescription: viewModel.headerSubTitle, tncUrl: viewModel.tncUrl)
    }
    
    func campaignSuccessfullyActivated(_ model: JRMCOMyOfferViewModel) {
        self.dismiss(animated: true, completion: {
            self.delegate?.campaignSucceessFullyActivated(model)
        })
    }
}
