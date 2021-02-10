//
//  JRSwiftConstants.swift
//  Jarvis
//
//  Created by Shrinivasa Bhat on 30/12/15.
//  Copyright © 2015 One97. All rights reserved.
//

import Foundation
import UIKit

public let JROriginalUrlString = "JROriginalUrlString"
public let JRUrlString = "url"

@objc public class JRSwiftConstants: NSObject {
    @objc public class var windowWidth: CGFloat {
        if let rootwindow = UIApplication.shared.delegate?.window, let view = rootwindow!.rootViewController?.view{
            return view.bounds.size.width
        }
        return 0
    }
    
    @objc public class var windowHeigth: CGFloat {
        if let rootwindow = UIApplication.shared.delegate?.window, let view = rootwindow!.rootViewController?.view{
            return view.bounds.size.height
        }
        return 0
    }
    
    @objc public static var orientationMask: UIInterfaceOrientationMask = [.portrait]
}
