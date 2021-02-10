//
//  JRAuthPopupVC.swift
//  jarvis-auth-ios
//
//  Created by Aakash Srivastava on 27/10/20.
//

import UIKit

class JRAuthPopupVC: JRAuthBaseVC {

    @IBOutlet weak var mainContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainContainerView.makeRoundedBorder(withCornerRadius: 12.0)
        mainContainerView.transform = CGAffineTransform(translationX: 0, y: mainContainerView.frame.height)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showPopup()
    }
    
    func didShowPopup() { }
    
    func showPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainContainerView.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }, completion: { _ in
            self.didShowPopup()
        })
    }
    
    func hidePopup(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainContainerView.transform = CGAffineTransform(translationX: 0, y: self.mainContainerView.frame.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: { _ in
            completion()
        })
    }
}
