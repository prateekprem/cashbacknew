//
//  MPFilterSortingVC.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 30/12/19.
//

import UIKit

public class MPFilterSortingVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    private let animationDuration = 0.3
    public var closeView: ((SFSortingValue)->())?
    
    private var sortingArray = [SFSortingValue]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfiguration()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundTopCorners(containerView, cornerRadius: 15.0)
    }
    
    public static func getFilterSortingVC() -> MPFilterSortingVC {
        let storyBoard: UIStoryboard = UIStoryboard(name: "MPFilter", bundle: Bundle.sfBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MPFilterSortingVC") as! MPFilterSortingVC
        return vc
    }
    
    @IBAction func closeButton(_ sender: Any) {
        hide()
    }
    // MARK: Private Methods
    private func doInitialConfiguration() {
        addTapGestureToBGView()
        self.bottomViewHeightConstraint.constant = 0
        bgView.alpha = 0.0
        self.view.layoutIfNeeded()
    }
    
    private func addTapGestureToBGView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        bgView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Public Methods
    public func configureView(_ sortingKeys: [SFSortingValue]) {
        self.sortingArray = sortingKeys
        tableView.reloadData()
    }
    
    public func show() {
        let contentHeight = CGFloat(sortingArray.count*60 + 60)
        UIView.animate(withDuration: animationDuration) {
            self.bgView.alpha = 0.5
            self.bottomViewHeightConstraint.constant = contentHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomViewHeightConstraint.constant = 0
            self.bgView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func roundTopCorners(_ view: UIView, cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension MPFilterSortingVC: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MPSortingTableViewCell") as? MPSortingTableViewCell {
            cell.configureCell(value:sortingArray[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hide()
        closeView?(sortingArray[indexPath.row])
    }
}
