//
//  UserListViewController.swift
//  
//
//  Created by Abhishek Tripathi on 25/07/20.
//  Copyright © 2020 Abhishek Tripathi. All rights reserved.
//

import UIKit


class UserListViewController: UIViewController /*, Alertable, Loadabel*/ {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var constraint: NSLayoutConstraint!
    @IBOutlet var topView: UIView!
    @IBOutlet var containerView: UIView!
    
    var viewModel: UserListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startObserving()
        self.viewModel.viewIsReady()
        self.amountLabel.text = "₹\(Int(self.viewModel.amount))"
        self.headerLabel.text = self.viewModel.headerTile
        self.constraint.constant = self.viewModel.height
        self.view.layoutIfNeeded()
        self.tableView.isScrollEnabled = self.viewModel.height >= UIScreen.main.bounds.height*0.8
        self.containerView.roundCorn([.topLeft, .topRight], radius: 12.0)
        self.containerView.layoutIfNeeded()
        self.containerView.layer.masksToBounds = true
    }
    
    static func instanse(model: [ReferralUser], totalAmount: Double, headerTile: String) -> UserListViewController? {
        let viewController = JRCBStoryboard.stbReferral.instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController
        viewController?.viewModel = UserListViewModel(users: model,totalAmount: totalAmount, headerTile: headerTile)
        return viewController
    }
    
    func startObserving() {
        self.viewModel.observer = { [weak self] state in
            switch state {
            case .loding: break
            //self?.showloader()
            case .content: break //self?.hideloader()
            case .reload: self?.tableView.reloadData()
            case .error(let errorMessage):
                self?.showAlert("Error", andTitle: errorMessage)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
         
    }
    
    @IBAction func didSelectCrossButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.dismiss(animated: true, completion: nil)
    }
}


extension UserListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.viewModel.data(forRow: indexPath)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserListTableCell", for: indexPath) as! UserListTableCell
        cell.configureData(data)
        return cell
    }
}
