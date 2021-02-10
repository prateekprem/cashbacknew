//
//  SFCategoryVM.swift
//  Jarvis
//
//  Created by Abhishek Tripathi on 06/12/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

protocol JRHomeItemCollectionInfo {
    var count: Int {get}
    var isHiddenPage: Bool {get}
    func itemForIndexPath(indexPath: IndexPath) -> JRLayoutViewModel
    func setCurrentPage(page: Int)
}

public class SFCategoryVM {
    let maximumNumberInPage: Int = 9
    public private(set) var pageCount:Int = 0
    var currentPage: Int = 0
    private var dataSource: [JRLayoutViewModel] = [JRLayoutViewModel]()
    var isPageCHidden : Bool = true
    var enableInfiniteScroll = true
    weak var deleagte: SFCategoryPopupVCDelegate?
    
    init(layouts: [SFLayoutViewInfo], delegate: SFCategoryPopupVCDelegate?) {
        self.deleagte = delegate
        self.setupInformation(layouts: layouts)
    }
    
    deinit {
        print("Category VM Deinit")
    }
    
   public func setupInformation(layouts: [SFLayoutViewInfo]) {
        self.dataSource.removeAll()
        checkForCircularScroll()
        let actualLayout: [SFLayoutViewInfo] = layouts
        for information in 0..<actualLayout.count {
            let viewModel: [JRLayoutViewModel] = self.startMappingWith(layout: actualLayout[information], viewIds: actualLayout.count)
            if viewModel.count > 0 {
                self.dataSource.append(contentsOf: viewModel)
            }
        }
        self.pageCount = self.dataSource.count
        isPageCHidden = !(self.dataSource.count > 1)
        if self.dataSource.count > 1 && enableInfiniteScroll {
            self.modifyDatasourceForCircularScroll()
        }
    }
    
    func checkForCircularScroll() {
        enableInfiniteScroll = self.deleagte?.circularScrollEnabled() ?? false
    }
    
    func modifyDatasourceForCircularScroll() {
        let firstElement = self.dataSource.first
        let lastElement = self.dataSource.last
        if let firstEl = firstElement, let lastEl = lastElement {
            self.dataSource.insert(lastEl,at: 0)
            self.dataSource.insert(firstEl,at: self.dataSource.endIndex)
        }
    }
    
    func startMappingWith(layout: SFLayoutViewInfo, viewIds: Int) -> [JRLayoutViewModel]  {
        if layout.vItems.count == 0 {
            return []
        }
        var output: [JRLayoutViewModel] = []
        var outputItem: [JRItemViewModel] = []
        let viewId = layout.vId
        let pageId = layout.pageId
        let contextParams = layout.contextParams
        
        for i in 0...layout.vItems.count-1 {
            if i % maximumNumberInPage == 0 {
                if i != 0 {
                    let model: JRLayoutViewModel = JRLayoutViewModel(item: outputItem, title: layout.vTitle, type: layout.layoutVType)
                    output.append(model)
                }
                outputItem = []
                let cellModel = JRItemViewModel(item: layout.vItems[i], viewId: viewId, pageId: pageId, context: contextParams)
                outputItem.append(cellModel)
            } else {
                let cellModel = JRItemViewModel(item: layout.vItems[i], viewId: viewId, pageId: pageId, context: contextParams)
                outputItem.append(cellModel)
            }
        }
        
        let altration = 0
        if outputItem.count > altration {
            let model: JRLayoutViewModel = JRLayoutViewModel(item: outputItem, title: layout.vTitle, type: layout.layoutVType)
            output.append(model)
        }
        return output
    }
    
}

extension SFCategoryVM: JRHomeItemCollectionInfo {
    
    var count: Int {
        return self.dataSource.count
    }
    
    func itemForIndexPath(indexPath: IndexPath) -> JRLayoutViewModel {
        return self.dataSource[indexPath.row]
    }
    
    func setCurrentPage(page: Int) {
        self.currentPage = page
    }
    
    var isHiddenPage: Bool {
        return self.isPageCHidden
    }
}


public class JRLayoutViewModel {
    var title: String? = ""
    public var type: LayoutViewType = .none
    public var items: [JRItemViewModel] = [JRItemViewModel]()
    
    init(item: [JRItemViewModel], title: String?, type: LayoutViewType) {
        self.items = item
        self.title = title ?? ""
        self.type = type
    }
    
    var count: Int {
        return self.items.count
    }
    
    func itemForIndexPath(indexPath: IndexPath) -> JRItemViewModel {
        return self.items[indexPath.row]
    }
}

public class JRItemViewModel {
    var image: String = ""
    public var title: String = ""
    public var item: SFLayoutItem
    public var pageId: Int = 0
    public var viewId: Int = 0
    public var requestId: String = ""
    
    init(item: SFLayoutItem, viewId: Int, pageId: Int, context: [String:Any]?) {
        self.item = item
        self.title = item.itemName
        self.image = item.itemImageUrl
        self.pageId = pageId
        self.viewId = viewId
        if let contxt = context, let reqId = contxt["request_id"] as? String {
            self.requestId = reqId
        }
    }
}
