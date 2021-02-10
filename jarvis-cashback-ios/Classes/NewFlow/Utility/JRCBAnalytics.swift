//
//  JRCBAnalytics.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 12/02/20.
//

import Foundation

class JRCBAnalytics {
    private var mScreen    = JRCBAnalyticsScreen.screen_None
    private var mVertical  = JRCBAnalyticsVertical.vertical_Cashback
    private var mEventType = JRCBAnalyticsEventType.eventUserInfo
    
    private var mCategory = JRCBAnalyticsCategory.cat_None
    private var mAction   = JRCBAnalyticsAction.act_None
    private var mEventLabels : [String: String] = [:]
    
    init(screen: JRCBAnalyticsScreen) { // used for user info default
        self.mScreen = screen
    }
    
    init(screen: JRCBAnalyticsScreen, vertical: JRCBAnalyticsVertical, eventType: JRCBAnalyticsEventType) {
        self.mScreen = screen
        self.mVertical = vertical
        self.mEventType = eventType
    }
    
    init(screen: JRCBAnalyticsScreen, vertical: JRCBAnalyticsVertical, eventType: JRCBAnalyticsEventType,
         category: JRCBAnalyticsCategory, action: JRCBAnalyticsAction, labels: [String: String]) {
        self.mScreen = screen
        self.mVertical = vertical
        self.mEventType = eventType
        
        self.mCategory = category
        self.mAction = action
        self.mEventLabels = labels
    }
    
    func track() {
        if mEventType == .eventCustom {
            self.trackCustomEvent()
        } else {
            self.trackUserInfo()
        }
    }
    
    private func trackUserInfo() {
        JRCashbackManager.shared.cashbackDelegate?.track(for: mScreen.rawValue,
                                                         verticalName: mVertical.rawValue)
    }
    
    private func trackCustomEvent() {
        var vDict = ["event_category" : mCategory.rawValue,
                     "event_action"   : mAction.rawValue,
                     "vertical_name"  : mVertical.rawValue,
                     "customer_id"    : JRCOAuthWrapper.usrIdEitherBlank]
        
        for labelDict in mEventLabels {
            vDict[labelDict.key] = labelDict.value
        }
        
        JRCashbackManager.shared.cashbackDelegate?.trackCustomEvent(for: self.mScreen.rawValue,
                                                                    eventName: self.mEventType.rawValue,
                                                                    variables: vDict)
    }
}


//----Supporting Enums------
enum JRCBAnalyticsEventType: String {
    case eventCustom   = "custom_event"
    case eventUserInfo = "userInfo"
}

enum JRCBAnalyticsScreen: String {
    case screen_None = "None"
    case screen_CashbackLanding                   = "/cashback-landing"
    case screen_CashbackVouchers                  = "/cashback-vouchers"
    case screen_CashbackOfferActiveteNewOffer     = "/cashback-offers/activated-new-offer"
    case screen_CashbackOfferPostTransInitialized = "/cashback-offers/post-transaction-initialized"
    
    case screen_CashbackOfferMerchantProgress    = "/cashback-offers/merchant/progress"
    case screen_CashbackOfferMerchantCompletes   = "/cashback-offers/merchant/completed"
    case screen_CashbackOfferMerchantExpired     = "/cashback-offers/merchant/expired"
    case screen_CashbackOfferVouchersListing     = "/cashback-offers/vouchers-listing"
    case screen_CashbackOfferVouchersCode        = "/cashback-offers/voucher-code"
    case screen_PostOrder                        = "/postorder"
    case screen_ScratchCardSection               = "/scratchCardSection"
    case screen_CashbackOffersPostTransCompleted = "/cashback-offers/post-transaction-completed"
    case screen_CashbackOffersPostTransProgress  = "/cashback-offers/post-transaction-progress"
    case screen_CashbackOffersPostTransNoOffer   = "/cashback-offers/post-transaction-no-offer"
    case screen_CashbackNewOfferDetails          = "/offer-details"
    
    case screen_CashbackVouchersCode             = "/cashback-voucher/code" // unused
    case screen_CashbackMerchantActivateNewOffer = "/cashback-offers/merchant/activate-newoffer"
    case screen_PaytmHomepage = "/homepage"
    
    //referral
    case screen_ReferralLanding                  = "/referral_landing"
    case screen_ReferralSecondaryLanding         = "/referral_secondary_landing"
}

enum JRCBAnalyticsVertical: String {
    case vertical_Cashback          = "cashback"
    case vertical_MarchantCashback  = "merchant_cashback"
    case vertical_MyVoucherCashback = "cashback_voucher"
    case vertical_Referral          = ""
}

enum JRCBAnalyticsCategory: String {
    case cat_None            = "none"
    case cat_CashbackOffers  = "cashback_offers"
    case cat_MyVoucher       = "my_vouchers"
    case cat_PostTransaction = "post_transaction"
    case cat_PaytmCoins      = "paytm_coins"
    case cat_AppOpen         = "app_open"
    
    //Referral
    case cat_PrimaryOffer    = "primary offer"
    case cat_SecondaryOffer  = "secondary offer"
}

enum JRCBAnalyticsAction: String {
    case act_None                   = ""
    case act_FilterClicked          = "filter_clicked"
    case act_VoucherCodeCopyClicked = "voucher_code_copy_clicked"
    case act_RedeemNowClicked       = "redeem_now_clicked"
    case act_ViewDetailsClicked     = "view_details_clicked"
    case act_ApplyFilterClicked     = "apply_filter_clicked"
    case act_BannerLoaded           = "banner_loaded"
    case act_BannerClicked          = "banner_clicked"
    case act_ScratchCardLoaded      = "scratch_card_loaded"
    case act_ScratchCardScratched   = "scratch_card_scratched"
    case act_CashbackSummaryClicked = "cashback_summary_clicked"
    case act_PointsSummaryClicked   = "points_summary_clicked"
    case act_MyVouchersClicked      = "my_vouchers_clicked"
    case act_OfferCategoryClicked   = "offer_category_clicked"
    case act_LockedCardsClicked     = "locked_cards_clicked"
    case act_TopOfferCardClicked    = "top_offer_card_clicked"
    case act_Screenview             = "screenview"
    //Post Order
    case act_ActivateOffersClicked    = "activate_offers_clicked"
    case act_TransactionCtaClicked    = "transaction_cta_clicked"
    case act_CollectibleCtaClicked    = "collectible_cta_clicked"
    //Voucher
    case act_ViewExpiredVouchersClicked = "view_expired_vouchers_clicked"
    case act_VoucherCardClicked       = "voucher_card_clicked"
    case act_VouchersTopNavClicked    = "vouchers_top_nav_clicked"
    //Referral
    case act_PrimaryPageLoad = "primary_page_load"
    case act_SecondaryPageLoad = "secondary_page_load"
    case act_BackClicked = "back_clicked"
    case act_TotalCashbackClicked = "total_cashback_clicked"
    case act_KnowMoreClicked = "know_more_clicked"
    case act_CopyClicked = "copy_clicked"
    case act_WhatsappClicked = "wa_clicked"
    case act_SmsClicked = "sms_clicked"
    case act_TwitterClicked = "twitter_clicked"
    case act_ShareMoreClicked = "more_clicked"
    case act_InviteClicked = "invite_clicked"
    case act_OfferRewardsClicked = "offer&rewards_clicked"
    
}

struct JRCBAnalyticsEventLabel {
    static let klabel1 = "event_label"
    static let klabel2 = "event_label2"
    static let klabel3 = "event_labe3"
    static let klabel4 = "event_label4"
}

//-----------
