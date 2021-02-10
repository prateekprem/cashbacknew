//
//  JRPCRedeemCell.swift
//  jarvis
//
//  Created by Pankaj Singh on 21/01/20.
//

import UIKit
import Lottie

protocol JRPCRedeemCellDelegate: class {
    func purchaseVoucher(cell: JRPCRedeemCell)
    func viewDetailBtnClicked()
}

class JRPCRedeemCell: UITableViewCell {
    
    @IBOutlet weak var loadingView: UIButton!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var viewDetailBtn: UIButton!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var vocherImageView: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    var animationViewWidth: CGFloat = 48.0
    var thresholdValue: CGFloat = 60.0
    var coinsValueText: NSMutableAttributedString?
    weak var delegate: JRPCRedeemCellDelegate?
    
    @IBOutlet weak var sliderWidth: NSLayoutConstraint!
    var model: JRPCRewardsModel! {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell() {
        viewDetailBtn.createDashedLine(from: CGPoint(x: 2, y: viewDetailBtn.frame.size.height), to: CGPoint(x: viewDetailBtn.center.x + 50, y: viewDetailBtn.frame.size.height))

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panDetected))
        slideView.addGestureRecognizer(gesture)
        slideView.isUserInteractionEnabled = true
        gesture.delegate = self
        
        if coinsValueText == nil {
            let imageAttachment =  NSTextAttachment()
            imageAttachment.image = UIImage.imageWith(name: "ic_Star_point")
            imageAttachment.bounds = CGRect(x: 0, y: -3, width: 15.0, height: 15.0)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            let completeText = NSMutableAttributedString(string: "jr_pc_str".localized + "  ")
            completeText.append(attachmentString)
            coinsValueText = completeText
        }
    }
    
    func setData() {
        let  textAfterIcon = NSMutableAttributedString(string: " " + "\(JRPCUtilities.generateFormattedStringWithSeparator(model.attributes?.redemptionPoints?.value))")
        var redeemText: NSMutableAttributedString?
        if let coinsValueText = coinsValueText {
            redeemText = NSMutableAttributedString(attributedString: coinsValueText)
        }
        redeemText?.append(textAfterIcon)
        self.strLabel.textAlignment = .center;
        self.strLabel.attributedText = redeemText
        if let url = model.imageURL, let urlToLoad = URL(string: url) {
            self.bgImageView.jr_setImage(with: urlToLoad)
        }
    }
    
    @objc func panDetected(sender: UIPanGestureRecognizer) {
        var translatedPoint = sender.translation(in: animationView)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: animationView.frame.size.height / 2)
        
        // UI changes
        self.sliderWidth.constant = self.animationViewWidth + (translatedPoint.x > 0 ? translatedPoint.x : 0)
        
        
        if sender.state == .ended {
            var finalX = translatedPoint.x
            if finalX < 0 {
                finalX = 0
            } else if finalX + animationViewWidth  >  (animationView.frame.size.width - thresholdValue) {
                self.redeem()
            } else {
                self.reset()
            }
        }
    }
    
    func redeem() {
        print("redeem")
        UIView.transition(with: animationView, duration: 0.2, options: .curveEaseOut, animations: {
            self.sliderWidth.constant = self.animationView.frame.size.width
        }) { (Status) in
            if Status{
                self.loadingView.isHidden = false
                self.loadingView.showPointsLoader()
                self.delegate?.purchaseVoucher(cell: self)
            }
        }
    }
    
    func removeLoader() {
        self.loadingView.isHidden = true
        self.loadingView.removeLoader()
    }
    
    func resetCell() {
        self.removeLoader()
        self.sliderWidth.constant = 48.0
    }
    
    func reset() {
        print("reset")
        UIView.transition(with: animationView, duration: 0.2, options: .curveEaseOut, animations: {
            self.sliderWidth.constant = self.animationViewWidth
        }) { (Status) in
            if Status{
                
            }
        }
    }
    @IBAction func viewDetailGV(_ sender: UIButton) {
        delegate?.viewDetailBtnClicked()
    }
}
