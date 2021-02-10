//
//  JRDIYAccountUnblockPopup.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 13/10/20.
//

import UIKit

final class JRDIYAccountUnblockPopup: JRAuthBaseVC {
    // MARK: - IBOutlets
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitle1: UILabel!
    @IBOutlet weak private var activateButton: UIButton!
    @IBOutlet weak private var skipButton: UIButton!
    @IBOutlet weak private var bottomStackView: UIStackView!
    
    // MARK: - Properties
    public var viewModel: JRDIYAccountUnblockPopupViewModel?
    weak var delegate: JRDIYUnblockProtocol?
    
    // MARK: - LifeCycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    class func getController() -> JRDIYAccountUnblockPopup? {
        guard let vc = JRAuthManager.kAuthStoryboard.instantiateViewController(withIdentifier: "JRDIYAccountUnblockPopup") as? JRDIYAccountUnblockPopup else {
            return JRDIYAccountUnblockPopup()
        }
        return vc
    }
    
    // MARK: - Main Functions
    private func setupDefaults() {
        setupViews()
        setupImageViews()
        setupButtons()
        updateUI()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        stackView.customize(backgroundColor: .white, radiusSize: 8.0)
        subtitle1.popupPadding = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        subtitle1.setMargins()
        skipButton.isHidden = true
    }
    
    private func setupImageViews() {
        imageView.image = UIImage(named: "new", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        imageView.image = imageView.image?.imageWithInsets(insets: UIEdgeInsets(top: 50, left: 0, bottom: 45, right: 0))
        let backgroundImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width - 20.0 - 20.0, height: imageView.frame.size.height))
        backgroundImageView.image = UIImage(named: "security_background", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        backgroundImageView.roundCorn([.topLeft, .topRight], radius: 7.0)
        stackView.addSubview(backgroundImageView)
        stackView.bringSubviewToFront(imageView)
    }
    
    private func setupButtons() {
        let color = UIColor.colorWithHexString("#00ACED")
        activateButton.backgroundColor = color
        activateButton.setTitleColor(.white, for: .normal)
        activateButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        activateButton.layer.cornerRadius = 4.0
        skipButton.backgroundColor = .white
        skipButton.setTitleColor(color, for: .normal)
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        subtitle1.text = viewModel.subtitle
        if let cancelText = viewModel.cancelText {
            skipButton.isHidden = false
            skipButton.setTitle(cancelText, for: .normal)
        }
        activateButton.setTitle(viewModel.confirmText, for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction private func proceedTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.viewModel?.cancelText == nil ? self.delegate?.cancelClicked() : self.delegate?.proceedClicked()
        }
    }
    
    @IBAction private func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.cancelClicked()
        }
    }
}
