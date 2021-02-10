//
//  PANetworkDispatcher.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 05/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

class PANetworkDispatcher: NSObject {
    
    static let shared = PANetworkDispatcher()
    
    private var isDispatching = false
    
    func startDispatching() {
        switch PANetworkSession.shared.dispatchStrategy {
        case .manual:
            //DO NOTHING ON INITIALIZATION : USER WILL CHOOSE WHEN TO DISOATCH DATA TO SERVER
            //CALL METHOD PASignalDispatcher.shared.dispatch() to start dispatch
            break
        case .intervalBased(let interval):
            //UPLOAD DATA AFTER EACH INTEVAL CONFIGURED AT THE INITIALIAZATION
            startIntervalDispatch(interval: interval)
            break
        case .background:
            //TODO: BACKGROUND DISPATCH
            //UPLOAD DATA WHEN APP GOES TO BACKGROUNND
            break
        }
    }
    
    @objc private func uploadDataToServer() {
        isDispatching = true
        
        let currentTimeStamp = PADateHelper.getCurrentDateInMillis()
        PALogger.log(message: "STARTED DATA UPLOAD before \(currentTimeStamp): NETWORK CALL", withPAType: .networkSDK)
        
        PANetworkSession.shared.markStaged(upUntil: currentTimeStamp) { [weak self] (success) in
            guard let self = self else { return }
            
            if success {
                PANetworkSession.shared.sendDataToServer(withCompletionHandler: { (uploadSuccess) in
                    if uploadSuccess {
                        PANetworkSession.shared.deleteStagedData { _ in
                            self.isDispatching = false
                        }
                    } else {
                        self.isDispatching = false
                        PALogger.log(message: "FAILED TO UPLOAD DATA", withPAType: .networkSDK, andMessageType: .fail)
                    }
                })
            } else {
                self.isDispatching = false
                PALogger.log(message: "ERROR IN STAGING DATA", withPAType: .networkSDK, andMessageType: .fail)
            }
        }
    }
    
}

//MARK: MANUAL DISPATCH
private extension PANetworkDispatcher {
    
    func dispatch() {
        if isDispatching {
            // Data already being dispatched, try after an interval of 10 seconds
            perform(#selector(uploadDataToServer), with: nil, afterDelay: 10.0)
        } else {
            uploadDataToServer()
        }
    }
    
}

//MARK: INTERVAL BASED DISPATCH
private extension PANetworkDispatcher {
    
    func startIntervalDispatch(interval: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self, !self.isDispatching else {
                // Wait for next dispatch cycle as data is being uploaded
                return
            }
            self.uploadDataToServer()
        }
    }
    
}
