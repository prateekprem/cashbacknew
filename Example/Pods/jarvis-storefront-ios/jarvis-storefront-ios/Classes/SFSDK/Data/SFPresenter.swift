//
//  SFPresenter.swift
//  StoreFront
//
//  Created by Prakash Jha on 24/07/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

public protocol SFCategoryDatasource: class {
    func sfSDKGetLayoutData() -> [SFLayoutViewInfo]
}

extension SFCategoryDatasource {
    public func sfSDKGetLayoutData() -> [SFLayoutViewInfo] {return []}
}

public protocol SFLayoutPresentDatasource: class {
    func sfSDKLayoutPresentInfoFor(type: LayoutViewType) -> SFTableCellPresentInfo?
    func sfSDKShouldIgnore(layoutId: Int) -> Bool
    func sfSDKShouldIgnore(type: LayoutViewType) -> Bool
    func sfSDKShouldSupportLayout(type: LayoutViewType) -> Bool
    func sfSDKShouldIgnoreItemCountValidationFor(type: LayoutViewType) -> Bool
    func sfAnalyticsBatchCount() -> Int
}

extension SFLayoutPresentDatasource {
    public func sfSDKLayoutPresentInfoFor(type: LayoutViewType) -> SFTableCellPresentInfo? {
        return type.defaultPresentCellInfo
    }
    
    public func sfSDKShouldIgnore(layoutId: Int) -> Bool { return false }
    public func sfSDKShouldIgnore(type: LayoutViewType) -> Bool { return false }
    public func sfSDKShouldSupportLayout(type: LayoutViewType) -> Bool { return true }
    public func sfSDKShouldIgnoreItemCountValidationFor(type: LayoutViewType) -> Bool { return false}
    public func sfAnalyticsBatchCount() -> Int { return 1 }
}

public protocol SFLayoutPresentDelegate: class {
    /**
        Do not use any Analytics this sfSDKDidSelect method.
     */
    func sfSDKDidSelect(info: SFLayoutItem?, tableIndex: Int, collectIndex: Int, type: LayoutViewType)
    func reloadSection(_ indexPath: IndexPath)
    func sfDidClickViewAll(layout: SFLayoutViewInfo, page: Int)
    func sfDidClickFloatingTabItem(_ item: SFLayoutItem)
    func sfPresenterSupportTypes() -> [LayoutViewType]
    // more will be appended at end and the header will be at start, so only you need to pass at: in case of else
    func sfPresenterAppendItemForLayout(type: LayoutViewType) -> (at: Int, item: SFLayoutItem?)
    func sfDidClickOnRetry(_ item: SFLayoutItem)
    func sfAddToCart(_ item: SFLayoutItem, completionHandler: ((_ error: Error?) -> Void)?)
    func sfDeleteFromCart(_ item: SFLayoutItem,count: Int, completionHandler: ((_ error: Error?) -> Void)?)
    func sfDidClickOnWishlist(_ item: SFLayoutItem, completionHandler: ((_ error: Error?, _ isAdded: Bool) -> Void)?)
    func sfIsItemPresentInWishlist(_ item: SFLayoutItem) -> Bool
    func sfNavigateToCart()
    func sfGetCartItems() -> [SFLayoutItem]
    func sfGetWishlistItems() -> [SFLayoutItem]
    func sfGetRecentlyViewedItems() -> [SFLayoutItem]
    func sfGetActiveOrderItems() -> [SFLayoutItem]
    func sfDidClickViewAll(_ layout: SFLayoutViewInfo)
    func sfDidClickViewAllDeals(_ layout: SFLayoutViewInfo)
    func sfFeedItemClicked(item: SFLayoutItem, actionType: FeedAction, indexPath: IndexPath)
    func sfVariantTapped(item: SFLayoutItem, parent: SFLayoutItem)
    func getItemQuantityCountFromCart(_ item: SFLayoutItem) -> (Int,Int)
    func sfbackButtonTapped(_ view: SFLayoutViewInfo)
    func sfSearchTapped(_ view: SFLayoutViewInfo)
    func sfVideoHandleDeeplink(url: URL, awaitProcessing: Bool)
    func spVideoPushEvent(_ type: String, toTime time: Int?)
    func sfDidClickOnFlashSaleItemAtIndex(_ index: Int)
    func sfDidClickCTA(item: SFLayoutItem)
    func followUnfollow(_ follow: Bool, completionHandler: ((_ success: Bool)->Void)?)
    func sfDidClickExpand(layout: SFLayoutViewInfo, indexPath: IndexPath) //indexPath in table cell index path
    func sfHandleFooterShowMoreClick(_ url:String, type: LayoutViewType, showMoreText: String)
    func sfHandleClickForItem(_ item:SFLayoutItem)
    func sfShowCategoryPopup(_ layouts: [SFLayoutViewInfo],_ item:SFLayoutItem,_ layout:  SFLayoutViewInfo?)
    func sfRemoveRecoWidget(indexPath: IndexPath)
    func expandReco(recoRemovedObserver:(() -> Void)?, recoInfo:SFLayoutViewInfo,indexPath:IndexPath)
    func sfGetTableViewWidth() -> CGFloat?
    func getPhoneContact(phoneNumber: String) -> String?
    // Analytics
    /**
        This method is used for logging impression of storefornt widgets.
        This method has default implementation which triggers impression from storefront sdk via bridge.
        Do not implement this method until you need customization in analytics data.
     */
    func sfLogImpressionForItem(item: SFLayoutItem , viewInfo: SFLayoutViewInfo)
    /**
       This method is used for logging clicks of storefornt widgets.
       This method has default implementation which triggers clicks event from storefront sdk via bridge.
       Do not implement this method until you need customization in analytics data.
    */
    func sfLogClickForItem(item: SFLayoutItem , viewInfo: SFLayoutViewInfo)
}

extension SFLayoutPresentDelegate {
    public func sfSDKDidSelect(info: SFLayoutItem?, tableIndex: Int, collectIndex: Int, type: LayoutViewType) {}
    public func reloadSection(_ indexPath: IndexPath) { }
    public func sfDidClickViewAll(layout: SFLayoutViewInfo, page: Int) {}
    public func sfDidClickFloatingTabItem(_ item: SFLayoutItem) {}
    public func sfPresenterSupportTypes() -> [LayoutViewType] { return LayoutViewType.allCases}
    public func sfPresenterAppendItemForLayout(type: LayoutViewType) -> (at: Int, item: SFLayoutItem?) { return (0, nil) }
    public func sfDidClickOnRetry(_ item: SFLayoutItem) {}
    public func sfAddToCart(_ item: SFLayoutItem, completionHandler: ((_ error: Error?) -> Void)?) {}
    public func sfDeleteFromCart(_ item: SFLayoutItem,count: Int , completionHandler: ((_ error: Error?) -> Void)?) {}
    public func sfDidClickOnWishlist(_ item: SFLayoutItem, completionHandler: ((_ error: Error?, _ isAdded: Bool) -> Void)?) {}
    public func sfIsItemPresentInWishlist(_ item: SFLayoutItem) -> Bool { return false }
    public func sfNavigateToCart() { }
    public func sfGetCartItems() -> [SFLayoutItem] { return [] }
    public func sfGetWishlistItems() -> [SFLayoutItem] { return [] }
    public func sfGetRecentlyViewedItems() -> [SFLayoutItem] { return [] }
    public func sfGetActiveOrderItems() -> [SFLayoutItem] { return [] }
    public func sfDidClickViewAll(_ layout: SFLayoutViewInfo) { }
    public func sfDidClickViewAllDeals(_ layout: SFLayoutViewInfo) {}
    public func sfGetTableViewWidth() -> CGFloat? {
        return nil
    }
    public func sfLogImpressionForItem(item: SFLayoutItem, viewInfo: SFLayoutViewInfo) {
        if let batchCount: Int = viewInfo.pDatasource?.sfAnalyticsBatchCount() {
            SFItemTracker.shared.setBatchCount(batchCount)
        }
        if !(SFManager.shared.shouldFireGAEvent["\(viewInfo.pageId)"] ?? true) {
            return
        }
        if let itemDict =  SFManager.shared.itemDictEventFired["\(viewInfo.pageId)"] as? [String : Bool] {
            if  itemDict.getBoolForKey("\(item.itemId)") {
                return
            } else {
                SFManager.shared.itemDictEventFired["\(viewInfo.pageId)"]?["\(item.itemId)"] = true
            }
        } else {
            SFManager.shared.itemDictEventFired["\(viewInfo.pageId)"] = [:]
            SFManager.shared.itemDictEventFired["\(viewInfo.pageId)"]?["\(item.itemId)"] = true
        }
        DispatchQueue.global(qos: .background).async {
            var trackingDict: [String:Any] = [String:Any]()
            if item.isPromo {
                trackingDict = viewInfo.gaPromotionImpressionParamFor(item: item)
                if viewInfo.verticalName.isValidString() {
                    SFItemTracker.shared.logPromotionImpressionForItem(dict: trackingDict,verticalName: viewInfo.verticalName, pageName: viewInfo.gaKey)
                }
            }else {
                trackingDict = viewInfo.gaProductImpressionParamFor(item: item)
                trackingDict["dimension39"] = 1
                if viewInfo.verticalName.isValidString() {
                    SFItemTracker.shared.logProductImpressionForItem(dict: trackingDict,verticalName: viewInfo.verticalName, pageName: viewInfo.gaKey)
                }
            }
        }
    }
    
    public func sfLogClickForItem(item: SFLayoutItem, viewInfo: SFLayoutViewInfo) {
        var trackingDict: [String:Any] = [String:Any]()
        if item.isPromo {
            trackingDict = viewInfo.gaPromotionImpressionParamFor(item: item)
            if viewInfo.verticalName.isValidString() {
                if item.itemType == .showMore {
                    trackingDict["internal_promotion_creative"] = "Show More"
                    trackingDict["event_category"] = "Enhanced Ecommerce"
                }
                SFItemTracker.shared.logPromotionClickForItem(dict: trackingDict, verticalName: viewInfo.verticalName, pageName: viewInfo.gaKey)
            }
        }else {
            trackingDict = viewInfo.gaProductImpressionParamFor(item: item)
            trackingDict["dimension39"] = 1
            if viewInfo.verticalName.isValidString() {
                SFItemTracker.shared.logProductClickForItem(dict: trackingDict, verticalName: viewInfo.verticalName, pageName: viewInfo.gaKey)
            }
        }
    }
    public func sfFeedItemClicked(item: SFLayoutItem, actionType: FeedAction, indexPath: IndexPath) {}
    public func getItemQuantityCountFromCart(_ item: SFLayoutItem) -> (Int,Int) { return (0,0)}
    public func sfbackButtonTapped(_ view: SFLayoutViewInfo) {}
    public func sfSearchTapped(_ view: SFLayoutViewInfo) {}
    public func sfVideoHandleDeeplink(url: URL, awaitProcessing: Bool){ }
    public func spVideoPushEvent(_ type: String, toTime time: Int?){ }
    public func sfVariantTapped(item: SFLayoutItem, parent: SFLayoutItem) {}
    public func sfDidClickOnFlashSaleItemAtIndex(_ index: Int) {}
    public func sfDidClickCTA(item: SFLayoutItem) {}
    public func followUnfollow(_ follow: Bool, completionHandler: ((_ success: Bool)->Void)?) { completionHandler?(false) }
    public func sfDidClickExpand(layout: SFLayoutViewInfo, indexPath: IndexPath) {}
    public func sfHandleFooterShowMoreClick(_ url:String, type: LayoutViewType, showMoreText: String) {}
    public func sfHandleClickForItem(_ item:SFLayoutItem) {}
    public func sfShowCategoryPopup(_ layouts: [SFLayoutViewInfo],_ item:SFLayoutItem,_ layout:  SFLayoutViewInfo?) {}
    public func sfReloadTable() {}
    public func sfRemoveRecoWidget(indexPath: IndexPath) {}
    public func expandReco(recoRemovedObserver:(() -> Void)?, recoInfo:SFLayoutViewInfo,indexPath:IndexPath) {}
    public func getPhoneContact(phoneNumber: String) -> String? {return nil}
}

internal extension SFLayoutPresentDelegate {
    func sfSDKDidClick(item: SFLayoutItem?, viewInfo: SFLayoutViewInfo, tableIndex: Int, collectIndex: Int) {
        sfSDKDidSelect(info: item, tableIndex: tableIndex, collectIndex: collectIndex, type: viewInfo.layoutVType)
        if let item = item {
            sfLogClickForItem(item: item, viewInfo: viewInfo)
            if item.isRecentServices {
                SFUtilsManager.saveRecentItemName(name: item.itemName) // Used for showing recent-list widget filtered items
            }
        }
    }
}

public class SFPresenter {    
    public class func registerForAllType(table: UITableView) {
        SFPresenter.register(table: table, forTypes: LayoutViewType.allCases)
    }
    
    public class func register(table: UITableView, forTypes: [LayoutViewType]) {
        for type in forTypes {
            SFPresenter.register(table: table, layoutType: type)
        }
    }
}

extension SFPresenter {
    class func register(table: UITableView, layoutType: LayoutViewType) {
        switch layoutType {
        case .smartIconHeader:
            SFSmartIconHeaderTableCell.register(table: table)
        case .smartIconHeaderV2:
            SFSmartIconHeaderV2TableCell.register(table: table)
        case .smartIConList:
            SFSmartIConListTableCell.register(table: table)
        case .smartIconGroupGrid, .recentsList:
            SFSmartIconGroupGridTableCell.register(table: table)
        case .smartIconGrid4xn:
            SFSmartIconGrid4xnTableCell.register(table: table)
        case .smartIconGrid:
            SFSmartIconGridTableCell.register(table: table)
        case .thinBanner, .thinSmall:
            SFBannerTableCell.register(table: table)
        case .smartIconCarousel:
            SFSmartIconCarouselTableCell.register(table: table)
        case .carouselReco:
            SFCarouselRecoTableCell.register(table: table)
        case .carouselReco4x:
            SFCarouselReco4xTableCell.register(table: table)
        case .carouselRecoV2:
            SFCarouselRecoV2TableCell.register(table: table)
        case .listSmallTi:
            SFListSmallTiHeaderCell.register(table: table)
            SFListSmallTiTableCell.register(table: table)
        case .smartIconButton:
            SFSmartIconButtonTableCell.register(table: table)
        case .smartIconButton2xn:
            SFSmartIconButton2xnTableCell.register(table: table)
        case .c4Large:
            SFC4LargeTableCell.register(table: table)
        case .banner2xn:
            SFBanner2xnTableCell.register(table: table)
        case .banner3xn:
            SFBanner3xnTableCell.register(table: table)
        case .portrait3xn:
            SFPortrait3xnTableCell.register(table: table)
        case .carousel4:
            SFCarousel4TableCell.register(table: table)
        case .carouselBs1:
            SFCarouselBs1TableCell.register(table: table)
        case .carouselBs2:
            SFCarouselBs2TableCell.register(table: table)
        case .rowBs1:
            SFRowBs1TableCell.register(table: table)
        case .rowBs2, .row:
            SFRowBs2TableCell.register(table: table)
        case .row1xn:
            SFRow1xnTableCell.register(table: table)
            SFRow1xnHeaderTableCell.register(table: table)
        case .row2xn:
            SFRow2xnTableCell.register(table: table)
        case .row3xn:
            SFRow3xnTableCell.register(table: table)
        case .h1Banner, .h1FullBanner:
            SFBannerTableCell.register(table: table)
        case .h1MerchantBanner:
            SFH1MerchantBannerTableCell.register(table: table)
        case .carousel1:
            SFCarouselTableCell.register(table: table)
        case .carousel1_3:
            SFCarousel1_3TableCell.register(table: table)
        case .carousel2:
            SFCarouselTableCell.register(table: table)
        case .c1SquareBanner:
            SFC1SquareBannerTableCell.register(table: table)
        case .recentlyViewed, .itemInCart, .itemInWishlist:
            SFRecentlyViewedTableCell.register(table: table)
        case .activeOrder:
            SFActiveOrderTableCell.register(table: table)
        case .collage3x:
            SFCollage3xTableCell.register(table: table)
        case .collage5x:
            SFCollage5xTableCell.register(table: table)
        case .deals2xn:
            SFDeals2xnTableCell.register(table: table)
            SFDeals2xnHeaderCell.register(table: table)
        case .tree1:
            SFTree1TableCell.register(table: table)
            SFTree1HeaderTableCell.register(table: table)
        case .tabbed1:
            SFTabbed1TableCell.register(table: table)
            SFTabbed1ErrorTableCell.register(table: table)
            SFTabbed1xnTableCell.register(table: table)
            SFDealsGridTableCell.register(table: table)
            SFFreeDealsGridTableCell.register(table: table)
        case .tabbed2:
            SFTabbed2TableCell.register(table: table)
        case .footer:
            SFFooterTableCell.register(table: table)
        case .tabbed2Sale:
            SFTabbed2SaleTableCell.register(table: table)
        case .salutation:
            FSSalutationTableCell.register(table: table)
        case .deals:
            FSDealsTableCell.register(table: table)
        case .storesAround:
            FSSubStoresTableCell.register(table: table)
        case .brandStore:
            FSBrandTableCell.register(table: table)
        case .voucher3xn:
            FSVoucher3xnTableCell.register(table: table)
        case .yourVoucher:
            SFYourVoucherTableCell.register(table: table)
        case .feed:
            FSFeedTableCell.register(table: table)
        case .video:
            SFHVideoContainerCell.register(table: table)
        case .banner2_0:
            SFBannerTableCell.register(table: table)
        case .banner3_0:
            SFBannerTableCell.register(table: table)
        case .lCBOffers:
            SFCBTableCell.register(table: table)
        case .searchBar:
            SFSearchBarTableCell.register(table: table)
            
        default: break
        }
    }
    
    public class func cellIdFor(layoutType: LayoutViewType) -> String? {
        switch layoutType {
        case .smartIconHeader:   return SFSmartIconHeaderTableCell.cellId
        case .smartIconHeaderV2: return SFSmartIconHeaderV2TableCell.cellId
        case .smartIConList:     return SFSmartIConListTableCell.cellId
        case .smartIconGroupGrid,
             .recentsList:       return SFSmartIconGroupGridTableCell.cellId
        case .smartIconGrid4xn:  return SFSmartIconGrid4xnTableCell.cellId
        case .smartIconGrid:     return SFSmartIconGridTableCell.cellId
        case .thinBanner,
             .thinSmall:         return SFBannerTableCell.cellId
        case .carouselReco:      return SFCarouselRecoTableCell.cellId
        case .carouselReco4x:    return SFCarouselReco4xTableCell.cellId
        case .carouselRecoV2:    return SFCarouselRecoV2TableCell.cellId
        case .listSmallTi:       return SFListSmallTiTableCell.cellId
        case .smartIconCarousel: return SFSmartIconCarouselTableCell.cellId
        case .smartIconButton:   return SFSmartIconButtonTableCell.cellId
        case .smartIconButton2xn:   return SFSmartIconButton2xnTableCell.cellId
        case .c4Large:           return SFC4LargeTableCell.cellId
        case .banner2xn:         return SFBanner2xnTableCell.cellId
        case .banner3xn:         return SFBanner3xnTableCell.cellId
        case .portrait3xn:       return SFPortrait3xnTableCell.cellId
        case .carousel4:         return SFCarousel4TableCell.cellId
        case .carouselBs1:       return SFCarouselBs1TableCell.cellId
        case .carouselBs2:       return SFCarouselBs2TableCell.cellId
        case .rowBs1:            return SFRowBs1TableCell.cellId
        case .rowBs2, .row:      return SFRowBs2TableCell.cellId
        case .row1xn:            return SFRow1xnTableCell.cellId
        case .row2xn:            return SFRow2xnTableCell.cellId
        case .row3xn:            return SFRow3xnTableCell.cellId
        case .h1Banner,
             .h1FullBanner:      return SFBannerTableCell.cellId
        case .h1MerchantBanner:  return SFH1MerchantBannerTableCell.cellId
        case .carousel1:         return SFCarouselTableCell.cellId
        case .carousel1_3:         return SFCarousel1_3TableCell.cellId
        case .carousel2:         return SFCarouselTableCell.cellId
        case .c1SquareBanner:    return SFC1SquareBannerTableCell.cellId
        case .recentlyViewed,
             .itemInCart,
             .itemInWishlist:    return SFRecentlyViewedTableCell.cellId
        case .activeOrder:       return SFActiveOrderTableCell.cellId
        case .collage3x:         return SFCollage3xTableCell.cellId
        case .collage5x:         return SFCollage5xTableCell.cellId
        case .deals2xn:          return SFDeals2xnTableCell.cellId
        case .tree1:             return SFTree1TableCell.cellId
        case .tabbed1:           return SFTabbed1TableCell.cellId
        case .tabbed2:           return SFTabbed2TableCell.cellId
        case .footer:            return SFFooterTableCell.cellId
        case .tabbed2Sale:       return SFTabbed2SaleTableCell.cellId
        case .salutation:        return FSSalutationTableCell.cellId
        case .deals:             return FSDealsTableCell.cellId
        case .storesAround:      return FSSubStoresTableCell.cellId
        case .brandStore:        return FSBrandTableCell.cellId
        case .voucher3xn:        return FSVoucher3xnTableCell.cellId
        case .yourVoucher:       return SFYourVoucherTableCell.cellId
        case .feed:              return FSFeedTableCell.cellId
        case .video:             return SFHVideoContainerCell.cellId
        case .banner3_0:         return SFBannerTableCell.cellId
        case .banner2_0:         return SFBannerTableCell.cellId
        case .lCBOffers:         return SFCBTableCell.cellId
        case .searchBar:         return SFSearchBarTableCell.cellId
        default: return nil
        }
    }
    
    class func defaultCellHeightFor(layoutType: LayoutViewType) -> CGFloat {
        switch layoutType {
        case .smartIconHeader:    return 140
        case .smartIconHeaderV2:  return UITableView.automaticDimension
        case .smartIConList:      return 200
        case .smartIconGrid4xn:   return UITableView.automaticDimension
        case .smartIconGroupGrid,
             .recentsList:        return UITableView.automaticDimension
        case .smartIconGrid:      return UITableView.automaticDimension
        case .thinBanner:         return UITableView.automaticDimension
        case .thinSmall:          return UITableView.automaticDimension
        case .smartIconCarousel : return 100
        case .carouselReco:       return UITableView.automaticDimension //160
        case .carouselReco4x:     return 118
        case .carouselRecoV2:     return UITableView.automaticDimension
        case .listSmallTi :       return UITableView.automaticDimension
        case .smartIconButton :   return UITableView.automaticDimension
        case .c4Large:            return UITableView.automaticDimension
        case .smartIconButton2xn :   return UITableView.automaticDimension
        case .banner2xn:          return UITableView.automaticDimension
        case .banner3xn:          return UITableView.automaticDimension
        case .portrait3xn:        return UITableView.automaticDimension
        case .carousel4:          return UITableView.automaticDimension
        case .carouselBs1:        return UITableView.automaticDimension
        case .carouselBs2:        return 270
        case .rowBs1:             return UITableView.automaticDimension
        case .rowBs2, .row:       return UITableView.automaticDimension
        case .row1xn:             return UITableView.automaticDimension
        case .row2xn:             return SFRow2xnTableCell.collectionCellHeight * CGFloat(SFRow2xnTableCell.noOfRowsToShowInCollectionView) + 64
        case .row3xn:             return SFRow3xnTableCell.collectionCellHeight * CGFloat(SFRow3xnTableCell.noOfRowsToShowInCollectionView) + 64
        case .h1Banner:           return UITableView.automaticDimension
        case .h1FullBanner:       return UITableView.automaticDimension
        case .h1MerchantBanner:   return 150
        case .carousel1:          return UITableView.automaticDimension
        case .carousel1_3:          return UITableView.automaticDimension
        case .carousel2:          return 165
        case .c1SquareBanner:     return SFConstants.windowWidth
        case .recentlyViewed,
             .itemInCart,
             .itemInWishlist:     return 210
        case .activeOrder:        return UITableView.automaticDimension
        case .collage3x:          return 250
        case .collage5x:          return 290
        case .deals2xn:           return UITableView.automaticDimension
        case .tree1:              return UITableView.automaticDimension
        case .tabbed1:            return UITableView.automaticDimension
        case .tabbed2:            return UITableView.automaticDimension
        case .footer:             return UITableView.automaticDimension
        case .tabbed2Sale:        return UITableView.automaticDimension
        case .salutation:         return UITableView.automaticDimension
        case .deals:              return CGFloat(FSDealsTableCell.height)
        case .brandStore:         return 205
        case .storesAround:       return 100
        case .voucher3xn:         return UITableView.automaticDimension
        case .yourVoucher:        return 375
        case .feed:               return UITableView.automaticDimension
        case .video:              return 282.0
        case .banner2_0:          return UITableView.automaticDimension
        case .banner3_0:          return UITableView.automaticDimension
        case .lCBOffers:          return 200
        case .searchBar:          return UITableView.automaticDimension
        default:                  return 0
        }
    }
    
    
    class func defaultCollectInterimSpaceFor(layoutType: LayoutViewType) -> CGFloat {
        switch layoutType {
        case .smartIconHeader:
            return 10
        default : return 0.0
        }
    }
    
    class func defaultCollectLineSpaceFor(layoutType: LayoutViewType) -> CGFloat {
        switch layoutType {
        case .c4Large, .carouselBs1, .carouselBs2, .rowBs1, .carousel1, .carousel4,
             .recentlyViewed, .itemInCart, .itemInWishlist:
            return 12
        case .smartIconHeader, .smartIconHeaderV2, .smartIConList, .smartIconCarousel , .carouselReco:
            return 10
        default : return 0.0
        }
    }
}
