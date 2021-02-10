//
//  JRCBGridHeaderV.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/07/20.
//

import Foundation



class JRCBGridHeaderV: UICollectionReusableView {
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupHeader(vModel: JRCBGridViewModel) {
        let hDisplay = vModel.headerDisplay
        self.imgV.isHidden = !hDisplay.showImg
        if hDisplay.showImg {
            self.imgV.isHidden = false
            let img = Bundle.cbBundle.image(named: hDisplay.placeHolderImg)
            self.imgV.image = img
            if let mImgUrl = hDisplay.imgUrl, let iUrl = URL(string: mImgUrl) {
                self.imgV.jr_setImage(with: iUrl, placeholderImage: img) { (newImg, err, tyoe, nUrl) in
                    
                }
            }
        } else {
            self.imgV.isHidden = true
            self.bkView.backgroundColor = UIColor.Grid.headerBlue
        }
        
        let titleString = hDisplay.subTtl
        self.titleLabel.text = titleString
    }
}



protocol JRCBVoucherDealListHeaderVDeleagte: class {
    func segmentChnaged(index: Int)

    func filterBtnClicked()
}

class JRCBVoucherDealListHeaderV: UICollectionReusableView {
    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    private let buttonBar = UIView()
    @IBOutlet weak private var segmentView: UIView!
    @IBOutlet weak private var dotImageView: UIImageView! {
        didSet {
            dotImageView.roundedCorners(radius: 5.5)
        }
    }

    @IBOutlet weak private var constSegmntHeight: NSLayoutConstraint!
    @IBOutlet weak private var customSegmentControl: CustomSegmentedControl!{
        didSet{
            customSegmentControl.setButtonTitles(buttonTitles: ["jr_CB_Active".localized,"jr_CB_Expire".localized])
            customSegmentControl.selectorViewColor = UIColor.init(red: 74, green: 171, blue: 231)
            customSegmentControl.selectorTextColor = UIColor.init(red: 32, green: 47, blue: 81)
            customSegmentControl.textColor = UIColor.init(red: 150, green: 169, blue: 190)
            if let font =  UIFont(name: "Helvetica-Bold", size: 16.0)  {
                customSegmentControl.setButtonFont(buttonFont: font)
            }
            
            customSegmentControl.setIndex(index: 0)
        }
    }

    @IBOutlet weak private var btnFilter: UIButton!
    
    weak var delegate: JRCBVoucherDealListHeaderVDeleagte?
    
    
    
    func setupHeader(vModel: JRCBGridViewModel) {
        customSegmentControl.delegate = self
        let hDisplay = vModel.headerDisplay
        self.imgV.isHidden = !hDisplay.showImg
        if hDisplay.showImg {
            self.imgV.isHidden = false
            let img = Bundle.cbBundle.image(named: hDisplay.placeHolderImg)
            self.imgV.image = img
            if let mImgUrl = hDisplay.imgUrl, let iUrl = URL(string: mImgUrl) {
                self.imgV.jr_setImage(with: iUrl, placeholderImage: img) { (newImg, err, tyoe, nUrl) in
                    
                }
            }
        } else {
            self.imgV.isHidden = true
            self.bkView.backgroundColor = UIColor.Grid.headerBlue
        }
        
        let titleString = hDisplay.subTtl
        self.titleLabel.text = titleString

    }
    
    func updateSegmentIndex(index: Int) {
        customSegmentControl.setIndex(index: index)
        //self.btnFilter.isHidden = index != 0
    }
    
    @IBAction func btnFIlterClicked(_ sender: Any) {
        delegate?.filterBtnClicked()
    }
    
    func showDotView(isShow: Bool) {
        dotImageView.isHidden = !isShow
    }
}

extension JRCBVoucherDealListHeaderV: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        updateSegmentIndex(index: index)
        delegate?.segmentChnaged(index: index)
    }
}

