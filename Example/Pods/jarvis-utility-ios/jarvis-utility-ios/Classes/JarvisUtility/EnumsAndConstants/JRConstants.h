//
//  JRConstants.h
//  JarvisTextCases
//
//  Created by Shwetha Mugeraya on 27/08/13.
//  Copyright (c) 2013 Robosoft Technologies. All rights reserved.
//

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version)  ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending)

//Digital Product Constants
#define KEYBOARD_HEIGHT 216.0f
#define KEYBOARD_HEIGHT_PORTRAIT 264.0f
#define KEYBOARD_HEIGHT_LANDSCAPE 352.0f

#define TAB_BAR_HEIGHT 49.0f


#define KEYBOARD_TOOLBAR_HEIGHT 60.0f

#define PLACEHOLDER_TEXT_COLOR [UIColor colorWithWhite:0.70 alpha:1];
#define SHADOW_COLOR [UIColor colorWithWhite:0.3f alpha:0.5];
#define H1_PAGE_HEADING_FONT [UIFont helveticaNeueMediumFontOfSize:17]


#define T1_SECTION_TITLE_FONT [UIFont helveticaNeueLightFontOfSize:16];

#define JRErrorCodeGlobal 007007
#define JRErrorCodeJsonError 003003
#define JRErrorCodeBusTicketsServerDown 503
#define JRErrorCodeBadRequest 400
#define JRErrorCodeNotFound 404
#define JRErrorCodeNotRechable 500


//===========* Don't change the codes *========//|
#define JRErrorCodeAuthorizationFailed 410     //|
//=============================================//|

#define APPDELEGATE (JRAppDelegate *)[[UIApplication sharedApplication] delegate]

#define JRLoginRequiredError 449
#define JRNoNetworkError -1009
#define JRNoHostnameFound -1003

#define NO_NETWORK_ERROR_CODE 5001
#define UNKNOWN_ERROR_CODE 5003


#define pageSizeToLoadOrderHistory @"10"

#define WindowWidth [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds.size.width
#define WindowHeight [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds.size.height
#define CartViewWidth 450.0f

//Make it as 0 if you want staging environment
#define PRODUCTION_ENVIRONMENT 0

// These images are being used for different status 
#define kSuccessImage @"green_check_mark"
#define kPendingImage @"Order_Summary_Pending_icon"
#define kFailureImage @"Order_Summary_Fail_icon"

#define kPending @"PROCESSING"
#define kSuccess @"SUCCESS"
#define kFailed @"FAILED"

// This key is used for Identify Insurance Product Vertical ID
#define kInsuranceProductVerticalId 79



typedef NS_ENUM (NSUInteger, PassengerType) {
    PassengerTypeAdult = 0,
    PassengerTypeChild = 1,
    PassengerTypeInfant = 2
};

static NSInteger const JRDefaultNumberOfDummyCells = 3;

//iPhoneX SafeArea Margin
extern CGFloat const  iPhoneXSafeAreaMargin;

//AppStoreUpdateURL
extern NSString *const JRPaytmAppStoreUrl;

//Twitter
extern NSString * const JRTwitterSearchAPI;

extern NSString *const JRWalletTokenExpiryDate;
extern NSString *const JRWalletUDMap;
extern NSString *const JRWalletVersionNumber;
extern NSString *const JRWalletRefNumber;
extern NSString *const JRWalletOtpTimeInterval;
extern NSString *const JRWalletOtpRefreshInterval;
extern NSString *const JRWalletCGCPOfflineHeader;
extern NSString *const JRWalletOtpConfig;
extern NSString *const JRWalletEpochTime;

extern NSString * const kConvenienceFeeDisplayFormat;

extern NSString * const JROrderTypeRecharge;
extern NSString * const JROrderTypeMarketplace;

extern NSString * const JRSmallImageUrl;
extern NSString * const JRLargeImageUrl;
extern NSString * const JRImageData;

//item
extern NSString * const JRItemName;
extern NSString * const JRItems;
extern NSString * const JRItemprice;

//product
extern NSString * const JRProductID;
extern NSString * const JRProductType;
extern NSString * const JRProductURL;
extern NSString * const JRProductName;
extern NSString * const JRProductShortDescription;
extern NSString * const JRProductRichDescription;
extern NSString * const JRProductOtherRichDescription;
extern NSString * const JRProductPromoText;
extern NSString * const JRProductActualPrice;
extern NSString * const JRProductOfferPrice;
extern NSString * const JRProductRating;
extern NSString * const JRProductBrand;
extern NSString * const JRProductMerchant;
extern NSString * const JRProductSelectableAttributes;
extern NSString * const JRProductMerchantName;
extern NSString * const JRProductAddToCartUrl;
extern NSString * const JRProductOtherMedia;
extern NSString * const JRProductCreatedDate;
extern NSString * const JRProductEndDate;
extern NSString * const JRProductSkuId;
extern NSString * const JRProductCartText;
extern NSString * const JRProductSelectedAttributes;
extern NSString * const JRProductQuantity;
extern NSString * const JRProductPromocodeUrl;
extern NSString * const JRProductCartPrice;
extern NSString * const JRProductShippingCost;
extern NSString * const JRProductUpdateQuantityUrl;
extern NSString * const JRProductDeleteUrl;
extern NSString * const JRProductSize;
extern NSString * const JRProductLength;
extern NSString * const JRProductRegEx;
extern NSString * const JRProductStatus;
extern NSString * const JRProductError;

//merchant
extern NSString * const JRMerchantId;
extern NSString * const JRMerchantName;
extern NSString * const JRMerchantsRating;
extern NSString * const JRMerchantImage;
extern NSString * const JRStore;

//store
extern NSString * const JRStoreName;
extern NSString * const JRStoreId;
extern NSString * const JRStoreImage;

//selectableAttributes
extern NSString * const JRSelectableAttributeName;
extern NSString * const JRSelectableAttributeId;
extern NSString * const JRSelectableAttributeValues;

//layout
extern NSString * const JRLayoutType;
extern NSString * const JRLayoutName;
extern NSString * const JRLayoutTypeHorizontalList;
extern NSString * const JRLayoutTypeCarousel;
extern NSString * const JRLayoutTypeCarousel1;
extern NSString * const JRLayoutTypeTabs;
extern NSString * const JRLayoutTypeCarousel2;
extern NSString * const JRLayoutTypeHyphenCarousel1;
extern NSString * const JRLayoutTypeHyphenCarousel2;
extern NSString * const JRLayoutTypeRow;
extern NSString * const JRLayoutTypeList;
extern NSString * const JRLayoutTypeHtml;
extern NSString * const JRLayoutTypeHomePage;
extern NSString * const JRLayoutTypeCatalog;
extern NSString * const JRLayoutTypeGrid;
extern NSString * const JRFooterImageURL;
extern NSString * const JRLayoutTypeSmartIconList;
extern NSString * const JRLayoutTypeSmartIconBottomNavList;
extern NSString * const JRLayoutTypeMainCarousel2;

//gridLayoutParams
extern NSString * const JRGridLayout;
extern NSString * const JRGridFooterHtml;
extern NSString * const JRGriddefaultSortParams;
extern NSString * const JRGridSortingKeys;
extern NSString * const JRHasMoreProducts;

extern NSString * const JREventGridCategoryAction  ;
extern NSString * const JREventGridScrollDown ;
extern NSString * const JREventGridSortMenuClicked ;
extern NSString * const JREventGridSortApplied ;
extern NSString * const JREventGridFltersMenuClicked ;
extern NSString * const JREventGridFltersPriceRangeSelected ;
extern NSString * const JRVariableGridCategoryAction ;
extern NSString * const JRVariableGridCategoryItemName ;
extern NSString * const JRVariableGridCategoryPageType ;
extern NSString * const JRVariableGridProductPosition ;
extern NSString * const JRVariableGridSortFilterName ;
extern NSString * const JRVariableGridPriceRange ;
extern NSString * const JRVariableGridSelectedFieldCategory ;
extern NSString * const JREventGridFiltersApplied ;
extern NSString * const JREventGridFiltersResetClicked ;


extern NSString * const JRKYCStatusFetchedNotification;
extern NSString * const JRMinKYCSignUpNotification;
extern NSString * const JRMinKYCCompletedNotification;
extern NSString * const JRUserDidLoginNotification;
extern NSString * const JRDidUserSignOutNotification;
extern NSString * const JRPasswordChangedNotification;
extern NSString * const JRMoveToHomeByRefreshingEachTab;
extern NSString * const JRDidCartCountOrMessageCountChangeNotification;
extern NSString * const JRDidUserCameBackFromPgNotification;
extern NSString * const JRDidUserProfileUpdateNotification;
extern NSString * const JRUsersKYCDetailsUpdateNotification;
extern NSString * const JRCitySelectionClosedNotification;


extern NSString * const JRTextIosErrorTitle;
extern NSString * const JRTextIosLostConnectionErrorMessage;

//track GA Events for KYC
extern NSString * const JRScreenNameKYCHome;
extern NSString * const JRScreenNameKYCNonAadhar;
extern NSString * const JRScreenNameKYCVerifyDocument ;
extern NSString * const JREventKYCAadharProceedClicked ;
extern NSString * const JRVariableKYCUserId ;
extern NSString * const JREventKYCNonAadharClicked ;
extern NSString * const JREventKYCNonAadharProceedClicked ;
extern NSString * const JRVariableKYCDocType ;
extern NSString * const JREventKYCVerifyOptionTabClicked ;
extern NSString * const JRVariableKYCVerifyDocOption ;
extern NSString * const JREventKYCBookAppointmentClicked ;
extern NSString * const JREventKYCCourierDocDownloadClicked ;
extern NSString * const JRScreenNameNonAdhaarPage ;
extern NSString * const JRScreenNameVerifyDocument ;
extern NSString * const JRScreenNameCourierDocument;
extern NSString * const JRScreenNameKYCRequestAVisit ;
extern NSString * const JRScreenNameKYCCourierDocument ;
extern NSString * const JRScreenNameKYCVisitAKYCCenter ;

typedef NS_ENUM(NSUInteger, JRAadharAndPanViewState) {
    JRAadharAndPanViewStateEditable,
    JRAadharAndPanViewStateEditableExclamated,
    JRAadharAndPanViewStateNonEditable,
    JRAadharAndPanViewStateNonEditableTicked,
    JRAadharAndPanViewStateNonEditableWaiting
};

//Digital Gold
extern NSString * const JRScreenNameGold ;
extern NSString * const JRVariableGoldUserID ;

//Url Param constants
extern NSString * const JRContentType;
extern NSString * const CART_ID;
extern NSString * const APP_INSTALLED;
extern NSString * const COUNTLY_SDK_ACTIVATED;

//indicative Plans URL constants
extern NSString * const JRMobileIndicativeType;
extern NSString * const JRDTHIndicativeType;
extern NSString * const JRDatacardIndicativeType;
extern NSString * const JRTollcardIndicativeType;


//mobile number prefix value
extern NSString * const JRPrefixCountryCode;

#pragma Mark NotificationNames
extern NSString * const JRWalletRefreshBalanceNotification;
extern NSString * const JRUpgradeWalletActionNotification;
extern NSString * const JRNotificationItemSelectedFromCatalog;
extern NSString * const JRNotificationLoadingNextProductPage;
extern NSString * const JRNotificationCatalogCacheUpdated;
extern NSString * const JRNotificationTabMenuCacheUpdated;
extern NSString * const JRNotificationHomePageCacheUpdated;
extern NSString * const JRNotificationNameRechagesViewHeightChanged;
extern NSString * const JRApplicationDidEnterBackgroundNotification;
extern NSString * const JRNotificationInternetConnectionReachableNow;
extern NSString * const JRNotificationFrequentOrdersUpdated;
extern NSString * const JRNotificationFrequentOrdersModified; //when new favorite added or favorites updated
extern NSString * const JRApplicationDidEnterForegroundNotification;

extern NSString * const JRNotification503StatusOccured;
extern NSString * const JRNotificationMaintenancePageDidDismiss;
extern NSString * const JRNotificationItemSelctedInCatalogView;
extern NSString * const JRNotificationUpdateCount;
extern NSString * const JRNotificationMoveToHomeTab;
extern NSString * const JRNotificationEraseAmountTextfieldText;
extern NSString * const JRNotificationMoveToCatalogHome;
extern NSString * const JRWalletRequestSizeChangeNotification;

extern NSString * const JRDidAppEnterForegroundNotification;
extern NSString * const JRNotificationShowWalletLoader;

#pragma Apsalar Event Names
extern NSString * const JRTrackEventSoftBlock;
extern NSString * const JRTrackEventApplicationOpen;
extern NSString * const JRTrackEventHomeMobilePrepaid;
extern NSString * const JRTrackEventHomeMobilePostpaid;
extern NSString * const JRTrackEventHomeDTH;
extern NSString * const JRTrackEventHomeDatacardPrepaid;
extern NSString * const JRTrackEventHomeDatacardPostpaid;
extern NSString * const JRTrackEventDeepLinking;

extern NSString * const JRHomeEventWalletStripClicked;

//Revenue Events
extern NSString * const JRTrackEventRechargeRevenue;
extern NSString * const JRTrackEventMarketPlaceRevenue;

extern NSString * const JRTrackEventLeftMobilePrepaid;
extern NSString * const JRTrackEventLeftMobilePostpaid;
extern NSString * const JRTrackEventLeftDTH;
extern NSString * const JRTrackEventLeftDatacardPrepaid;
extern NSString * const JRTrackEventLeftDatacardPostpaid;
extern NSString * const JRTrackEventLeftCategoryName;
extern NSString * const JRLeftCatalogMenu;

extern NSString * const JRTrackEventHomeMobilePlans;
extern NSString * const JRTrackEventHomeDatacardPlans;
extern NSString * const JRTrackEventHomeDthPlans;
extern NSString * const JRTrackEventLeftMobilePlans;
extern NSString * const JRTrackEventLeftDatacardPlans;
extern NSString * const JRTrackEventLeftDthPlans;
extern NSString * const JRTrackEventSearch;
extern NSString * const JRTrackEventHomeShowcase;
extern NSString * const JRTrackEventYourOrders;
extern NSString * const JRTrackEventSettings;
extern NSString * const JRTrackEventHelp;
extern NSString * const JRTrackEventSignOut;
extern NSString * const JRTrackEventCheckout;
extern NSString * const JRTrackEventEditCartDelete;
extern NSString * const JRTrackEventEditCartUpdate;
extern NSString * const JRTrackEventApplyPromoCart;
extern NSString * const JRTrackEventApplyPromoCartEdit;
extern NSString * const JRTrackEventSelectShipping;
extern NSString * const JRTrackEventSelectAddress;
extern NSString * const JRTrackEventShippingProceed;
extern NSString * const JRTrackEventShowPassword;
extern NSString * const JRTrackEventForgotPassword;
extern NSString * const JRTrackEventSignIn;
extern NSString * const JRTrackEventCreateAccountLogin;
extern NSString * const JRTrackEventSignUp;
extern NSString * const JRTrackEventSelectPayment;
extern NSString * const JRTrackEventThankYouShopping;
extern NSString * const JRTrackEventThankYouRecharge;
extern NSString * const JRTrackEventThankYouWallet;
extern NSString * const JRTrackEventLandlineOperators;
extern NSString * const JRTrackEventElectricityOperators;
extern NSString * const JRTrackEventGasOperators;


extern NSString * const JRTrackEventHome;
extern NSString * const JRTrackEventHomeSeeAll;
extern NSString * const JRTrackEventOrderSummary;
extern NSString * const JRTrackEventOrderSummarySeeAll;
extern NSString * const JRTrackEventOrderSummaryShowcase;

extern NSString * const JRTrackEventSelectFreeCoupon;
extern NSString * const JRTrackEventSelectPaidCoupon;
extern NSString * const JRTrackEventRechargeApplyPromo;
extern NSString * const JRTrackEventRechargeSkipCoupon;
extern NSString * const JRTrackEventRechargeUseWallet;
extern NSString * const JRTrackEventRechargeUnselectWallet;
extern NSString * const JRTrackEventRechargeSelectPayment;
extern NSString * const JRTrackEventRechargeProceedToPay;
extern NSString * const JRTrackEventThankYouRecharge;
extern NSString * const JRTrackEventRechargeContinueShop;
extern NSString * const JRTrackEventChangeSize;
extern NSString * const JRTrackEventDescription;
extern NSString * const JRTrackEventRefine;
extern NSString * const JRTrackEventSortNew;
extern NSString * const JRTrackEventSortPopular;
extern NSString * const JRTrackEventSortPrice;
extern NSString * const JRTrackEventSortRelevance;
extern NSString * const JRTrackEventHomeProduct;
extern NSString * const JRTrackEventCategoryProduct;
extern NSString * const JRTrackEventAddToCart;
extern NSString * const JRTrackEventURLConnectionError;
extern NSString * const JRTrackEventPushNotificationBuckets;

// new Events
extern NSString * const JRTrackEventHomeTab;
extern NSString * const JRTrackEventCouponsTabChange;
extern NSString * const JRTrackEventPaytmCashPage;
extern NSString * const JRTrackEventPaytmCashLedgerPage;
extern NSString * const JRTrackEventAddPaytmCash;
extern NSString * const JRTrackEventProfileTabInfo;
extern NSString * const JRTrackEventProfileTabSavedCards;
extern NSString * const JRTrackEventProfileTabAddress;
extern NSString * const JRTrackEventBrowsePlanSelected;
extern NSString * const JRTrackEventSearchText;
extern NSString * const JRTrackEventLedgerButtonClick;
extern NSString * const JRTrackEventContactIconClick;
extern NSString * const JRTrackEventContactSelected;
extern NSString * const JRTrackEventFrequentOrderSelected;
extern NSString * const JRTrackEventFastForward;
extern NSString * const JRTrackEventMarketPlaceOrderContinueShopping;
extern NSString * const JRTrackEventBrowsePlanTab;
extern NSString * const JRTrackEventYourOrdersRepeatRetry;
extern NSString * const JRTrackEventPrepaidPostPaidToggle;
extern NSString * const JRTrackEventTopUpSpecialRechargeToggle;
extern NSString * const JRTrackEventProductPageView;
extern NSString * const JRTrackEventFrequentOrderAmountChanged;
extern NSString * const JRTrackEventQueingError;
extern NSString * const JRTrackEventApplicationOpenUnique;
extern NSString * const JRTrackEventApplicationOpenSignout;
extern NSString * const JRTrackEventApplicationOpenSignIn;
extern NSString * const JRTrackEventPageNavigation;
extern NSString * const JRTrackEventCheckOutFromProductPage;


//Type of recharge Products. for event tracking purpose, indicative plans loading and for frequent list purpose only
//so if you are going to change these values please make sure that they will support all the above purposes.
extern NSString * const JRProductTypeMobile;
extern NSString * const JRProductTypeDTH;
extern NSString * const JRProductTypeDatacard;
extern NSString * const JRProductTypeLandline;
extern NSString * const JRProductTypeElectricity;
extern NSString * const JRProductTypeGas;
extern NSString * const JRProductTypeMetro;
extern NSString * const JRProductTypeInsurance;
extern NSString * const JRProductTypeWater;

//RegEx for validation
extern NSString * const mobileRegEx;
extern NSString * const emailRegEx;

//Track Countly events
extern NSString * const JRTrackCountlyEventTransactions;
extern NSString * const JRTrackCountlyEventActivations;
extern NSString * const JRAlllowableCharacters;
extern NSString * const JRNumberOnlyCharacters ;
//Used in add address controller
//indicates the main screen till which we need to pop in case 410/401 error occurs
typedef enum
{
    JRCartScreen = 0,
    JRCouponScreen = 1,
    JRUserProfileScreen = 2,
    JRKYCRequestScreen = 3,
    JRPurchaseCardScreen = 4,
    JRInsuranceAddressScreen = 5
}JRMainScreen;

//Deeplinking Values for Wallet features
extern NSString * const JRWalletFeatureAddMoney;
extern NSString * const JRWalletFeatureSendMoney;
extern NSString * const JRWalletFeatureAcceptMoneySetting;
extern NSString * const JRWalletFeatureVIPCashback;
extern NSString * const JRWalletFeatureRequestMoney;
extern NSString * const JRWalletFeatureWithdrawMoney;
extern NSString * const JRWalletFeatureShowCode;
extern NSString * const JRWalletFeatureSendMoneyToBank;
extern NSString * const JRWalletFeatureTransferMoneyToBank;
extern NSString * const JRWalletFeatureTransferMoneyToPPB;
extern NSString * const JRWalletFeatureScanner;
extern NSString * const JRWalletFeaturePaymentRequest;
extern NSString * const JRWalletFeatureSendToMobileNumber;
extern NSString * const JRWalletFeatureAcceptMoney;
extern NSString * const JRWalletFeatureActivatePDC;
extern NSString * const JRWalletFeatureOpenDebitCard;
extern NSString * const JRWalletFeatureVIPCashbackHome;
extern NSString * const JRWalletFeatureVIPCashbackConfirm;
extern NSString * const JRWalletFeatureVIPCashbackOfferDetail;
extern NSString * const JRWalletFeatureMoneyTransfer;

// GTM Events Tracking
extern NSString * const JRScreenNameLogin;
extern NSString * const JRScreenNameCoupon;
extern NSString * const JRScreenNameOrderDetails;
extern NSString * const JRScreenNameSummary;
extern NSString * const JRScreenNameCart;
extern NSString * const JRScreenNameCartScreenPopup;
extern NSString * const JRScreenNameCheckout;
extern NSString * const JRScreenNameDeleiveryAddress;
extern NSString * const JRScreenNameAddDeleiveryAddress;
extern NSString * const JRScreenNameWalletScreen;
extern NSString * const JRScreenNameSignUp;
extern NSString * const JRScreenNameSignUpConfirmaiton;
extern NSString * const JRScreenNameBusTicket;
extern NSString * const JRScreenNameBusSelection;
extern NSString * const JRScreenNameBusSeatSelection;
extern NSString * const JRScreenNameBusBoarding;
extern NSString * const JRScreenNamePassenger;
extern NSString * const JRScreenNameConfirmBooking;
extern NSString * const JRScreenNameBusTicketsSummary;
extern NSString * const JRScreenNameBusTickets;
extern NSString * const JRScreenNameSearchScreen;
extern NSString * const JRScreenNameBusRating;
extern NSString * const JRScreenNameWishList;
extern NSString * const JRScreenNameUpdate;
extern NSString * const JRScreenNameWallet;
extern NSString * const JRScreenNameWallet_AddMoney;
extern NSString * const JRScreenNameWallet_Nearby;
extern NSString * const JRScreenNameWallet_AcceptPayment;
extern NSString * const JRScreenNameMyOrders;
extern NSString * const JRScreenNameHotelHome;
extern NSString * const JRScreenNamePaymentScreen;
extern NSString * const JRScreenNameWalletSendMoney;
extern NSString * const JRScreenNameWalletSendMoney_To_Request;
extern NSString * const JRScreenNameWalletPassBook;
extern NSString * const JRScreenNameMall;
extern NSString * const JRScreenNameHotelConfirmScreen;
extern NSString * const JRScreenNameHotelDetail;
extern NSString * const JRScreenNameHotelResults;
extern NSString * const JRScreenNameHotelRoomOption;
extern NSString * const JRScreenNameMovie;
extern NSString * const JRScreenNameCartEdit;
extern NSString * const JRScreenNameBrandStore;
extern NSString * const JRScreenNameCartDetailsScreen;
extern NSString * const JRScreenNameCartEditScreen;
extern NSString * const JRScreenNameFlightsHome;
extern NSString * const JRScreenNameFlightsSearchResults;
extern NSString * const JRScreenNameFlightsReview;
extern NSString * const JRScreenNameFlightsTraveller;
extern NSString * const JRScreenNameRecharge;
extern NSString * const JRScreenNameDataCard;
extern NSString * const JRScreenNameDTH;
extern NSString * const JRScreenNameMetro;
extern NSString * const JRScreenNameInsurance;
extern NSString * const JRScreenNameElectricity;
extern NSString * const JRScreenNameBroadband;
extern NSString * const JRScreenNameLandline;
extern NSString * const JRScreenNameGas;
extern NSString * const JRScreenNameWater;
extern NSString * const JRScreenNameEducation;
extern NSString * const JRScreenNameSettings;
extern NSString * const JRScreenNameFavourites;
extern NSString * const JRScreenNameHelpAndFAQ;
extern NSString * const JRScreenNameBeneficiary;
extern NSString * const JRScreenNameWalletAddNew;
extern NSString * const JRScreenNameWalletManage;
extern NSString * const JRScreenNameWalletEdit;
extern NSString * const JRScreenNameWalletAdvanceSettings;




extern NSString * const JRVariableOperatorNameCircle;
extern NSString * const JRVariableOperatorName;
extern NSString * const JRVariableMobileNumber;
extern NSString * const JRVariableActualAmount;
extern NSString * const JRVariableVerticalName;
extern NSString * const JRVariableUserIDValue;
extern NSString * const JRVariableCategoryName;
extern NSString * const JRVariableSubCategoryName;
extern NSString * const JRVariableCouponID;
extern NSString * const JRVariablePromoCode;
extern NSString * const JRVariableProductSKU;
extern NSString * const JRVariablePinCode;
extern NSString * const JRVariableName;
extern NSString * const JRVariableAddress1;
extern NSString * const JRVariableAddress2;
extern NSString * const JRVariableErrorMessage;
extern NSString * const JRVariableAmount;
extern NSString * const JRVariableComment;
extern NSString * const JRVariableEmail;
extern NSString * const JRVariableSearchTerm;
extern NSString * const JRVariableDate;

extern NSString * const JRScreenNameWalletPaySendScanCode;
extern NSString * const JRScreenNameWalletPaySendMobile;
extern NSString * const JRScreenNameWalletPaySendSuccess;
extern NSString * const JRScreenNameWalletPendSendShowCode;
extern NSString * const JRScreenNameWalletPassbookBank;
extern NSString * const JRScreenNameWalletMoneyTransfer;

extern NSString * const JRVariableCartQuantity;
extern NSString * const JRVariableCartQuantityIncreased;
extern NSString * const JRVariableCartQuantityDecreased;
extern NSString * const JRVariableCartProductID;
extern NSString * const JRVariableCartProductName;
extern NSString * const JRVariableCartOldQuantity;
extern NSString * const JRVariableCartNewQuantity;


extern NSString * const JREventQRIconClicked;
extern NSString * const JREventQRSendMoney;
extern NSString * const JREventWalletUpgrade;
extern NSString * const JREventRechargeScreenLoaded;
extern NSString * const JREventMobileNumberFieldFocusOut;
extern NSString * const JREventOperatorPopulated;
extern NSString * const JREventDifferentOperatorSelected;
extern NSString * const JREventAmountFieldFocusOut;
extern NSString * const JREventFastForwardClicked;
extern NSString * const JREventProceedToRechargeClicked;
extern NSString * const JREventOperatorDownDialogBoxOpen;
extern NSString * const JREventClickOnProceed;
extern NSString * const JREventClickOnLater;

extern NSString * const JREventLoginScreenLoaded;
extern NSString * const JREventEmailOrNumberFieldFocusOut;
extern NSString * const JREventPasswordFieldFocusOut;
extern NSString * const JREventForgotPasswordClicked;
extern NSString * const JREventInvalidLoginCredentialsError;
extern NSString * const JREventClickOnSecureLogin;
extern NSString * const JREventSignInWithFacebook;
extern NSString * const JREventSignInWithGooglePlus;
extern NSString * const JREventLoginSuccessful;

extern NSString * const JREventSummaryScreenLoadedRecharge;
extern NSString * const JREventSummaryScreenLoadedMarketplace;
extern NSString * const JREventSummaryScreenLoadedWallet;
extern NSString * const JREventSummaryScreenLoadedBus;
extern NSString * const JREventSummaryScreenLoadedHotel;
extern NSString * const JREventSummaryScreenLoadedRechargeMobile;
extern NSString * const JREventSummaryScreenOrderSuccessfullRechargeMobile;
extern NSString * const JREventSummaryScreenBusPaymentSucces;

extern NSString * const JREventCouponScreenLoaded;
extern NSString * const JREventCouponCategoryClicked;
extern NSString * const JREventCouponClicked;
extern NSString * const JREventCouponAccepted;
extern NSString * const JREventCouponDeclined;
extern NSString * const JREventPromoCodeFieldFocusOut;
extern NSString * const JREventInvalidPromoCode;
extern NSString * const JREventApplyButtonClicked;
extern NSString * const JREventProceedButtonClicked;
extern NSString * const JREventCouponRechargeMobileScreenLoaded;
extern NSString * const JREventCouponMobilePromocodeEnter;
extern NSString * const JREventCouponMobilePromocodeError;
extern NSString * const JREventCouponMobileProceedToPayClicked;


extern NSString * const JREventOrderDetailsScreenLoaded;

extern NSString * const JREventCategoryClicked;
extern NSString * const JREventSubCategoryClicked;
extern NSString * const JREventTopNavigationMenuButtonClicked;
extern NSString * const JREventCategoryScreenLoaded;
extern NSString * const JREventProductClicked;

extern NSString * const JREventProductScreenLoaded;
extern NSString * const JREventProductDescriptionSeen;
extern NSString * const JREventPinCodeFieldFocusOut;
extern NSString * const JREventCheckButtonClicked;
extern NSString * const JREventInvalidPinCodeError;
extern NSString * const JREventProductDescriptionclosed;
extern NSString * const JREventProductScreenScrolled;
extern NSString * const JREventProductPriceClicked;
extern NSString * const JREventProductAddedToCart;
extern NSString * const JREventProductScreenBackButtonClicked;
extern NSString * const JREventProductScreenShareButtonClicked;
extern NSString * const JREventProductSharedOnSocial;
extern NSString * const JREventCartButtonClickedProduct;
extern NSString * const JREventCartButtonClicked;


extern NSString * const JREventCartScreenLoaded;
extern NSString * const JREventItemQuantityChanges;
extern NSString * const JREventItemRemovedFromCart;
extern NSString * const JREventPromoCodeEntered;
extern NSString * const JREventCartInvalidPromoCode;
extern NSString * const JREventSelectDeliveryAddressButton;

extern NSString * const JREventDeliveryAddressScreenLoaded;
extern NSString * const JREventAddDeliveryAddressClicked;

extern NSString * const JREventPaymentScreenLoaded;

extern NSString * const JREventAddmoneyScreenLoaded;
extern NSString * const JREventAddDeliveryAddressScreenLoaded;
extern NSString * const JREventNameFieldFocusOut;
extern NSString * const JREventAddress1FieldFocusOut ;
extern NSString * const JREventAddress2FieldFocusOut;
extern NSString * const JREventDeliveryPinCodeFieldFocusOut;
extern NSString * const JREventCityFieldFocusOut ;
extern NSString * const JREventStateFieldFocusOut;
extern NSString * const JREventPhonbeNumberFocusOut;
extern NSString * const JREventValidationErrors;
extern NSString * const JREventDeliverToThisAddressClicked;
extern NSString * const JREventDeliveryBackButtonClicked;

extern NSString * const JREventBottomNavWalletClicked;
extern NSString * const JREventWalletAmountFieldFocusOut;
extern NSString * const JREventAddToWalletClicked;
extern NSString * const JREventWalletPromocodeFieldFocusOut;
extern NSString * const JREventWalletInvalidPromocode;
extern NSString * const JREventWalletOrderDetailScreenLoaded;
extern NSString * const JREventWalletOnScreenPassbookClicked;
extern NSString * const JREventWalletScreenLoaded;
extern NSString * const JREventWalletMobileNumberFieldClicked;
extern NSString * const JREventWalletAddMoneyPromoClicked;
extern NSString * const JREventWalletMobileNumberEntered;
extern NSString * const JREventWalletMobileOptionsClicked;
extern NSString * const JREventWalletOptionsTabClicked;
extern NSString * const JREventWalletMobileProceedClicked;
extern NSString * const JREventWalletConfirmTabName;
extern NSString * const JREventWalletInstantOtpClicked;
extern NSString * const JREventWalletPayQrScanSuccessful;
extern NSString * const JREventWalletPayFlashOptionsClicked;
extern NSString * const JREventWalletPayGalleryIconClicked;
extern NSString * const JREventWalletPayOptionsClicked;
extern NSString * const JREventWalletPayOptionsTabClicked;
extern NSString * const JREventWalletPaySendClicked;
extern NSString * const JREventWalletPaySendSuccess;

extern NSString * const JREventWalletNearbyCategoryClicked;
extern NSString * const JREventWalletNearbyTabClicked;
extern NSString * const JREventWalletNearbyNeedHelpClicked;
extern NSString * const JREventWalletNearbyCallClicked;
extern NSString * const JREventWalletNearbyMoreClicked;
extern NSString * const JREventWalletNearbyDistanceIconClicked;
extern NSString * const JREventWalletNearbyTabName;
extern NSString * const JREventWalletNearbyParameterScreenTypeValue;

extern NSString * const JREventWalletPostPaymentShareIconClicked;
extern NSString * const JREventWalletPostPaymentAddMoneyToWalletClicked;
extern NSString * const JREventWalletPostPaymentViewPassbookClicked;
extern NSString * const JREventWalletPostPaymentContactUsClicked;
extern NSString * const JREventWalletPostPaymentLogoutClicked;
extern NSString * const JREventWalletPostPaymentParameterScreenTypeValue;

extern NSString * const JREventWalletParameterScreenType;
extern NSString * const JREventWalletParameterScreenTypeValue;
extern NSString * const JREventWalletParameterPayScreenTypeValue;

extern NSString * const JREventWalletMoneyTransferTabSelected;
extern NSString * const JREventWalletMoneyTransferScreenTypeValue;
extern NSString * const JREventWalletMoneyTransferTabName;
extern NSString * const JREventWalletMoneyTransferTabNameP2P;
extern NSString * const JREventWalletMoneyTransferTabNameP2B;
extern NSString * const JREventWalletMobileNumberEnterMethod;
extern NSString * const JREventWalletEnterMethodRecentInline;
extern NSString * const JREventWalletEnterMethodPhonebook;
extern NSString * const JREventWalletEnterMethodType;
extern NSString * const JREventWalletEnterMethodRecent;
extern NSString * const JREventWalletMobileAmount;
extern NSString * const JREventWalletMobileConfirmTabName;
extern NSString * const JREventWalletMoneyTransferType;
extern NSString * const JREventWalletAccountNumberEnterMethod;
extern NSString * const JREventWalletBankAmount;
extern NSString * const JREventWalletBankIFSCCode;
extern NSString * const JREventWalletBankName;
extern NSString * const JREventWalletBankConfirmTabName;
extern NSString * const JREventWalletBankTransactionStatusProcessing;
extern NSString * const JREventWalletBankTransactionStatusSuccess;
extern NSString * const JREventWalletMobileAmountFieldClicked;
extern NSString * const JREventWalletMobileAmountFieldEntered;
extern NSString * const JREventWalletMobileConfirmClicked;
extern NSString * const JREventWalletMobileRecentClicked;
extern NSString * const JREventWalletBankAccountNumberFieldClicked;
extern NSString * const JREventWalletBankAccountNumberFieldEntered;
extern NSString * const JREventWalletBankAccountNameFieldClicked;
extern NSString * const JREventWalletBankAccountNameFieldEntered;
extern NSString * const JREventWalletBankAmountFieldClicked;
extern NSString * const JREventWalletBankAmountFieldEntered;
extern NSString * const JREventWalletBankFindIFSCClicked;
extern NSString * const JREventWalletBankFindIFSCContinueClicked;
extern NSString * const JREventWalletBankProceedClicked;
extern NSString * const JREventWalletBankConfirmClicked;
extern NSString * const JREventWalletBankTransactionStatus;


extern NSString * const JREventAddmoneyScreenLoaded;
extern NSString * const JREventSendmoneyScreenLoaded;
extern NSString * const JREventSendmoneyMobileFieldFocusOut;
extern NSString * const JREventSendmoneyAmountFieldFocusOut;
extern NSString * const JREventSendmoneyCommentFieldFocusOut;
extern NSString * const JREventSendMoneyButtonClicked;

extern NSString * const JREventSignUpScreenLoaded;
extern NSString * const JREventSignUpMobileNumberFieldFocusOut;
extern NSString * const JREventSignUpEmailFieldFocusOut;
extern NSString * const JREventSignUpPasswordFieldFocusOut;
extern NSString * const JREventSignUpConfirmationScreenLoaded;
extern NSString * const JREventSignUpChangeMobileNumberLinkClicked ;
extern NSString * const JREventSignUpOTPFieldFocusOut;
extern NSString * const JREventSignUpFirstNameFieldFocusOut;
extern NSString * const JREventSignUpLastNameFieldFocusOut;
extern NSString * const JREventSignUpGenderRadioButtonSelected;
extern NSString * const JREventSignUpDateOfBirthSelected;
extern NSString * const JREventSignUpValidationErrors;
extern NSString * const JREventSignUpConfirmButtonClicked;
extern NSString * const JREventSignUpSuccesful;



extern NSString * const JREventBusticketScreenLoaded;
extern NSString * const JREventBusFromFieldSelected;
extern NSString * const JREventBusToFieldSelected;
extern NSString * const JREventBusDateSelected;
extern NSString * const JREventBusTicketsSearchButtonClicked;

extern NSString * const JREventBusSelectionScreenLoaded;
extern NSString * const JREventBusSelectionRefineButtonClicked;;
extern NSString * const JREventBusSelectionApplyButtonClicked;


extern NSString * const JREventBusSeatSelectionScreenLoaded;
extern NSString * const JREventBusSeatSelectionProceedClicked;

extern NSString * const JREventPassengerDetailsScreenLoaded;

extern NSString * const JREventConfirmBookingScreenLoaded;
extern NSString * const JREventConfirmCancellationpolicyReviewed;
extern NSString * const JREventConfirmBoardingpointChanges;


extern NSString * const JREventSearchScreenLoaded;
extern NSString * const JREventSearchTermLoaded;
extern NSString * const JREventSearchSuggestionSelected;
extern NSString * const JREventHotSearchSelected;
extern NSString * const JREventNoSearchResultsFound;

extern NSString * const JREventSearchResultScreenLoaded;
extern NSString * const JREventSearchResultTabSelected;
extern NSString * const JREventSearchResultSortByPrice;
extern NSString * const JREventSearchResultRefineClicked;

extern NSString * const JREventSearchRefineScreenLoaded;
extern NSString * const JREventSearchFilterSelected;
extern NSString * const JREventSearchFilterCleared;
extern NSString * const JREventSearchShowButtonClicked;
extern NSString * const JREventSearchResultsClicked;

extern NSString * const JREventCartQuantityChanged;

extern NSString * const JRUpdateWalletCasNotification;

extern NSString * const JRUpdateShippingChargeViewNotification;

extern NSString * const JRUserPreferancePinCode;


extern NSString * const JRScreenNameWalletRequestMoney;
extern NSString * const JRScreenNameWalletSavedCards;
extern NSString * const JRScreenNameWalletMerchantList;
extern NSString * const JRScreenNameWalletOffers;

//profile tracking
extern NSString * const JRScreenNameAccountMainScreen;
extern NSString * const JREventAccountItemClicked;
extern NSString * const JRVariableUserAccountUserID;
extern NSString * const JRVariableAccountItemName;
extern NSString * const JRScreenNameUserAccountProfile;
extern NSString * const JREventUserProfileEditClicked;
extern NSString * const JREventUserProfileItemClicked;
extern NSString * const JRVariableUserProfileItemName;
extern NSString * const JRScreenProfileAddressSection;
extern NSString * const JREventProfileAddressEditClicked;
extern NSString * const JREventProfileAddressAddClicked;
extern NSString * const JREventProfileAddressRemoveClicked;
extern NSString * const JREventProfileAddressSuccessError ;
extern NSString * const JRVariableProfileAddressDefaultState ;
extern NSString * const JREventProfileNewAddressSavedClicked ;
extern NSString * const JRScreenNameProfileNewAddress;
extern NSString * const JRScreenNameProfileChangePassword ;
extern NSString * const JREventProfileChangePasswordSaveClicked;
extern NSString * const JRScreenNameProfileYourOrders ;
extern NSString * const JREventProfileYourOrdersTabClicked ;
extern NSString * const JRVariableProfileYourOrdersTabName ;
extern NSString * const JREventProfileYourOrdersItemClicked ;
extern NSString * const JRVariableProfileOrders_OrderID ;
extern NSString * const JRVariableProfileOrders_OrderStatus ;
extern NSString * const JRVariableProfileOrders_Vertical_Name ;
extern NSString * const JREventProfileYourOrdersRepeatRetryClicked ;
extern NSString * const JRVariableProfileOrders_Action_Name ;
extern NSString * const JREventProfileYourOrdersSearchClicked ;
extern NSString * const JRVariableProfileOrdersSearchKeyword ;
extern NSString * const JRScreenNameProfileWishList ;
extern NSString * const JREventProfileWishListItemClicked ;
extern NSString * const JRVariableProfileWishListProdName ;
extern NSString * const JRVariableProfileWishListItemPosition ;
extern NSString * const JREventProfileWishListOffersClicked;
extern NSString * const JREventProfileWishListItemRemoved ;
extern NSString * const JREventProfileWishListItemAddtoBag ;
extern NSString * const JREventProfileWishListItemShared ;
extern NSString * const JREventProfileWishListOfferApplied;
extern NSString * const JRVariableProfileWishListPromoCode;
extern NSString * const JRWishListDisplayName;
extern NSString * const PDP_SAVE_FOR_LATER_CLICKED;
extern NSString * const GRID_SAVE_FOR_LATER_CLICKED;
extern NSString * const GRID_ADD_TO_CART_CLICKED;

extern NSString * const JREventNotificationSettingClicked;
extern NSString * const JREventNotificationChanged;

//Favourites in Profile
extern NSString * const JRScreenNameProfileFavourites ;
extern NSString * const JREventProfileFavouritesSetNowClicked;
extern NSString * const JREventProfileFavouritesRemoved ;
extern NSString * const JRVariableProfileFavouritesItemName ;
extern NSString * const JRVariableProfileFavouriteItemPosition ;
extern NSString * const JREventProfileFavouritesEdited ;

//Help & FAQ section
extern NSString * const JRScreenNameProfileFAQ ;
extern NSString * const JREventProfileFAQClicked ;
extern NSString * const JRVariableProfileFAQLevel ;
extern NSString * const JRVariableProfileFAQCategory ;

//Choose Language Section
extern NSString * const JRScreenNameProfileLanguage ;
extern NSString * const JREventProfileLanguageSelected ;
extern NSString * const JRVariableProfileAccountLanguage ;

//Contact US Section
extern NSString * const JRScreenNameProfileContactUs ;
extern NSString * const JREventProfileContactCategoryClicked ;
extern NSString * const JRVariableProfileContactCategory ;
extern NSString * const JRVariableProfileContactQueryPosition ;
extern NSString * const JREventProfileContactQueryOrderSelected ;
extern NSString * const JREventProfileContactQuerySubmitted ;


//payment status tracking for Order Summary Page
extern NSString * const JRScreenNameOrderSummaryPage;
extern NSString * const JREventPayOrderSummaryTransactionStatus;
extern NSString * const JREventPayOrderSummaryOrderStatus;
extern NSString * const JRVariablePayTransactionPaymentStatus;
extern NSString * const JRVariablePayPaymentStatusID;
extern NSString * const JRVariablePayTransactionID;
extern NSString * const JRVariablePayPaymentType;
extern NSString * const JRVariablePayTransactionOrderStatus;

extern NSString * const JRRefreshOrderSummaryNotification;
extern NSString * const JRHandleOrderSummaryRedirectionNotification;
extern NSString * const JRHandlePGPageRedirectionNotification;
extern NSString * const JRLoadParentOrderIdNotification;

//In Mobi Events
extern NSString * const JRGNAAppUrlType;

extern NSString * const JRGNAListAppName;
extern NSString * const JRGNAListAppPosition;

extern NSString * const JRGNAAppName;
extern NSString * const JRGNAAppPosition;

extern NSString * const JRSearchUserID;

extern NSString * const JRTrackingCategoryID;
extern NSString * const JRTrackingCategoryName;
extern NSString * const JRTrackingProductID;
extern NSString * const JRTrackingProductName;
extern NSString * const JRTrackingAmount;
extern NSString * const JRTrackingOrderID;
extern NSString * const JRTrackingTotalCartAmount;
extern NSString * const JRTrackingSearch_String;
extern NSString * const JRTrackingCategory_L1;
extern NSString * const JRTrackingCategory_L2;
extern NSString * const JRTrackingCategory_L3;
extern NSString * const JRTrackingMerchantId;



extern NSString * const JRTrackingCategoryViewEvent;
extern NSString * const JRTrackingSubCategoryViewEvent;
extern NSString * const JRTrackingProductViewEvent;
extern NSString * const JRTrackingAddToCartEvent;
extern NSString * const JRTrackingApplyPromoEvent;
extern NSString * const JRTrackingRemoveFromCartEvent;
extern NSString * const JRTrackingFavouriteEvent;
extern NSString * const JRTrackingShareEvent;
extern NSString * const JRTrackingSearchEvent;
extern NSString * const JRTrackingInitiatedCheckoutEvent;
extern NSString * const JRTrackingThankYouRechargeEvent;
extern NSString * const JRTrackingThankYouMarketplaceEvent;
extern NSString * const JRTrackingThankYouAppsflyerEvent;


extern NSString * const JRHotelHomePageloaded;
extern NSString * const JRHotelSearchClicked;
extern NSString * const JRhotelResultClicked;
extern NSString * const JRHotelRefineClicked;
extern NSString * const JRHotelRefineApplied;
extern NSString * const JRHotelSelectRoomClicked;
extern NSString * const JRhotelMapClicked;
extern NSString * const JRHotelImageClicked;
extern NSString * const JRhotelRoomOptionClicked;
extern NSString * const JRHotelAppliedPromocode;
extern NSString * const JRHotelProceedToPayCliked;
extern NSString * const JRhotelOrderSummarySuccess;

//Recharge
extern NSString * const GTM_KEY_MOBILE_SUB_VERTICAL;
extern NSString * const GTM_EVENT_MOBILE_POSTPAID_SELECTED;
extern NSString * const GTM_EVENT_MOBILE_PREPAID_SELECTED;
extern NSString * const GTM_EVENT_MOBILE_AMOUNT_CLICK ;
extern NSString * const GTM_EVENT_MOBILE_AMOUNT_ENTERED ;
extern NSString * const GTM_KEY_RECHARGE_MOBILE_AMOUNT ;
extern NSString * const GTM_KEY_RECHARGE_MOBILE_RECENTSEARCHES_TOP_SELECTED;
extern NSString * const GTM_KEY_RECHARGE_MOBILE_RECENTSEARCHES_BOTTOM_SELECTED;
extern NSString * const GTM_EVENT_RECHRGE_FASTFRWD_CLICKED;
extern NSString * const GTM_KEY_MOBILE_OPERATOR_NAME;
extern NSString * const GTM_KEY_MOBILE_CIRCLE_NAME;
extern NSString * const GTM_KEY_RECHARGE_MOBILE_NUM;
extern NSString * const GTM_EVENT_RECHARGE_BROSEPLANS_CLICKED;
extern NSString * const GTM_EVENT_RECHARGE_BROSEPLANS_SELECTED;
extern NSString * const GTM_KEY_RECHARGE_BROSEPLANS_CATEGORY;
extern NSString * const GTM_EVENT_MOBILE_PROCEED_CLICKED;
extern NSString * const GTM_KEY_MOBILE_PROMO_CODE;
extern NSString * const GTM_KEY_HELPVIDEO_CAPTION;

//Recharge event
extern NSString * const GTM_EVENT_MOBILE_MOBILE_FIELD_CLICKED;
extern NSString * const GTM_EVENT_MOBILE_OPERATOR_CLICKED;
extern NSString * const GTM_EVENT_MOBILE_CONTACT_LIST_CLICKED;
extern NSString * const GTM_EVENT_MOBILE_OPERATOR_SELECTED;
extern NSString * const GTM_EVENT_MOBILE_CIRCLE_CLICKED;
extern NSString * const GTM_EVENT_MOBILE_CIRCLE_SELECTED;
extern NSString * const GTM_EVENT_MOBILE_RECENTS_TAB_CLICKED;
extern NSString * const GTM_EVENT_MOBILE_OFFERS_TAB_CLICKED ;
extern NSString * const GTM_EVENT_MOBILE_OFFERS_LISTITEM_CLICKED ;

//Adword
extern NSString * const JRVariablegdr_chkout_amount;
extern NSString * const GTM_KEY_NAV_SEARCH_TYPE;
extern NSString * const GTM_KEY_NAV_SEARCH_TERM;
extern NSString * const GTM_KEY_NAV_SEARCH_CATEGORY;
extern NSString * const GTM_KEY_NAV_SEARCH_RESULT_TYPE;

extern NSString * const GTM_KEY_Customer_ID;
extern NSString * const GTM_EVENT_GDR_SCREEN_LOADED_SEARCH_RESULTS;
extern NSString * const GTM_EVENT_CATEGORY_GDR_SCREEN_LOADED_CATEGORY;
extern NSString * const GTM_EVENT_GDR_PRODUCT_LOADED;
extern NSString * const GTM_EVENT_CART_GDR_SCREEN_LOADED_CART;
extern NSString * const GTM_EVENT_GDR_MARKET_PLACE_SUMMARY;

extern NSString * const GTM_EVENT_CUSTOM;
extern NSString * const GTM_VERTICAL_NAME_KEY;
extern NSString * const GTM_VERTICAL_MARKETPLACE;
extern NSString * const GTM_VERTICAL_OAUTH;
extern NSString * const GTM_SCREEN_NAME_KEY;
extern NSString * const GTM_EVENT_ACTION_KEY;
extern NSString * const GTM_EVENT_CATEGORY_KEY;
extern NSString * const GTM_EVENT_LABEL_KEY;
extern NSString * const GTM_EVENT_LABEL2_KEY;
extern NSString * const GTM_EVENT_LABEL3_KEY;
extern NSString * const GTM_USER_ID;
extern NSString * const GTM_VERTICAL_WALLET;
extern NSString * const GTM_CATEGORY_MONEY_TRANSFER;

extern NSString * const GTM_KEY_GDR_REFERRER;
extern NSString * const GTM_KEY_GDR_CHKOUT_AMOUNT;
extern NSString * const GTM_KEY_GDR_PRODUCT_NAME ;
extern NSString * const GTM_KEY_GDR_PRODUCT_ID ;
extern NSString * const GTM_KEY_GDR_PRODUCT_CATEGORY_NAME;
extern NSString * const GTM_KEY_GDR_PRODUCT_CATEGORY_ID ;
extern NSString * const GTM_KEY_GDR_TOTAL_VALUE;
extern NSString * const GTM_KEY_LIST_NAME;
extern NSString * const GTM_KEY_LIST_POSITION;
extern NSString * const GTM_KEY_SEARCH_TYPE;
extern NSString * const GTM_KEY_SEARCH_CATEGORY;
extern NSString * const GTM_KEY_SEARCH_AB_VALUE;
extern NSString * const GTM_KEY_SEARCH_TERM;
extern NSString * const GTM_KEY_SEARCH_RESULT_TYPE;
extern NSString * const GTM_KEY_GDR_USER_ID;
extern NSString * const GTM_KEY_DESTINATION_URL;

extern NSString * const GTM_KEY_SEARCH_INPUT_TYPE;
extern NSString * const GTM_KEY_SEARCH_OUTPUT_TYPE;
extern NSString * const GTM_KEY_SEARCH_AUTOSUGGEST_DATA;

extern NSString * const GTM_EVENT_CART_PAGE_LOADED;
extern NSString * const GTM_KEY_CART_FNL_GA_KEY;
extern NSString * const GTM_KEY_CART_FNL_VERTICAL;
extern NSString * const GTM_EVENT_CART_CHECKOUT_PROCEED_CLICK;
extern NSString * const GTM_EVENT_CART_POPUP_PROMO_SELECTED_CLICKED;
extern NSString * const GTM_EVENT_CART_POPUP_CONTINUE_ANYWAYS_CLICKED;
extern NSString * const GTM_EVENT_ORDER_SUMMARY_LOADED;
extern NSString * const GTM_EVENT_NAV_PUSH_NOTIFICATION_CLICKED;
extern NSString * const GTM_EVENT_NAV_PUSH_NOTIFICATION_RECIEVED;
extern NSString * const GTM_EVENT_CATALOG_TOP_NAVIGATION_CLICKED;
extern NSString * const GTM_EVENT_PDP_TOP_NAVIGATION_CLICKED;
extern NSString * const GTM_EVENT_PDP_NAVIGATION_SELLER_LINK_CLICKED;
extern NSString * const GTM_EVENT_PDP_NAVIGATION_BRAND_CLICKED;
extern NSString * const GTM_EVENT_SEARCH_NO_RESULTS_DISPLAYED;
extern NSString * const GTM_EVENT_SEARCH_DID_YOU_MEAN_TERM_CLICKED;
extern NSString * const GTM_EVENT_NAV_RICH_PUSH_NOTIFICATION_CLICKED;
extern NSString * const GTM_EVENT_NAV_RICH_PUSH_NOTIFICATION_VIEWED;
extern NSString * const GTM_EVENT_MALL_TOP_NAV_CLICKED;
extern NSString * const GTM_EVENT_CART_TOP_BAR_CLIKED;
extern NSString * const GTM_EVENT_WL_SCREEN_LOADED;
extern NSString * const GTM_CART_TOP_BAR_BTN_TYPE;

extern NSString * const GTM_EVENT_MOVIE_HOME_SCREEN_LOADED;
extern NSString * const GTM_KEY_MOVIE_SEARCH_TYPE_SELECTED;
extern NSString * const GTM_KEY_MOVIE_SEARCH_PERFORMED;
extern NSString * const GTM_EVENT_MOVIE_GRID_ITEM_CLICKED;
extern NSString * const GTM_EVENT_MOVIE_GRID_ITEM_VIEWED;
extern NSString * const GTM_EVENT_MOVIE_LISTING_SCREEN_LOADED;
extern NSString * const GTM_EVENT_MOVIE_LISTING_SCREEN_TIMINGS_CLICKED;
extern NSString * const GTM_EVENT_MOVIE_SEAT_SCREEN_LOADED;
extern NSString * const GTM_EVENT_MOVIE_SEAT_PROMO_CLICKED;
extern NSString * const GTM_EVENT_MOVIE_SEAT_PROMO_APPLIED;
extern NSString * const GTM_EVENT_MOVIE_SEAT_PROCCED_CLICKED;
extern NSString * const GTM_EVENT_MOVIE_ORDER_SCREEN_LOADED;
extern NSString * const GTM_EVENT_MOVIE_ORDER_PAYMENT_STATUS;
extern NSString * const GTM_KEY_MOVIE;
extern NSString * const GTM_KEY_CINEMA;
extern NSString * const GTM_KEY_MOVIE_CITY_NAME;
extern NSString * const GTM_KEY_MOVIE_USER_ID;
extern NSString * const GTM_KEY_MOVIE_SEARCH_TYPE;
extern NSString * const GTM_KEY_MOVIE_LISTING_TYPE;

//Brand Store
extern NSString * const GTM_KEY_Brandstore_Site_Id;
extern NSString * const GTM_KEY_Brandstore_View_Identifier;
extern NSString * const GTM_KEY_Brandstore_Tab_Name;
extern NSString * const GTM_KEY_Brandstore_Item_Identifier;

// --------------------- New Recharge/Utility Events

extern NSString * const GTM_KEY_UTILITY_SUB_VERTICAL;
extern NSString * const GTM_KEY_UTILITY_SERVICE_TYPE;
extern NSString * const GTM_KEY_UTILITY_GROUP_FIELD_PLACEHOLDER;
extern NSString * const GTM_KEY_UTILITY_GROUP_FIELD_VALUE;
extern NSString * const GTM_KEY_UTILITY_INPUT_FIELD_PLACEHOLDER;
extern NSString * const GTM_KEY_UTILITY_INPUT_FIELD_VALUE;
extern NSString * const GTM_KEY_UTILITY_OFFER_PROMOCODE;
extern NSString * const GTM_KEY_UTILITY_PROCEED_FETCH_ERROR_MESSAGE;
extern NSString * const GTM_KEY_UTILITY_AMOUNT;
extern NSString * const GTM_KEY_UTILITY_PROCEED_ERROR_MESSAGE;
extern NSString * const GTM_KEY_UTILITY_APPLY_PROMO_ERROR_MESSAGE;

extern NSString * const GTM_KEY_UTILITY_FF_STATE;
extern NSString * const GTM_VALUE_UTILITY_FF_STATE_CHECKED;
extern NSString * const GTM_VALUE_UTILITY_FF_STATE_UNCHECKED;

extern NSString * const GTM_KEY_UTILITY_GROUP_FIELD_VALUES;
extern NSString * const GTM_KEY_UTILITY_INPUT_FIELD_VALUES;

extern NSString * const GTM_KEY_UTILITY_BOTTOM_TAB_NAME;

extern NSString * const GTM_KEY_UTILITY_ORDER_ID;
extern NSString * const GTM_KEY_UTILITY_ORDER_PAYMENT_STATUS;
extern NSString * const GTM_KEY_UTILITY_PG_RESPONSE_CODE;
extern NSString * const GTM_KEY_UTILITY_ITEM_STATUS_CODE;

extern NSString * const GTM_KEY_UTILITY_AMOUNT_TYPE;
extern NSString * const GTM_VALUE_UTILITY_AMOUNT_TYPE_PREFETCH_EDITABLE;
extern NSString * const GTM_VALUE_UTILITY_AMOUNT_TYPE_NON_PREFETCH;
extern NSString * const GTM_VALUE_UTILITY_AMOUNT_TYPE_PREFETCH_NON_EDITABLE;

extern NSString * const GTM_KEY_UTILITY_GROUP_FIELD_SELECTION_TYPE;
extern NSString * const GTM_VALUE_UTILITY_GROUP_FIELD_SELECTION_TYPE_AUTOMATIC;
extern NSString * const GTM_VALUE_UTILITY_GROUP_FIELD_SELECTION_TYPE_MANUAL;

extern NSString * const GTM_KEY_UTILITY_ERROR_MESSAGE_TYPE;
extern NSString * const GTM_VALUE_UTILITY_ERROR_MESSAGE_TYPE_OPERATOR;
extern NSString * const GTM_VALUE_UTILITY_ERROR_MESSAGE_TYPE_GENERAL;

extern NSString * const GTM_KEY_UTILITY_ERROR_DISPLAY_TYPE;
extern NSString * const GTM_VALUE_UTILITY_ERROR_DISPLAY_TYPE_POPUP;
extern NSString * const GTM_VALUE_UTILITY_ERROR_DISPLAY_TYPE_NONPOPUP;

// Events
extern NSString * const GTM_EVENT_UTILITY_HOME_SCREEN_LOADED;
extern NSString * const GTM_EVENT_UTILITY_SERVICE_TYPE_SELECTED;
extern NSString * const GTM_EVENT_UTILITY_GROUP_FIELD_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_GROUP_FIELD_SELECTED;
extern NSString * const GTM_EVENT_UTILITY_INPUT_FIELD_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_INPUT_FIELD_ENTERED;
extern NSString * const GTM_EVENT_UTILITY_PROCEED_FETCH_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_PROCEED_FETCH_ERROR;

extern NSString * const GTM_EVENT_UTILITY_AMOUNT_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_AMOUNT_ENTERED;
extern NSString * const GTM_EVENT_UTILITY_RECENT_SELECTED_INLINE;
extern NSString * const GTM_EVENT_UTILITY_BOTTOM_TAB_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_RECENT_SELECTED_BOTTOM_TAB;
extern NSString * const GTM_EVENT_UTILITY_OFFER_CLICKED_BOTTOM_TAB;
extern NSString * const GTM_EVENT_UTILITY_HELP_CLICKED_BOTTOM_TAB;
extern NSString * const GTM_EVENT_UTILITY_FASTFORWARD_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_PROCEED_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_PROCEED_ERROR;

extern NSString * const GTM_EVENT_UTILITY_COUPON_PAGE_LOADED;
extern NSString * const GTM_EVENT_UTILITY_COUPON_PROMO_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_COUPON_PROMO_ENTERED;
extern NSString * const GTM_EVENT_UTILITY_COUPON_PROMO_ERROR;
extern NSString * const GTM_EVENT_UTILITY_COUPON_PROCEEDTOPAY_CLICKED;

extern NSString * const GTM_EVENT_UTILITY_SUMMARY_PAGE_LOADED;
extern NSString * const GTM_EVENT_UTILITY_SUMMARY_ORDER_SUCCESSFUL;

extern NSString * const GTM_EVENT_UTILITY_VIEW_SAMPLE_BILL_CLICKED;
extern NSString * const GTM_EVENT_UTILITY_MESSAGE_DISPLAYED;

//NearBy
extern NSString * const JRScreenNameNEARBY;

// Screens
extern NSString * const GTM_SCREEN_UTILITY;
extern NSString * const GTM_SCREEN_COUPON;
extern NSString * const GTM_TRACKING_INFO_KEY;

//Item Detail Screen
extern NSString * const JRScreenNameItemDetail;
extern NSString * const JREventItemDetailScreenLoaded;

extern NSString * const JRVariableItemState;
extern NSString * const JRVariableItemVerticalLabel;
extern NSString * const JRVariableItemID;
extern NSString * const JRVariableOrderID;

extern NSString * const JREventItemDetailViewTrackingDetailsClicked;
extern NSString * const JREventItemDetailContactCourierClicked;
extern NSString * const JREventItemDetailViewRefundPolicyClicked;
extern NSString * const JREventItemDetailExtendTimeClicked;
extern NSString * const JREventItemDetailCancelOrderClicked;
extern NSString * const JREventItemDetailReturnOrReplaceClicked;
extern NSString * const JREventItemDetailEscalateToPaytmClicked;
extern NSString * const JREventItemDetailDownloadInvoiceClicked;
extern NSString * const JREventItemDetailViewOrderDetailsClicked;
extern NSString * const JREventItemDetailViewReplacementOrderClicked;

//Order Detail Screen
extern NSString * const JRScreenNameOrderDetail;
extern NSString * const JREventOrderDetailScreenLoaded;
extern NSString * const JRVariableOrderState;

//bottom navigation

extern NSString * const JREventBottomNavIconClicked;
extern NSString * const JREventBottomNavHome ;
extern NSString * const JREventBottomNavMall ;
extern NSString * const JREventBottomNavProfile ;
extern NSString * const JREventBottomNavUpdates ;
extern NSString * const JREventBottomNavScan;
extern NSString * const JREventBottomNavBank;

extern NSString * const KAuthToken;

// pdp events

extern NSString * const PDP_CART_ICON_CLICKED;
extern NSString * const PDP_BRAND_CLICKED;
extern NSString * const PDP_QUANTITY_CHANGED;
extern NSString * const PDP_VIEW_SIZE_CHART_CLICKED;
extern NSString * const PDP_SIZE_SELECTED;
extern NSString * const PDP_OFFER_ACTION_PERFORMED;
extern NSString * const PDP_OFFER_VIEW_MORE_CLICKED;
extern NSString * const PDP_OFFER_SELECTED_FROM_VIEWMORE;
extern NSString * const PDP_PINCODE_CLICKED;
extern NSString * const PDP_PINCODE_CHANGED;
extern NSString * const PDP_OTHER_SELLERS_EXPANDED;
extern NSString * const PDP_OTHER_SELLER_ACTIONS_PERFORMED;
extern NSString * const PDP_OTHER_SELLER_SELECTED;
extern NSString * const PDP_INFO_TAB_CLICKED;
extern NSString * const PDP_CALL_TO_ACTION_CLICKED;
extern NSString * const PDP_RELATED_PRODUCT_CLICKED;
extern NSString * const PDP_MORE_PRODUCTS_BY_CLICKED;
extern NSString * const PRODUCT_PUSH_CATEGORY;

//EMI Events
extern NSString * const ZERO_COST_EMI_CLICKED;
extern NSString * const ZERO_COST_EMI_SELECTED;
extern NSString * const ZERO_COST_EMI_CALL_TO_ACTION_CLICKED;
extern NSString * const JRScreenNameZeroEmiReviewScreen;
extern NSString * const ZERO_COST_EMI_PROCEED_TO_PAY_CLICKED;
extern NSString * const REVIEW_SCREEN_LOADED;
extern NSString * const CANCEL_PAYMENT_CONFIRMATION;

// Exchange Events
extern NSString * const EXCHANGE_OFFER_CLICKED;
extern NSString * const EXCHANGE_OFFER_CLOSE_CLICKED;
extern NSString * const EXCHANGE_CHANGE_CLICKED;
extern NSString * const EXCHANGE_HOW_IT_WORKS_CLICKED;
extern NSString * const EXCHANGE_DONE_CLICKED;
extern NSString * const EXCHANGE_PRODUCT_REMOVED;
extern NSString * const PROCEED_TO_LOGIN_CART;
//Passbook Navigation
typedef NS_ENUM(NSInteger, JRPassbookEntryModule) {
    JRPassbookEntryModuleContactUs = 1,
    JRPassbookEntryModuleDefault
};

typedef NS_ENUM(NSInteger, JRPassbookOrdersFilterType) {
    JRPassbookOrdersFilterTypeEAll = 0,
    JRPassbookOrdersFilterTypeEPaid = 1,
    JRPassbookOrdersFilterTypeERecieved = 2,
    JRPassbookOrdersFilterTypeEAdded = 3,
    JRPassbookOrdersFilterTypeEOnHold = 4,
    JRPassbookOrdersFilterTypeESearch = 5,
    JRPassbookOrdersFilterTypeEOthers = 6,
};

//Payments Bank
extern NSString * const JRScreenNamePBankProceedScreen;
extern NSString * const JRScreenNamePBankTnCScreen;
extern NSString * const JRScreenNamePBankKYCCongratulationScreen;

extern NSString * const JREventPBankOpenAccountClicked;
extern NSString * const JREventPBankProceedClicked;
extern NSString * const JREventPBankTnCClicked;
extern NSString * const JREventPBankSetPasscodeClicked;
extern NSString * const JREventPBankConfirmPasscodeClicked;
extern NSString * const JREventPBankAddNomineeProceedClicked;
extern NSString * const JREventPBankAddNomineeDetailsProceedClicked;
extern NSString * const JREventPBankRequestAppointmentProceedClicked;
extern NSString * const JREventPBankOpenAccountDoneClicked;

extern NSString * const JREventPBankSavingAccountOpenSource;
extern NSString * const JREventPBankSavingAccountProceedScreen;
extern NSString * const JREventPBankSavingAccountNomineeSelectedTabName;
extern NSString * const kNewFeatureSeenUserDefaultKey;
extern NSString * const kHideNewFeatureArrowNotificationKey;



// ---------------------

extern NSString * const JRPromotionalUATag;

extern NSString * const JRModuleID;

//Deeplink query string
extern NSString * const JRDeeplinkFeatureType;
extern int  const JRDealsVerticalId;
extern int  const JRGiftCardsVerticalId;
extern NSString*  const JRGiftCardCatId;

// ---------------------

extern NSString* const JRScreenNameMoneyTransfer;


//MMID Client id and Client secret
extern NSString *  const MMIDClientId;
extern NSString *  const MMIDClientSecret;
extern NSString *  const MMIRestAPIKey;
extern NSString *  const MMIMapAPIKey;
