//
//  CarouselReco4xVC.swift
//  jarvis-storefront-ios
//
//  Created by Romit Kumar on 15/09/20.
//

import UIKit

public class SFCarouselReco4xVC: UIViewController {

    @IBOutlet weak var showLessButton: UIButton!
    @IBOutlet weak private var carouselRecoView: SFCarouselReco4xView!
    @IBOutlet weak var blurrView: UIVisualEffectView!
    @IBOutlet weak var showLessView: UIView!
    @IBOutlet weak var carouselRecoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var showLessBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreBehindView: UIView!
    
    public var recoInfo: (SFLayoutViewInfo?, IndexPath)?
    var lineSpacing:CGFloat = 10
    public var headerRecoRemovedObserver: (() -> Void)?
    
    public class func instance() ->  SFCarouselReco4xVC {
           let vc = UIStoryboard(name: "SFReco", bundle: Bundle.sfBundle).instantiateViewController(withIdentifier: "SFCarouselReco4xVC") as! SFCarouselReco4xVC
           return vc
       }
       
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        showRecoAsChild(info: recoInfo?.0, indexPath: recoInfo?.1 ?? IndexPath.init(row: 0, section: 0))
        setupUI()
        var trackingDict: [String:Any] = [String:Any]()
        trackingDict["name"] = "carousal-icon-4x"
        trackingDict["creative"] = "Show More"
        trackingDict["type"] = "collapsed"
        SFItemTracker.shared.logPromotionClickForItem(dict: trackingDict, verticalName: recoInfo?.0?.verticalName ?? "", pageName: recoInfo?.0?.gaKey ?? "")
    }
    
    private func setupUI() {
        blurrView.alpha = 0
        showLessView.layer.cornerRadius = 15
        showLessView.alpha = 0
        self.showLessView.transform = CGAffineTransform(scaleX: 0.2, y: 0.8)
        showLessBottomContraint.constant = -8
        carouselRecoViewTopConstraint.constant = UIApplication.shared.statusBarFrame.height + 65.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recoBackgroundTapped))
        carouselRecoView.addGestureRecognizer(tapGesture)
        showMoreBehindView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(recoBackgroundTapped)))
        tapGesture.delegate = self
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4) {
            self.blurrView.alpha = 1
        }
        self.carouselRecoView.expandRecoCells()
        self.showLessBottomContraint.constant = 7
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: .curveEaseIn, animations: {
            let scaleTransform = CGAffineTransform.identity
            self.showLessView.transform = scaleTransform
            self.showLessView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
        })
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let recognizers = carouselRecoView.gestureRecognizers {
            for recognizer in recognizers {
                carouselRecoView.removeGestureRecognizer(recognizer)
            }
        }
        if let recognizers = showMoreBehindView.gestureRecognizers {
            for recognizer in recognizers {
                showMoreBehindView.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    public func showRecoAsChild(info: SFLayoutViewInfo?, indexPath: IndexPath) {
        recoInfo = (info, indexPath)
          if let cancelledRecoItems = SFUtilsManager.getCancelledRecoItems(), let items = info?.vItems, cancelledRecoItems.count > 0 {
                 let cancelledRecos: Set<String> = Set(cancelledRecoItems)
                 info?.vItems = items.filter { (item) -> Bool in
                     let hashKey: String = SFUtilsManager.cancelledRecoHashKey(itemId: item.itemId, title: item.itemTitle , ctaLabel: item.ctaLabel ?? "")
                     return !cancelledRecos.contains(hashKey)
            }
        }
        if info?.vItems.count == 0 {
            recoInfo = (nil, indexPath)
        }
        if let carouselInfo = recoInfo?.0 {
            carouselRecoView.isHidden = false
            carouselRecoView.show(info: carouselInfo, indexPath: indexPath)
        } else {
            carouselRecoView.isHidden = true
        }
        carouselRecoView.recoRemovedObserver = { [weak self] in
            guard let strongSelf = self, let recoInfo = self?.recoInfo else {
                return
            }
            strongSelf.showRecoAsChild(info: recoInfo.0, indexPath: recoInfo.1)
            if info?.vItems.count == 0 {
                self?.dismiss(animated: false, completion: nil)
            }
            if let smarHeaderV2RemoveObserver = self?.headerRecoRemovedObserver {
                smarHeaderV2RemoveObserver()
            }
        }
    }

    
    
    @IBAction func goBack(_ sender: Any) {
        carouselRecoView.expandRecoCells(shouldExpand: false)
    }
    
    @objc func recoBackgroundTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        showLessButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func showLessButtonTapped(_ sender: Any) {
        carouselRecoView.expandRecoCells(shouldExpand: false)
        self.showLessBottomContraint.constant = -8
        UIView.animate(withDuration: 0.4, animations: {
              self.showLessView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
              self.showLessView.alpha = 0
              self.carouselRecoView.alpha = 0
              self.blurrView.alpha = 0
              self.view.layoutIfNeeded()
        }) { (finished) in
                 self.dismiss(animated: false, completion: nil)
        }
        var trackingDict: [String:Any] = [String:Any]()
        trackingDict["name"] = "carousal-icon-4x"
        trackingDict["creative"] = "Show Less"
        trackingDict["type"] = "expanded"
        SFItemTracker.shared.logPromotionClickForItem(dict: trackingDict, verticalName: recoInfo?.0?.verticalName ?? "", pageName: recoInfo?.0?.gaKey ?? "")
    }
    
    @IBAction func toggleExpandTap(_ sender: Any) {
        carouselRecoView.expandRecoCells()
    }
}

extension SFCarouselReco4xVC:UIGestureRecognizerDelegate {
      public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if let recoView = touch.view, recoView.isKind(of: UICollectionView.self)  {
             return true
         }
         return false
     }
}
