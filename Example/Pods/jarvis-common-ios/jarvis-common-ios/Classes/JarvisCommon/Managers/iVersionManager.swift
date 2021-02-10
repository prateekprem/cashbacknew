//
//  iVersionManager.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 06/08/19.
//

import UIKit
import jarvis_utility_ios

internal class iVersionManager: NSObject,iVersionDelegate {
    private(set) static var shared : iVersionManager = iVersionManager()
    
    class func init_iVarsion() {
        iVersion.sharedInstance().appStoreID = "\(JRUtility.appStoreID)"
        iVersion.sharedInstance().delegate = iVersionManager.shared
        if let url = URL(string: GlobalConstants.JRAppStoreUpdateURL) {
            iVersion.sharedInstance().updateURL = url
        }
    }
    
    func iVersionDidNotDetectNewVersion() {
        NotificationCenter.default.post(name: Notification.Name.JRGotResultFromVersionCheck,
                                        object: nil, userInfo: ["newVersionPresent": false, "newVersion": ""])
    }
    
    func iVersionVersionCheckDidFailWithError(_ error: Error!) {
        NotificationCenter.default.post(name: Notification.Name.JRGotResultFromVersionCheck,
                                        object: nil, userInfo: ["newVersionPresent": false, "newVersion": ""])
    }
    
    func iVersionDidDetectNewVersion(_ version: String!, details versionDetails: String!) {
        NotificationCenter.default.post(name: Notification.Name.JRGotResultFromVersionCheck,
                                        object: nil, userInfo: ["newVersionPresent": true, "newVersion": version ?? ""])
    }
}


