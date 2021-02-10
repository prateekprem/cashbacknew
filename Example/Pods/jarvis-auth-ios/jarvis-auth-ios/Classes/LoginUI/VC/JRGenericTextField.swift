//
//  File.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 06/11/20.
//

import UIKit

enum JRTextFieldType {
    case phoneNumber
    case cardNumber
    case expiryDate
}

final class JRGenericTextField: UITextField {
    // MARK: - Properties
    private var isLabelReqd: Bool = false
    private var placeholderText: String? = nil
    private var labelText: String? = nil
    private var isCountryCodeRequired: Bool = false
    
    // MARK: - UIViews
    private var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .natural
        topLabel.font = .systemFont(ofSize: 12)
        topLabel.textColor = .colorWithHexString("#506d85")
        topLabel.backgroundColor = .white
        topLabel.numberOfLines = 0
        return topLabel
        
    }()
    
    // MARK: - LifeCycle
    init(type: JRTextFieldType) {
        super.init(frame: .zero)
        setupUI(for: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender)
        return action == #selector(UIResponderStandardEditActions.cut) || action == #selector(UIResponderStandardEditActions.copy)
    }
    
    // MARK: - Main Methods
    private func setupUI(for type: JRTextFieldType) {
        switch type {
        case .phoneNumber:
            placeholderText = "jr_login_mobile_number".localized
            isCountryCodeRequired = true
        case .cardNumber:
            isLabelReqd = true
            labelText = "jr_login_card_number".localized
        case .expiryDate:
            isLabelReqd = true
            placeholderText = "jr_login_dabu_card_expiry_placeholder".localized
            labelText = "jr_login_dabu_card_expiry_date".localized
        }
        customizeTextField()
    }
    
    private func customizeTextField() {
        setupDefaults()
        setHeight(height: 45.0)
        setBottomBorder()
        addTitleLabel()
        addPlaceholder()
        addCountryCodeLabel()
    }
    
    private func setupDefaults() {
        clearButtonMode = .whileEditing
        keyboardType = .numberPad
        borderStyle = .none
        textColor = .black
    }
    
    private func addTitleLabel() {
        guard let text = labelText, isLabelReqd else { return }
        let label = topLabel
        label.text = text
        label.textColor = .colorWithHexString("#506d85")
        addSubview(label)
        label.anchor(left: leftAnchor,
                     bottom: topAnchor,
                     right: rightAnchor,
                     paddingBottom: 0,
                     height: 14.0)
    }
    
    private func addPlaceholder() {
        guard let text = placeholderText else { return }
        placeholder = text
    }
    
    private func addCountryCodeLabel() {
        guard isCountryCodeRequired else { return }
        let label = UILabel()
        label.text = "+91"
        label.setDimensions(height: 45.0, width: 40.0)
        label.textColor = JRLoginConstants.Colors.darkGray
        leftView = label
        leftViewMode = .always
    }
}
