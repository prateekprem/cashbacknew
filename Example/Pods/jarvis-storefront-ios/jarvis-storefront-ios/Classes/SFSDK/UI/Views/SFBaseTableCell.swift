//
//  SFBaseTableCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

public class SFBaseTableCell: UITableViewCell {
    weak var layout : SFLayoutViewInfo?
    private(set) var index = 0 // must set this
    private(set) var rowIndex = 0 // must set this
    private(set) var indexPath: IndexPath?
    
    @IBOutlet weak var containV: UIView?
    @IBOutlet weak var imgV: UIImageView?
    @IBOutlet weak var borderView: UIView?
    
    weak public var categoryDatasource: SFCategoryDatasource?
    
    let placeholderImage = UIImage.imageNamed(name: "mp_placeholder")
    
   public class func register(table: UITableView) { }
    class var cellId: String { return "" }
    
    public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        self.layout = info
        self.indexPath = indexPath
        self.index = indexPath.section
        self.rowIndex = indexPath.row
        
        guard let presentInfo = self.layout?.cellPresentInfo else { return }
        if let vv = self.containV {
            vv.backgroundColor = presentInfo.backColor
            makeRounded(view: vv, roundV: presentInfo.tableCellBgImageRoundBy)
        } else {
            self.backgroundColor = presentInfo.backColor
        }
        if let bv = self.borderView {
            bv.layer.borderWidth = presentInfo.tableCellBorderWidth
            bv.layer.borderColor = presentInfo.tableCellBorderColor.cgColor
            makeRounded(view: bv, roundV: presentInfo.tableCellRoundBy)
            bv.layer.backgroundColor = UIColor.white.cgColor
            bv.sfMakeShadow(shadowRadius: presentInfo.tableCellShadowRadius, shadowOpacity: presentInfo.tableCellShadowOpacity, shadowColor: presentInfo.tableCellShadowColor.cgColor, shadowOffset: presentInfo.tableCellShadowOffset)
        }
        if let imageV = self.imgV {
            imageV.image = presentInfo.backImg
        }
    }
    
    public func showRecoAsChild(info: SFLayoutViewInfo?, indexPath: IndexPath) { }
    
    public func pauseResumeAutoScroll(isResume: Bool) {
        
    }

//    public func suspendTimer() {
//
//    }

    public func addChildView(_ view: UIView) {
        
    }
    
    public func hideInfoForFlashSale(_ hide: Bool) {
        
    }
    
    public func invalidateTimerForTabbed2Cell() {
        
    }
    
    func makeRounded(view: UIView, roundV: SFCornerRadius) {
        var roundBy: CGFloat = 0
        switch roundV {
        case .half:
            roundBy = view.frame.width/2.0
        case .custom(let value):
            roundBy = value
        }
        view.sfRoundCorner(roundBy)
    }
        
    public func logImpressionForItem(item: SFLayoutItem?){
        guard let mLayout = self.layout, let itemToLog = item , let viewInfoToLog = self.layout else { return }
        
        guard let delegate = mLayout.pDelegate else { return }
        delegate.sfLogImpressionForItem(item: itemToLog, viewInfo: viewInfoToLog)
    }
    
    public func containerType() -> SFAppType {
        return self.layout?.containerType ?? .other
    }
}
