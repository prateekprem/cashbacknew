//
//  JRLoadMoreFooterView.swift
//  Jarvis
//
//  Created by Prakash Raj Jha on 23/11/17.
//  Copyright © 2017 One97. All rights reserved.
//

import UIKit

public class JRLoadMoreFooterView: UIView {
    @IBOutlet weak private var retryErrorLabel : UILabel!
    public var callback : (()->(Void))?
   
    public var additionalText  = "" {
        didSet {
            retryErrorLabel.text = additionalText
        }
    }
    
    public class func footer() -> JRLoadMoreFooterView {
        let header = UINib(nibName: "JRLoadMoreFooterView", bundle: Bundle.framework).instantiate(withOwner: nil, options: nil)[0] as! JRLoadMoreFooterView
        header.layoutIfNeeded()
        return header
    }
    
    public class func retry() -> JRLoadMoreFooterView {
        let header = UINib(nibName: "JRLoadMoreFooterView", bundle: Bundle.framework).instantiate(withOwner: nil, options: nil)[1] as! JRLoadMoreFooterView
        header.layoutIfNeeded()
        return header
    }
    
    @IBAction func retryButtonAction(_ sender: UIButton) {
        callback?()
    }
}
