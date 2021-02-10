//
//  Ext_UIImageView.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIImageView {

     public func makeRounded() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
}
