//
//  AsyncImgView.swift
//  FBSDKCoreKit
//
//  Created by Lokesh kumar on 19/11/20.
//

import Foundation

public class AsyncImageView: UIImageView {
    
    private var activityView: UIActivityIndicatorView?
    private var showActivityIndicator: Bool?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        showActivityIndicator = (image == nil)
    }
    
    @objc public var imageURL : URL? {
        didSet {
            if let url = imageURL {
                if (showActivityIndicator == true) {
                    if activityView == nil {
                        activityView = UIActivityIndicatorView(style: activityIndicatorStyle ?? UIActivityIndicatorView.Style.gray)
                        activityView?.hidesWhenStopped = true
                        activityView?.center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
                        activityView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
                        addSubview(activityView!)
                    }
                    activityView?.startAnimating()
                }
                self.jr_setImage(with: url, placeholderImage: self.image) { [weak self] (image, erro, cacheType, url) -> Void in
                    guard let self = self else { return }
                        if url == self.imageURL {
                       self.activityView?.stopAnimating()
                    }
                }
            }
        }
    }
    
    public var activityIndicatorStyle : UIActivityIndicatorView.Style? {
        didSet {
            activityView?.removeFromSuperview()
            activityView = nil
        }
    }
}
