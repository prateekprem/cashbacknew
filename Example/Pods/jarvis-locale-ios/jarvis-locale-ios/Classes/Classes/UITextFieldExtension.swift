//
//  UITextField+JRLocalization.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 01/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

extension UITextField{

    private struct AssociatedKeys {
        static var isLocalizable = "isLcoalizable"
    }
    
    @IBInspectable
    var isLocalizable : Bool {
        get {
            guard let number = objc_getAssociatedObject(self, &AssociatedKeys.isLocalizable) as? NSNumber else {
                return true
            }
            return number.boolValue
        }
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.isLocalizable,NSNumber(value: value),objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if isLocalizable {
            setupLocalization()
        }
    }
    
    func setupLocalization(){
        if let text = self.text{
            self.text = text.localized
        }
        if let placeholder = self.placeholder{
            self.placeholder = placeholder.localized
        }
    }
}
