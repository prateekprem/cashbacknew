//
//  JRCBLandingTableHeader.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 09/06/20.
//

import UIKit

protocol JRCBLandingTableHeaderActionDelegate: class {
    func landingTableHeaderDidClickCashback()
    func landingTableHeaderDidClickPoint()
    func landingTableHeaderDidClickVoucher()
    func landingTableHeaderOpen(deeplink: String)
}

class JRCBLandingTableHeader: UIView, JRCBLandingTableHeaderVMDelegate, JRCBLandingTableHeaderRawViewDalegate {
    @IBOutlet weak var cashbackRawV: JRCBLandingTableHeaderRawView!
    @IBOutlet weak var pointRawV: JRCBLandingTableHeaderRawView!
    @IBOutlet weak var stickerRawV: JRCBLandingTableHeaderRawView!
    @IBOutlet weak var voucherRawV: JRCBLandingTableHeaderRawView!
    
    let viewModel = JRCBLandingTableHeaderVM()
    weak private var hDelegate: JRCBLandingTableHeaderActionDelegate?
    
    func initMeWith(delegate: JRCBLandingTableHeaderActionDelegate?) {
        self.hDelegate = delegate
        self.viewModel.delegate = self
        cashbackRawV.show(info: viewModel.cashBackInfo)
        pointRawV.show(info: viewModel.pointInfo)
        voucherRawV.show(info: viewModel.voucherInfo)
        stickerRawV.show(info: viewModel.stickerInfo)
//        stickerRawV.setSticker(subtitle: viewModel.stickerInfo.rSubTitle)
        
        cashbackRawV.delegate = self
        pointRawV.delegate = self
        stickerRawV.delegate = self
        voucherRawV.delegate = self
        self.refreshHeaderData()
    }
    
    func refreshHeaderData() {
        self.viewModel.refreshData()
    }
       
    // delegate methods
    func cbLandingRefreshCBAndPoints() {
        DispatchQueue.main.async {
            self.cashbackRawV.show(info: self.viewModel.cashBackInfo)
            self.pointRawV.show(info: self.viewModel.pointInfo)
            self.stickerRawV.show(info: self.viewModel.stickerInfo)
        }
    }
    
    func cbLandingRefreshSticker() {
        DispatchQueue.main.async {
            self.stickerRawV.show(info: self.viewModel.stickerInfo)
        }
    }
    
    // JRCBLandingTableHeaderRawViewDalegate
    func landingTableHeaderRawViewDidClick(view: UIView) {
        if view == cashbackRawV {
            self.hDelegate?.landingTableHeaderDidClickCashback(); return
        }
        
        if view == pointRawV {
            self.hDelegate?.landingTableHeaderDidClickPoint(); return
        }
        
        if view == voucherRawV {
            self.hDelegate?.landingTableHeaderDidClickVoucher(); return
        }
        
        if view == stickerRawV, let dLink = self.viewModel.stickerInfo.rDeeplink {
            self.hDelegate?.landingTableHeaderOpen(deeplink: dLink)
        }
    }
}


protocol JRCBLandingTableHeaderRawViewDalegate: class {
    func landingTableHeaderRawViewDidClick(view: UIView)
}

class JRCBLandingTableHeaderRawView: UIView {
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var valueLbl: UILabel?
    @IBOutlet weak var subTitleLbl: UILabel?
    @IBOutlet weak var iconImgV: UIImageView?
    weak var delegate: JRCBLandingTableHeaderRawViewDalegate?
    
    func show(info: JRCBLandingTableHeaderRaw) {
        titleLbl?.text = info.rawTtl
        valueLbl?.text = info.rValue
        subTitleLbl?.text = info.rSubTitle
        self.roundCorner(1, UIColor(hex: "DDE5ED"), 5, true)
        
        if let imgV = self.iconImgV, !info.rIcon.isEmpty {
            imgV.jr_setImage(with: URL(string: info.rIcon))
        }
    }
    
    func setSticker(subtitle: String) {
        subTitleLbl?.lineBreakMode = .byWordWrapping

        let arr = subtitle.components(separatedBy: "\n")
        guard arr.count > 1 else { return }
        
        let clr1 = UIColor(hex: "4A4A4A")
        let clr2 = UIColor(hex: "2979ED")
        
       let firstAttr = [NSAttributedString.Key.foregroundColor: clr1]
       let secAttr = [NSAttributedString.Key.foregroundColor: clr2]

       let firstString = NSMutableAttributedString(string: arr[0] + "\n", attributes: firstAttr)
       //firstString.addAttribute(NSAttributedString.Key.kern, value: 2, range: NSMakeRange(0, firstString.length))
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5 // change line spacing between paragraph like 36 or 48
      // style.minimumLineHeight = 20 // change line spacing between each line like 30 or 40
        firstString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: firstString.length))

       let secondString = NSAttributedString(string: arr[1], attributes: secAttr)
       firstString.append(secondString)
       subTitleLbl?.attributedText = firstString
    }
    
    @IBAction func didClickRaw(_ sender: UIButton) {
        self.delegate?.landingTableHeaderRawViewDidClick(view: self)
    }
}

