//
//  JRLOTPTextField.swift
// Login
//
//  Created by Parmod on 16/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
protocol JRLOTPTextFieldDelegate: class {
    func textFieldDidDeleteButtonPressed(_ textfield : UITextField)
}

class JRLOTPTextField: UITextField {
    
    weak var jrOTPTextFieldDelegate : JRLOTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        self.jrOTPTextFieldDelegate?.textFieldDidDeleteButtonPressed(self)
    }
}
