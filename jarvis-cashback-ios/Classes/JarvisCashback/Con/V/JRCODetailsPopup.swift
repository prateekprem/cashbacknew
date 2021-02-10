//
//  JRCODetailsPopup.swift
//  Jarvis
//
//  Created by Ankit Agarwal on 12/02/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class JRCODetailsPopup: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var offerDetailsLabel: UILabel!
    
    @IBOutlet weak var offerDetailsTitleLabel: UILabel!
    @IBOutlet weak var termsTitleTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tnCTextView: UITextView!
    @IBOutlet weak var termsTitleLabel: UILabel!
    @IBOutlet weak var offerIDLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var offerIDLabel: UILabel!
    let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: self.popupView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 15.5, height: 15.5))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        popupView.layer.mask = mask
    }
    
    private func commonInit() {
        Bundle.cbBundle.loadNibNamed("JRCODetailsPopup", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        parentView.addGestureRecognizer(tap)
        popupView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
    }
    
    func showOfferDetailsPopUp<T>(model:T?) where T:GenericProtocol {
        self.layoutIfNeeded()
        guard let model = model else {return}
        offerDetailsLabel.text = model.short_description
        offerDetailsLabel.isHidden = true
        termsTitleLabel.text = ""
        tnCTextView.setHTML(html: "")
        
        if model is JRCONewOfferModel{
            offerIDLabel.isHidden = true
            offerIDLabelTopConstraint.constant = 0
        } else {
            offerIDLabel.isHidden = true
            offerIDLabel.text = "Offer ID : \(model.id)"
            offerIDLabelTopConstraint.constant = 0
        }
        self.isHidden = false
        loaderView.isHidden = false
        popupView.isHidden = false
        showLoaderAnimation()
        self.layoutIfNeeded()
        self.setNeedsLayout()

        UIView.animate(withDuration: 0.4, animations: {
            self.parentView.backgroundColor = self.parentView.backgroundColor?.withAlphaComponent(0.4)
            self.popupView.transform = .identity
            self.layoutIfNeeded()
            self.setNeedsLayout()

        }) { (_) in
            if model.tnc.count > 0 {
                self.hitTermsAndConditionsApi(tncLink: model.tnc)
            }
        }
    }
    
    func showOfferDetailPopUpInMerchant(shortDescription: String, tncUrl: String) {
        self.layoutIfNeeded()
        offerDetailsLabel.text = shortDescription
        offerDetailsLabel.isHidden = true
        termsTitleLabel.text = ""
        tnCTextView.setHTML(html: "")
        offerIDLabel.isHidden = true
        offerIDLabelTopConstraint.constant = 0
        self.isHidden = false
        loaderView.isHidden = false
        popupView.isHidden = false
        showLoaderAnimation()
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.parentView.backgroundColor = self.parentView.backgroundColor?.withAlphaComponent(0.4)
            self.popupView.transform = .identity
            self.layoutIfNeeded()
            self.setNeedsLayout()
            
        }) { (_) in
            if tncUrl.count > 0 {
                self.hitTermsAndConditionsApi(tncLink: tncUrl)
            }
        }
    }
    func showGVDetail(shortDescription: String, tnStr: String) {
        self.layoutIfNeeded()
        offerDetailsLabel.text = shortDescription
        offerDetailsLabel.isHidden = true
        termsTitleLabel.text = ""
        tnCTextView.setHTML(html: "")
        offerIDLabel.isHidden = true
        offerIDLabelTopConstraint.constant = 0
        self.isHidden = false
        loaderView.isHidden = true
        popupView.isHidden = false
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.parentView.backgroundColor = self.parentView.backgroundColor?.withAlphaComponent(0.4)
            self.popupView.transform = .identity
            self.layoutIfNeeded()
            self.setNeedsLayout()
            
        }) { (_) in
            self.showPopUp(tncModel: JRCOTNCModel(termsTitle: "jr_pc_paytm_gift_vocher".localized, termsDescription: tnStr), showTitle:true)
        }
    }
    
    func showTermsAndCondition(tncURL: String) {
        
        self.layoutIfNeeded()
        offerDetailsLabel.text = "jr_CB_TermsConditions".localized
        offerDetailsLabel.isHidden = true
        termsTitleLabel.text = ""
        tnCTextView.setHTML(html: "")
        offerIDLabel.isHidden = true
        offerIDLabelTopConstraint.constant = 0
        self.isHidden = false
        loaderView.isHidden = false
        popupView.isHidden = false
        showLoaderAnimation()
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.parentView.backgroundColor = self.parentView.backgroundColor?.withAlphaComponent(0.4)
            self.popupView.transform = .identity
            self.layoutIfNeeded()
            self.setNeedsLayout()
            
        }) { (_) in
            if tncURL.count > 0 {
                self.getPromoTnC(tncLink: tncURL)
            }
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.hideOfferDetailsPopUp()
    }
    
    
    private func showPopUp(tncModel: JRCOTNCModel, showTitle:Bool, isRedemptionPopUp : Bool = false) {
        self.layoutIfNeeded()
        if showTitle {
            offerDetailsTitleLabel.text = tncModel.terms_title
        } else {
            termsTitleLabel.text = ""
        }
        
        self.setHTMLText(html: tncModel.terms, input : tnCTextView, isRedemptionPopUp : isRedemptionPopUp)
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
            self.setNeedsLayout()
        })
    }
    
    public func setHTMLText(html: String, input : UITextView, isRedemptionPopUp : Bool = false) {
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let attributedString  = try NSMutableAttributedString(data: htmlData,
                                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                                      documentAttributes: nil)
                if isRedemptionPopUp {
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0, weight: .regular) , range: NSRange(location: 0, length: attributedString.length))
                }
                
                input.attributedText = attributedString
                
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
    
    func showPopUpDealCrossPromo(tncModel: JRCOTNCModel, titleColor : UIColor = UIColor.black, isRedemptionPopUp : Bool = false) {
        self.isHidden = false
        offerIDLabel.isHidden = true
        offerIDLabelTopConstraint.constant = 0
        termsTitleTopConstraint.constant = 0
        //termsTitleBtmConstraint.constant = 0
        popupView.isHidden = false
        self.loaderView.isHidden = true
        self.offerDetailsLabel.isHidden = true
        offerDetailsTitleLabel.text = tncModel.terms_title
        offerDetailsTitleLabel.textColor = titleColor
        self.layoutIfNeeded()
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.4, animations: {
            self.parentView.backgroundColor = self.parentView.backgroundColor?.withAlphaComponent(0.4)
            self.popupView.transform = .identity
            self.layoutIfNeeded()
            self.setNeedsLayout()
            
        }) { (_) in
            self.showPopUp(tncModel:tncModel, showTitle:false, isRedemptionPopUp: isRedemptionPopUp)
        }
    }
    
    func hideOfferDetailsPopUp() {
        UIView.animate(withDuration: 0.4, animations: {
            self.popupView.transform = CGAffineTransform(translationX: 0, y: self.contentView.bounds.height)
        }) { (_) in
            self.isHidden = true
            self.popupView.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    @objc private func handleGesture(gestureRecognizer: UIGestureRecognizer)
    {
        let p = gestureRecognizer.location(in:parentView)
        
        let tapArea = CGRect(x:parentView.bounds.origin.x , y:parentView.bounds.origin.y , width:parentView.bounds.width , height: parentView.bounds.height - popupView.bounds.height)
        
        if tapArea.contains(p)
        {
            hideOfferDetailsPopUp()
        }
    }
    func showLoaderAnimation(){
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        loaderView.addSubview(animationView)
        animationView.play()
    }
}

extension JRCODetailsPopup {
    
    fileprivate func hitTermsAndConditionsApi(tncLink:String){
        
        guard JRCBCommonBridge.isNetworkAvailable else {
            let err = JRCBError.networkError
            JRAlertPresenter.shared.presentSnackBar(title: err.title ?? "", message: err.message ?? "", autoDismiss: true, actions: nil, dismissHandler: nil)
            self.hideOfferDetailsPopUp()
            return
        }
        
        let aModel = JRCBApiModel(type: .pathCustomAPI, param: nil, body: nil, appendUrlExt: "")
        aModel.update(urlString: tncLink)
        JRCBServiceManager.executeAPI(model: aModel) { [weak self] (isSuccess, response, error) in
            DispatchQueue.main.async{
                self?.animationView.stop()
                self?.loaderView.isHidden = true
                
                guard let resp = response as? JRCBJSONDictionary else {
                    var errr: NSError?
                    if let err = error {
                        errr = err as NSError
                    } else {
                        errr = JRCBServiceManager.genericError as NSError?
                    }
                    
                    if let anErr = errr {
                        JRAlertPresenter.shared.presentSnackBar(title: anErr.localizedFailureReason, message: anErr.localizedDescription, autoDismiss: true, actions: nil, dismissHandler: nil)
                    }
                    
                    return
                }
                
               self?.showPopUp(tncModel: JRCOTNCModel(dict: resp), showTitle:true)
            }
        }
    }
    
    fileprivate func getPromoTnC(tncLink: String) {
        guard JRCBCommonBridge.isNetworkAvailable else {
            let err = JRCBError.networkError
            JRAlertPresenter.shared.presentSnackBar(title: err.title ?? "", message: err.message ?? "", autoDismiss: true, actions: nil, dismissHandler: nil)
            self.hideOfferDetailsPopUp()
            return
        }
        
        JRCBServices.serviceGetTnCForPromocodes(tncUrl: tncLink, completion: {[weak self] (model, error) in
            DispatchQueue.main.async {
                self?.animationView.stop()
                self?.loaderView.isHidden = true
                
                if error == nil {
                    self?.showTncData(model: model, showTitle:true)
                } else {
                    JRAlertPresenter.shared.presentSnackBar(title: error?.title ?? "", message: error?.message ?? "Something Went wrong!",
                                                            autoDismiss: true, actions: nil, dismissHandler: nil)
                }
            }
        })
    }
    
    private func showTncData(model: JRCOPromoTnC?, showTitle: Bool) {
        self.layoutIfNeeded()
        if showTitle {
            offerDetailsTitleLabel.text = model?.termsTitle ?? ""
        } else {
            termsTitleLabel.text = ""
        }
        self.setHTMLText(html: model?.terms ?? "", input : tnCTextView, isRedemptionPopUp : false)
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
            self.setNeedsLayout()
        })
    }
}

