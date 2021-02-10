//
//  JROtpView.swift
// Login
//
//  Created by Parmod on 15/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

protocol JRLOTPTextFieldViewDelegate: class {
    func didEnterOTP(otp: String)
    func showHideOTPErrorLbl(isHidden: Bool)
}

class JRLOTPTextFieldView: UIView {
    
    @IBOutlet private weak var contentView:UIView?
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var textFieldCount: Int?
    weak var delegate: JRLOTPTextFieldViewDelegate?
    private var otpString: String?
    
    private var borderStyle: UITextField.BorderStyle?
    private var isSecureTextEntry: Bool?
    private var textFieldInputAccessoryView: UIView?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let _ = JRLBundle.loadNibNamed(JRLOTPTextFieldView.identifier, owner: self, options: nil) as? [UIView] else  { return }
        guard let content = contentView else { return }
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showOtpKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    private static var identifier: String {
        return String(describing: self)
    }
    
    func resetUI() {
        otpString = nil
        self.collectionView.reloadData()
        self.setTextFieldFirstResponder(index: 0)
    }
    
    @objc private func showOtpKeyboard() {
        guard let count = otpString?.count, count > 0 else{
            self.setTextFieldFirstResponder(index: 0)
            return
        }
        self.setTextFieldFirstResponder(index: count)
    }
}

extension JRLOTPTextFieldView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func registerXib() {
        self.collectionView.register(JRLOTPTextFieldCell.nib, forCellWithReuseIdentifier: JRLOTPTextFieldCell.identifier)
    }
    
    func setUpUI(count: Int, borderStyle: UITextField.BorderStyle, isSecureTextEntry: Bool) {
        self.registerXib()
        textFieldCount = count
        self.borderStyle = borderStyle
        self.isSecureTextEntry = isSecureTextEntry
        self.collectionView.delegate  = self
        self.collectionView.reloadData()
    }
    
    func setTextFieldFirstResponder(index: Int) {
        if index < collectionView.numberOfItems(inSection: 0) {
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? JRLOTPTextFieldCell
            cell?.txtField.becomeFirstResponder()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let textFieldCount = textFieldCount else {
            return 0
        }
        
        return textFieldCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JRLOTPTextFieldCell.identifier, for: indexPath) as! JRLOTPTextFieldCell
        cell.configureView(txtFieldBorderStyle: borderStyle, isSecureTextEntry: isSecureTextEntry)
        cell.delegate = self
        cell.tag = indexPath.row
        if let otpString = otpString, (indexPath.item < otpString.length) {
            cell.txtField.text = "\(otpString.substring(start: indexPath.item, end: (indexPath.item + 1)))"
        } else {
            cell.txtField.text = nil
        }
        cell.txtField.inputAccessoryView = textFieldInputAccessoryView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let textFieldCount = textFieldCount, let cellSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing else {
            return CGSize(width: 0, height: self.collectionView.bounds.height)
        }
        
        let cellWidth = (self.collectionView.bounds.width - (cellSpacing * CGFloat(textFieldCount) - 1)) / CGFloat(textFieldCount)
        if cellWidth > 0 {
            return CGSize(width: cellWidth, height: self.collectionView.bounds.height)
        }
        
        return CGSize(width: 0, height: self.collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension JRLOTPTextFieldView: JRLOTPTextFieldCellDelegate {
    
    func textFieldDidBeginEditing() {
    }
    
    func textFieldDidDeleteButtonPressed(cell: JRLOTPTextFieldCell) {
        let rowIndex = cell.tag
        guard let textFieldCount = textFieldCount else {
            return
        }
        
        if rowIndex > 0, rowIndex < (textFieldCount - 1) {
            //make previous textfield active
            self.collectionView.scrollToItem(at: IndexPath(row: rowIndex - 1, section: 0), at: .centeredHorizontally, animated: false)
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            let previousCell = self.collectionView.cellForItem(at: IndexPath(row: rowIndex - 1, section: 0)) as? JRLOTPTextFieldCell
            previousCell?.txtField.text = ""
            previousCell?.txtField.becomeFirstResponder()
        } else if rowIndex == (textFieldCount - 1) {
            if let otpString = self.otpString, otpString.count < textFieldCount {
                self.collectionView.scrollToItem(at: IndexPath(row: rowIndex - 1, section: 0), at: .centeredHorizontally, animated: false)
                self.collectionView.setNeedsLayout()
                self.collectionView.layoutIfNeeded()
                let previousCell = self.collectionView.cellForItem(at: IndexPath(row: rowIndex - 1, section: 0)) as? JRLOTPTextFieldCell
                previousCell?.txtField.text = ""
                previousCell?.txtField.becomeFirstResponder()
            }
        }
        
        if let otpString = self.otpString {
            if !otpString.isEmpty {
                self.otpString?.removeLast()
            }
            
            self.delegate?.didEnterOTP(otp: self.otpString!)
        }
    }
    
    func txtFieldValueChanged(cell: JRLOTPTextFieldCell) {
        self.delegate?.showHideOTPErrorLbl(isHidden: true)
        guard let textFieldCount = textFieldCount, let text = cell.txtField.text, !text.isEmpty else {
            return
        }
        
        if text.count <= 1 {
            if otpString == nil {
                otpString = text
            }else {
                otpString?.append(text)
            }
        }
        
        let rowIndex = cell.tag
        if rowIndex < (textFieldCount - 1) {
            //make next textfield active
            self.collectionView.scrollToItem(at: IndexPath(row: rowIndex + 1, section: 0), at: .centeredHorizontally, animated: false)
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            let nextCell = self.collectionView.cellForItem(at: IndexPath(row: rowIndex + 1, section: 0)) as? JRLOTPTextFieldCell
            nextCell?.txtField.text = ""
            nextCell?.txtField.becomeFirstResponder()
        }
        
        if let otpString = self.otpString {
            self.delegate?.didEnterOTP(otp: otpString)
        }
        
    }
    
    func txtFieldEndEditing(cell: JRLOTPTextFieldCell) {
        
    }
}
