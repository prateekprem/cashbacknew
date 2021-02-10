//
//  JRDIYAccountUnblockHelper.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 13/10/20.
//

import UIKit

public class JRDIYAccountUnblockHelper {
    static public let sharedInstance = JRDIYAccountUnblockHelper()
    private var completion: ((Bool) -> ())?
    private init() {}
    
    // Exposed Method
    public func presentPopup(withModel model: JRDIYAccountUnblockPopupViewModel, completion: @escaping (Bool) -> ()) {
        self.completion = completion
        let popup = getPopupController()
        DispatchQueue.main.async {
            popup.viewModel = JRDIYAccountUnblockPopupViewModel(title: model.title,
                                                                subtitle: model.subtitle,
                                                                confirmText: model.confirmText,
                                                                cancelText: model.cancelText)
            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
        }
    }
    
    // Private Methods
    private func getPopupController() -> JRDIYAccountUnblockPopup {
        guard let controller = JRDIYAccountUnblockPopup.getController() else { return JRDIYAccountUnblockPopup() }
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.delegate = self
        return controller
    }
    
    private func handleCompletion(value: Bool) {
        guard let completion = completion else { return }
        completion(value)
    }
}

// JRDIYUnblockProtocol Methods
extension JRDIYAccountUnblockHelper: JRDIYUnblockProtocol {
    func proceedClicked() {
        handleCompletion(value: true)
    }
    
    func cancelClicked() {
        handleCompletion(value: false)
    }
}
