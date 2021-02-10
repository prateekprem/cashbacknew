//
//  JRMCOPaymentDetailVC.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 22/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit


class JRMCOPaymentDetailVC: JRCBBaseVC {
    
    @IBOutlet weak private var tableView               : UITableView!
    @IBOutlet weak private var headerTitleLabel        : UILabel!
    @IBOutlet weak private var emptyMessageLabel       : UILabel!
    @IBOutlet weak private var emptyMessageContentView : UIView!
    
    var gameId:Int?
    var scrollTabView: JRCOScrolTabs!
    var scrollDataSource:[StageViewModel]?
    var headerTitleTextArray:[String] = []
    private var viewModel = JRMCBPaymentDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        self.setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollTabView.frame.origin.y = tableView.frame.origin.y - 45.0
    }
    
    class func instance(dataSource:[StageViewModel], gameId:String) -> JRMCOPaymentDetailVC {
        let controller = JRCBStoryboard.stbMerchant.instantiateViewController(withIdentifier: "JRMCOPaymentDetailVC") as! JRMCOPaymentDetailVC
        controller.scrollDataSource = dataSource
        controller.gameId = Int(gameId)
        return controller
    }
    
    //MARK: Private Methods
    private func setup() {
        if let dataSource = scrollDataSource {
            dataSource.forEach { stageVM in
                let titleText = stageVM.stage_screen_construct1
                headerTitleTextArray.append(titleText)
            }
        }
        
        scrollTabView = JRCOScrolTabs.tabVWith(fr: CGRect(x: 0, y: (tableView.frame.origin.y - 45.0), width: self.view.frame.width, height: 45.0))
        scrollTabView.setList(titles: headerTitleTextArray)
        scrollTabView.delegate = self
        view.addSubview(scrollTabView)
        self.fetchData(index:0)
    }
    
    private func shouldShowEmptyErrorView(state:Bool, index: Int) {
        tableView.isHidden = state
        emptyMessageContentView.isHidden = !state
        emptyMessageLabel.isHidden = !state
        if index == 0 {
            emptyMessageLabel.text = "jr_co_no_transaction_stg_1".localized
        } else {
            emptyMessageLabel.text = "jr_co_no_transaction_stg_2".localized
        }
    }
    
    private func refreshView(pageNumber : Int) {
        DispatchQueue.main.async {
            if self.viewModel.transactionsList.count > 0 {
                self.shouldShowEmptyErrorView(state:false, index: pageNumber)
            } else {
                self.shouldShowEmptyErrorView(state:true, index: pageNumber)
            }
             self.tableView.reloadData()
        }
       
    }
    
    private func fetchData(index:Int) {
        guard let id = gameId else {
            return
        }
        
        var tempStr = ""
        if let stageModel = scrollDataSource?[index] {
            let stageArr = stageModel.allStage
            for i in stageArr {
                if tempStr.length == 0 {
                    tempStr = "\(i)"
                } else {
                    tempStr = "\(tempStr),\(i)"
                }
            }
        } else {
             tempStr = "\(index)"
        }
        viewModel.removeAllTransactionData()
        tableView.reloadData()
        viewModel.fetchPaymentDetailsForGame(gameId:id, stage:tempStr, completion: { [weak self] (success, error) in
            if success {
                self?.refreshView(pageNumber:index)
            } else {
                if let error = error {
                    DispatchQueue.main.async {
                       JRAlertPresenter.shared.presentSnackBar(title: error.localizedFailureReason, message: error.localizedDescription, autoDismiss: true, actions: nil, dismissHandler: nil)
                    }
                    return
                }
            }
        })
    }
    
    //IBAction
    @IBAction func didTappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}



extension JRMCOPaymentDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactionsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JRMCOPaymentDetailCell", for: indexPath) as? JRMCOPaymentDetailCell else { return UITableViewCell() }
        
        let anInfo = viewModel.transactionsList[indexPath.row]
        cell.setDataInCell(info: anInfo)
        return cell
    }
}

extension JRMCOPaymentDetailVC: JRCOScrolTabsDelegate {
    func jrScrolTabsDidSelectItem(at: Int) {
        fetchData(index:at)
    }
}
