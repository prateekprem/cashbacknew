//
//  JRLocalizedSegmentedControl.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 04/06/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UISegmentedControl{
    
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
        for i in 0..<self.numberOfSegments{
            if let title = self.titleForSegment(at: i){
                self.setTitle(title.localized, forSegmentAt: i)
            }
        }
    }
    
}
