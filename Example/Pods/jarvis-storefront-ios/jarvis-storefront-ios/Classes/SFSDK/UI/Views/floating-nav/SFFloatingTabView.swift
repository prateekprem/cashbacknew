//
//  SFFloatingTabView.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 26/06/20.
//

import UIKit

public class SFFloatingTabView: UIView {
    
    private var layout: SFLayoutViewInfo?
    private let maxItem: Int = 5
    private let tabHeight: CGFloat = 64
    private let bottomTabMargin: CGFloat = 37
    private let leftRightTabMargin: CGFloat = 24
    
    private var tabButtons: [SFFloatingTabButton] = [SFFloatingTabButton]()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: Public Methods
    static func loadView(_ layoutInfo: SFLayoutViewInfo) -> SFFloatingTabView {
        let floatingView = Bundle.sfBundle.loadNibNamed("SFFloatingTabView", owner: self, options: nil)?.first as! SFFloatingTabView
        floatingView.layout = layoutInfo
        return floatingView
    }
    
    public func show() {
        loadTabItems()
    }
        
    
    public func centerPointForButtonWith(uniqueName: String) -> CGPoint {
        guard let fr = self.getItemRect(uniqueName) else {
            return CGPoint(x: -1, y: -1)
        }
        let yy = self.frame.origin.y - self.frame.height/2.0
        let xx = self.frame.origin.x + fr.origin.x + fr.width/2.0
        return CGPoint(x: xx, y: yy)
    }
    
    
    public func showDotOnTabItem(uniqueName: String, animated: Bool) {
        guard let itemButton = self.buttonWith(uniqueName: uniqueName) else {
            return
        }
                
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                itemButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                
            }, completion: { (success) in
                UIView.animate(withDuration: 0.4) {
                    itemButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                itemButton.shShowDot = true
            })
        } else {
            itemButton.shShowDot = true
        }
    }
    
    public func showDotOnTabItem(uniqueName: String) {
        guard let itemButton = self.buttonWith(uniqueName: uniqueName) else {
            return
        }
        itemButton.shShowDot = true
    }
}

// MARK: Private Methods
extension SFFloatingTabView {
    
    private func loadTabItems() {
        guard let items = layout?.vItems, !items.isEmpty else {
            return
        }
        
        let tabItems: [SFLayoutItem] = Array(items.prefix(maxItem))
        if tabItems.count == 1 {
            setupTabForOneItem(tabItems[0])
        }
        else {
            setupTabItems(tabItems)
        }
    }
    
    private func setupTabForOneItem(_ tabItem: SFLayoutItem) {
        let screenBounds = UIScreen.main.bounds
        
        let oneItemWidth: CGFloat = (screenBounds.width - leftRightTabMargin) / CGFloat(maxItem)
        
        let tabWidth: CGFloat = 2 * oneItemWidth
        let tabX: CGFloat = (screenBounds.width / 2) - (tabWidth / 2)
        let tabY = screenBounds.height - tabHeight - bottomTabMargin
        let tabFrame = CGRect(x: tabX, y: tabY, width: tabWidth, height: tabHeight)
        self.frame = tabFrame
        
        tabButtons.removeAll()
        let itemFrame = CGRect(x: 0, y: 0, width: tabWidth, height: self.frame.height)
        let tabItemButton = SFFloatingTabButton.singleButton(itemFrame)
        tabButtons.append(tabItemButton)
        tabItemButton.delegate = self
        tabItemButton.configureButton(tabItem, isTitlePresent: tabItem.itemTitle.isValidString())
        self.addSubview(tabItemButton)
        
        self.roundCorner(0, nil, self.frame.height/2.0, true)
    }
    
    
    private func setupTabItems(_ tabItems: [SFLayoutItem]) {
        let screenBounds = UIScreen.main.bounds
       
        let oneItemWidth: CGFloat = (screenBounds.width - leftRightTabMargin) / CGFloat(maxItem)
        
        let noOfItem = tabItems.count
        let tabWidth: CGFloat = CGFloat(noOfItem) * oneItemWidth
        let tabX: CGFloat = (screenBounds.width / 2) - (tabWidth / 2)
        let tabY = screenBounds.height - tabHeight - bottomTabMargin
        let tabFrame = CGRect(x: tabX, y: tabY, width: tabWidth, height: tabHeight)
        self.frame = tabFrame
        
        var isTitlePresent: Bool = false
        for item in tabItems {
            if item.itemTitle.isValidString() {
                isTitlePresent = true
                break
            }
        }
        
        tabButtons.removeAll()
        var xPos: CGFloat = 0
        for item in tabItems {
            let itemFrame = CGRect(x: xPos, y: 0, width: oneItemWidth, height: self.frame.height)
            let tabItemButton = SFFloatingTabButton.button(itemFrame)
            tabButtons.append(tabItemButton)
            tabItemButton.delegate = self
            tabItemButton.configureButton(item, isTitlePresent: isTitlePresent)
            self.addSubview(tabItemButton)
            xPos = xPos + oneItemWidth
            
            if let layout = layout {
                layout.pDelegate?.sfLogImpressionForItem(item: item, viewInfo: layout)
            }
        }
        
        let cornerRadius: CGFloat = CGFloat(12 + (maxItem - noOfItem) * 4)
        self.roundCorner(0, nil, cornerRadius, true)
    }
    
    private func buttonWith(uniqueName: String) -> SFFloatingTabButton? {
        guard let items = layout?.vItems, let index = items.index(where: { $0.itemTag.caseInsensitiveCompare(uniqueName) == .orderedSame || $0.itemName.caseInsensitiveCompare(uniqueName) == .orderedSame }), index < maxItem else {
            return nil
        }
        
        return tabButtons[index]
    }
    
    private func getItemRect(_ itemUniqueName: String) -> CGRect? {
        guard let itemButton = buttonWith(uniqueName: itemUniqueName) else {
            return nil
        }
        
        return itemButton.frame
    }
}

extension SFFloatingTabView: SFFloatingTabButtonDelegate {
    func didClickItem(_ layoutItem: SFLayoutItem) {
        guard let layoutViewInfo = layout else {
            return
        }
        layoutViewInfo.pDelegate?.sfDidClickFloatingTabItem(layoutItem)
        layoutViewInfo.pDelegate?.sfLogClickForItem(item: layoutItem, viewInfo: layoutViewInfo)
    }
}

