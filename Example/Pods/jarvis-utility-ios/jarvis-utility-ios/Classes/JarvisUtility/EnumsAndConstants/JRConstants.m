//
//  JRConstants.m
//  JarvisTextCases
//
//  Created by Shwetha Mugeraya on 27/08/13.
//  Copyright (c) 2013 Robosoft Technologies. All rights reserved.
//

#import "JRConstants.h"
//iPhoneX SafeArea Margin
CGFloat const iPhoneXSafeAreaMargin = 24.0;

NSString *const JRPaytmAppStoreUrl = @"itms-apps://itunes.apple.com/app/id473941634";

NSString *const JRTwitterSearchAPI = @"https://api.twitter.com/1.1/search/tweets.json";

NSString *const JRWalletTokenExpiryDate = @"WalletTokenExpiryDate";
NSString *const JRWalletUDMap = @"ud_map";
NSString *const JRWalletVersionNumber = @"version";
NSString *const JRWalletRefNumber = @"ref_no";
NSString *const JRWalletOtpTimeInterval = @"time_interval";
NSString *const JRWalletOtpRefreshInterval = @"refresh_interval";
NSString *const JRWalletCGCPOfflineHeader = @"cgcp_offline_header";
NSString *const JRWalletOtpConfig = @"otp_config";
NSString *const JRWalletEpochTime = @"epoch_time";


//Digital Product Constants
NSString * const kConvenienceFeeDisplayFormat = @"₹ %d will be charged as convenience fee";

NSString * const JROrderTypeRecharge = @"recharge";
NSString * const JROrderTypeMarketplace = @"marketplace";

NSString * const JRSmallImageUrl = @"image_url";
NSString * const JRImageData = @"image_data";


NSString * const JRItems = @"items";
NSString * const JRItemprice = @"price";
NSString * const JRItemName = @"name";

NSString * const JRProductID = @"product_id";
NSString * const JRProductType = @"product_type";
NSString * const JRProductURL = @"product_url";
NSString * const JRProductName = @"name";
NSString * const JRProductShortDescription = @"short_desc";
NSString * const JRProductRichDescription = @"long_rich_desc";
NSString * const JRProductOtherRichDescription = @"other_rich_desc";
NSString * const JRProductPromoText = @"promo_text";
NSString * const JRProductActualPrice = @"actual_price";
NSString * const JRProductOfferPrice = @"offer_price";
NSString * const JRProductRating = @"product_rating";
NSString * const JRProductBrand = @"brand";
NSString * const JRProductMerchant = @"merchant";
NSString * const JRProductSelectableAttributes = @"selectable_attributes";
NSString * const JRProductMerchantName = @"merchant_name";
NSString * const JRProductAddToCartUrl = @"add_to_cart_url";
NSString * const JRProductOtherMedia = @"other_media";
NSString * const JRProductCreatedDate = @"product_created_date";
NSString * const JRProductEndDate = @"product_end_date";
NSString * const JRProductSkuId = @"product_sku_id";
NSString * const JRProductCartText = @"cart_text";
NSString * const JRProductSelectedAttributes = @"selected_attributes";
NSString * const JRProductQuantity = @"quantity";
NSString * const JRProductPromocodeUrl = @"promocode_url";
NSString * const JRProductCartPrice = @"cart_price";
NSString * const JRProductShippingCost = @"shipping_cost";
NSString * const JRProductUpdateQuantityUrl = @"update_quantity_url";
NSString * const JRProductDeleteUrl = @"delete_url";
NSString * const JRProductRegEx = @"regEx";
NSString * const JRProductStatus = @"status";
NSString * const JRProductError = @"error";

NSString * const JRMerchantId = @"merchant_id";
NSString * const JRMerchantName = @"merchant_name";
NSString * const JRMerchantsRating = @"merchant_rating";
NSString * const JRMerchantImage = @"merchant_image";
NSString * const JRStore = @"stores";

NSString * const JRStoreName = @"store_name";
NSString * const JRStoreId = @"store_id";
NSString * const JRStoreImage = @"store_image";

NSString * const JRSelectableAttributeName = @"name";
NSString * const JRSelectableAttributeId = @"id";
NSString * const JRSelectableAttributeValues = @"values";

NSString * const JRLayoutType = @"layout";
NSString * const JRLayoutName = @"name";

NSString * const JRLayoutTypeHomePage = @"homepage_layout";
NSString * const JRLayoutTypeCarousel = @"carousel";
NSString * const JRLayoutTypeHorizontalList = @"horizontal_text_list";
NSString * const JRLayoutTypeHyphenCarousel1 = @"carousel-1";
NSString * const JRLayoutTypeHyphenCarousel2 = @"carousel-2";
NSString * const JRLayoutTypeCarousel1 = @"carousel_1";
NSString * const JRLayoutTypeTabs = @"tabs";
NSString * const JRLayoutTypeCarousel2 = @"carousel_2";
NSString * const JRLayoutTypeRow = @"row";
NSString * const JRLayoutTypeList = @"textlinks";
NSString * const JRLayoutTypeHtml = @"html";
NSString * const JRLayoutTypeCatalog = @"catalog";
NSString * const JRLayoutTypeGrid = @"grid";
NSString * const JRFooterImageURL = @"footer_image_url";
NSString * const JRLayoutTypeSmartIconList = @"smart-icon-list";
NSString * const JRLayoutTypeSmartIconBottomNavList = @"smart-icon-bottom-nav";
NSString * const JRLayoutTypeMainCarousel2 = @"main_carousel_2";


NSString * const JRGridLayout =@"grid_layout";
NSString * const JRGridFooterHtml = @"footer_html";
NSString * const JRGriddefaultSortParams = @"default_sorting_param";
NSString * const JRGridSortingKeys = @"sorting_keys";
NSString * const JRHasMoreProducts = @"has_more";

//grid tracking constants
NSString * const JREventGridCategoryAction = @"product_grid_category_action_performed" ;
NSString * const JREventGridScrollDown = @"product_grid_scrolled_down";
NSString * const JREventGridSortMenuClicked = @"product_grid_sort_menu_clicked";
NSString * const JREventGridSortApplied = @"product_grid_sort_applied";
NSString * const JREventGridFltersMenuClicked = @"product_grid_filters_menu_clicked";
NSString * const JREventGridFltersPriceRangeSelected = @"product_grid_price_range_selected";
NSString * const JRVariableGridCategoryAction = @"product_grid_category_action";
NSString * const JRVariableGridCategoryItemName = @"product_grid_category_item";
NSString * const JRVariableGridCategoryPageType = @"product_grid_page_type";
NSString * const JRVariableGridProductPosition = @"product_grid_last_product_position";
NSString * const JRVariableGridSortFilterName = @"product_grid_sort_filter_name";
NSString * const JRVariableGridPriceRange = @"product_grid_price_range";
NSString * const JRVariableGridSelectedFieldCategory = @"product_grid_selected_field_category";
NSString * const JREventGridFiltersApplied = @"product_grid_filters_applied";
NSString * const JREventGridFiltersResetClicked = @"product_grid_filters_reset_clicked";




NSString * const JRWalletRefreshBalanceNotification = @"JRWalletRefreshBalanceNotification";
NSString * const JRUpgradeWalletActionNotification = @"JRUpgradeWalletActionNotification";
NSString * const JRKYCStatusFetchedNotification = @"JRKYCStatusFetchedNotification";
NSString * const JRMinKYCSignUpNotification = @"JRMinKYCSignUpNotification";
NSString * const JRMinKYCCompletedNotification = @"JRMinKYCCompletedNotification";
NSString * const JRUserDidLoginNotification = @"UserLoggedInNotification";
NSString * const JRDidUserSignOutNotification = @"DidUserSignOutNotification";
NSString * const JRPasswordChangedNotification = @"JRPasswordChangedNotification";
NSString * const JRMoveToHomeByRefreshingEachTab = @"MoveToHomeByRefreshingEachTab";
NSString * const JRDidCartCountOrMessageCountChangeNotification = @"DidCartCountOrMessageCountChangeNotification";
NSString * const JRDidUserCameBackFromPgNotification = @"DidUserCameBackFromPgNotification";
NSString * const JRDidUserProfileUpdateNotification = @"DidUserProfileUpdateNotification";
NSString * const JRWalletRequestSizeChangeNotification = @"JRWalletRequestSizeChangeNotification";
NSString * const JRUsersKYCDetailsUpdateNotification = @"UsersKYCDetailsUpdateNotification";
NSString * const JRCitySelectionClosedNotification = @"MovieCitySelectionClosedNotification";


NSString * const JRTextIosErrorTitle = @"Paytm";
NSString * const JRTextIosLostConnectionErrorMessage = @"It seems you lost your internet connection. Paytm requires a working internet connection.";

NSString * const KAuthToken  = @"oauth_token";

NSString * const JRSearchUserID = @"search_user_id";

NSString * const CART_ID = @"CART_ID";
NSString * const APP_INSTALLED = @"APP_INSTALLED";
NSString * const COUNTLY_SDK_ACTIVATED = @"COUNTLY_SDK_ACTIVATED";

//indicative Plans URL constants
NSString * const JRMobileIndicativeType = @"mobile";
NSString * const JRDTHIndicativeType = @"dth";
NSString * const JRDatacardIndicativeType = @"datacard";
NSString * const JRTollcardIndicativeType = @"Tollcard";


NSString * const JRPrefixCountryCode = @"+91 ";


// ******************---APSALAR EVENT TRACKING----*******************

//----- new events
NSString * const JRTrackEventHomeTab = @"HomeTab";
NSString * const JRTrackEventCouponsTabChange = @"CouponsTabChange";
NSString * const JRTrackEventPaytmCashPage = @"PaytmCashPage";
NSString * const JRTrackEventPaytmCashLedgerPage = @"PaytmCashLedgerPage";
NSString * const JRTrackEventAddPaytmCash = @"AddPaytmCash";
NSString * const JRTrackEventProfileTabInfo = @"ProfileTabInfo";
NSString * const JRTrackEventProfileTabSavedCards = @"ProfileTabSavedCards";
NSString * const JRTrackEventProfileTabAddress = @"ProfileTabAddress";
NSString * const JRTrackEventBrowsePlanSelected = @"BrowsePlanSelected";
NSString * const JRTrackEventSearchText = @"SearchText";
NSString * const JRTrackEventLedgerButtonClick = @"LedgerButtonClick";
NSString * const JRTrackEventContactIconClick = @"ContactsIconClick";
NSString * const JRTrackEventContactSelected = @"ContactSelected";
NSString * const JRTrackEventFrequentOrderSelected = @"FrequentOrderSelected";
NSString * const JRTrackEventFrequentOrderAmountChanged = @"FrequentOrderAmountChanged";
NSString * const JRTrackEventFastForward = @"FastForward";
NSString * const JRTrackEventMarketPlaceOrderContinueShopping = @"MarketPlaceContinueShopping";
NSString * const JRTrackEventBrowsePlanTab = @"BrowsePlanTab";
NSString * const JRTrackEventYourOrdersRepeatRetry = @"YourOrdersRepeatRetryClick";
NSString * const JRTrackEventPrepaidPostPaidToggle = @"PrepaidPostPaidToggle";
NSString * const JRTrackEventTopUpSpecialRechargeToggle = @"TopUpSpecialRechargeToggle";
NSString * const JRTrackEventProductPageView = @"ProductPageView";
NSString * const JRTrackEventQueingError = @"QueingError";
NSString * const JRTrackEventApplicationOpenUnique = @"AppOpenUnique";
NSString * const JRTrackEventApplicationOpenSignout = @"AppOpenSignOut";
NSString * const JRTrackEventApplicationOpenSignIn = @"AppOpenSignIn";
NSString * const JRTrackEventPageNavigation = @"PageNavigation";
NSString * const JRTrackEventCheckOutFromProductPage = @"CheckOutFromProductPage";


NSString * const JRTrackEventSoftBlock = @"SoftBlock";
NSString * const JRTrackEventApplicationOpen = @"AppOpen";
NSString * const JRTrackEventHomeMobilePrepaid = @"HomeMobilePrepaid";
NSString * const JRTrackEventHomeMobilePostpaid = @"HomeMobilePostpaid";
NSString * const JRTrackEventHomeDTH = @"HomeDTH";
NSString * const JRTrackEventHomeDatacardPrepaid = @"HomeDatacardPrepaid";
NSString * const JRTrackEventHomeDatacardPostpaid = @"HomeDatacardPostpaid";
NSString * const JRTrackEventDeepLinking = @"EventClickDeepLinking";

NSString * const JRHomeEventWalletStripClicked = @"homepage_walletstrip_clicked";

//Revenue Events
NSString * const JRTrackEventRechargeRevenue = @"RechargeRevenue";
NSString * const JRTrackEventMarketPlaceRevenue = @"MarketPlaceRevenue";


//Catalog events
NSString * const JRLeftCatalogMenu = @"LeftCatalogMenu";
NSString * const JRTrackEventLeftMobilePrepaid = @"LeftMobilePrepaid";
NSString * const JRTrackEventLeftMobilePostpaid = @"LeftMobilePostpaid";
NSString * const JRTrackEventLeftDTH = @"LeftDTH";
NSString * const JRTrackEventLeftDatacardPrepaid = @"LeftDatacardPrepaid";
NSString * const JRTrackEventLeftDatacardPostpaid = @"LeftDatacardPostpaid";

NSString * const JRTrackEventLeftCategoryName = @"Menu";
NSString * const JRTrackEventHomeMobilePlans = @"HomeMobilePlans";
NSString * const JRTrackEventHomeDthPlans= @"HomeDthPlans";
NSString * const JRTrackEventHomeDatacardPlans = @"HomeDatacardPlans" ;
NSString * const JRTrackEventLeftMobilePlans = @"LeftMobilePlans";
NSString * const JRTrackEventLeftDatacardPlans = @"LeftDatacardPlans";
NSString * const JRTrackEventLeftDthPlans = @"LeftDthPlans";
NSString * const JRTrackEventSearch = @"Search";
NSString * const JRTrackEventHomeShowcase = @"HomeShowcase";
NSString * const JRTrackEventYourOrders = @"YourOrders";
NSString * const JRTrackEventSettings = @"Settings";
NSString * const JRTrackEventHelp = @"Help";
NSString * const JRTrackEventSignOut = @"SignOut";
NSString * const JRTrackEventCheckout = @"Checkout";
NSString * const JRTrackEventEditCartDelete = @"EditCartDelete";
NSString * const JRTrackEventEditCartUpdate = @"EditCartUpdate";
NSString * const JRTrackEventApplyPromoCart = @"ApplyPromoCart";
NSString * const JRTrackEventApplyPromoCartEdit= @"ApplyPromoCartEdit";
NSString * const JRTrackEventSelectShipping = @"SelectShipping";
NSString * const JRTrackEventSelectAddress = @"SelectAddress";
NSString * const JRTrackEventShippingProceed = @"ShippingProceed";
NSString * const JRTrackEventShowPassword = @"ShowPassword";
NSString * const JRTrackEventForgotPassword = @"ForgotPassword";
NSString * const JRTrackEventSignIn = @"SignIn";
NSString * const JRTrackEventCreateAccountLogin = @"CreateAccountLogin";
NSString * const JRTrackEventSignUp = @"af_complete_registration";
NSString * const JRTrackEventSelectPayment = @"SelectPayment";
NSString * const JRTrackEventThankYouShopping = @"ThankYouShopping";
NSString * const JRTrackEventThankYouWallet = @"ThankYouWallet";
NSString * const JRTrackEventLandlineOperators = @"LandlineOperators";
NSString * const JRTrackEventElectricityOperators = @"ElectricityOperators";
NSString * const JRTrackEventGasOperators = @"GasOperators";
NSString * const JRTrackEventThankYouRecharge = @"ThankYouRecharge";
NSString * const JRTrackEventHome = @"Home";
NSString * const JRTrackEventHomeSeeAll = @"HomeSeeAll";
NSString * const JRTrackEventOrderSummary = @"OrderSummary";
NSString * const JRTrackEventOrderSummarySeeAll = @"OrderSummaryCarouselSeeAll";
NSString * const JRTrackEventOrderSummaryShowcase = @"OrderSummaryShowcase";
NSString * const JRTrackEventAddToCart = @"AddToCart";
NSString * const JRTrackEventURLConnectionError = @"URLConnectionError";
NSString * const JRTrackEventSelectFreeCoupon = @"SelectFreeCoupon";
NSString * const JRTrackEventSelectPaidCoupon = @"SelectPaidCoupon";
NSString * const JRTrackEventRechargeApplyPromo = @"RechargeApplyPromo";
NSString * const JRTrackEventRechargeSkipCoupon = @"RechargeSkipCoupon";
NSString * const JRTrackEventRechargeUseWallet = @"RechargeUseWallet";
NSString * const JRTrackEventRechargeUnselectWallet = @"RechargeUnselectWallet";
NSString * const JRTrackEventRechargeSelectPayment = @"RechargeSelectPayment";
NSString * const JRTrackEventRechargeProceedToPay = @"RechargeProceedToPay";
NSString * const JRTrackEventRechargeContinueShop = @"RechargeContinueShop";
NSString * const JRTrackEventChangeSize = @"ChangeSize";
NSString * const JRTrackEventDescription = @"Description";
NSString * const JRTrackEventRefine = @"Refine";
NSString * const JRTrackEventSortNew = @"SortNew";
NSString * const JRTrackEventSortPopular = @"SortPopular";
NSString * const JRTrackEventSortPrice = @"SortPrice";
NSString * const JRTrackEventSortRelevance = @"SortRelevance";

NSString * const JRTrackEventHomeProduct = @"HomeProduct";
NSString * const JRTrackEventCategoryProduct = @"CategoryProduct";
NSString * const JRTrackEventPushNotificationBuckets = @"PushNotificationBuckets";

//Profile Tracking
NSString * const JRScreenNameAccountMainScreen = @"Account Main screen";
NSString * const JREventAccountItemClicked = @"account_item_clicked";
NSString * const JRVariableUserAccountUserID = @"user_account_user_id";
NSString * const JRVariableAccountItemName = @"account_item_name";
NSString * const JRScreenNameUserAccountProfile = @"user account - Profile screen";
NSString * const JREventUserProfileEditClicked = @"user_account_profile_edit_profile_clicked";
NSString * const JREventUserProfileItemClicked = @"user_account_profile_item_clicked";
NSString * const JRVariableUserProfileItemName = @"user_account_profile_item_name";
NSString * const JRScreenProfileAddressSection = @"user account - Profile - Address section";
NSString * const JREventProfileAddressEditClicked = @"user_account_profile_address_edit_clicked";
NSString * const JREventProfileAddressAddClicked = @"user_account_profile_address_add_clicked";
NSString * const JREventProfileAddressRemoveClicked = @"user_account_profile_address_removed";

NSString * const JREventProfileAddressSuccessError = @"user_account_address_success_error";
NSString * const JRVariableProfileAddressDefaultState = @"user_account_address_set_default_state";
NSString * const JREventProfileNewAddressSavedClicked = @"user_account_profile_save_address_clicked";
NSString * const JRScreenNameProfileNewAddress = @"Profile - Address section - add new addr";

NSString * const JRScreenNameProfileChangePassword = @"user account - Profile page - Change Password section";
NSString * const JREventProfileChangePasswordSaveClicked = @"user_account_profile_save_password_clicked";

NSString * const JRScreenNameProfileYourOrders = @"user account - Your orders screen";
NSString * const JREventProfileYourOrdersTabClicked = @"user_account_orders_tab_clicked";
NSString * const JRVariableProfileYourOrdersTabName = @"user_account_orders_tab_name";

NSString * const JREventProfileYourOrdersItemClicked = @"user_account_orders_item_clicked";
NSString * const JRVariableProfileOrders_OrderID = @"user_account_orders_order_id";
NSString * const JRVariableProfileOrders_OrderStatus = @"user_account_orders_order_status";
NSString * const JRVariableProfileOrders_Vertical_Name = @"user_account_vertical_name";
NSString * const JREventProfileYourOrdersRepeatRetryClicked = @"user_account_orders_repeat_retry_clicked";
NSString * const JRVariableProfileOrders_Action_Name = @"user_account_orders_action_name";

NSString * const JREventProfileYourOrdersSearchClicked = @"user_account_orders_item_searched";
NSString * const JRVariableProfileOrdersSearchKeyword = @"user_account_orders_search_keyword";

NSString * const JRScreenNameProfileWishList = @"user account - Wishlist screen";
NSString * const JREventProfileWishListItemClicked = @"user_account_wishlist_item_clicked";
NSString * const JRVariableProfileWishListProdName = @"user_account_wishlist_product_name";
NSString * const JRVariableProfileWishListItemPosition = @"user_account_wishlist_position";
NSString * const JREventProfileWishListOffersClicked = @"user_account_wishlist_new_offers_clicked";
NSString * const JREventProfileWishListItemRemoved = @"user_account_wishlist_item_removed";
NSString * const JREventProfileWishListItemAddtoBag = @"user_account_wishlist_item_moved_to_cart";
NSString * const JREventProfileWishListItemShared = @"user_account_wishlist_item_shared";
NSString * const JREventProfileWishListOfferApplied = @"user_account_wishlist_offer_applied";
NSString * const JRVariableProfileWishListPromoCode= @"user_account_wishlist_promocode";
NSString * const JRWishListDisplayName= @"Saved Items";
NSString * const PDP_SAVE_FOR_LATER_CLICKED = @"pdp_save_for_later_clicked";
NSString * const GRID_SAVE_FOR_LATER_CLICKED = @"grid_save_for_later_clicked";
NSString * const GRID_ADD_TO_CART_CLICKED = @"grid_add_to_cart_clicked";

//Favourites in Profile
NSString * const JRScreenNameProfileFavourites = @"user account - favourites section";
NSString * const JREventProfileFavouritesSetNowClicked = @"user_account_favorites_set_now_clicked";
NSString * const JREventProfileFavouritesRemoved = @"user_account_favorites_removed";
NSString * const JRVariableProfileFavouritesItemName = @"user_account_favorites_item_name";
NSString * const JRVariableProfileFavouriteItemPosition = @"user_account_favorites_position";
NSString * const JREventProfileFavouritesEdited = @"user_account_favorites_edited";

//Help & FAQ section
NSString * const JRScreenNameProfileFAQ = @"user account - Help & FAQ section";
NSString * const JREventProfileFAQClicked = @"user_account_faq_clicked";
NSString * const JRVariableProfileFAQLevel = @"user_account_faq_level";
NSString * const JRVariableProfileFAQCategory = @"user_account_faq_category";

//Choose Language Section
NSString * const JRScreenNameProfileLanguage = @"user account - Choose language section";
NSString * const JREventProfileLanguageSelected = @"user_account_language_selected";
NSString * const JRVariableProfileAccountLanguage = @"user_account_language";

//Contact US Section
NSString * const JRScreenNameProfileContactUs = @"user account - contact us section";
NSString * const JREventProfileContactCategoryClicked = @"user_account_contactus_query_category_clicked";
NSString * const JRVariableProfileContactCategory = @"user_account_query_main_category";
NSString * const JRVariableProfileContactQueryPosition = @"user_account_query_position";
NSString * const JREventProfileContactQueryOrderSelected = @"user_account_contactus_query_order_selected";
NSString * const JREventProfileContactQuerySubmitted = @"user_account_contactus_query_submitted";


NSString * const JREventNotificationSettingClicked = @"user_updates_push_notification_settings_clicked";
NSString * const JREventNotificationChanged = @"user_updates_push_notification_state_changed";

//Payment Status Tracking in OrderSummary
NSString * const JRScreenNameOrderSummaryPage = @"Order summary page";
NSString * const JREventPayOrderSummaryTransactionStatus = @"pay_order_summary_txn_status";
NSString * const JREventPayOrderSummaryOrderStatus = @"pay_order_summary_order_status";
NSString * const JRVariablePayTransactionPaymentStatus = @"pay_transaction_payment_status";
NSString * const JRVariablePayPaymentStatusID = @"pay_payment_statusID";
NSString * const JRVariablePayTransactionID = @"pay_transaction_id";
NSString * const JRVariablePayPaymentType = @"pay_payment_type";
NSString * const JRVariablePayTransactionOrderStatus = @"pay_transaction_order_status";

//******************-------*******************

#pragma Mark NotificationNames
NSString * const JRNotificationItemSelectedFromCatalog =@"JRNotificationItemSelectedFromCatalog";
NSString * const JRNotificationLoadingNextProductPage = @"JRNotificationLoadingNextProductPage";
NSString * const JRNotificationCatalogCacheUpdated = @"JRNotificationCatalogCacheUpdated";
NSString * const JRNotificationTabMenuCacheUpdated = @"JRNotificationTabMenuCacheUpdated";
NSString * const JRNotificationHomePageCacheUpdated = @"JRNotificationHomePageCacheUpdated";
NSString * const JRNotificationNameRechagesViewHeightChanged = @"JRNotificationNameRechagesViewHeightChanged";
NSString * const JRNotificationNameLeadAPIForAppLaunch = @"JRNotificationNameLeadAPIForAppLaunch";
NSString * const JRApplicationDidEnterBackgroundNotification = @"ApplicationDidEnterBackgroundNotification";
NSString * const JRApplicationDidEnterForegroundNotification = @"ApplicationDidEnterForegroundNotification";

NSString * const JRNotificationInternetConnectionReachableNow = @"JRNotificationInternetConnectionReachableNow";
NSString * const JRNotificationFrequentOrdersUpdated = @"JRNotificationFrequentOrdersUpdated";
NSString * const JRNotificationFrequentOrdersModified = @"JRNotificationFrequentOrdersModified";

NSString * const JRNotification503StatusOccured = @"JRNotification503StatusOccured";
NSString * const JRNotificationMaintenancePageDidDismiss = @"JRNotificationMaintenancePageDidDismiss";
NSString * const JRNotificationItemSelctedInCatalogView = @"JRNotificationItemSelctedInCatalogView";
NSString * const JRNotificationUpdateCount = @"JRNotificationUpdateCount";
NSString * const JRNotificationMoveToHomeTab = @"JRMoveToHomeTabNotification";
NSString * const JRNotificationMoveToCatalogHome = @"JRNotificationCatalogHome";
NSString * const JRNotificationEraseAmountTextfieldText = @"JREraseAmountTextfiledTextNotification";

NSString * const JRDidAppEnterForegroundNotification = @"JRDidAppEnterForegroundNotification";
NSString * const JRNotificationShowWalletLoader = @"JRNotificationShowWalletLoader";



//Type of recharge Products. for event tracking purpose, indicative plans loading and for frequent list purpose only
//so if you are going to change these values please make sure that they will support all the above purposes.
NSString * const JRProductTypeMobile = @"Mobile";
NSString * const JRProductTypeDTH = @"DTH";
NSString * const JRProductTypeDatacard = @"Datacard";
NSString * const JRProductTypeLandline = @"Landline";
NSString * const JRProductTypeElectricity = @"Electricity";
NSString * const JRProductTypeGas = @"Gas";
NSString * const JRProductTypeMetro = @"Metro";
NSString * const JRProductTypeInsurance = @"Insurance";
NSString * const JRProductTypeWater = @"Water";


NSString * const mobileRegEx = @"^[56789][0-9]{9}$";
NSString * const emailRegEx = @"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*(\\+[_A-Za-z0-9-]+){0,1}@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";

//Track Countly events
NSString * const JRTrackCountlyEventTransactions = @"transactions";
NSString * const JRTrackCountlyEventActivations = @"activations";
NSString * const JRAlllowableCharacters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890()'@- ";
NSString * const JRNumberOnlyCharacters = @"1234567890";

//Deeplinking Values for Wallet features
NSString * const JRWalletFeatureAddMoney = @"add_money";
NSString * const JRWalletFeatureSendMoney = @"send_money";
NSString * const JRWalletFeatureAcceptMoneySetting = @"accept_money";
NSString * const JRWalletFeatureVIPCashback = @"vip";
NSString * const JRWalletFeatureRequestMoney = @"request_money";
NSString * const JRWalletFeatureWithdrawMoney = @"withdraw_money";
NSString * const JRWalletFeatureShowCode = @"show_code";
NSString * const JRWalletFeatureSendMoneyToBank = @"send_money_bank";
NSString * const JRWalletFeatureTransferMoneyToBank = @"transfer_money_bank";
NSString * const JRWalletFeatureTransferMoneyToPPB = @"wallet_to_ppb";
NSString * const JRWalletFeatureScanner = @"scanner";
NSString * const JRWalletFeaturePaymentRequest = @"send_money_dl";
NSString * const JRWalletFeatureSendToMobileNumber = @"sendmoneymobile";
NSString * const JRWalletFeatureAcceptMoney = @"accept_money";
NSString * const JRWalletFeatureActivatePDC = @"activate_pdc";
NSString * const JRWalletFeatureOpenDebitCard = @"manage_debit";
NSString * const JRWalletFeatureVIPCashbackHome = @"paytmmp://cash_wallet?featuretype=vip&screen=homescreen";
NSString * const JRWalletFeatureMoneyTransfer = @"money_transfer";

// GTM Events Tracking
NSString * const JRScreenNameLogin = @"/login";
NSString * const JRScreenNameCoupon = @"/coupon";
NSString * const JRScreenNameCart = @"/cart";
NSString * const JRScreenNameCartScreenPopup = @"cart_screen_popup";
NSString * const JRScreenNameCheckout = @"/checkout";
NSString * const JRScreenNameSignUp = @"/sign-up";
NSString * const JRScreenNameSignUpConfirmaiton = @"/sign-up/confirmation";
NSString * const JRScreenNameBusTickets = @"/bus-tickets";
NSString * const JRScreenNameBusTicketsSummary = @"/bus-tickets-summary";
NSString * const JRScreenNameBusTicket = @"/bus-tickets-search";
NSString * const JRScreenNameBusSelection = @"/bus-tickets/search-results";
NSString * const JRScreenNameBusSeatSelection = @"/bus-tickets-seatlayout";
NSString * const JRScreenNameBusBoarding = @"/bus-tickets-boarding";
NSString * const JRScreenNamePassenger = @"/bus-tickets-traveller";
NSString * const JRScreenNameBusRating = @"/bus-ratings";
NSString * const JRScreenNameConfirmBooking = @"/bus-tickets-review";
NSString * const JRScreenNameWishList = @"/wishlist";
NSString * const JRScreenNameUpdate = @"/updates";
NSString * const JRScreenNameWallet = @"/wallet";
NSString * const JRScreenNameMall = @"/mall";
NSString * const JRScreenNameWallet_AddMoney = @"/wallet/add-money";
NSString * const JRScreenNameWallet_AcceptPayment =  @"/wallet/accept-payment";
NSString * const JRScreenNameWallet_Nearby =  @"/wallet/nearby";
NSString * const JRScreenNameMyOrders = @"/myorders";
NSString * const JRScreenNameWalletScreen = @"/wallet";
NSString * const JRScreenNameWalletSendMoney= @"/wallet/pay-send";
NSString * const JRScreenNameWalletSendMoney_To_Request = @"Send money to Requests";
NSString * const JRScreenNameWalletPassBook = @"/wallet/passbook";
NSString * const JRScreenNameHotelHome = @"/hotel";
NSString * const JRScreenNameHotelResults = @"/hotel/search-results";
NSString * const JRScreenNameHotelDetail = @"/hotel/hotel-details";
NSString * const JRScreenNameMovie = @"/movies";
NSString * const JRScreenNameHotelConfirmScreen = @"/hotel/review-booking";
NSString * const JRScreenNameHotelRoomOption = @"/hotel/hotel-details/room-options";
NSString * const JRScreenNameSummary = @"/summary";
NSString * const JRScreenNameFlightsHome = @"/flights";
NSString * const JRScreenNameFlightsSearchResults = @"/flights/search-results";
NSString * const JRScreenNameFlightsReview = @"/flights/review-itinerary";
NSString * const JRScreenNameFlightsTraveller = @"/flights/traveler-details";
NSString * const JRScreenNameRecharge = @"/recharge";
NSString * const JRScreenNameDataCard = @"/datacard";
NSString * const JRScreenNameDTH = @"/dth";
NSString * const JRScreenNameMetro = @"/metro";
NSString * const JRScreenNameInsurance = @"/insurance";
NSString * const JRScreenNameElectricity = @"/electricity";
NSString * const JRScreenNameBroadband = @"/broadband";
NSString * const JRScreenNameLandline = @"/landline";
NSString * const JRScreenNameGas = @"/gas";
NSString * const JRScreenNameWater = @"/water";
NSString * const JRScreenNameEducation = @"/education";
NSString * const JRScreenNameSettings = @"/settings";
NSString * const JRScreenNameFavourites = @"/favorite";
NSString * const JRScreenNameHelpAndFAQ = @"/care";
NSString * const JRScreenNameBeneficiary = @"/beneficiary";
NSString * const JRScreenNameWalletAddNew = @"/beneficiary/wallet/add_new";
NSString * const JRScreenNameWalletManage = @"/beneficiary/wallet/manage";
NSString * const JRScreenNameWalletEdit = @"/beneficiary/wallet/edit";
NSString * const JRScreenNameWalletAdvanceSettings = @"/beneficiary/wallet/advanced_settings";


//GTM Events for KYC
NSString * const JRScreenNameKYCHome = @"/kyc-wallet-upgrade";
NSString * const JRScreenNameKYCNonAadhar = @"/kyc-wallet-upgrade/non-aadhar";
NSString * const JRScreenNameKYCVerifyDocument = @"/kyc-wallet-upgrade/verify-document";
NSString * const JRScreenNameKYCRequestAVisit = @"/kyc-wallet-upgrade/request-visit";
NSString * const JRScreenNameKYCCourierDocument = @"/kyc-wallet-upgrade/courier-documents";
NSString * const JRScreenNameKYCVisitAKYCCenter = @"/kyc-wallet-upgrade/visit-kyc-centre";

NSString * const JREventKYCAadharProceedClicked = @"kyc_upgrade_wallet_proceed_clicked";
NSString * const JRVariableKYCUserId = @"kyc_user_id";
NSString * const JREventKYCNonAadharClicked = @"kyc_upgrade_wallet_kyc_with_other_docs_clicked";
NSString * const JREventKYCNonAadharProceedClicked = @"kyc_verify_document_proceed_clicked";
NSString * const JRVariableKYCDocType = @"kyc_document_type";
NSString * const JREventKYCVerifyOptionTabClicked = @"kyc_verify_document_option_tab_clicked";
NSString * const JRVariableKYCVerifyDocOption = @"verify_doc_option";
NSString * const JREventKYCBookAppointmentClicked = @"kyc_verify_document_book_appointment_clicked";
NSString * const JREventKYCCourierDocDownloadClicked = @"kyc_courier_document_download_clicked";
NSString * const JRScreenNameNonAdhaarPage = @"Verify Document Screen 1";
NSString * const JRScreenNameVerifyDocument = @"Verify Document Screen 2";
NSString * const JRScreenNameCourierDocument = @"Verify document - Courier your Documents Screen";


//Digital Gold
NSString * const JRScreenNameGold = @"/digital-gold";
NSString * const JRVariableGoldUserID = @"digital_gold_user_id";


NSString * const JRScreenNamePaymentScreen = @"Payment Screen";
NSString * const JRScreenNameOrderDetails = @"OrderDetails";
NSString * const JRScreenNameDeleiveryAddress = @"Delivery Address";
NSString * const JRScreenNameAddDeleiveryAddress = @"Add a Delivery Address";
NSString * const JRScreenNameSearchScreen = @"Search Screen";

NSString * const JRScreenNameCartEdit = @"Cart Edit screen";
NSString * const JRScreenNameBrandStore = @"/BrandStore";

NSString * const GTM_KEY_SCREEN_HOME_PAGE = @"Homepage";
NSString * const GTM_KEY_SCREEN_LEFT_NAV = @"LEFT NAV";


NSString * const JRVariableOperatorNameCircle = @"OPERATOR_NAME_CIRCLE";
NSString * const JRVariableOperatorName = @"OPERATOR_NAME";
NSString * const JRVariableMobileNumber = @"MOBILE_NUM";
NSString * const JRVariableActualAmount = @"ACTUAL_AMOUNT";
NSString * const JRVariableVerticalName = @"VERTICAL_NAME";

NSString * const JRVariableUserIDValue  = @"USER_ID_VALUE";
NSString * const JRVariableCategoryName = @"CATEGORY_NAME";
NSString * const JRVariableSubCategoryName = @"SUBCATEGORY_NAME";
NSString * const JRVariableCouponID = @"COUPON_ID";
NSString * const JRVariablePromoCode = @"PROMO_CODE";
NSString * const JRVariableProductSKU = @"PRODUCT_SKU";
NSString * const JRVariablePinCode = @"PINCODE";
NSString * const JRVariableName= @"NAME";
NSString * const JRVariableAddress1= @"ADDRESS1";
NSString * const JRVariableAddress2= @"ADDRESS2";
NSString * const JRVariableErrorMessage = @"ERROR_MESSAGE";
NSString * const JRVariableAmount = @"AMOUNT";
NSString * const JRVariableComment = @"COMMENT";
NSString * const JRVariableEmail = @"EMAIL_ADDRESS";
NSString * const JRVariableSearchTerm = @"SEARCH_TERM";
NSString * const JRVariableDate = @"DATE";

NSString * const JRVariableCartQuantity = @"cart_qty_action";
NSString * const JRVariableCartQuantityIncreased = @"increased";
NSString * const JRVariableCartQuantityDecreased = @"decreased";
NSString * const JRVariableCartProductID = @"cart_product_id";
NSString * const JRVariableCartProductName = @"cart_product_name";
NSString * const JRVariableCartOldQuantity = @"cart_old_qty";
NSString * const JRVariableCartNewQuantity = @"cart_new_qty";

NSString * const JREventQRIconClicked = @"qr_clicked";
NSString * const JREventQRSendMoney = @"qr_send_money";
NSString * const JREventWalletUpgrade = @"qr_upgrade";

NSString * const JREventRechargeScreenLoaded = @"screen_loaded_recharge";
NSString * const JREventMobileNumberFieldFocusOut = @"mobile_number_entered";
NSString * const JREventOperatorPopulated = @"operator_populated";
NSString * const JREventDifferentOperatorSelected =@"different_operator_selected";
NSString * const JREventAmountFieldFocusOut = @"amount_entered";
NSString * const JREventFastForwardClicked = @"fast_forward_clicked";
NSString * const JREventProceedToRechargeClicked = @"proceed_to_recharge_clicked";
NSString * const JREventOperatorDownDialogBoxOpen = @"operator_down_dialog_box";
NSString * const JREventClickOnProceed = @"operator_down_proceed";
NSString * const JREventClickOnLater = @"operator_down_later";

NSString * const JREventLoginScreenLoaded = @"screen_loaded_login";
NSString * const JREventEmailOrNumberFieldFocusOut = @"user_id_entered";
NSString * const JREventPasswordFieldFocusOut = @"password_entered";
NSString * const JREventForgotPasswordClicked = @"forgot_password_clicked";
NSString * const JREventInvalidLoginCredentialsError = @"invalid_login_attempt";
NSString * const JREventClickOnSecureLogin = @"login_button_clicked";
NSString * const JREventSignInWithFacebook = @"sign_in_fb_clicked";
NSString * const JREventSignInWithGooglePlus = @"sign_in_gplus_clicked";
NSString * const JREventLoginSuccessful = @"login_successful";

NSString * const JREventCouponScreenLoaded = @"screen_loaded_coupon";
NSString * const JREventCouponCategoryClicked = @"coupon_category_clicked";
NSString * const JREventCouponClicked = @"coupon_clicked";
NSString * const JREventCouponAccepted = @"coupon_accepted";
NSString * const JREventCouponDeclined = @"coupon_declined";
NSString * const JREventPromoCodeFieldFocusOut = @"recharge_promo_code_entered";
NSString * const JREventInvalidPromoCode = @"recharge_invalid_promo_code";
NSString * const JREventApplyButtonClicked = @"apply_clicked";
NSString * const JREventProceedButtonClicked = @"coupon_proceed";
NSString * const JREventCouponRechargeMobileScreenLoaded = @"recharge_mobile_coupon_page_loaded";
NSString * const JREventCouponMobilePromocodeEnter = @"recharge_mobile_promo_code_entered";
NSString * const JREventCouponMobilePromocodeError = @"recharge_mobile_promo_code_error_displayed";
NSString * const JREventCouponMobileProceedToPayClicked = @"recharge_mobile_proceed_to_pay_clicked";

NSString * const JREventOrderDetailsScreenLoaded = @"screen_loaded_order_details";

NSString * const JREventSummaryScreenLoadedRecharge = @"recharge_screen_loaded_summary";
NSString * const JREventSummaryScreenLoadedMarketplace = @"marketplace_screen_loaded_summary";
NSString * const JREventSummaryScreenLoadedWallet = @"wallet_screen_loaded_summary";
NSString * const JREventSummaryScreenLoadedBus = @"bus_screen_loaded_summary";
NSString * const JREventSummaryScreenLoadedHotel = @"screen_loaded_order_summary";
NSString * const JREventSummaryScreenLoadedRechargeMobile = @"recharge_mobile_summary_page_loaded";
NSString * const JREventSummaryScreenOrderSuccessfullRechargeMobile = @"recharge_mobile_order_successful_displayed";

NSString * const JREventTopNavigationMenuButtonClicked = @"top_nav_clicked";

NSString * const JREventCategoryClicked = @"left_nav_category_clicked";
NSString * const JREventSubCategoryClicked = @"left_nav_subcategory_clicked";
NSString * const JREventCategoryScreenLoaded = @"screen_loaded_category";
NSString * const JREventProductClicked = @"product_clicked";

NSString * const JREventProductScreenLoaded = @"product_loaded";
NSString * const JREventProductDescriptionSeen = @"product_description_seen";
NSString * const JREventPinCodeFieldFocusOut= @"pin_code_entered";
NSString * const JREventCheckButtonClicked = @"check_pincode_clicked";
NSString * const JREventInvalidPinCodeError= @"invalid_pin_code_error";
NSString * const JREventProductDescriptionclosed= @"product_description_closed";
NSString * const JREventProductScreenScrolled= @"product_scrolled";
NSString * const JREventProductPriceClicked= @"product_price_clicked";
NSString * const JREventProductAddedToCart= @"product_added_to_cart";
NSString * const JREventProductScreenBackButtonClicked= @"product_back_button_clicked";
NSString * const JREventProductScreenShareButtonClicked= @"product_share_button_clicked";
NSString * const JREventProductSharedOnSocial= @"product_shared_social";
NSString * const JREventCartButtonClickedProduct= @"cart_button_clicked_product";
NSString * const JREventCartButtonClicked = @"cart_button_clicked";

NSString * const JREventCartScreenLoaded = @"screen_loaded_cart";
NSString * const JREventItemQuantityChanges = @"item_quantity_changed";
NSString * const JREventItemRemovedFromCart = @"item_removed_from_cart";
NSString * const JREventPromoCodeEntered = @"cart_promo_code_entered";
NSString * const JREventCartInvalidPromoCode = @"cart_invalid_promo_code";
NSString * const JREventSelectDeliveryAddressButton = @"select_delivery_address_button_clicked";

NSString * const JREventDeliveryAddressScreenLoaded = @"screen_loaded_delivery_address";
NSString * const JREventAddDeliveryAddressClicked= @"add_delivery_address_clicked";

NSString * const JREventPaymentScreenLoaded =@"screen_loaded_marketplace_payment";

NSString * const JREventAddDeliveryAddressScreenLoaded = @"screen_loaded_add_a_delivery_address";
NSString * const JREventNameFieldFocusOut = @"dlvry_name_entered";
NSString * const JREventAddress1FieldFocusOut = @"dlvry_address1_entered";
NSString * const JREventAddress2FieldFocusOut = @"dlvry_address2_entered";
NSString * const JREventDeliveryPinCodeFieldFocusOut = @"dlvry_pin_code_entered";
NSString * const JREventCityFieldFocusOut = @"dlvry_field_entered";
NSString * const JREventStateFieldFocusOut = @"dlvry_state_entered";
NSString * const JREventPhonbeNumberFocusOut = @"dlvry_phone_entered";
NSString * const JREventValidationErrors = @"dlvry_validation_error";
NSString * const JREventDeliverToThisAddressClicked = @"deliver_to_this_address_clicked";
NSString * const JREventDeliveryBackButtonClicked = @"deliver_to_this_address_back_clicked";

NSString * const JREventBottomNavWalletClicked = @"bottom_nav_wallet_clicked";
NSString * const JREventWalletAmountFieldFocusOut = @"wallet_amount_entered";
NSString * const JREventAddToWalletClicked =@"add_to_wallet_clicked";
NSString * const JREventWalletPromocodeFieldFocusOut =@"wallet_promo_code_entered";
NSString * const JREventWalletInvalidPromocode =@"wallet_invalid_promo_code";
NSString * const JREventWalletOrderDetailScreenLoaded = @"screen_loaded_order_details_wallet";
NSString * const JREventWalletOnScreenPassbookClicked = @"wallet_onscreen_passbook_clicked";
NSString * const JREventWalletScreenLoaded = @"wallet_screen_loaded";
NSString * const JREventWalletAddMoneyPromoClicked = @"wallet_add_money_promocode_clicked";
NSString * const JREventWalletMobileNumberFieldClicked = @"new_wallet_mobile_number_field_clicked";
NSString * const JREventWalletMobileNumberEntered = @"new_wallet_mobile_number_entered";
NSString * const JREventWalletMobileOptionsClicked = @"new_wallet_mobile_options_clicked";
NSString * const JREventWalletOptionsTabClicked = @"new_wallet_options_tab_clicked";
NSString * const JREventWalletMobileProceedClicked = @"new_wallet_mobile_proceed_clicked";
NSString * const JREventWalletConfirmTabName = @"new_wallet_confirm_tab_name";
NSString * const JREventWalletInstantOtpClicked = @"new_wallet_see_instant_paytm_otp_clicked";
NSString * const JREventWalletPayQrScanSuccessful = @"new_wallet_pay_qr_scan_successful";
NSString * const JREventWalletPayFlashOptionsClicked = @"new_wallet_pay_flash_options_clicked";
NSString * const JREventWalletPayGalleryIconClicked = @"new_wallet_pay_gallery_icon_clicked";
NSString * const JREventWalletPayOptionsClicked = @"new_wallet_pay_options_clicked";
NSString * const JREventWalletPayOptionsTabClicked = @"new_wallet_pay_options_tab_clicked";
NSString * const JREventWalletPaySendClicked = @"new_wallet_pay_send_clicked";
NSString * const JREventWalletPaySendSuccess = @"wallet_success_screen_loaded";

NSString * const JREventWalletNearbyCategoryClicked = @"new_wallet_nearby_category_clicked";
NSString * const JREventWalletNearbyTabClicked = @"new_wallet_nearby_tab_clicked";
NSString * const JREventWalletNearbyNeedHelpClicked = @"new_wallet_nearby_need_help_clicked";
NSString * const JREventWalletNearbyCallClicked = @"new_wallet_nearby_call_clicked";
NSString * const JREventWalletNearbyMoreClicked = @"new_wallet_nearby_more_clicked";
NSString * const JREventWalletNearbyDistanceIconClicked = @"new_wallet_nearby_distance_icon_clicked";
NSString * const JREventWalletNearbyTabName = @"new_wallet_nearby_tab_name";
NSString * const JREventWalletNearbyParameterScreenTypeValue = @"nearby";

NSString * const JREventWalletPostPaymentShareIconClicked = @"new_wallet_share_icon_clicked";
NSString * const JREventWalletPostPaymentAddMoneyToWalletClicked = @"new_wallet_add_money_to_wallet_clicked";
NSString * const JREventWalletPostPaymentViewPassbookClicked = @"new_wallet_view_passbook_clicked";
NSString * const JREventWalletPostPaymentContactUsClicked = @"new_wallet_contact_us_clicked";
NSString * const JREventWalletPostPaymentLogoutClicked = @"new_wallet_logout_tab_clicked";
NSString * const JREventWalletPostPaymentParameterScreenTypeValue = @"pay_successful";

NSString * const JREventWalletParameterScreenType = @"new_wallet_screen_type";
NSString * const JREventWalletParameterScreenTypeValue = @"wallet_send_money_screen";
NSString * const JREventWalletParameterPayScreenTypeValue = @"send_money";

NSString * const JREventWalletMoneyTransferTabSelected = @"new_wallet_money_transfer_tab_selected";
NSString * const JREventWalletMoneyTransferScreenTypeValue = @"money_transfer";
NSString * const JREventWalletMoneyTransferTabName = @"new_wallet_money_transfer_tab_name";
NSString * const JREventWalletMoneyTransferTabNameP2P = @"P2P";
NSString * const JREventWalletMoneyTransferTabNameP2B = @"P2B";
NSString * const JREventWalletMobileNumberEnterMethod = @"new_wallet_number_enter_method";
NSString * const JREventWalletEnterMethodRecentInline = @"Recent inline";
NSString * const JREventWalletEnterMethodPhonebook = @"phonebook";
NSString * const JREventWalletEnterMethodType = @"type";
NSString * const JREventWalletEnterMethodRecent = @"recent";
NSString * const JREventWalletMobileAmount = @"new_wallet_amount";
NSString * const JREventWalletMobileConfirmTabName = @"new_wallet_mobile_confirm_tab_name";
NSString * const JREventWalletMoneyTransferType = @"new_wallet_money_transfer_type";
NSString * const JREventWalletAccountNumberEnterMethod = @"new_wallet_account_number_enter_method";
NSString * const JREventWalletBankAmount = @"new_wallet_bank_amount";
NSString * const JREventWalletBankIFSCCode = @"new_wallet_bank_ifsc_code";
NSString * const JREventWalletBankName = @"new_wallet_bank_name";
NSString * const JREventWalletBankConfirmTabName = @"new_wallet_bank_confirm_tab_name";
NSString * const JREventWalletBankTransactionStatusProcessing = @"PROCESSING";
NSString * const JREventWalletBankTransactionStatusSuccess = @"SUCCESS";
NSString * const JREventWalletMobileAmountFieldClicked = @"new_wallet_mobile_amount_field_clicked";
NSString * const JREventWalletMobileAmountFieldEntered = @"new_wallet_mobile_amount_field_entered";
NSString * const JREventWalletMobileConfirmClicked = @"new_wallet_mobile_confirm_tab_clicked";
NSString * const JREventWalletMobileRecentClicked = @"new_wallet_mobile_recent_clicked";
NSString * const JREventWalletBankAccountNumberFieldClicked = @"new_wallet_bank_account_number_field_clicked";
NSString * const JREventWalletBankAccountNumberFieldEntered = @"new_wallet_bank_acount_number_field_entered";
NSString * const JREventWalletBankAccountNameFieldClicked = @"new_wallet_bank_account_name_field_clicked";
NSString * const JREventWalletBankAccountNameFieldEntered = @"new_wallet_bank_account_name_field_entered";
NSString * const JREventWalletBankAmountFieldClicked = @"new_wallet_bank_amount_field_clicked";
NSString * const JREventWalletBankAmountFieldEntered = @"new_wallet_bank_amount_field_entered";
NSString * const JREventWalletBankFindIFSCClicked = @"new_wallet_bank_find_ifsc_clicked";
NSString * const JREventWalletBankFindIFSCContinueClicked = @"new_wallet_bank_ifsc_continue_clicked";
NSString * const JREventWalletBankProceedClicked = @"new_wallet_bank_proceed_clicked";
NSString * const JREventWalletBankConfirmClicked = @"new_wallet_bank_confirm_tab_clicked";
NSString * const JREventWalletBankTransactionStatus = @"new_wallet_bank_transaction_status";

NSString * const JREventAddmoneyScreenLoaded = @"screen_loaded_add_money";
NSString * const JREventSendmoneyScreenLoaded = @"screen_loaded_send_money";
NSString * const JREventSendmoneyMobileFieldFocusOut = @"send_money_mobile_entered";
NSString * const JREventSendmoneyAmountFieldFocusOut = @"send_money_amount_entered";
NSString * const JREventSendmoneyCommentFieldFocusOut = @"send_money_comment_entered";
NSString * const JREventSendMoneyButtonClicked = @"send_money_button_clicked";

NSString * const JREventSignUpScreenLoaded = @"screen_loaded_signup";
NSString * const JREventSignUpMobileNumberFieldFocusOut = @"signup_mobile_entered";
NSString * const JREventSignUpEmailFieldFocusOut = @"signup_email_entered";
NSString * const JREventSignUpPasswordFieldFocusOut = @"signup_password_entered";
NSString * const JREventSignUpConfirmationScreenLoaded = @"screen_loaded_signup_confirmation";
NSString * const JREventSignUpChangeMobileNumberLinkClicked = @"change_the_number_link_clicked";
NSString * const JREventSignUpOTPFieldFocusOut = @"signup_otp_entered";
NSString * const JREventSignUpFirstNameFieldFocusOut = @"signup_first_name_entered";
NSString * const JREventSignUpLastNameFieldFocusOut = @"signup_last_name_entered";
NSString * const JREventSignUpGenderRadioButtonSelected = @"signup_gender_selected";
NSString * const JREventSignUpDateOfBirthSelected = @"signup_dob_entered";
NSString * const JREventSignUpValidationErrors = @"signup_validation_error";
NSString * const JREventSignUpConfirmButtonClicked = @"signup_confirm_clicked";
NSString * const JREventSignUpSuccesful = @"signup_successful";


NSString * const JREventBusticketScreenLoaded = @"screen_loaded_bus_ticket";
NSString * const JREventBusFromFieldSelected = @"bus_home_from_selected";
NSString * const JREventBusToFieldSelected = @"bus_home_to_selected";
NSString * const JREventBusDateSelected = @"bus_home_date_selected";
NSString * const JREventBusTicketsSearchButtonClicked = @"bus_home_search_bus_clicked";
NSString * const JREventBusSelectionScreenLoaded = @"screen_loaded_bus_selection";
NSString * const JREventBusSelectionRefineButtonClicked = @"bus_search_refine_button_clicked";
NSString * const JREventBusSelectionApplyButtonClicked = @"bus_refine_apply_clicked";
NSString * const JREventBusSeatSelectionScreenLoaded = @"screen_loaded_bus_seat_selection";
NSString * const JREventBusSeatSelectionProceedClicked = @"bus_seat_proceed_clicked";
NSString * const JREventSummaryScreenBusPaymentSucces = @"bus_summary_payment_successful";
NSString * const JREventPassengerDetailsScreenLoaded = @"screen_loaded_passenger_details";
NSString * const JREventConfirmBookingScreenLoaded = @"screen_loaded_confirm_booking";
NSString * const JREventConfirmCancellationpolicyReviewed = @"bus_review_cancellation_policy";


NSString * const JREventSearchScreenLoaded = @"screen_loaded_search";
NSString * const JREventSearchTermLoaded = @"search_term_entered";
NSString * const JREventSearchSuggestionSelected = @"search_suggestion_selected";
NSString * const JREventHotSearchSelected  = @"search_hot_search_selected";
NSString * const JREventNoSearchResultsFound = @"screen_loaded_no_search_results";

NSString * const JREventSearchResultScreenLoaded = @"screen_loaded_search_results";
NSString * const JREventSearchResultTabSelected = @"screen_loaded_search_tab";
NSString * const JREventSearchResultSortByPrice = @"search_sorted_price";
NSString * const JREventSearchResultRefineClicked = @"search_refine_clicked";

NSString * const JREventSearchRefineScreenLoaded =@"screen_loaded_search_refine";
NSString * const JREventSearchFilterSelected = @"search_refine";
NSString * const JREventSearchFilterCleared  = @"search_refine_clear";
NSString * const JREventSearchShowButtonClicked = @"search_filter_show_clicked";
NSString * const JREventSearchResultsClicked = @"search_product_clicked";

NSString * const JREventCartQuantityChanged = @"cart_qty_changed";

NSString * const JRUpdateWalletCasNotification = @"JRUpdateWalletCasNotification";

NSString * const JRUpdateShippingChargeViewNotification = @"JRUpdateShippingChargeViewNotification";

NSString * const JRUserPreferancePinCode = @"JRUserPreferancePinCode";


NSString * const JRRefreshOrderSummaryNotification = @"RefreshOrderSummaryNotification";
NSString * const JRHandleOrderSummaryRedirectionNotification = @"JRHandleOrderSummaryRedirectionNotification";
NSString * const JRHandlePGPageRedirectionNotification = @"JRHandlePGPageRedirectionNotification";
NSString * const JRLoadParentOrderIdNotification = @"JRLoadParentOrderIdNotification";

//Inmobi events

NSString * const JRGNAAppUrlType = @"gna_app_url_type";
NSString * const JRGNAListAppName = @"gna_list_app_name";
NSString * const JRGNAListAppPosition = @"gna_list_app_position";
NSString * const JRGNAAppName = @"gna_%@_app_name";
NSString * const JRGNAAppPosition = @"gna_%@_app_position";

NSString * const JRTrackingCategoryID = @"CATEGORY_ID";
NSString * const JRTrackingCategoryName = @"CATEGORY_NAME";
NSString * const JRTrackingProductID = @"PRODUCT_ID";
NSString * const JRTrackingProductName = @"PRODUCT_NAME";
NSString * const JRTrackingAmount = @"AMOUNT";
NSString * const JRTrackingOrderID = @"ORDER_ID";
NSString * const JRTrackingTotalCartAmount = @"TOTAL_CART_AMOUNT";
NSString * const JRTrackingSearch_String= @"SEARCH_STRING";
NSString * const JRTrackingCategory_L1= @"CATEGORY_L1";
NSString * const JRTrackingCategory_L2= @"CATEGORY_L2";
NSString * const JRTrackingCategory_L3= @"CATEGORY_L3";
NSString * const JRTrackingMerchantId = @"MERCHANT_ID";


NSString * const JRTrackingCategoryViewEvent = @"Category_View_Event";
NSString * const JRTrackingSubCategoryViewEvent = @"Sub_Category_View_Event";
NSString * const JRTrackingProductViewEvent  = @"af_content_view";
NSString * const JRTrackingAddToCartEvent = @"Add_to_Cart";
NSString * const JRTrackingApplyPromoEvent = @"Apply_Promocode";
NSString * const JRTrackingRemoveFromCartEvent = @"Remove_from_Cart";
NSString * const JRTrackingFavouriteEvent = @"Favorite_Activity";
NSString * const JRTrackingShareEvent = @"Share_on_Social";
NSString * const JRTrackingSearchEvent = @"af_search";
NSString * const JRTrackingInitiatedCheckoutEvent = @"Initiated_checkout";
NSString * const JRTrackingThankYouRechargeEvent = @"Thank_You_Page_Recharge";
NSString * const JRTrackingThankYouMarketplaceEvent = @"Thank_You_Page_Marketplace";
NSString * const JRTrackingThankYouAppsflyerEvent = @"Thank_You_Page";



NSString * const JRHotelHomePageloaded = @"screen_loaded_home";
NSString * const JRHotelSearchClicked = @"clicked_search_hotels";
NSString * const JRhotelResultClicked =@"clicked_hotel_details";
NSString * const JRHotelRefineClicked = @"hotels_clicked_refine";
NSString * const JRHotelRefineApplied = @"hotels_applied_refine";
NSString * const JRHotelSelectRoomClicked = @"clicked_select_room";
NSString * const JRhotelMapClicked = @"hotels_viewed_location_map";
NSString * const JRHotelImageClicked = @"hotels_opened_gallery";
NSString * const JRhotelRoomOptionClicked = @"hotels_clicked_room_option";
NSString * const JRHotelAppliedPromocode = @"promo_applied";
NSString * const JRHotelProceedToPayCliked = @"clicked_proceed_to_pay";
NSString * const JRhotelOrderSummarySuccess = @"hotels_order_success";

NSString * const JRScreenNameWalletRequestMoney = @"/wallet/request-money";
NSString * const JRScreenNameWalletSavedCards = @"/wallet/saved-cards";
NSString * const JRScreenNameWalletMerchantList = @"/wallet/merchant-list";
NSString * const JRScreenNameWalletOffers = @"/wallet/wallet-offers";

//Wallet
NSString * const JRScreenNameWalletPaySendScanCode = @"/wallet/pay-send/scan-code";
NSString * const JRScreenNameWalletPaySendMobile = @"/wallet/pay-send/mobile";
NSString * const JRScreenNameWalletPaySendSuccess = @"/wallet/pay-send/success";
NSString * const JRScreenNameWalletPendSendShowCode = @"/wallet/pay-send/show-code";
NSString * const JRScreenNameWalletPassbookBank = @"/wallet/passbook/bank";
NSString * const JRScreenNameWalletMoneyTransfer = @"/wallet/money-transfer";

//Recharge
NSString * const GTM_KEY_MOBILE_SUB_VERTICAL = @"recharge_business_sub_vertical";
NSString * const GTM_EVENT_MOBILE_POSTPAID_SELECTED = @"recharge_mobile_postpaid_selected";
NSString * const GTM_EVENT_MOBILE_PREPAID_SELECTED = @"recharge_mobile_prepaid_selected";
NSString * const GTM_EVENT_MOBILE_AMOUNT_CLICK = @"recharge_mobile_amount_clicked";
NSString * const GTM_EVENT_MOBILE_AMOUNT_ENTERED = @"recharge_mobile_amount_entered";
NSString * const GTM_KEY_RECHARGE_MOBILE_AMOUNT = @"recharge_mobile_amount";
NSString * const GTM_KEY_RECHARGE_MOBILE_RECENTSEARCHES_TOP_SELECTED = @"recharge_mobile_recent_selected";
NSString * const GTM_KEY_RECHARGE_MOBILE_RECENTSEARCHES_BOTTOM_SELECTED = @"recharge_mobile_recent_selected_bottom";
NSString * const GTM_KEY_MOBILE_OPERATOR_NAME = @"recharge_mobile_operator_name";
NSString * const GTM_KEY_MOBILE_CIRCLE_NAME = @"recharge_mobile_circle_name";
NSString * const GTM_EVENT_RECHRGE_FASTFRWD_CLICKED = @"recharge_mobile_fast_forward_clicked";
NSString * const GTM_KEY_RECHARGE_MOBILE_NUM = @"recharge_mobile_number";
NSString * const GTM_EVENT_RECHARGE_BROSEPLANS_CLICKED = @"recharge_mobile_browse_plans_clicked";
NSString * const GTM_EVENT_RECHARGE_BROSEPLANS_SELECTED = @"recharge_mobile_plan_selected";
NSString * const GTM_KEY_RECHARGE_BROSEPLANS_CATEGORY = @"recharge_mobile_category";
NSString * const GTM_KEY_MOBILE_PROMO_CODE = @"recharge_mobile_promo_code";
NSString * const GTM_KEY_HELPVIDEO_CAPTION = @"recharge_utilities_video_caption";

//Recharge event
NSString * const GTM_EVENT_MOBILE_MOBILE_FIELD_CLICKED = @"recharge_mobile_mobile_field_clicked";
NSString * const GTM_EVENT_MOBILE_OPERATOR_CLICKED = @"recharge_mobile_operator_clicked";
NSString * const GTM_EVENT_MOBILE_CONTACT_LIST_CLICKED = @"recharge_mobile_contact_list_clicked";
NSString * const GTM_EVENT_MOBILE_OPERATOR_SELECTED = @"recharge_mobile_operator_selected";
NSString * const GTM_EVENT_MOBILE_CIRCLE_CLICKED = @"recharge_mobile_circle_clicked";
NSString * const GTM_EVENT_MOBILE_CIRCLE_SELECTED = @"recharge_mobile_circle_selected";
NSString * const GTM_EVENT_MOBILE_PROCEED_CLICKED = @"recharge_mobile_proceed_to_recharge_clicked";
NSString * const GTM_EVENT_MOBILE_RECENTS_TAB_CLICKED = @"recharge_mobile_recents_clicked";
NSString * const GTM_EVENT_MOBILE_OFFERS_TAB_CLICKED = @"recharge_mobile_offers_clicked";
NSString * const GTM_EVENT_MOBILE_OFFERS_LISTITEM_CLICKED = @"recharge_mobile_offer_details_selected";

//Adword
NSString * const JRVariablegdr_chkout_amount= @"gdr_chkout_amount";
NSString * const GTM_KEY_NAV_SEARCH_TYPE = @"nav_search_type";
NSString * const GTM_KEY_NAV_SEARCH_TERM = @"nav_search_term";
NSString * const GTM_KEY_NAV_SEARCH_CATEGORY = @"nav_search_category";
NSString * const GTM_KEY_NAV_SEARCH_RESULT_TYPE = @"nav_search_result_type";
NSString * const GTM_KEY_Customer_ID= @"Customer_Id";

NSString * const GTM_KEY_GDR_REFERRER = @"gdr_referrer";
NSString * const GTM_KEY_GDR_CHKOUT_AMOUNT = @"gdr_chkout_amount";
NSString * const GTM_KEY_GDR_PRODUCT_NAME = @"gdr_prod_name";
NSString * const GTM_KEY_GDR_PRODUCT_ID = @"gdr_prod_id";
NSString * const GTM_KEY_GDR_PRODUCT_CATEGORY_NAME = @"gdr_prod_cat_name";
NSString * const GTM_KEY_GDR_PRODUCT_CATEGORY_ID = @"gdr_prod_cat_id";
NSString * const GTM_KEY_GDR_TOTAL_VALUE = @"gdr_total_value";
NSString * const GTM_KEY_LIST_NAME = @"list_name";
NSString * const GTM_KEY_LIST_POSITION = @"list_position";
NSString * const GTM_KEY_SEARCH_TYPE = @"search_type";
NSString * const GTM_KEY_SEARCH_CATEGORY = @"search_category";
NSString * const GTM_KEY_SEARCH_AB_VALUE = @"search_ab_value";
NSString * const GTM_KEY_SEARCH_TERM = @"search_term";
NSString * const GTM_KEY_SEARCH_RESULT_TYPE = @"search_result_type";
NSString * const GTM_KEY_GDR_USER_ID = @"gdr_user_id";
NSString * const GTM_KEY_DESTINATION_URL = @"destinationURL";

NSString * const GTM_KEY_SEARCH_INPUT_TYPE = @"search_input_type";
NSString * const GTM_KEY_SEARCH_OUTPUT_TYPE = @"search_output_type";
NSString * const GTM_KEY_SEARCH_AUTOSUGGEST_DATA = @"search_autosuggest_data";

NSString * const GTM_EVENT_GDR_SCREEN_LOADED_SEARCH_RESULTS = @"gdr_screen_loaded_search_results";
NSString * const GTM_EVENT_CATEGORY_GDR_SCREEN_LOADED_CATEGORY = @"gdr_screen_loaded_category";
NSString * const GTM_EVENT_GDR_PRODUCT_LOADED = @"gdr_product_loaded";
NSString * const GTM_EVENT_CART_GDR_SCREEN_LOADED_CART = @"gdr_screen_loaded_cart";
NSString * const GTM_EVENT_GDR_MARKET_PLACE_SUMMARY = @"gdr_marketplace_screen_loaded_summary";

NSString * const GTM_EVENT_CUSTOM = @"custom_event";
NSString * const GTM_VERTICAL_NAME_KEY = @"vertical_name";
NSString * const GTM_VERTICAL_MARKETPLACE = @"marketplace";
NSString * const GTM_VERTICAL_OAUTH = @"oauth";
NSString * const GTM_SCREEN_NAME_KEY = @"screenName";
NSString * const GTM_EVENT_ACTION_KEY = @"event_action";
NSString * const GTM_EVENT_CATEGORY_KEY = @"event_category";
NSString * const GTM_EVENT_LABEL_KEY = @"event_label";
NSString * const GTM_EVENT_LABEL2_KEY = @"event_label2";
NSString * const GTM_EVENT_LABEL3_KEY = @"event_label3";
NSString * const GTM_USER_ID = @"user_id";
NSString * const GTM_VERTICAL_WALLET = @"wallet";
NSString * const GTM_CATEGORY_MONEY_TRANSFER = @"wallet_money_transfer";

NSString * const GTM_EVENT_CART_PAGE_LOADED = @"fnl_cart_screen_loaded";
NSString * const GTM_KEY_CART_FNL_GA_KEY = @"fnl_ga_key";
NSString * const GTM_KEY_CART_FNL_VERTICAL = @"fnl_vertical";
NSString * const GTM_EVENT_ORDER_SUMMARY_LOADED = @"fnl_success_summary_screen_loaded";
NSString * const GTM_EVENT_CART_CHECKOUT_PROCEED_CLICK = @"fnl_checkout_cart_proceed_clicked";
NSString * const GTM_EVENT_CART_POPUP_PROMO_SELECTED_CLICKED = @"popup_promo_selected_clicked";
NSString * const GTM_EVENT_CART_POPUP_CONTINUE_ANYWAYS_CLICKED = @"popup_continue_anyways_clicked";
NSString * const GTM_EVENT_NAV_PUSH_NOTIFICATION_CLICKED = @"nav_push_notification_clicked";
NSString * const GTM_EVENT_NAV_PUSH_NOTIFICATION_RECIEVED = @"nav_push_notification_received";
NSString * const GTM_EVENT_CATALOG_TOP_NAVIGATION_CLICKED = @"nav_subcategory_down_arrow_clicked";
NSString * const GTM_EVENT_PDP_TOP_NAVIGATION_CLICKED = @"nav_product_down_arrow_clicked";
NSString * const GTM_EVENT_PDP_NAVIGATION_SELLER_LINK_CLICKED = @"nav_seller_clicked";
NSString * const GTM_EVENT_PDP_NAVIGATION_BRAND_CLICKED = @"nav_brand_clicked";
NSString * const GTM_EVENT_SEARCH_NO_RESULTS_DISPLAYED = @"search_no_results_displayed";
NSString * const GTM_EVENT_SEARCH_DID_YOU_MEAN_TERM_CLICKED = @"search_did_you_mean_term_clicked";
NSString * const GTM_EVENT_NAV_RICH_PUSH_NOTIFICATION_CLICKED = @"nav_rich_push_notification_clicked";
NSString * const GTM_EVENT_NAV_RICH_PUSH_NOTIFICATION_VIEWED = @"nav_rich_push_notification_viewed";
NSString * const GTM_EVENT_MALL_TOP_NAV_CLICKED = @"mall_top_nav_clicked";
NSString * const GTM_EVENT_CART_TOP_BAR_CLIKED = @"cart_top_bar_bag_wishlist_click";
NSString * const GTM_EVENT_WL_SCREEN_LOADED = @"wl_screen_loaded";
NSString * const GTM_CART_TOP_BAR_BTN_TYPE = @"cart_top_bar_button_type";
//movies
NSString * const GTM_EVENT_MOVIE_HOME_SCREEN_LOADED = @"movie_home_screen_loaded";
NSString * const GTM_KEY_MOVIE_SEARCH_TYPE_SELECTED = @"movie_search_type_selected";
NSString * const GTM_KEY_MOVIE_SEARCH_PERFORMED = @"movie_search_performed";
NSString * const GTM_EVENT_MOVIE_GRID_ITEM_CLICKED = @"movie_grid_movie_cinema_clicked";
NSString * const GTM_EVENT_MOVIE_GRID_ITEM_VIEWED = @"movie_grid_movie_cinema_viewed";
NSString * const GTM_EVENT_MOVIE_LISTING_SCREEN_LOADED = @"movie_listing_screen_loaded";
NSString * const GTM_EVENT_MOVIE_LISTING_SCREEN_TIMINGS_CLICKED = @"movie_listing_show_timings_clicked";
NSString * const GTM_EVENT_MOVIE_SEAT_SCREEN_LOADED = @"movie_seat_selection_screen_loaded";
NSString * const GTM_EVENT_MOVIE_SEAT_PROMO_CLICKED = @"movie_seat_promocode_clicked";
NSString * const GTM_EVENT_MOVIE_SEAT_PROMO_APPLIED = @"movie_seat_promocode_applied";
NSString * const GTM_EVENT_MOVIE_SEAT_PROCCED_CLICKED = @"movie_seat_procced_to_pay_clicked";
NSString * const GTM_EVENT_MOVIE_ORDER_SCREEN_LOADED = @"movie_order_screen_loaded";
NSString * const GTM_EVENT_MOVIE_ORDER_PAYMENT_STATUS = @"movie_payment_status_displayed";
NSString * const GTM_KEY_MOVIE = @"Movie";
NSString * const GTM_KEY_CINEMA = @"Cinema";
NSString * const GTM_KEY_MOVIE_CITY_NAME = @"movie_city_name";
NSString * const GTM_KEY_MOVIE_USER_ID = @"movie_user_id";
NSString * const GTM_KEY_MOVIE_SEARCH_TYPE = @"movie_search_type";
NSString * const GTM_KEY_MOVIE_LISTING_TYPE = @"movie_cinema_listing_type";

//Brand Store
NSString * const GTM_KEY_Brandstore_Site_Id = @"brandstore_site_id";
NSString * const GTM_KEY_Brandstore_View_Identifier = @"brandstore_view_identifier";
NSString * const GTM_KEY_Brandstore_Tab_Name = @"brandstore_tab_name";
NSString * const GTM_KEY_Brandstore_Item_Identifier = @"brandstore_item_identifier";


// -------- ----  New Recharge/Utility Events,Keys

NSString * const GTM_KEY_UTILITY_SUB_VERTICAL = @"recharge_utilities_business_sub_vertical";
NSString * const GTM_KEY_UTILITY_SERVICE_TYPE = @"recharge_utilities_service_type";
NSString * const GTM_KEY_UTILITY_GROUP_FIELD_PLACEHOLDER = @"recharge_utilities_group_field";
NSString * const GTM_KEY_UTILITY_GROUP_FIELD_VALUE = @"recharge_utilities_group_field_value";
NSString * const GTM_KEY_UTILITY_INPUT_FIELD_PLACEHOLDER = @"recharge_utilities_input_field";
NSString * const GTM_KEY_UTILITY_INPUT_FIELD_VALUE = @"recharge_utilities_input_field_value";
NSString * const GTM_KEY_UTILITY_OFFER_PROMOCODE = @"recharge_utilities_offer_promocode";

NSString * const GTM_KEY_UTILITY_GROUP_FIELD_VALUES = @"recharge_utilities_group_field_values";
NSString * const GTM_KEY_UTILITY_INPUT_FIELD_VALUES = @"recharge_utilities_input_field_values";

NSString * const GTM_KEY_UTILITY_PROCEED_FETCH_ERROR_MESSAGE = @"recharge_utilities_proceed_fetch_error_message";
NSString * const GTM_KEY_UTILITY_AMOUNT = @"recharge_utilities_amount";
NSString * const GTM_KEY_UTILITY_PROCEED_ERROR_MESSAGE = @"recharge_utilities_proceed_error_message";
NSString * const GTM_KEY_UTILITY_APPLY_PROMO_ERROR_MESSAGE = @"recharge_utilities_promo_code_error_message";

NSString * const GTM_KEY_UTILITY_FF_STATE = @"recharge_utilities_ff_state";
NSString * const GTM_VALUE_UTILITY_FF_STATE_CHECKED = @"checked";
NSString * const GTM_VALUE_UTILITY_FF_STATE_UNCHECKED = @"unchecked";

NSString * const GTM_KEY_UTILITY_BOTTOM_TAB_NAME = @"recharge_utilities_bottom_tab_name";

NSString * const GTM_KEY_UTILITY_ORDER_ID = @"recharge_utilities_order_id";
NSString * const GTM_KEY_UTILITY_ORDER_PAYMENT_STATUS = @"recharge_utilities_payment_status";
NSString * const GTM_KEY_UTILITY_PG_RESPONSE_CODE = @"recharge_utilities_pg_response_code";
NSString * const GTM_KEY_UTILITY_ITEM_STATUS_CODE = @"recharge_utilities_item_status_code";

NSString * const GTM_KEY_UTILITY_AMOUNT_TYPE = @"recharge_utilities_amount_type";
NSString * const GTM_VALUE_UTILITY_AMOUNT_TYPE_PREFETCH_EDITABLE = @"prefetch_editable";
NSString * const GTM_VALUE_UTILITY_AMOUNT_TYPE_NON_PREFETCH = @"non_prefetch";
NSString * const GTM_VALUE_UTILITY_AMOUNT_TYPE_PREFETCH_NON_EDITABLE = @"prefetch_non_editable";

NSString * const GTM_KEY_UTILITY_GROUP_FIELD_SELECTION_TYPE = @"recharge_utilities_selection_method";
NSString * const GTM_VALUE_UTILITY_GROUP_FIELD_SELECTION_TYPE_AUTOMATIC = @"autoselect";
NSString * const GTM_VALUE_UTILITY_GROUP_FIELD_SELECTION_TYPE_MANUAL = @"manual";

NSString * const GTM_KEY_UTILITY_ERROR_MESSAGE_TYPE = @"recharge_utilities_message_type";
NSString * const GTM_VALUE_UTILITY_ERROR_MESSAGE_TYPE_OPERATOR = @"operator_specific";
NSString * const GTM_VALUE_UTILITY_ERROR_MESSAGE_TYPE_GENERAL = @"general";

NSString * const GTM_KEY_UTILITY_ERROR_DISPLAY_TYPE = @"recharge_utilities_display_type";
NSString * const GTM_VALUE_UTILITY_ERROR_DISPLAY_TYPE_POPUP = @"popup";
NSString * const GTM_VALUE_UTILITY_ERROR_DISPLAY_TYPE_NONPOPUP = @"non_popup";

// Events
NSString * const GTM_EVENT_UTILITY_HOME_SCREEN_LOADED = @"recharge_utilities_home_screen_loaded";
NSString * const GTM_EVENT_UTILITY_SERVICE_TYPE_SELECTED = @"recharge_utilities_servicetype_selected";
NSString * const GTM_EVENT_UTILITY_GROUP_FIELD_CLICKED = @"recharge_utilities_group_field_clicked";
NSString * const GTM_EVENT_UTILITY_GROUP_FIELD_SELECTED = @"recharge_utilities_group_field_selected";
NSString * const GTM_EVENT_UTILITY_INPUT_FIELD_CLICKED = @"recharge_utilities_input_field_clicked";
NSString * const GTM_EVENT_UTILITY_INPUT_FIELD_ENTERED = @"recharge_utilities_input_field_entered";
NSString * const GTM_EVENT_UTILITY_PROCEED_FETCH_CLICKED = @"recharge_utilities_proceed_fetch_clicked";
NSString * const GTM_EVENT_UTILITY_PROCEED_FETCH_ERROR = @"recharge_utilities_proceed_fetch_error";

NSString * const GTM_EVENT_UTILITY_AMOUNT_CLICKED = @"recharge_utilities_amount_clicked";
NSString * const GTM_EVENT_UTILITY_AMOUNT_ENTERED = @"recharge_utilities_amount_entered";
NSString * const GTM_EVENT_UTILITY_RECENT_SELECTED_INLINE = @"recharge_utilities_recent_selected_inline";
NSString * const GTM_EVENT_UTILITY_BOTTOM_TAB_CLICKED = @"recharge_utilities_bottom_tab_clicked";
NSString * const GTM_EVENT_UTILITY_RECENT_SELECTED_BOTTOM_TAB = @"recharge_utilities_recent_selected_bottom_tab";
NSString * const GTM_EVENT_UTILITY_OFFER_CLICKED_BOTTOM_TAB = @"recharge_utilities_offer_clicked_bottom_tab";
NSString * const GTM_EVENT_UTILITY_HELP_CLICKED_BOTTOM_TAB = @"recharge_utilities_help_clicked_bottom_tab";

NSString * const GTM_EVENT_UTILITY_FASTFORWARD_CLICKED = @"recharge_utilities_fast_forward_clicked";
NSString * const GTM_EVENT_UTILITY_PROCEED_CLICKED = @"recharge_utilities_proceed_clicked";
NSString * const GTM_EVENT_UTILITY_PROCEED_ERROR = @"recharge_utilities_proceed_error";

NSString * const GTM_EVENT_UTILITY_COUPON_PAGE_LOADED = @"recharge_utilities_coupon_page_loaded";
NSString * const GTM_EVENT_UTILITY_COUPON_PROMO_CLICKED = @"recharge_utilities_promo_code_clicked";
NSString * const GTM_EVENT_UTILITY_COUPON_PROMO_ENTERED = @"recharge_utilities_promo_code_entered";
NSString * const GTM_EVENT_UTILITY_COUPON_PROMO_ERROR = @"recharge_utilities_promo_code_error_displayed";
NSString * const GTM_EVENT_UTILITY_COUPON_PROCEEDTOPAY_CLICKED = @"recharge_utilities_proceed_to_pay_clicked";

NSString * const GTM_EVENT_UTILITY_SUMMARY_PAGE_LOADED = @"recharge_utilities_summary_page_loaded";
NSString * const GTM_EVENT_UTILITY_SUMMARY_ORDER_SUCCESSFUL = @"recharge_utilities_order_successful_displayed";

NSString * const GTM_EVENT_UTILITY_VIEW_SAMPLE_BILL_CLICKED = @"recharge_utilities_view_sample_bill_clicked";
NSString * const GTM_EVENT_UTILITY_MESSAGE_DISPLAYED = @"recharge_utilities_message_displayed";

//NearBy
NSString * const JRScreenNameNEARBY  =   @"nearby";

// Screens
NSString * const GTM_SCREEN_UTILITY = @"reharge/utilities home screen";
NSString * const GTM_SCREEN_COUPON = @"Coupons screen";
NSString * const GTM_TRACKING_INFO_KEY = @"ga_tracking_info";

//Item Detail Screen
NSString * const JRScreenNameItemDetail = @"/item-details";
NSString * const JREventItemDetailScreenLoaded = @"item_details_screen_loaded";

NSString * const JRVariableItemState = @"item_details_item_state";
NSString * const JRVariableItemVerticalLabel = @"item_details_vertical_label";
NSString * const JRVariableItemID = @"item_details_item_id";
NSString * const JRVariableOrderID = @"item_details_order_id";

NSString * const JREventItemDetailViewTrackingDetailsClicked = @"item_details_view_tracking_details_clicked";
NSString * const JREventItemDetailContactCourierClicked = @"item_details_contact_courier_clicked";
NSString * const JREventItemDetailViewRefundPolicyClicked = @"item_details_view_refund_policy_clicked";
NSString * const JREventItemDetailExtendTimeClicked = @"item_details_extend_time_clicked";
NSString * const JREventItemDetailCancelOrderClicked = @"item_details_cancel_order_clicked";
NSString * const JREventItemDetailReturnOrReplaceClicked = @"item_details_return_or_replace_clicked";
NSString * const JREventItemDetailEscalateToPaytmClicked = @"item_details_escalate_to_paytm_clicked";
NSString * const JREventItemDetailDownloadInvoiceClicked = @"item_details_download_invoice_clicked";
NSString * const JREventItemDetailViewOrderDetailsClicked = @"item_details_view_order_details_clicked";
NSString * const JREventItemDetailViewReplacementOrderClicked = @"my_orders_view_replacement_order_clicked";

//Order Detail Screen
NSString * const JRScreenNameOrderDetail = @"/order-details";
NSString * const JREventOrderDetailScreenLoaded = @"order_details_screen_loaded";
NSString * const JRVariableOrderState = @"order_details_order_state";

//bottom navigation
NSString * const JREventBottomNavIconClicked = @"bottom_nav_icon_clicked";
NSString * const JREventBottomNavHome = @"bottom_nav_home_clicked";
NSString * const JREventBottomNavMall = @"bottom_nav_mall_clicked";
NSString * const JREventBottomNavProfile = @"bottom_nav_account_clicked";
NSString * const JREventBottomNavUpdates = @"bottom_nav_updates_clicked";
NSString * const JREventBottomNavScan = @"bottom_nav_scancode_clicked";
NSString * const JREventBottomNavBank = @"bottom_nav_bank_clicked";

// pdp events
NSString * const PDP_CART_ICON_CLICKED = @"pdp_cart_icon_clicked";
NSString * const PDP_BRAND_CLICKED = @"pdp_brand_clicked";
NSString * const PDP_QUANTITY_CHANGED = @"pdp_quantity_changed";
NSString * const PDP_VIEW_SIZE_CHART_CLICKED = @"pdp_view_size_chart_clicked";
NSString * const PDP_SIZE_SELECTED = @"pdp_size_selected";
NSString * const PDP_OFFER_ACTION_PERFORMED = @"pdp_offer_action_performed";
NSString * const PDP_OFFER_VIEW_MORE_CLICKED = @"pdp_offers_viewmore_clicked";
NSString * const PDP_OFFER_SELECTED_FROM_VIEWMORE = @"pdp_offer_selected_from_viewmore";
NSString * const PDP_PINCODE_CLICKED = @"pdp_pincode_clicked";
NSString * const PDP_PINCODE_CHANGED = @"pdp_pincode_changed";
NSString * const PDP_OTHER_SELLERS_EXPANDED = @"pdp_other_sellers_expanded";
NSString * const PDP_OTHER_SELLER_ACTIONS_PERFORMED = @"pdp_other_sellers_action_performed";
NSString * const PDP_OTHER_SELLER_SELECTED = @"pdp_other_seller_selected";
NSString * const PDP_INFO_TAB_CLICKED = @"pdp_info_tab_clicked";
NSString * const PDP_CALL_TO_ACTION_CLICKED = @"pdp_call_to_action_clicked";
NSString * const PDP_MORE_PRODUCTS_BY_CLICKED = @"pdp_more_products_by_clicked";
NSString * const PDP_RELATED_PRODUCT_CLICKED = @"pdp_related_product_type";
NSString * const PRODUCT_PUSH_CATEGORY = @"product_push_category";

//EMI Events
NSString * const ZERO_COST_EMI_CLICKED = @"zero_cost_emi_field_clicked";
NSString * const ZERO_COST_EMI_SELECTED = @"zero_cost_emi_selected";
NSString * const ZERO_COST_EMI_CALL_TO_ACTION_CLICKED = @"call_to_action_clicked";
NSString * const JRScreenNameZeroEmiReviewScreen = @"Review Screen";
NSString * const ZERO_COST_EMI_PROCEED_TO_PAY_CLICKED = @"proceed_to_pay_clicked";
NSString * const REVIEW_SCREEN_LOADED = @"review_screen_loaded";
NSString * const CANCEL_PAYMENT_CONFIRMATION = @"cancel_payment_confirmation";

// Exchange Events
NSString * const EXCHANGE_OFFER_CLICKED = @"exchange_offer_clicked";
NSString * const EXCHANGE_OFFER_CLOSE_CLICKED = @"close_button_clicked";
NSString * const EXCHANGE_CHANGE_CLICKED = @"exchange_change_clicked";
NSString * const EXCHANGE_HOW_IT_WORKS_CLICKED = @"exchange_info_overlay_clicked";
NSString * const EXCHANGE_DONE_CLICKED = @"done_button_clicked";
NSString * const EXCHANGE_PRODUCT_REMOVED = @"exchange_product_removed";
NSString * const PROCEED_TO_LOGIN_CART = @"login_to_proceed_clicked";
//Payments Bank
NSString * const JRScreenNamePBankProceedScreen = @"/bank/saving-account/proceed";
NSString * const JRScreenNamePBankTnCScreen = @"/bank/saving-account/t&c";
NSString * const JRScreenNamePBankKYCCongratulationScreen = @"/bank/saving-account/kyc-success";

NSString * const JREventPBankOpenAccountClicked = @"bank_saving_account_open_account_clicked";
NSString * const JREventPBankProceedClicked = @"bank_saving_account_proceed_clicked";
NSString * const JREventPBankTnCClicked = @"bank_saving_account_tnc_clicked";
NSString * const JREventPBankSetPasscodeClicked = @"bank_saving_account_set_passcode";
NSString * const JREventPBankConfirmPasscodeClicked = @"bank_saving_account_confirm_passcode";
NSString * const JREventPBankAddNomineeProceedClicked = @"add_nominee_proceed_clicked";
NSString * const JREventPBankAddNomineeDetailsProceedClicked = @"add_nominee_details_proceed_clicked";
NSString * const JREventPBankRequestAppointmentProceedClicked = @"request_appointment_proceed_clicked";
NSString * const JREventPBankOpenAccountDoneClicked = @"bank_saving_account_done_clicked";

NSString * const JREventPBankSavingAccountOpenSource = @"banking_saving_account_open_source";
NSString * const JREventPBankSavingAccountProceedScreen = @"banking_saving_account_proceed_screen";
NSString * const JREventPBankSavingAccountNomineeSelectedTabName = @"bank_saving_account_nominee_selected_tab_name";

// ------- ---- ---- ---- ----

NSString * const JRPromotionalUATag = @"promotional";

NSString * const JRModuleID = @"moduleID";

NSString * const kNewFeatureSeenUserDefaultKey = @"newFeatureSeen";
NSString * const kHideNewFeatureArrowNotificationKey = @"hideNewFeatureArrowView";


//Deeplink query string
NSString * const JRDeeplinkFeatureType = @"featuretype";
int  const JRDealsVerticalId = 66;
int  const JRGiftCardsVerticalId = 81;
NSString *  const JRGiftCardCatId = @"91373";

// -------------------------------
NSString* const JRScreenNameMoneyTransfer = @"/money-transfer";


//MMID Client id and Client secret
NSString *  const MMIDClientId = @"gBQwdy8VRhUZwL9vOU17u4Gu-VWla8x0NN1HhdTPaXI=";
NSString *  const MMIDClientSecret = @"5NoeOrGVfz_6EMwGKDiR2YChPdpdPumDf1YlEd6aXesuxA5dPYvIog==";
NSString *  const MMIRestAPIKey = @"84f7c05c0669b8f6e331584ac8e95e24";
NSString *  const MMIMapAPIKey = @"4f58e96f6890f5333e775856127b672e";
