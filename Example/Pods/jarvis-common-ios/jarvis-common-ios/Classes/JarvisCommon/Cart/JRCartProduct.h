//
//  JRCartProduct.h
//  Jarvis
//
//  Created by Shwetha Mugeraya on 05/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum : NSUInteger{
    IMEIStateScan = 0, IMEIStateVerify, IMEIStateVerified
} IMEIState;

@class JRSellerRating, JRCartServiceModel, JRSDDNDD, JRError, ExchangeQuoteModel, JRPDPValidationDetails, JRCartReturnPolicyModel;

@interface JRPaymentModeConvenienceFee : NSObject <NSCopying>
@property (nonatomic, copy) NSString* modeName;
@property (nonatomic, assign) double fee;

- (NSString*) displayModeName;
- (NSString*) serverExpectingModeName;
- (BOOL)isPaytmWalletMode;

@end

@interface JRCartProduct : NSObject

@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *totalPrice;
@property (nonatomic, strong) NSNumber *shippingCost;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *discountedPrice;
@property (nonatomic, strong) NSNumber *mrpPrice;

@property (nonatomic, strong) NSNumber *availableQuatity;
@property (nonatomic, copy) NSString *productConfigName;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *promocode;
@property (nonatomic, copy) NSString *itemPromotext;
@property (nonatomic, copy) NSNumber *merchant_id;
@property (nonatomic, copy) NSNumber *vertical_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *promotext;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, copy) NSString *offerText;
@property (nonatomic, copy) NSString *promostatus;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *errorTitle;
@property (nonatomic, copy) NSString *shippingCharge;
@property (nonatomic, copy) NSString *productVerticalLabel;
@property (nonatomic, assign) BOOL needshipping;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSArray *categoryMap;
@property (nonatomic, strong) JRSellerRating *sellerRating;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *paytmCashback;
@property (nonatomic, copy) NSString *cashbackAmount;
@property (nonatomic, copy) NSString *deleveryInfo;
@property (nonatomic, copy) NSString *deliveryRangeInfoString;
@property (nonatomic, copy) NSString *deliveryText;
@property (nonatomic, strong) NSArray *serviceOption;
@property (nonatomic, strong) NSDictionary *productAttributes;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSArray *producTags;
@property (nonatomic, copy) NSString *convinienceFee;
@property (nonatomic, strong) NSArray *taxes;
@property (nonatomic, assign) CGFloat totalTax;
@property (nonatomic, assign) BOOL isOTPFlow;
@property (nonatomic, strong) NSString *userOTPNumber;
@property (nonatomic, strong) NSDictionary *configuration;
@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, copy) NSString *offerUrl;

@property (nonatomic, strong) JRCartServiceModel *serviceOptions;
@property (nonatomic, strong) JRError *cartProductImportantInfo;
@property (nonatomic, strong) NSArray* serviceOptionUpdatedValues;

@property (nonatomic, strong) NSDictionary *recievedServiceOptions;
@property (nonatomic, strong) NSDictionary *productAttibuteNames;
@property (nonatomic, assign) NSUInteger productType;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, assign) BOOL inStock;
@property (nonatomic, strong) JRSDDNDD *sddndd;

@property (nonatomic, copy) NSString *gaKey;
@property (nonatomic, strong) NSArray *category_ids;
@property (nonatomic, strong) NSString *category_Name;
@property (nonatomic, strong) NSDictionary *trackingInfo;
@property (nonatomic, strong) NSString *parentID;
@property (nonatomic, copy) NSString *errorCode;
@property (nonatomic, copy) NSString *errorStr;

@property (nonatomic, assign) BOOL moreSellers;
@property (nonatomic, strong) NSArray *moreSellersList;
@property (nonatomic, assign) BOOL showSellerHeader;
@property (nonatomic, assign) BOOL isLastCellForMerchantID;
@property (nonatomic, assign) BOOL isInstallable;
@property (nonatomic, assign) BOOL nonReturnableItem;
@property (nonatomic, strong) NSString *installation_url;

@property (nonatomic, strong) NSMutableArray *priceBreakUpArray;
@property (nonatomic, strong) NSNumber *aggregate_item_price;

@property (nonatomic, copy) NSString *returnPolicyText;
@property (nonatomic, copy) NSString *returnPolicyLabel;
@property (nonatomic, copy) NSString *returnPolicySummary;

@property (nonatomic, copy) NSString *warehouseAddressCity;
@property (nonatomic, copy) NSString *warehouseAddressState;

@property (nonatomic, strong) JRCartReturnPolicyModel *returnPolicyModel;
@property (nonatomic, copy) NSString *paytypeLabel;

//Exchange flow
@property (nonatomic, strong) ExchangeQuoteModel *exchangeModel;
@property (nonatomic, assign) BOOL isExchangeAvailable;

//IMEI flow
@property (nonatomic, assign) BOOL isIMEIAvailable;
@property (nonatomic, assign) IMEIState imeiCellState;
@property (nonatomic, strong) JRPDPValidationDetails *imeiDetailObj;

// Convenience Fee List
@property (nonatomic, strong) NSArray<JRPaymentModeConvenienceFee*>* convenienceFeeList;

// EMI Subvention
@property (nonatomic, strong) NSDictionary *emiOffersDict;

//Promo SDK
@property (nonatomic, strong) NSString *skuType;
@property (nonatomic, strong) NSArray *promoSkuParentPids;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)setWithDictionary:(NSDictionary *)dictionary;

- (BOOL)hasValidPromoCode;
- (BOOL)isCategoryMapContainsIdForCarOrBike;
- (NSString*)getColorSizeAttribtes;
-(NSInteger) getDisplayShippingCharge;
- (NSString*) getCartItemDetailsForGA;

- (NSString*) discountPercentage;
@end
