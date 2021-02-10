//
//  JRCBLandingVC.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 17/01/20.
//

import UIKit
import jarvis_storefront_ios

class JRCBLandingVC: JRCBBaseVC {
    @IBOutlet weak private var navV       : UIView!
    @IBOutlet weak private var navInsideV : UIView!
    @IBOutlet weak private var ttlLbl     : UILabel!
    @IBOutlet weak private var table      : UITableView!
    @IBOutlet weak private var tHeader    : JRCBLandingTableHeader!
    
    private let refreshControl = UIRefreshControl()
    private let vModel = JRCBLandingVM()
        
    private var refreshOnAppear = false
    private var refreshRewardsOnAppear = false
    
    private var sRouter: JRCBHomeScreenRouter? {
        return self.vModel.sRouter
    }

    class var newInstance : JRCBLandingVC {
        let vc = JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBLandingVC") as! JRCBLandingVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JRCBManager.userMode = .Customer
        self.navInsideV.alpha = 0
        self.view.bringSubviewToFront(self.navV)
        self.table.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        JRCBNotificationName.notifRemoveScreatchCard.addObserverTo(object: self,
                                                                   selector: #selector(self.removeScratchCardBy(_:)), obj: nil)
        JRCBNotificationName.notifCampainActivated.addObserverTo(object: self,
                                                                 selector: #selector(self.refreshCampainCardBy(_:)), obj: nil)
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback, eventType: .eventUserInfo).track()        
        self.initilizeMe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkRefreshOnApear()
    }
    
    
    private func initilizeMe() {
        self.vModel.kickOff(routerDelegate: self) { (refresh, errMsg, indices) in
            if refresh {
                switch indices {
                case .update(let index):
                    DispatchQueue.main.async {
                        if self.vModel.mLayouts.count > index {
                            let indxP = IndexPath(row: index, section: 0)
                            let theLayout = self.vModel.mLayouts[index]
                            if let aLayout = self.vModel.localLayoutFor(type: theLayout.layoutVType),
                                let cell = self.table.cellForRow(at: indxP) as? JRCBLandingTableCell {
                                cell.show(info: aLayout)
                                
                            } else {
                                self.table.reloadData()
                            }
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
            }
        }
        
        self.tHeader.initMeWith(delegate: self.sRouter)
        self.checkNavVisibility()
        SFPresenter.registerForAllType(table: self.table)
        self.refreshPage()
    }
    
    private func checkRefreshOnApear() {
        if self.refreshOnAppear {
            self.refreshPage()
            self.refreshOnAppear = false
            self.refreshRewardsOnAppear = false
            
        } else if self.refreshRewardsOnAppear {
            self.refreshRewardsOnAppear = false
            self.tHeader.refreshHeaderData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshData(_ sender: Any?) {
        self.refreshPage()
    }
    
    private func refreshPage() {
        self.refreshControl.endRefreshing()
        self.vModel.refreshFullPage()
        self.tHeader.refreshHeaderData()
    }
       
    private func checkNavVisibility() {
        let offset = self.table.contentOffset
        let shMoveUp = offset.y > 30
        UIView.animate(withDuration: 0.3) {
            self.navInsideV.alpha = shMoveUp ? 1.0 : 0
        }
    }
    
    @objc private func removeScratchCardBy(_ notification: Notification?) {
        guard let aInfo = notification?.userInfo as? [String: String] else { return }
        print("removeScratchCardBy")
        if let mScratchId = aInfo["sId"], !mScratchId.isEmpty {
            let removedData = self.vModel.remove(scratchCardId: mScratchId)
            if let indxP = removedData.index {
                print("remove->\(indxP.row)")
                DispatchQueue.main.sync {
                    if removedData.removeRow {
                        self.table.reloadData()
                    } else {
                        self.table.reloadRows(at: [indxP], with: UITableView.RowAnimation.fade)
                    }
                }
                    
                }
            }
        
        let refresh = aInfo.getStringKey("refresh")
        if refresh == "true" {
            self.refreshOnAppear = true
        } else {
            self.refreshRewardsOnAppear = true
        }
    }
    
    @objc private func refreshCampainCardBy(_ notification: Notification?) {
        guard let aInfo = notification?.userInfo as? [String: String] else { return }
        print("remove campId : ")
        if let mCampId = aInfo["campId"], !mCampId.isEmpty {
            self.refreshOnAppear = true
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension JRCBLandingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vModel.mLayouts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard vModel.mLayouts.count > section else { return 0 }
        let viewInfo = vModel.mLayouts[section]
        return viewInfo.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard vModel.mLayouts.count > indexPath.section else { return UITableViewCell() }
        let viewInfo = vModel.mLayouts[indexPath.section]
        
        if let aLayout = self.vModel.localLayoutFor(type: viewInfo.layoutVType)  {
            let cell = tableView.dequeueReusableCell(withIdentifier: JRCBLandingTableCell.cellId, for: indexPath) as! JRCBLandingTableCell
            cell.show(info: aLayout)
            cell.delegate = self.sRouter
            return cell
        }
        
        if let cellId = viewInfo.tCellIdFor(row: indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SFBaseTableCell {
            cell.show(info: viewInfo, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard vModel.mLayouts.count > indexPath.section else { return 0 }
        
        let viewInfo = vModel.mLayouts[indexPath.section]
        if let aLayout = self.vModel.localLayoutFor(type: viewInfo.layoutVType)  { return aLayout.cellConfig.cellHeight }
        return viewInfo.cellPresentInfo.cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard vModel.mLayouts.count > indexPath.section else { return 0 }
        
        let viewInfo = vModel.mLayouts[indexPath.section]
        if let aLayout = self.vModel.localLayoutFor(type: viewInfo.layoutVType)  { return aLayout.cellConfig.cellHeight }
        return viewInfo.cellPresentInfo.cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.checkNavVisibility()
    }
}

// MARK: - JRCBPopOverDelegate
extension JRCBLandingVC: JRCBPopOverDelegate {
    func popOverDidSelect(index: Int, inView: JRCBPopOver) {}
    func popOverDidDissmiss() { self.checkRefreshOnApear() }
}

// MARK: - JRCBScreenRouterDelegate
extension JRCBLandingVC: JRCBScreenRouterDelegate {
    func screenRouterHostNavVC() -> UINavigationController? { return self.navigationController }
    func screenRouterHostVC() -> UIViewController? { return self }
}
