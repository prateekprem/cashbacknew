//
//  JRCBGameDetailsVC.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/01/20.
//

import UIKit

class JRCBGameDetailsVC: JRCBBaseVC {
    
    @IBOutlet weak private var tableView: UITableView!
    var viewModel = JRCBGameDetailsVM()
    
    class var newInstance : JRCBGameDetailsVC {
        return JRCBStoryboard.stbLandingDetails.instantiateViewController(withIdentifier: "JRCBGameDetailsVC") as! JRCBGameDetailsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        if self.isPresented {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupTable() {
        setupFooterView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupFooterView() {
        let footerView = JRCBSingleLabelFooter.instanceFromNib()
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        (footerView as? JRCBSingleLabelFooter)?.setText(text: viewModel.getFooterViewText())
        tableView.tableFooterView = footerView
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension JRCBGameDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contentType.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let identifier = viewModel.getCellIdentifier(row: indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! JRCBGameDetailsTVC
            cell.delegate = self
            viewModel.loadData(cell: cell)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - JRCBGameDetailsTVCDelegate
extension JRCBGameDetailsVC: JRCBGameDetailsTVCDelegate {

    func cbGmDetailTVCCtaClicked() {
        viewModel.ctaBtnClicked { (success, errMsg, deeplinkURL) in
            if success, let dUrl = deeplinkURL, !dUrl.isEmpty {
                if self.isPresented {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(dUrl, isAwaitProcessing: false)
                        }
                    }
                }
            }
            else if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    JRAlertPresenter.shared.presentSnackBar(title: "", message: JRCBConstants.Symbol.kOfferActivated,
                                                            autoDismiss: true, actions: nil, dismissHandler: nil)
                }
                
            } else {
                DispatchQueue.main.async {
                    JRAlertPresenter.shared.presentSnackBar(title: JRCBConstants.Common.kDefaultErrorTitle, message: errMsg ?? JRCBConstants.Common.kDefaultErrorMsg, autoDismiss: true, actions: nil, dismissHandler: nil)
                }
                
            }
        }
    }
    
    func cbGmDetailTVCDetailsBtnClicked() {
        if let detailModel = viewModel.getTnCDetailModel() {
            let vc = JRCBTnCVC.instance(offerDetailModel: detailModel)
            present(vc, animated: true, completion: nil)
        }
    }
}
