//
//  JRCBSFLayout.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 22/01/20.
//

import Foundation
import jarvis_storefront_ios

class JRCBSFLayout {
    private(set) var lType: LayoutViewType = .lCBScratchCards //lCBLockedCards
    private(set) var lTitle: String = ""
    private(set) var lItems = [JRCBSFItem]()
    private(set) var cellConfig = JRCBSFLayoutCellDisplayConfig.cellConfig(lType: .lCBScratchCards)
    
    init() { }
    
    init(type: LayoutViewType, title: String, items: [JRCBSFItem]) {
        self.lType = type
        self.cellConfig = JRCBSFLayoutCellDisplayConfig.cellConfig(lType: lType)
        self.lTitle = title
        self.lItems = items
    }
    
    func update(title: String)       { self.lTitle = title }
    func update(items: [JRCBSFItem]) { self.lItems = items }
    func removeItem(at: Int) { self.lItems.remove(at: at) }
    
    class var locallySupportedLayouts: [LayoutViewType] { return [.lCBScratchCards, .lCBLockedCards] }
    
    class func emptyWith(type: LayoutViewType, title: String) -> JRCBSFLayout {
        let items = [JRCBSFItem.loadingItem, JRCBSFItem.loadingItem, JRCBSFItem.loadingItem]
        return JRCBSFLayout(type: type, title: title, items: items)
    }
}


class JRCBSFLayoutCellDisplayConfig {
    private(set) var identifier      : String  = JRCBScratchWonCVC.identifier
    private(set) var cellHeight      : CGFloat = 395.0
    private(set) var contentSZ       : CGSize  = CGSize(width: 100, height: 260)
    private(set) var itemsToDisplay  : CGFloat = 2.27 // in a row
    private(set) var collCellMargine : CGFloat = 16.0

    init(identifier: String = JRCBScratchWonCVC.identifier, showTitle: Bool = true,
         nItemsInRow: CGFloat = 2.27, ratio: CGFloat = 1.16) {
        
        self.identifier = identifier
        self.itemsToDisplay = nItemsInRow
        self.contentSZ = JRCBSFLayoutCellDisplayConfig.sizeWith(ratio: ratio, margin: self.collCellMargine,
                                                                displayCount: self.itemsToDisplay)
        self.cellHeight = self.contentSZ.height + 72
    }
    
    class func sizeWith(ratio: CGFloat, margin: CGFloat = 16.0, displayCount: CGFloat) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let ww = screenWidth/displayCount
        let noOfItem = Int(displayCount)
        let margineScale: CGFloat = noOfItem>1 ? 1.5 : 2
        let fWW = ww - (margin * margineScale)
        let fHh = fWW * ratio
        return CGSize(width: fWW, height: fHh)
    }

    class func cellConfig(lType: LayoutViewType) -> JRCBSFLayoutCellDisplayConfig {
        return JRCBSFLayoutCellDisplayConfig()
    }
}

class JRCBSFItem {
    private(set) var rId: String         = ""
    private(set) var rTitle: String      = ""
    private(set) var rBackImg: String    = ""
    private(set) var rDeeplink: String   = ""
    private(set) var rIsViewAll: Bool    = false
    private(set) var isLoading: Bool     = false
    
    init() {}
    init(dict: JRCBJSONDictionary) {
        self.rId = dict.stringFor(key: "id")
        self.rTitle = dict.stringFor(key: "title")
        self.rBackImg = dict.stringFor(key: "image_url")
        self.rDeeplink = dict.stringFor(key: "url")
    }
    
    init(title: String, viewAll: Bool, backImg: String) {
        self.rTitle = title
        self.rIsViewAll = viewAll
        self.rBackImg = backImg
    }
    
    class var loadingItem: JRCBSFItem {
        let item = JRCBSFItem()
        item.isLoading = true
        return item
    }
}
