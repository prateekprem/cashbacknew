//
//  JRShoppingCart.h
//  Jarvis
//
//  Created by Shwetha Mugeraya on 05/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import "JRAddress.h"

@class JRStatus;
@class JRCart;
@class JRGSTModel;
@class JRConvFeesPaymentInfo;
@class EmiSubPlansModel;
@class EmiSubTenureModel;

@interface JRShoppingCart : NSObject

@property (nonatomic, strong) JRStatus *status;
@property (nonatomic, strong) NSNumber *orderTotal;
@property (nonatomic, strong) NSNumber *shippingCharges;
@property (nonatomic, strong) NSNumber *finalPrice;
@property (nonatomic, strong) NSNumber *grandtotalExcludingConvfee;
@property (nonatomic, strong) NSNumber *aggregatePgConvFee;
@property (nonatomic, strong) NSNumber *effectivePrice; 
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *finalPriceExpecptShipping;
@property (nonatomic, strong) NSNumber *paytmCashback;
@property (nonatomic, copy) NSString *errorTitle;

@property (nonatomic, copy) NSString *placeOrderUrl;
@property (nonatomic, copy) NSString *paytmPromocode;
@property (nonatomic, strong) NSArray *cartItems;
@property (nonatomic, strong) NSArray *addresses;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, assign) BOOL needShipping;
@property (nonatomic, copy) NSString *promotext;
@property (nonatomic, copy) NSString *promostatus;
@property (nonatomic, copy) NSString *promocode;
@property (nonatomic, copy) NSDictionary *promoMetaData;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *errorCode;
@property (nonatomic, copy) NSString *error_info;
@property (nonatomic, copy) NSString *cashback_text;
@property (nonatomic, copy) NSString *cashbackPriceValue; // paytm_goldback || paytm_cashback which is not 0
@property (nonatomic, assign) BOOL retrunPolicyDisplay;
@property (nonatomic, copy) NSString *categoryId; // We get this categroy id from order summary response. It will be used for fetching the offers.

//@property (nonatomic, assign) CGFloat valueAddedTax;
//@property (nonatomic, assign) CGFloat stateEntryTax;
@property (nonatomic, assign) CGFloat totalTax;
@property (nonatomic, strong) NSArray *taxes;
@property (nonatomic, strong) JRGSTModel *selectedGST;

@property (nonatomic, copy) NSString *promoFailureText;
@property (nonatomic, assign) BOOL containServiceOptions;

//new additions as per CA-2222
@property (nonatomic, strong) NSNumber *aggregate_item_price;
@property (nonatomic, strong) NSNumber *conv_fee;
@property (nonatomic, strong) NSMutableArray *priceBreakUpSet;
@property (nonatomic, copy) NSString *imageURL;

//additon of Convenience Fee and payment insutruments on Verify call (JIRA IDs: CAI-17624, CAI-17646), edited on 4th June, 2019, by @Ashutosh Lasod
@property (nonatomic, strong) NSDictionary *paymentInstruments;
@property (nonatomic, strong) JRConvFeesPaymentInfo *paymentInfo;
@property (nonatomic, assign) BOOL isConvFeeApplicable;

//new addition EMI plan
@property (nonatomic, strong) EmiSubPlansModel *emiPlan;
@property (nonatomic, strong) EmiSubTenureModel *selectedTenureModel;
@property (nonatomic, strong) NSDictionary *selectedTenureDict;// For passing from PG to Native

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)setWithDictionary:(NSDictionary *)dictionary;

- (NSInteger)numberOfCartItemWithPromoStatusAs:(BOOL)success;

- (void)getProductIDandProductNamesWithCategory:(void(^)(NSArray *productIDs, NSArray *productNames, NSArray *categoryIds,NSArray *categoryNames,NSString* price))handler ;
- (void)getProductIDandProductNames:(void(^)(NSArray *productIDs, NSArray *productNames, NSString* price))handler;

@end
