//
//  CashBackButtonView.swift
//  Cashback
//
//  Created by Nikita Maheshwari on 17/05/19.
//  Copyright © 2019 Nikita Maheshwari. All rights reserved.
//

import UIKit

enum AnimationType {
    case animation
    case loader
    case none
}

protocol CashBackButtonViewProtocol: class {
    func flatButtonTapped(tag: Int)
    func borderedAnimatedButtonTapped(tag: Int)
}

class CashBackButtonView: UIView {

    @IBOutlet weak var buttonImageWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var flatButton: UIButton!
    @IBOutlet weak var activeOfferButton: UIButton!
    @IBOutlet weak var animatedButtonView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var buttonType: ButtonType = .flat
    private var bgColor: UIColor = .white
    private var textColor: UIColor = .black
    private var animationType: AnimationType = .none
    private var borderColor: UIColor = .white
    
    let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView

    weak var delegate: CashBackButtonViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    func loadViewFromNib() {
        UINib(nibName: CashBackButtonView.identifier, bundle: Bundle.cbBundle).instantiate(withOwner: self, options: nil)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.autoresizesSubviews = true
        addSubview(containerView)
    }
    
    func renderButton(with type: ButtonType, title: String, image: String, backgroundColor: UIColor = .white, textColor: UIColor = .black, animationType: AnimationType = .none, borderColor: UIColor = .white) {
        self.buttonType = type
        self.bgColor = backgroundColor
        self.textColor = textColor
        self.animationType = animationType
        self.borderColor = borderColor
        switch type {
        case .flat:
            setUpflatButton(title: title)
            animatedButtonView.isUserInteractionEnabled = true
        case .borderWithAnimated:
            setUpBorderAnimatedButton(title: title, image: image)
            animatedButtonView.isUserInteractionEnabled = true
        case .bordered:
            setUpBorderedButton(title: title)
            animatedButtonView.isUserInteractionEnabled = true
        }
    }
    
    private func setUpBorderedButton(title: String) {
        setUpBorderAnimatedButton(title: title, image: "")
        buttonImageWidth.constant = 0
    }
    
    private func setUpBorderAnimatedButton(title: String, image: String) {
        activeOfferButton.setTitle(title, for: .normal)
        activeOfferButton.setTitleColor(textColor, for: .normal)
        buttonImage.image = UIImage.imageWith(name: image)
        flatButton.isHidden = true
        animatedButtonView.isHidden = false
        buttonImageWidth.constant = 0
        animatedButtonView.backgroundColor = self.bgColor
        createBorder(view: animatedButtonView, color: borderColor)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(borderedButtonTapped))
        animatedButtonView.addGestureRecognizer(tap)
    }

    private func setUpflatButton(title: String) {
        flatButton.setTitle(title, for: .normal)
        flatButton.setTitleColor(textColor, for: .normal)
        flatButton.isHidden = false
        flatButton.backgroundColor = self.bgColor
        animatedButtonView.isHidden = true
        flatButton.isEnabled = true
    }
    
    private func createBorder(view: UIView, color: UIColor) {
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = 1.0
    }
    
    @IBAction func flatButtonTapped(_ sender: UIButton) {
        startAnimation()
        delegate?.flatButtonTapped(tag: self.tag)
    }
    
    @objc func borderedButtonTapped() {
        startAnimation()
    }
    
    func startAnimation() {
        switch animationType {
        case .animation:
            showSparkleAnimation()
        case .loader:
            
            animationView.frame = animatedButtonView.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            animationView.autoresizesSubviews = true
            animatedButtonView.addSubview(animationView)
            JRCBLoaderAnimationView().infinitePlay(viewAnimate: self.animationView)
            self.delegate?.borderedAnimatedButtonTapped(tag: self.tag)
        default: return
        }
    }
    
    func stopAnimation() {
        switch animationType {
        case .loader:
            DispatchQueue.main.async {
                 self.animationView.removeFromSuperview()
            }
        default: return
        }
    }
    
    func showSparkleAnimation() {
        let animationView = JRCBLOTAnimation.animationActButtonOnDealsCard.lotView
        animationView.frame = CGRect(x: animatedButtonView.frame.origin.x, y: animatedButtonView.frame.origin.y-10, width: animatedButtonView.frame.size.width, height: animatedButtonView.frame.size.width)
        animatedButtonView.addSubview(animationView)
        animatedButtonView.alpha = 0.0
        buttonImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: 0.40, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.animatedButtonView.alpha = 1.0
            self.buttonImage.transform = .identity
            self.renderButton(with: .borderWithAnimated, title: "Activated", image: "icTick1", backgroundColor: UIColor.cashbackLightGreen, textColor: UIColor.cashbackGreen, animationType: .animation, borderColor: UIColor.cashbackLightGreen)
             self.buttonImageWidth.constant = 10
            
        }, completion: {(finish) in
            print("\(finish)")
        })
        animationView.play {(finished) in
            print("\(finished)")
            animationView.removeFromSuperview()
            self.delegate?.borderedAnimatedButtonTapped(tag: self.tag)
        }
    }
}
