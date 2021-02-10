//
//  SFLayoutViewEnums.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 12/10/19.
//

import UIKit

public enum LayoutViewType: String, CaseIterable {
    case none              = ""
    case video             = "video-bottom-image"
    case smartIconHeader   = "smart-icon-header"
    case smartIconHeaderV2 = "smart-icon-header-v2"
    case smartIConList     = "smart-icon-list"
    case smartIconGroupGrid = "smart-icon-group-grid"
    case smartIconGrid4xn = "smart-icon-grid-4xn"
    case smartIconGrid     = "smart-icon-grid"
    case smartIconButton   = "smart-icon-button"
    case smartIconButton2xn   = "smart-icon-button-2xn"
    case thinBanner        = "thin-banner"
    case thinSmall         = "thin-small"
    case smartIconCarousel = "smart-icon-carousel" // UPI
    case c4Large           = "c4-large"
    // case smartIconTicker   = "smart-icon-ticker" // anouncement
    case banner2xn         = "banner-2xn"
    case banner3xn         = "banner-3xn"
    case portrait3xn       = "portrait-3xn"
    case banner3_0         = "banner-3_0"
    case banner2_0         = "banner-2_0"
    case carousel4         = "carousel-4"
    case carouselBs1       = "carousel-bs1"
    case carouselBs2       = "carousel-bs2"
    case carouselReco4x       = "carousal-icon-4x"
    case carouselRecoV2    = "carousel-reco-v2"
    case row               = "row"
    case rowBs1            = "row-bs1"
    case rowBs2            = "row-bs2"
    case row1xn            = "row-1xn" // should add a custome header
    case row2xn            = "row-2xn"
    case row3xn            = "row-3xn"
    case h1Banner          = "h1-banner"
    case h1FullBanner      = "h1-full-banner"
    case h1MerchantBanner  = "h1-merchant-banner"
    case carousel1         = "carousel-1"
    case carousel1_3         = "carousel-1_3"
    case carousel2         = "carousel-2"
    case c1SquareBanner    = "c1-square-banner"
    case recentlyViewed    = "recently_viewed"
    case itemInCart        = "item_in_cart"
    case itemInWishlist    = "item_in_wishlist"
    case activeOrder       = "active_order"
    case collage3x         = "collage-3x"
    case collage5x         = "collage-5x"
    case deals2xn          = "deals-2xn"
    case tree1             = "tree-1"   // should add a custome header
    case tabbed1           = "tabbed-1"
    case h1StoreBanner     = "h1-store-banner" // store banner header sticky
    case footer            = "footer"
    case tabbed2           = "tabbed-2"
    case tabbed2Sale       = "tabbed-2-sale"
    case floatingTab       = "floating-nav"
    case searchBar         = "search-bar"
    case recentsList       = "recents-list" // Same as smart-icon-group-grid
    
    // Favourite Stores Cells
    case salutation        = "salutation"
    case deals             = "deals"
    case brandStore        = "brand-stores"
    case storesAround      = "stores-around-you"
    case voucher3xn        = "voucher-3xn"
    case yourVoucher       = "your-voucher"
    case feed              = "feed"
    
    // Channel
    case merchantList      = "merchant-list"
    case carouselReco      = "carousel-reco"
    case listSmallTi       = "list-small-ti"
    
    case interstitial      = "interstitial"
    case scratchcardPopup  = "scratchcard-popup"
    case flashPopup        = "flash-popup"
    
    // Cashback
    case lCBScratchCards   = "carousel-scratch-card"
    case lCBLockedCards    = "carousel-locked-cards"
    case lCBOffers         = "carousel-toi"
   // case lCBOfferCategory  = "list-small-ti" // listSmallTi
   // case lCBBanner_3_0     = "banner-3_0" // banner3_0
    
    case recentCategories  = "recentCategories"
    
    // P4B widgets
    case p4bAnnouncement   = "p4b-announcement"
    case p4bHometabs       = "p4b-hometabs"
    case p4bQR             = "p4b-qr"
}


extension LayoutViewType {
    
    var shouldPresentInRow: Bool {
        let rowsList : [LayoutViewType] = [.row1xn, .deals2xn, .tree1, .listSmallTi]
        return rowsList.contains(self)
    }
    
    var shouldAddCustomHeader: Bool {
        let rowsList : [LayoutViewType] = [.tree1, .row1xn, .deals2xn, .listSmallTi]
        return rowsList.contains(self)
    }

    var ignoreValidation: Bool {
        let skipValidationsType : [LayoutViewType] = [.itemInCart, .itemInWishlist, .recentlyViewed, .activeOrder, .h1StoreBanner, .merchantList]
        return skipValidationsType.contains(self)
    }

    var cellId: String? {
        return SFPresenter.cellIdFor(layoutType: self)
    }
    
    var headerCellId: String? {
        switch self {
        case .tree1: return SFTree1HeaderTableCell.cellId
        case .row1xn: return SFRow1xnHeaderTableCell.cellId
        case .deals2xn: return SFDeals2xnHeaderCell.cellId
        case .listSmallTi: return SFListSmallTiHeaderCell.cellId
        default: return nil
        }
    }
    
    var defaultHeight: CGFloat {
       return SFPresenter.defaultCellHeightFor(layoutType: self)
    }
    
    // this will help if we are passing 2 rows but the items is less
    public var defaultCollectRowHeight: SFCollRowHeight {
        switch self {
        default: return SFCollRowHeight.full
        }
    }
    
    public var defaultPresentCellInfo : SFTableCellPresentInfo {
       return SFTableCellPresentInfo.defaultCellInfoFor(layoutType: self)
    }
}
