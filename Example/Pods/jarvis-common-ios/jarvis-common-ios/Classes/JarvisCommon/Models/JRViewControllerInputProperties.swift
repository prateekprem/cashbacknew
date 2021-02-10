//
//  JRViewControllerInputProperties.swift
//  jarvis-common-ios
//
//  Created by Shivam Jaiswal on 21/12/20.
//

import Foundation

@objcMembers
public class JRViewControllerInputProperties: NSObject {
    public var urlType: String?
    public var url: String?
    public var relatedCategories: [JRRelatedRechargeCategory]?
    public var origin: String?
    public var httpMethod: String?
    public var item: JRItem?
    public var title: String?
    public var deeplinkInfo: [AnyHashable : Any]?
    public var isFromDeeplinking = false
    public var searchType: String?
    /// Input/output properties. These can be set from inside to check outside and do some operation.
    public var isModalPresentation = false
    public var baseTab = 0
}
