//
//  JRLOTPTextFieldCell.swift
// Login
//
//  Created by Parmod on 15/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

protocol JRLOTPTextFieldCellDelegate: class {
    func textFieldDidBeginEditing()
    func textFieldDidDeleteButtonPressed(cell: JRLOTPTextFieldCell)
    func txtFieldValueChanged(cell: JRLOTPTextFieldCell)
    func txtFieldEndEditing(cell: JRLOTPTextFieldCell)
}
class JRLOTPTextFieldCell: UICollectionViewCell {

    @IBOutlet weak var txtField: JRLOTPTextField!
    @IBOutlet weak var horizontalLineview: UIView!
    @IBOutlet weak var horizontalLineViewHeight: NSLayoutConstraint!
    
    weak var delegate: JRLOTPTextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: JRLBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configureView(txtFieldBorderStyle: UITextField.BorderStyle?, isSecureTextEntry: Bool?) {
        txtField.jrOTPTextFieldDelegate = self
        txtField.tintColor = UIColor.paytmBlueColor()
        if txtFieldBorderStyle == nil || txtFieldBorderStyle == UITextField.BorderStyle.none{
            txtField.borderStyle = UITextField.BorderStyle.none
            horizontalLineViewHeight.constant = 1.0
        }else {
            txtField.borderStyle = txtFieldBorderStyle!
            horizontalLineViewHeight.constant = 0.0
        }
        
        if isSecureTextEntry == nil {
            txtField.isSecureTextEntry = false
        }else {
            txtField.isSecureTextEntry = isSecureTextEntry!
        }
        
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        self.delegate?.txtFieldValueChanged(cell: self)
    }
}

extension JRLOTPTextFieldCell: UITextFieldDelegate, JRLOTPTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) -> Void {
        horizontalLineview.backgroundColor = UIColor.paytmBlueColor()
        txtField.textColor = UIColor.paytmBlueColor()
        self.delegate?.textFieldDidBeginEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if changedString.count <= 1 {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) -> Void {
        horizontalLineview.backgroundColor = LOGINCOLOR.lightGray3
        txtField.textColor = LOGINCOLOR.navyBlue
        self.delegate?.txtFieldEndEditing(cell: self)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidDeleteButtonPressed(_ textfield : UITextField) {
        self.delegate?.textFieldDidDeleteButtonPressed(cell: self)
    }
}
