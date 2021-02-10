//
//  CBHomeViewController.swift
//  jarvis-cashback-ios_Example
//
//  Created by Prakash Jha on 02/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import jarvis_cashback_ios

class CBExampleBaseVC: UIViewController {
    var showNav: Bool = false
    let vModel = JRSFViewModel()
    
    class var storyB: UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = !showNav
    }
    
    final func checkTabbar() {
        vModel.fetchDataFromAPI { (success) in
            DispatchQueue.main.async {
                self.addTabbar()
            }
        }
    }
    
    final func addTabbar() {
        guard let tabbar = vModel.floatTabbar else { return }
        tabbar.show()
        self.view.addSubview(tabbar)
    }
}

class CBHomeViewController: CBExampleBaseVC {
    @IBOutlet weak private var table: UITableView!
    @IBOutlet weak private var loginBtn: UIButton!
    
    private var theList = CBHomeViewTCellInfo.list
   
    var homeType: CBHomeVCType = .main
    
    class var newInstance : CBHomeViewController {
        let vc = CBHomeViewController.storyB.instantiateViewController(withIdentifier: "CBHomeViewController") as! CBHomeViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNav = true
        
        if homeType == .deeplink {
            theList = CBHomeViewTCellInfo.dlList
        }
        
        self.table.rowHeight = UITableViewAutomaticDimension
        CBLoginManager.setUpEnvironment(viewController: self)
        self.resetLoginTtl()
        self.checkTabbar()
        
//        JRCBManager.flashBannerWith(delegate: self)
    }
    
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        if CBLoginManager.isUsrLoggedIn {
            CBLoginManager.shared.getLogout()
             DispatchQueue.main.async {
                self.resetLoginTtl()
            }
        } else {
            CBLoginManager.shared.getLogin { [weak self] (isSuccess, err) in
                if isSuccess {
                    DispatchQueue.main.async {
                        self?.openCachBack()
                        self?.resetLoginTtl()
                    }
                }
            }
        }
    }
    
    func openCachBack() {
      JRCashbackManager.openLandingWith(navigation: self.navigationController)
    }
    
    func openPaytmPoints() {
        JRCashbackManager.openPoints(landingType: .merchantRedeem, navigationController: self.navigationController,mid: "KvtipD32768051403836")
    }
    
    func resetLoginTtl() {
        let loginTtl = CBLoginManager.isUsrLoggedIn ? "Logout" : "Login"
        loginBtn.setTitle(loginTtl, for: .normal)
        loginBtn.setTitle(loginTtl, for: .highlighted)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension CBHomeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCBHomeViewTCell") as! CBHomeViewTCell
        cell.show(info: theList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.homeType == .deeplink {
            if self.theList[indexPath.row].desc.contains(find: "paytmmp://business-app") {
                JRCashbackManager.getCBUserMerchantId { (status, mID) in
                    if status, !mID.isEmpty {
                        print("Merchant ID ----------- %@", mID)
                    }
                }
                let navEngine = PBNavEngineVC.newInstance
                navEngine.umpLoadURL = "http://ump-staging2.paytm.com/app?redirectUrl=rewards-passbook&src=p4b&channel=p4b"
                self.navigationController?.pushViewController(navEngine, animated: true)
                return
            }
            let strUrl = self.theList[indexPath.row].desc
            JRCashbackManager.openWith(deeplink: strUrl, navigation: self.navigationController,
                                       extraParam: nil)
            return
        }
                
        let type = theList[indexPath.row].type
        switch type {
        case .typePostTransaction:
            let vc = PostTransactionVC.instance
            self.navigationController?.pushViewController(vc, animated: true)
        case .typeCashbackLanding:
            if CBLoginManager.isUsrLoggedIn {
                self.openCachBack()
            } else {
                CBLoginManager.shared.getLogin { [weak self] (isSuccess, err) in
                    if isSuccess {
                        self?.openCachBack()
                        self?.resetLoginTtl()
                    }
                }
            }

        case .typePaytmPoints:
            if CBLoginManager.isUsrLoggedIn {
                self.openPaytmPoints()
            } else {
                CBLoginManager.shared.getLogin { [weak self] (isSuccess, err) in
                    if isSuccess {
                        self?.openPaytmPoints()
                        self?.resetLoginTtl()
                    }
                }
            }
            
        case .typeDeepLink:
            let vc =  CBHomeViewController.newInstance
            vc.homeType = .deeplink
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: - JRCBPostTxnBannerDelegate
extension CBHomeViewController: JRCBPostTxnBannerDelegate {
    func cbPostTxnBannerContainVC() -> UIViewController? { return self }
    
    func cbPostTxnBannerContainVCIsOnTop() -> Bool {
        return self.navigationController?.topViewController == self
    }
    
    func cbDidFinishPresentAnimation(uniqueId: String, animated: Bool) {
        guard let mTabbar = self.vModel.floatTabbar else { return }
        mTabbar.showDotOnTabItem(uniqueName: uniqueId, animated: animated)
    }
    
     func cbPostTrClosingPoint( uniqueId:String ) -> CGPoint {
        guard let mTabbar = self.vModel.floatTabbar else { return CGPoint(x: -1, y: -1) }
        return mTabbar.centerPointForButtonWith(uniqueName: uniqueId)
    }
}
