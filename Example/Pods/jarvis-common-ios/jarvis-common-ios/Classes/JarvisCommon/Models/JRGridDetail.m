//
//  JRGridDetail.m
//  Jarvis
//
//  Created by Shwetha Mugeraya on 11/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import "JRGridDetail.h"
#import "jarvis_common_ios/jarvis_common_ios-Swift.h"
#import <jarvis_utility_ios/NSObject+SafeKVC.h>

@implementation JRGridDetail

- (void)setWithDictionary:(NSDictionary *)dictionary
{
    self.rawGridDetail = dictionary;
    
    self.offerPrice = [dictionary[@"offer_price"] validObjectValue];
    self.brand = [dictionary[@"brand"] validObjectValue];
    self.paytypeLabel = [dictionary[@"paytype_label"] validObjectValue] ? dictionary[@"paytype_label"] : nil;
    
    NSString* imageURL = [dictionary[@"image_url"] validObjectValue];
    
    if (imageURL) {
        imageURL = [imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        self.imageUrl = imageURL;
    }
    
    self.url = [dictionary[@"url"] validObjectValue];
    self.urlType = [dictionary[@"url_type"] validObjectValue];
    self.actualPrice = [dictionary[@"actual_price"] validObjectValue];
    self.name = [dictionary[@"name"] validObjectValue];
    self.tag = [dictionary[@"tag"] validObjectValue];
    self.label = [dictionary[@"label"] validObjectValue];
    self.inStock = [[dictionary[@"stock"] validObjectValue] boolValue];
    self.categoryID = [dictionary[@"id"] validObjectValue];
    self.source = [dictionary stringForKey:@"source"];
    self.locationScore = [dictionary[@"location_score"] isNull] ? 0 : [dictionary[@"location_score"] floatValue];
    self.showAddToCart = [dictionary[@"add_to_cart"] validObjectValue] ? [dictionary[@"add_to_cart"] boolValue]: NO;
    self.minQuantity = [dictionary[@"min_purchase_quantity"] validObjectValue] ? [dictionary[@"min_purchase_quantity"] intValue]: 1;
    self.maxQuantity = [dictionary[@"max_purchase_quantity"] validObjectValue] ? [dictionary[@"max_purchase_quantity"] intValue]: 1;
    
    NSArray *related_category = [dictionary[@"related_category"] validObjectValue];
    if (related_category.count)
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        JRRelatedRechargeCategory *prepaidCategory = [[JRRelatedRechargeCategory alloc]initWithName:self.label url:self.url];
        
        [tempArray addObject:prepaidCategory];
        
        for (NSDictionary *category in dictionary[@"related_category"]) {
            JRRelatedRechargeCategory *rechargeCategory = [[JRRelatedRechargeCategory alloc]initWithDictionary:category];
            [tempArray addObject:rechargeCategory];
        }
        
        self.relatedCategories = tempArray;
    }
    
    else
    {
        self.relatedCategories = nil;
    }
    
    self.cashbackType = false;

    self.variantSelectionAPI =  [dictionary[@"variant_selection_api"] validObjectValue];
    //self.variantSelectionAPI = @"https://catalog.paytm.com/v1/s/motorola-moto-c-16-gb-starry-black-CMPLXMOBMOTOROLA-MOTDEAL23206988D9A57";
    self.shortDescription = [dictionary[@"short_desc"] validObjectValue];
    NSMutableArray *array0 = [NSMutableArray array];
    for(id obj in [dictionary[@"long_rich_desc"] validObjectValue])
    {
        [array0 addObject:[[JRCouponDescription alloc] initWithDictionary:[obj validObjectValue]]];
    }
    self.fullDescriptionArray = array0;
    self.productID = [dictionary[@"product_id"] isNull] ? nil : [NSString stringWithFormat:@"%@",dictionary[@"product_id"]];
    self.changedProductID = self.productID;
    NSString *parentId  = [dictionary[@"parent_id"] validObjectValue] ? [NSString stringWithFormat:@"%@",dictionary[@"parent_id"]]: nil;
    self.parentId = parentId.length ? parentId: self.productID;
    self.itemID = @"";
    self.discount = [dictionary[@"discount"] validObjectValue];
    if ([self.discount isKindOfClass:[NSNumber class]])
    {
        self.discount = [(NSNumber *)self.discount stringValue];
    }
    if ((self.actualPrice.integerValue <= self.offerPrice.integerValue) || [self.discount isEqualToString:@"0"])
    {
        self.discount = @"";
    }
    self.verticalLabel = [dictionary[@"vertical_label"] validObjectValue];
    CGFloat height = [[dictionary[@"img_height"] validObjectValue] floatValue];
    CGFloat width = [[dictionary[@"img_width"] validObjectValue] floatValue];
    
    height = (height == 0) ? 400 : height;
    width = (width == 0) ? 400 : width;
    self.imageSize = CGSizeMake(width, height);
    self.redirectionAlertMessage = (dictionary[@""] && ![dictionary[@""] isNull]) ? [[JRError alloc] initWithDictionary:dictionary[@""]] : nil;
    self.attributes = dictionary[@"attributes"];
    self.cartQuantity = self.oldQuantity = 0;
    self.gridCartError = false;
    self.offerUrl = [dictionary[@"offers_url"] validObjectValue];
    self.totalOffers = [dictionary[@"offers_more"] validObjectValue] ? [dictionary[@"offers_more"] intValue]: 0;
    
    NSArray *offers = [dictionary[@"offers"] validObjectValue];
    if(offers != nil && offers.count > 0) {
        NSDictionary *offer = offers[0];
        self.appliedPromoCode = [[JRProductPromoDetail alloc] initWithGridOfferDictionary:offer];
        self.totalOffers = self.totalOffers + 1;
        NSString *cashback = [offer[@"cashback"] validObjectValue];
        if(cashback != nil) {
            self.cashbackType = true;
            self.tag = [NSString stringWithFormat:@"₹%@ CashBack",cashback];
        }
    }
    self.metadata = [dictionary[@"meta_data"] validObjectValue];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		[self setWithDictionary:dictionary];
	}
    return self;
}

-(BOOL)isEqual:(JRGridDetail *)object
{

    if ([object.productID isEqualToString:self.productID] )
    {
        if ( object.offerPrice.floatValue == self.offerPrice.floatValue && object.actualPrice.floatValue == self.actualPrice.floatValue)
        {
            return YES;

        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"product id -%@ price = %f", self.productID, self.offerPrice.floatValue];
}

- (BOOL) isOfSpecialRechargeType {
    BOOL isOfSpecialType = false;
    
    if (self.attributes[@"producttype"]) {
        NSString* productType = self.attributes[@"producttype"];
        
        if ([productType.lowercaseString isEqualToString:@"recharge"]) {
            isOfSpecialType = true;
        }
    }
    
    return isOfSpecialType;
}

@end
