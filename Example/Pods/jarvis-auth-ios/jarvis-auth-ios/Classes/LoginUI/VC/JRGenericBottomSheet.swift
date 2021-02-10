//
//  JRGenericBottomSheet.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 06/11/20.
//

import UIKit

struct JRGenericBottomSheetViewModel {
    let title: String
    let primaryDesc: String?
    let secondaryDesc: String?
    let buttonText: String
    let isCrossBtnEnabled: Bool
    
    init(title: String, primaryDesc: String? = nil, secondaryDesc: String? = nil, buttonText: String, isCrossBtnEnabled: Bool) {
        self.title = title
        self.primaryDesc = primaryDesc
        self.secondaryDesc = secondaryDesc
        self.buttonText = buttonText
        self.isCrossBtnEnabled = isCrossBtnEnabled
    }
}

final class JRGenericBottomSheet: UIViewController {
    // MARK: - Properties
    var viewModel: JRGenericBottomSheetViewModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UIViews
    private let crossImage: UIImageView = {
        let image = UIImage(named: "ic_close_light", in: JRAuthManager.kAuthBundle, compatibleWith: nil)
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        return label
    }()
    
    private var primaryDescLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    private var secondaryDescLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var confirmButton: CustomButton = {
        let button = CustomButton(ofType: .blueBackground, withText: viewModel?.buttonText ?? "")
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addAllSubviews()
        addGestures()
    }
    
    // MARK: - Main Methods
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        primaryDescLabel.text = viewModel.primaryDesc
        secondaryDescLabel.text = viewModel.secondaryDesc
        confirmButton.setTitle(viewModel.buttonText, for: .normal)
        crossImage.isHidden = !viewModel.isCrossBtnEnabled
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.roundCorners([.topLeft, .topRight], radius: 12)
    }
    
    private func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        crossImage.isUserInteractionEnabled = true
        crossImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    @objc private func confirmTapped() {
        callNumber(phoneNumber: "jr_login_dabu_unblock_customer_care".localized)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    private func callNumber(phoneNumber: String) {
        let urlString = "tel://\("jr_login_dabu_unblock_customer_care".localized.digits)"
        if let phoneCallURL = URL(string: urlString),
            UIApplication.shared.canOpenURL(phoneCallURL) {
            
            if #available(iOS 10, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneCallURL)
            }
            
        }
    }
}

// MARK: - SubViews
extension JRGenericBottomSheet {
    private func addAllSubviews() {
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = view.topAnchor
        }
        
        view.addSubview(crossImage)
        crossImage.anchor(top: topAnchor,
                          right: view.rightAnchor,
                          paddingTop: 20.0, paddingRight: 20.0,
                          width: 24.0, height: 24.0)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 24.0, paddingLeft: 20.0, paddingRight: 20.0)
        
        view.addSubview(primaryDescLabel)
        primaryDescLabel.anchor(top: titleLabel.bottomAnchor,
                                left: view.leftAnchor,
                                right: view.rightAnchor,
                                paddingTop: 16.0, paddingLeft: 20.0, paddingRight: 20.0)
        
        view.addSubview(secondaryDescLabel)
        secondaryDescLabel.anchor(top: primaryDescLabel.bottomAnchor,
                                  left: view.leftAnchor,
                                  right: view.rightAnchor,
                                  paddingTop: 20.0, paddingLeft: 20.0, paddingRight: 20.0)
        
        view.addSubview(confirmButton)
        confirmButton.anchor(left: view.leftAnchor,
                             bottom: view.bottomAnchor,
                             right: view.rightAnchor,
                             paddingLeft: 16.0, paddingBottom: 16.0, paddingRight: 16.0,
                             height: 45.0)
    }
}
