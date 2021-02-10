//
//  Ext_UIProgressView.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIProgressView {
    
    open func animate(progress: Float) {
        setProgress(0.01, animated: true)
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear, animations: {[weak self] in
            self?.setProgress(progress, animated: true)
            }, completion: nil)
    }
    
}
