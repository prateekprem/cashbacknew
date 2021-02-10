//
//  JRLoadingIndicatorView.swift
//  Login
//
//  Created by Parmod on 16/08/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class JRLoadingIndicatorView: UIView {
    
    @IBOutlet weak var progressView: JRChatOnboardingSpinnerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    private func initialSetUp(){
        loadNib()
    }
    
    private func loadNib() {
        let bundle = JRLBundle
        if let nibArray = bundle.loadNibNamed("JRLoadingIndicatorView", owner: self, options: nil) as? [UIView], let view = nibArray.last{
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    func showLoadingView(){
        progressView.startSpinner()
    }
    
    func show(){
        isHidden = false
        showLoadingView()
    }
}

