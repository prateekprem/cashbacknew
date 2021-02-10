//
//  Ext_ScrollView.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIScrollView {

    public func scrolDown(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: (self.contentSize.height-self.frame.height)), animated: animated)
    }
    
}
