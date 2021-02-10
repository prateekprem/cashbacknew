//
//  PopOver.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 13/03/20.

import UIKit

protocol JRCBPopOverDelegate {
    func popOverDidSelect(index: Int, inView: JRCBPopOver)
    func popOverDidDissmiss()
}

class JRCBPopOver: UIView {
    var delegate : JRCBPopOverDelegate?
    
    func addMe(_ onView: UIView) {
        self.frame = onView.bounds
        onView.addSubview(self)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3) { self.alpha = 1.0 }
    }
    
    func removeMe() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { (success: Bool) in
            self.removeFromSuperview()
        })
        
        self.delegate?.popOverDidDissmiss()
    }
}
