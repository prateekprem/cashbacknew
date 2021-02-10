//
//  JRGridDetail.h
//  Jarvis
//
//  Created by Shwetha Mugeraya on 11/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JRError;
@class JRProductPromoDetail;

@interface JRGridDetail : NSObject

@property (nonatomic, strong) NSDictionary* rawGridDetail;

@property (nonatomic, strong) NSNumber *offerPrice;
@property (nonatomic, strong) NSNumber *actualPrice;
@property (nonatomic, copy) NSString *promoText;
@property (nonatomic, copy) NSString *planId;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *variantSelectionAPI;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL inStock;
@property (nonatomic, assign) BOOL dynamicBrowsePlan;
@property (assign, nonatomic) BOOL showAddToCart;
@property (assign, nonatomic) BOOL cashbackType;
@property (assign, nonatomic) int minQuantity;
@property (assign, nonatomic) int maxQuantity;
@property (assign, nonatomic) BOOL isAddedToWishList;
@property (assign, nonatomic) BOOL isFreeDealButtonTick;

//used for prepaid and postpaid recharges
@property (nonatomic, strong) NSArray *relatedCategories;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *shortDescription;
@property (nonatomic, copy) NSArray *fullDescriptionArray;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *itemID;
@property (nonatomic, strong) NSString *changedProductID; //After Quanity Change
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *verticalLabel;

@property (nonatomic, assign)CGSize imageSize;

////This property is used to animate grid cell only once.
//@property (nonatomic, assign) BOOL isAnimated;

// used in coupons to show popup.
@property (nonatomic, assign) BOOL shippable;
@property (nonatomic, assign) BOOL isItemTracked;
@property (nonatomic, assign) NSInteger positionInList;
@property (nonatomic, strong) NSString *parentId;

@property (nonatomic, copy) NSString *containerInstanceID;
@property (nonatomic, assign) double ListID;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) NSDictionary* attributes;
@property (nonatomic, assign) float locationScore;
@property (nonatomic, assign) int cartQuantity;
@property (nonatomic, assign) int oldQuantity;
@property (nonatomic, assign) BOOL gridCartError;
@property (nonatomic, copy) NSString *offerUrl;
@property (nonatomic, strong) JRProductPromoDetail *appliedPromoCode;
@property (nonatomic, assign) int totalOffers;
@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, copy) NSString *paytypeLabel;

//Ae redirection message
//"message": {
//    "title": "Redirecting...",
//    "okbutton": "Proceed",
//    "cancelButton": "Cancel",
//    "message": "You will now be redirected to our partner site of AliExpress."
//}
@property (nonatomic, strong) JRError *redirectionAlertMessage;

// For UI Purpose
@property (nonatomic, assign) BOOL selected;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)setWithDictionary:(NSDictionary *)dictionary;

- (BOOL) isOfSpecialRechargeType;


@end
