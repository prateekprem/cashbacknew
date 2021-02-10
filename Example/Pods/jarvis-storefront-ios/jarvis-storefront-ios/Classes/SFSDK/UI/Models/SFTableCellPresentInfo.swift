//
//  SFTableCellPresentInfo.swift
//  StoreFront
//
//  Created by Prakash Jha on 27/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

public typealias SFCellMargin = (top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat)

public enum SFCornerRadius: Equatable {
    case half
    case custom(CGFloat)
}

public enum SFCollRowHeight: Equatable {
    case full              // for single row in collection
    case custom(CGFloat)
}

public enum SFIntType: Equatable {
    case all
    case custom(Int)
}

public class SFTableCellPresentInfo {
    public var margin: SFCellMargin = (0,0,0,0)
    public var hideBottomMarginInCaseOfConsumerApp: Bool = false
    public var bannerScaleFactor: CGFloat = 1/2.0
    public var backColor : UIColor = .white // show in contain area
    public var backImg: UIImage?
    public var tableCellBgImageRoundBy: SFCornerRadius = SFCornerRadius.custom(0)
    public var cellHeight: CGFloat = 80 // Should not be flexible to vertical.
    
    // Font Support
    
    public var collectionRowCount = 1
    public var collectColomnCount: CGFloat = 4
    public var collectTitleClr = UIColor.black
    public var tableWidth: CGFloat = UIScreen.main.bounds.width
    
    // only applicable on the image container..
    public var collectCellRoundBy: SFCornerRadius = SFCornerRadius.custom(0)
    public var collectCellRoundBorder: CGFloat = 0
    public var collectCellRoundClr = UIColor.clear
    public var collectCellBackColor: UIColor = .lightGray
    public var collectRowHeight = SFCollRowHeight.full
    public var collCellImageContentMode: UIView.ContentMode?
    public var tableCellRoundBy: SFCornerRadius = SFCornerRadius.custom(0)
    public var tableCellBorderWidth: CGFloat = 0
    public var tableCellBorderColor = UIColor.clear
    public var tableCellShadowRadius : CGFloat = 0
    public var tableCellShadowOpacity: Float = 0
    public var tableCellShadowColor: UIColor = UIColor.clear
    public var tableCellShadowOffset: CGSize = CGSize(width: 0, height: 0)
    public var collectInterimSpace = CGFloat(0)
    public var collectLineSpace = CGFloat(0)
    public var collectCellMargin: SFCellMargin = (0,0,0,0)
    public var collectCellHandleClassType: Bool = false
    public var collectCellRightBorderhidden: Bool = true
    
    public var isFavStore: Bool = false
    
    public var itemLimit = SFIntType.all
    
    public var showAltImage = true
    public var titleFont : UIFont?
    public var iconHW : CGFloat?
    
    public func evaluteCorrectRowCountWith(itemCount: Int) {
        switch self.collectRowHeight {
        case .custom(let collRH):
            if collectionRowCount > 1 {
                let itemCapicity = collectionRowCount*Int(collectColomnCount)
                
                if itemCapicity > itemCount {
                    let newRCount = Int(ceil(Double(itemCount)/Double(collectColomnCount)))
                    let diff = collectionRowCount - newRCount
                    collectionRowCount = newRCount
                    cellHeight = cellHeight - CGFloat(diff) * CGFloat(collRH)
                }
            }
            
        default: break
        }
    }
    
    public init(height: CGFloat) {
        self.cellHeight = height
    }
}

extension SFTableCellPresentInfo {
    public class func defaultCellInfoFor(layoutType: LayoutViewType) -> SFTableCellPresentInfo {
        let info = SFTableCellPresentInfo(height: layoutType.defaultHeight)
        info.collectionRowCount = 1
        info.collectRowHeight = layoutType.defaultCollectRowHeight
        info.collectLineSpace = SFPresenter.defaultCollectLineSpaceFor(layoutType: layoutType)
        info.collectInterimSpace = SFPresenter.defaultCollectInterimSpaceFor(layoutType: layoutType)
        
        switch layoutType {
        case .smartIconHeader :
            info.backColor = UIColor.blue
            info.collectTitleClr = UIColor.white
            // info.collectCellBackColor = UIColor.colorRGB(0, green: 0, blue: 0, alpha: 0.2)
            info.collectCellRoundBy = .half //.custom(5)
            info.cellHeight = 128.0
            info.tableCellBgImageRoundBy = .custom(10)
        case .smartIconHeaderV2:
            info.collectColomnCount = 4
            
        case .smartIConList :
            info.backColor = UIColor.white
            info.collectTitleClr = UIColor(hex: "566D83")
            info.collectCellBackColor = UIColor.white
            info.collectCellRoundBorder = 1
            info.collectCellRoundBy = .custom(5)
            info.collectionRowCount = 2
            info.collectColomnCount = 3
    
        case .smartIconGroupGrid, .recentsList:
            info.backColor = UIColor.white
            info.collectTitleClr = UIColor(hex: "566D83")
            info.collectCellBackColor = UIColor.white
            info.collectCellRoundBorder = 0.0
            info.collectCellRoundBy = .custom(7)
            info.collectCellRoundClr = UIColor(hex: "DADADA")
            info.collectionRowCount = 2
            info.collectColomnCount = 3
            if layoutType == .smartIconGroupGrid {
                info.itemLimit = .custom(5)
            }
            info.tableCellRoundBy = .custom(8)
            info.tableCellBorderWidth = 1
            info.tableCellBorderColor = UIColor(hex: "F3F7F8")
            info.tableCellShadowRadius = 10
            info.tableCellShadowOpacity = 0.6
            info.tableCellShadowColor = UIColor(red: 0.867, green: 0.898, blue: 0.929, alpha: 0.5)
            info.tableCellShadowOffset = CGSize(width: 10, height: 1)
            info.collCellImageContentMode = .scaleAspectFit
        case .smartIconGrid4xn :
            info.backColor = UIColor.clear
            info.collectTitleClr = UIColor.black
            info.collectCellBackColor = UIColor.white
            info.collectCellRoundBorder = 0.0
            info.collectCellRoundBy = .custom(7)
            info.collectCellRoundClr = UIColor(hex: "DADADA")
            info.collectionRowCount = 2
            info.collectColomnCount = 4 //Fixed 4
            info.tableCellRoundBy = .custom(8)
            info.tableCellBorderWidth = 1
            info.tableCellBorderColor = UIColor(hex: "F3F7F8")
            info.tableCellShadowRadius = 10
            info.tableCellShadowOpacity = 0.6
            info.tableCellShadowColor = UIColor(red: 0.867, green: 0.898, blue: 0.929, alpha: 0.5)
            info.tableCellShadowOffset = CGSize(width: 10, height: 1)
            info.collCellImageContentMode = .scaleAspectFit
            info.itemLimit = .custom(4)
        case .thinBanner:
            info.backColor = UIColor.white
            info.collectColomnCount = 1
            info.collectCellRoundBy = .custom(5)
            info.collectCellMargin = (0, 0, 15, 15)
            info.margin = (12, 12, 0, 0)
            info.bannerScaleFactor = 1/3.6
        case .thinSmall:
            info.backColor = UIColor.white
            info.collectColomnCount = 1
            info.collectCellRoundBy = .custom(5)
            info.collectCellMargin = (0, 0, 15, 15)
            info.margin = (12, 12, 0, 0)
            info.bannerScaleFactor = 1/7.2
            
        case .smartIconCarousel:
            // info.backColor = UIColor(hex: "F6F8FA")
            info.collectCellBackColor = UIColor.white
            info.cellHeight = 120
            info.collectCellRoundBy = .custom(5)
            info.collectColomnCount = 3
            
        case .carouselReco:
               info.backColor = UIColor.white
            info.collectCellBackColor = UIColor.white
            info.collectCellRoundBy = .custom(5)
            info.collectColomnCount = 3
            info.tableCellRoundBy = .custom(8)
            info.tableCellBorderWidth = 1
            info.tableCellBorderColor = UIColor(hex: "DDE5ED")
            info.collectLineSpace = 0
            
        case .carouselReco4x:
            info.backColor = UIColor.clear
            info.collectColomnCount = 1
            info.tableCellRoundBy = .custom(8)
            info.collectLineSpace = 0
            info.collectTitleClr = UIColor(hex: "566D83")
            info.collectCellBackColor = UIColor.clear
            info.collectCellRoundBorder = 0.0
            info.collectCellRoundBy = .custom(7)
            info.collectCellRoundClr = UIColor(hex: "DADADA")
            info.collectionRowCount = 1
            info.collectLineSpace = 15

        case .smartIconButton :
            info.backColor = UIColor.white
            info.collectTitleClr = UIColor(hex: "07448E")
            info.collectCellBackColor = UIColor.white
            info.collectCellRoundBorder = 0.0
            info.collectCellRoundBy = .custom(8)
            info.collectCellRoundClr = UIColor(hex: "DADADA")
            info.collectionRowCount = 1
            info.collectColomnCount = 2
            
        case .smartIconButton2xn :
            info.backColor = UIColor.clear
            info.collectTitleClr = UIColor.black
            info.collectCellBackColor = UIColor.white
            info.collectCellRoundBorder = 0.0
            info.collectionRowCount = 2
            info.itemLimit = .custom(4)
        case .banner2xn:
            info.collectColomnCount = 2
        case .banner3xn:
            info.collectionRowCount = 2
            info.collectColomnCount = 3
            info.collCellImageContentMode = .scaleAspectFit
        case .portrait3xn:
            info.collectCellRoundBy = .custom(10)
            info.collectColomnCount = 3
            info.collectLineSpace = 10
            info.backColor = .clear
            info.collCellImageContentMode = .scaleAspectFit
        case .carousel4:
            info.collectCellRoundBy = .custom(5)
        case .carouselBs1:
            info.collectCellRoundBy = .custom(5)
            info.collectColomnCount = 2.5
        case .carouselBs2:
            info.collectCellRoundBy = .custom(5)
            info.itemLimit = .custom(15)
        case .rowBs2, .row:
            info.collectColomnCount = 2.2
            info.itemLimit = .custom(15)
        case .rowBs1:
            info.collectCellRoundBy = .custom(5)
            info.tableCellBgImageRoundBy = .custom(5)
        case .h1Banner:
            info.collectColomnCount = 1
            info.collectCellMargin = (0, 0, 15, 15)
            info.collectCellRoundBy = .custom(5)
            info.margin = (12, 12, 0, 0)
            info.bannerScaleFactor = 1/1.6
        case .h1FullBanner:
            info.collectColomnCount = 1
            info.collectCellMargin = (0, 0, 15, 15)
            info.collectCellRoundBy = .custom(5)
            info.margin = (12, 12, 0, 0)
            info.bannerScaleFactor = 460/375.0
        case .carousel1:
            info.collectColomnCount = 1.2
        case .carousel1_3:
            info.backColor = UIColor.clear
            info.collectColomnCount = 1.2
            info.collectCellRoundBy = .custom(8)
            info.collectLineSpace = 5
        case .carousel2:
            info.collectColomnCount = 1.7
            info.collectCellMargin = (0, 0, 15, 15)
            info.collectCellRightBorderhidden = false
        case .deals2xn:
            info.backColor = UIColor(red: 242/255, green: 251/255, blue: 254/255, alpha: 1.0)
        case .video: 
            info.collectColomnCount = 1
            info.collectionRowCount = 1
        case .banner3_0:
            info.backColor = UIColor.white
            info.collectCellRoundBy = .custom(5)
            info.collectColomnCount = 1
            info.collectCellMargin = (0, 0, 15, 15)
            info.margin = (16,16,0,0)
            info.bannerScaleFactor = 1/3.0
        case .banner2_0:
            info.backColor = UIColor.clear
            info.collectCellRoundBy = .custom(5)
            info.collectColomnCount = 1
            info.collectCellMargin = (0, 0, 15, 15)
            info.collectCellHandleClassType = true
            info.margin = (20,20,0,0)
            info.hideBottomMarginInCaseOfConsumerApp = true
            info.bannerScaleFactor = 1/2.0
        case .listSmallTi:
            info.backColor = UIColor.clear
        case .voucher3xn:
            info.collCellImageContentMode = .scaleAspectFit
            info.isFavStore = true
            
        default: break
        }
        
        return info
    }
    
    public func setCellHeightForSpecificCondition(viewInfo: SFLayoutViewInfo) {
        
//        if (viewInfo.layoutVType == .h1Banner) , let classType = viewInfo.classType, !classType.isEmpty, classType.lowercased() == H1Bannerclass.fullwidthimage.rawValue {
//            // Left and right padding is also increased for this case only, for maintaining aspect ration adding 15 + 15
//            self.cellHeight = SFPresenter.defaultCellHeightFor(layoutType: .h1Banner) + 15 + 15
//        }
    }
}
