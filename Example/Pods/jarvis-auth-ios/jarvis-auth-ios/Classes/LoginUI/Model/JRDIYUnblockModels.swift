//
//  JRDIYUnblockModels.swift
//  jarvis-auth-ios
//
//  Created by Deepanshu Jain on 14/10/20.
//

import Foundation

protocol JRDIYUnblockProtocol: class {
    func proceedClicked()
    func cancelClicked()
}

public struct JRDIYAccountUnblockPopupViewModel {
    let title: String
    let subtitle: String
    let confirmText: String
    let cancelText: String?
    
    public init(title: String, subtitle: String, confirmText: String, cancelText: String?) {
        self.title = title
        self.subtitle = subtitle
        self.confirmText = confirmText
        self.cancelText = cancelText
    }
}
