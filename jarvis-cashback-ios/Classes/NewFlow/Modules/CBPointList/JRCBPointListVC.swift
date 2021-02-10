//
//  JRCBPointListVC.swift
//
//  Created by Prakash Jha on 22/07/20.
//

import UIKit

class JRCBPointListVC: JRCBBaseVC {
    @IBOutlet weak private var table  : UITableView!
    @IBOutlet weak private var navV   : UIView!
    @IBOutlet weak private var backBtn: UIButton!
    @IBOutlet weak private var topV: UIView!
    @IBOutlet weak private var ttlLbl : UILabel!
    @IBOutlet weak private var redeemV: UIView!
    private let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
    
    private var tHeader : JRCBPointListTableHeader?
    private var vModel  : JRCBPointListVM = JRCBPointListVM(type: .listCashbackEarned)
    private var footerView = JRLoadMoreFooterView.footer()

    class func newInstance(type: JRCBPointListType) -> JRCBPointListVC {
        let vc = JRCBStoryboard.stbLanding.instantiateViewController(withIdentifier: "JRCBPointListVC") as! JRCBPointListVC
        vc.setList(type: type)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.rowHeight = UITableView.automaticDimension
        self.table.estimatedRowHeight = UITableView.automaticDimension
        if self.vModel.lType == .listPointsEarned {
            let img = UIImage.imageWith(name: "ic_back_orrange")
            self.backBtn.setImage(img, for: .normal)
            self.backBtn.setImage(img, for: .highlighted)
        }
        self.redeemV.roundCorner(0, nil, 10, true)
        self.addHeader()
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
   override var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
   }
    
    @IBAction func redeemClicked(_ sender: UIButton) {
        JRCashbackManager.shared.cashbackDelegate?.handleDeeplink(JRCBRemoteConfig.kCBGridPointsDeeplinkKey.strValue, isAwaitProcessing: false)
        JRCBAnalytics(screen: .screen_CashbackLanding, vertical: .vertical_Cashback,
        eventType: .eventCustom, category: .cat_CashbackOffers, action: .act_PointsSummaryClicked, labels: [:]).track()
    }
    
    private func addHeader() {
        let headerHeight: CGFloat = 120
        let fr = CGRect( x: 0, y: table.safeAreaInsets.top, width: view.frame.width, height: headerHeight)
        tHeader = JRCBPointListTableHeader.headerWith(fr: fr)
        table.backgroundView = UIView()
        table.backgroundView?.addSubview(tHeader!)
        table.contentInset = UIEdgeInsets( top: headerHeight, left: 0, bottom: 0, right: 0)
        
        let clr = self.vModel.lType.navClr
        self.topV.backgroundColor = clr
        self.navV.backgroundColor = clr
        tHeader?.backgroundColor = clr
    }
    
    
    private func showLoaderAnimation() {
        if animationView.superview != self.view {
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.view.addSubview(animationView)
        animationView.center = self.table.center
        }
        animationView.play()
    }
    
    private func stopLoaderAnimation() {
        animationView.stop()
        animationView.isHidden = true
    }
    
    
    
    private func fetchData() {
        self.showLoaderAnimation()
        self.vModel.fetchData { [weak self] (success, err) in
            DispatchQueue.main.async {
                self?.stopLoaderAnimation()
                self?.reloadPageData(errMsg: err)
            }
        }
    }
    
    private func reloadPageData(errMsg: String?) {
        self.table.reloadData()
        tHeader?.show(hInfo: self.vModel.headerVM, type: self.vModel.lType)
        redeemV.isHidden = self.vModel.lType != .listPointsEarned
        
        self.ttlLbl.text = self.vModel.headerVM.combileTitle()
        self.ttlLbl.textColor = self.vModel.lType.titleColor
        self.table.tableFooterView = self.vModel.shAddFooter ? self.footerView : nil
        
        if self.vModel.isEmpty {
            let hw =  self.table.frame.width-20
            let empFooter = JRCBEmptyView.emptyVWith(fr: CGRect(x: 10, y: 10, width: hw, height: hw))
            self.table.tableFooterView = empFooter
            var msg = self.vModel.lType.emptyText
            if let eMsg = errMsg, eMsg.count > 0 {
                msg = eMsg
            }
            empFooter.show(title: msg, image: nil)
        }
    }
    
    func setList(type: JRCBPointListType) {
        self.vModel = JRCBPointListVM(type: type)
    }
    
    private func sectionAt(index: Int) -> JRCBPointListSection? {
        if self.vModel.sections.count > index {
           return self.vModel.sections[index]
        }
        return nil
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension JRCBPointListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.vModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectInfo = sectionAt(index: section) else { return 0 }
        return sectInfo.sList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectInfo = sectionAt(index: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: JRCBPointListTableCell.cellId, for: indexPath) as! JRCBPointListTableCell
        cell.show(info: sectInfo.sList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sectInfo = sectionAt(index: indexPath.section) else { return }

        if let cbData = sectInfo.sList[indexPath.row].redumInfo {
            JRCBScratchCardContainerFullScreen.display(gratification: JRCBGratification(redumpInfo: cbData), fromController: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectInfo = sectionAt(index: section) else { return nil }
        let header = JRCBSecHeader.headerWith(fr: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 48))
        header.show(text: sectInfo.sTitle)
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = self.tHeader else { return }
        
        let offset = scrollView.contentOffset.y
        var fr = header.frame
        fr.size.height = offset < 0 ? abs(offset) : 0
        header.frame = fr
        
        let showNav = offset > 0
        navV.isHidden = !showNav
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge + offset >= scrollView.contentSize.height), self.vModel.apiPage.pageNumber > 1 {
            self.fetchData()
        }
    }
}
