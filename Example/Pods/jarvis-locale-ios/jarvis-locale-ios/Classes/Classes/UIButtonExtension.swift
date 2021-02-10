//
//  UIButton+JRLocalization.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 01/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

extension UIButton{
    
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
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        if isLocalizable {
            setupLocalization()
        }
    }
    
    func setupLocalization(){
        for state in [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.selected, UIControl.State.disabled]{
            if let title = self.title(for: state){
                self.setTitle(title.localized, for: state)
            }
        }
    }
}
