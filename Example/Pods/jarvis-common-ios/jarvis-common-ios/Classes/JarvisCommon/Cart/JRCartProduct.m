//
//  JRCartProduct.m
//  Jarvis
//
//  Created by Shwetha Mugeraya on 05/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import "JRCartProduct.h"
#import "JRServiceOption.h"
#import "JRSDDNDD.h"
#import <jarvis_locale_ios/jarvis_locale_ios-Swift.h>
#import <jarvis_common_ios/jarvis_common_ios-Swift.h>


@implementation JRPaymentModeConvenienceFee

- (NSString*) displayModeName {
    
    NSString* displayName = self.modeName;
    NSString* name = self.modeName.uppercaseString;
    
    if ([name isEqualToString:@"CC"]) {
        displayName = [LanguageManager.shared getLocalizedStringWithKey:@"jr_ac_creditCard"];
    } else if ([name isEqualToString:@"DC"]) {
        displayName = [LanguageManager.shared getLocalizedStringWithKey:@"jr_ac_debitCard"];
    } else if ([name isEqualToString:@"NB"]) {
        displayName = [LanguageManager.shared getLocalizedStringWithKey:@"jr_ac_netBanking"];
    } else if ([name isEqualToString:@"PPI"]) {
        displayName = [LanguageManager.shared getLocalizedStringWithKey:@"jr_ac_paytmWallet"];
    } else if ([name isEqualToString:@"UPI"]) {
        displayName = [LanguageManager.shared getLocalizedStringWithKey:@"jr_ac_UPI"];
    }
    
    return displayName;
}

- (NSString *)serverExpectingModeName {
    return self.modeName.uppercaseString;
}

- (BOOL)isPaytmWalletMode {
    return [self.modeName.uppercaseString isEqualToString:@"PPI"];
}

- (id)copyWithZone:(NSZone*)zone {
    JRPaymentModeConvenienceFee* fee = [[[self class] allocWithZone:zone] init];
    if (fee) {
        fee.modeName = _modeName;
        fee.fee = _fee;
    }
    return fee;
}

@end

@implementation JRCartProduct

- (void)setWithDictionary:(NSDictionary *)dictionary
{
//    DEBUGLOG(@"dictionary in JRCartProduct: %@",dictionary);
    self.productVerticalLabel = [dictionary[@"vertical_label"] isNull] ? nil : dictionary[@"vertical_label"] ;
    self.vertical_id = [dictionary[@"vertical_id"] isNull] ? nil : [dictionary[@"vertical_id"] validObjectValue];
    self.discountedPrice = [dictionary[@"discounted_price"] isNull] ? nil : dictionary[@"discounted_price"];
    self.mrpPrice = [dictionary[@"mrp"] isNull] ? nil : dictionary[@"mrp"];

    
	self.quantity = [dictionary[@"quantity"] isNull] ? nil : dictionary[@"quantity"] ;
    self.totalPrice = [dictionary[@"total_price"] isNull] ? nil : dictionary[@"total_price"];
	self.merchantName = [dictionary[@"merchant_name"] isNull] ? nil : dictionary[@"merchant_name"];
	self.shippingCost = [dictionary[@"shipping_cost"] isNull] ? nil : dictionary[@"shipping_cost"];
	self.productConfigName = [dictionary[@"product_config_name"] isNull] ? nil : dictionary[@"product_config_name"];
	self.productId = [dictionary[@"product_id"] isNull] ? @"" : [NSString stringWithFormat:@"%@",dictionary[@"product_id"]];
    self.itemId = [dictionary[@"item_id"] isNull] ? @"" : [NSString stringWithFormat:@"%@",dictionary[@"item_id"]];

    
    //[dictionary[@"parent_id"] validObjectValue]? : self.productId;
    //this was done for not observing parentID from the response.
    NSString *str = [self assignParentIDToCartProductFromDictionary:dictionary];
    self.parentID = str? [NSString stringWithFormat:@"%@",str] : nil;
	self.price = [dictionary[@"price"] isNull] ? nil : dictionary[@"price"];
	self.promocode = [dictionary[@"promocode"] isNull] ? nil : dictionary[@"promocode"];
    self.itemPromotext = [dictionary[@"promotext"] isNull] ? nil : dictionary[@"promotext"];
	self.merchant_id = [dictionary[@"merchant_id"] isNull] ? nil : dictionary[@"merchant_id"];
	self.name = [dictionary[@"name"] isNull] ? @"" : dictionary[@"name"];
	self.imageUrl = [dictionary[@"image_url"] isNull] ? nil : dictionary[@"image_url"];
    self.promotext = [dictionary [@"promotext"] isNull] || [dictionary [@"promotext"] isBlank] ? nil : dictionary[@"promotext"];
    self.brand = [dictionary [@"brand"] isNull] ? nil : dictionary[@"brand"];
    self.error = [dictionary [@"error"] isNull] ? nil : dictionary[@"error"];
    self.url = [dictionary [@"url"] isNull] ? nil : dictionary[@"url"];
    self.title = [dictionary [@"title"] isNull] ? nil : dictionary[@"title"];
    self.configuration = [dictionary [@"configuration"] isNull] ? nil : dictionary[@"configuration"];
    self.metadata = [dictionary [@"meta_data"] isNull] ? nil : dictionary[@"meta_data"];
    self.offerText = [dictionary [@"offer_text"] isNull] || ([dictionary [@"offer_text"] isBlank]) ? nil : dictionary[@"offer_text"];
    self.promostatus = [dictionary[@"promostatus"] isNull] || [dictionary[@"promostatus"] isBlank]? nil : dictionary[@"promostatus"];
    self.availableQuatity = [dictionary[@"available_quantity"] isNull] || (dictionary[@"available_quantity"] == nil)|| ([dictionary[@"available_quantity"] integerValue] > 99)? @"99" : dictionary[@"available_quantity"];
    self.errorTitle = [dictionary[@"error_title"] isNull] ? nil : dictionary[@"error_title"];
    self.shippingCharge = [dictionary[@"shipping_charges"] isNull] ? nil : dictionary[@"shipping_charges"];
    self.needshipping = [dictionary[@"need_shipping"] boolValue];
    self.isInstallable = [dictionary[@"installation_eligible"] boolValue];
    self.installation_url = [dictionary[@"installation_url"] validObjectValue] ? dictionary[@"installation_url"] : nil;

    
    self.category = [[dictionary valueForKeyPath:@"categoryMap"] isNull] ? @"" : [self getCategorymapForProduct:[dictionary valueForKeyPath:@"categoryMap"]];
    
    NSMutableArray *ancestorArray = [NSMutableArray array];
    for (NSDictionary *dic in [[dictionary valueForKeyPath:@"categoryMap"] validObjectValue])
    {
        JRItem *item =  [[JRItem alloc] initWithDictionary:dic];
        [ancestorArray addObject:item];
    }
    
    //*********** This is for Exchange functionlity ***********//
    self.isExchangeAvailable = false;
    if ([[dictionary valueForKey:@"exchange"] validObjectValue]) {
        
        NSDictionary *exchangeDict = [[dictionary valueForKey:@"exchange"] validObjectValue];
        self.exchangeModel = [[ExchangeQuoteModel alloc] init:exchangeDict];
        self.isExchangeAvailable = true;
    }
    
    //*********** This is for IMEI functionlity ***********//
    
    self.imeiDetailObj = [[JRPDPValidationDetails alloc] init];
    /*self.imeiDetailObj.inputText = @"873454876485432";
    self.imeiDetailObj.isInputVerified = true;
    self.isIMEIAvailable = true; //will depend on server "validation" and "imei" key*/
    

    if ([dictionary[@"validations"] validObjectValue])
    {
        NSDictionary *dict = dictionary[@"validations"];
        if ([dict[@"imei"] validObjectValue])
        {
            NSDictionary *viewDict = dict[@"imei"];
            if ([viewDict[@"view"] validObjectValue])
            {
                NSDictionary *view = [viewDict[@"view"] validObjectValue] ? viewDict[@"view"] : nil;
                self.imeiDetailObj = [[JRPDPValidationDetails alloc] initWithDictionary:view];
                self.isIMEIAvailable = true;
            }
            self.imeiDetailObj.inputText = [viewDict[@"number"] validObjectValue] ? viewDict[@"number"] : nil;
            self.imeiDetailObj.isInputVerified = [viewDict[@"is_verified"] boolValue];
        }
    }
    
    if (self.imeiDetailObj.isInputVerified)
    {
        self.imeiCellState = IMEIStateVerified;
    }
    else if (self.imeiDetailObj.inputText.length > 0)
    {
        self.imeiCellState = IMEIStateVerify;
    }
    else
    {
        self.imeiCellState = IMEIStateScan;
    }
    
    self.categoryMap = ancestorArray.count ? ancestorArray : nil;
    self.discount = [dictionary[@"paytm_discount"] validObjectValue] ? dictionary[@"paytm_discount"] : nil;
    self.paytmCashback = [dictionary[@"paytm_cashback"] validObjectValue] ? dictionary[@"paytm_cashback"] : nil;
    self.cashbackAmount = [dictionary[@"cashback_text"] validObjectValue] ? dictionary[@"cashback_text"] : @"";
    self.deleveryInfo = [dictionary[@"estimated_delivery"] validObjectValue] ? dictionary[@"estimated_delivery"] : nil;
    NSArray *deliveryRange = [dictionary[@"estimated_delivery_range"] validObjectValue] ? dictionary[@"estimated_delivery_range"] : nil;
    self.deliveryRangeInfoString = [NSString fetchDeliveryInfoStringFromArray: deliveryRange];
    self.deliveryText = dictionary[@"delivery_text"];
    self.serviceOption = [self serviceoptionForAction:dictionary[@"service_options"][@"actions"]];
    self.productAttributes = [dictionary[@"attributes_dim_values"] validObjectValue] ? dictionary[@"attributes_dim_values"] : nil;
    self.attributes = [dictionary[@"attributes"] validObjectValue] ? dictionary[@"attributes"] : nil;
    self.offerUrl = [dictionary[@"offer_url"] validObjectValue] ? dictionary[@"offer_url"] : nil;
    self.producTags = [dictionary[@"tags"] validObjectValue] ? dictionary[@"tags"] : nil;
    self.productType = [dictionary[@"product_type"] validObjectValue] ? [dictionary[@"product_type"] intValue] : 0;
    self.productAttibuteNames = [dictionary[@"attributes_dim"] validObjectValue] ? dictionary[@"attributes_dim"] : nil;
    self.shareUrl = [dictionary[@"shareurl"] validObjectValue] ? dictionary[@"shareurl"] : nil;
    self.inStock = [dictionary[@"is_in_stock"] validObjectValue] ? [dictionary[@"is_in_stock"] boolValue] : YES;
    self.nonReturnableItem = [dictionary[@"non_returnable"] validObjectValue] ? [dictionary[@"non_returnable"] boolValue] : NO;

    self.returnPolicyText = [dictionary [@"return_policy_text"] validObjectValue] ? dictionary[@"return_policy_text"] : @"";
    self.returnPolicyLabel = [dictionary [@"return_policy_label"] validObjectValue] ? dictionary[@"return_policy_label"] : @"";
    self.returnPolicySummary = [dictionary [@"return_policy_summary"] validObjectValue] ? dictionary[@"return_policy_summary"] : @"";
    
    if ([[dictionary valueForKey:@"return_policy"] validObjectValue]) {
        NSDictionary *policyDict = [[dictionary valueForKey:@"return_policy"] validObjectValue];
        self.returnPolicyModel = [[JRCartReturnPolicyModel alloc] initWithDictionary:policyDict];
    }
    if(self.attributes != nil) {
        self.isOTPFlow = [self.attributes[@"otp_flow"] boolValue];
        self.paytypeLabel =[self.attributes[@"paytype_label"] validObjectValue] ? self.attributes[@"paytype_label"] : nil;
    }
    NSArray *list = [[dictionary[@"service_options"] validObjectValue] arrayForKey:@"actions"];
    for (NSDictionary *item in list) {
        
        NSDictionary *additionalUserInfo = [item objectForKey:@"additionalUserInfo"];
        if (additionalUserInfo != nil && additionalUserInfo.count > 0) {
            self.userOTPNumber = [additionalUserInfo [@"mobileNumber"] validObjectValue] ? [NSString stringWithFormat:@"%@",additionalUserInfo[@"mobileNumber"]] : nil;
        }
        
        if ([item objectForKey:@"displayValues"]) {
            if ([item[@"displayValues"] validObjectValue]) {
                self.serviceOptions = [[JRCartServiceModel alloc] initWithDictionary:item];
            }
            break;
        }
    }
    NSDictionary *addressDict = [dictionary[@"warehouse_address"] validObjectValue];
    self.warehouseAddressState = [addressDict[@"state"] validObjectValue] ? addressDict[@"state"] : nil;
    self.warehouseAddressCity = [addressDict[@"city"] validObjectValue] ? addressDict[@"city"] : nil;
    
    // cart product important info
    for (NSDictionary *item in list) {
        if ([JRError isValidInputWithDict:item]) {
            self.cartProductImportantInfo = [[JRError alloc]initWithDictionary:item];
            break;
        }
    }
    
    for (NSDictionary *item in list) {
        if ([item[@"updatedValues"] isKindOfClass:[NSArray class]]) {
            
            NSArray* rawUpdateValues = item[@"updatedValues"];
            NSMutableArray* updateValues = [NSMutableArray new];
            
            for (NSDictionary* rawUpdateValue in rawUpdateValues) {
                JRCartServiceOptionUpdateValuesModel* model = [[JRCartServiceOptionUpdateValuesModel alloc]initWithDictionary:rawUpdateValue];
                [updateValues addObject:model];
            }
            
            self.serviceOptionUpdatedValues = updateValues;
            
            break;
        }
        
    }
    
    self.recievedServiceOptions = [dictionary[@"service_options"] validObjectValue];
    
    self.taxes = [dictionary[@"other_taxes"] validObjectValue] ? dictionary[@"other_taxes"] : nil;;
    for (NSMutableDictionary *dic in self.taxes) {
        float value = [(NSString*)dic[@"value"] floatValue];
        self.totalTax += value;
        
    }
  
    if ([dictionary[@"is_pfa"] validObjectValue] && ([dictionary[@"is_pfa"] boolValue] == true)) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:dictionary[@"is_pfa"] forKey:@"is_pfa"];
        if ([dictionary[@"delivery_type"] validObjectValue]) {
            [dict setObject:dictionary[@"delivery_type"] forKey:@"delivery_type"];
        }
        self.sddndd = [[JRSDDNDD alloc] initWithDictionary:dict];
        self.sddndd.deliveryText = self.deliveryText;
    }
    
    self.convinienceFee = [dictionary[@"conv_fee"] validObjectValue] ? dictionary[@"conv_fee"] : nil;
    self.category_ids = [self getCategoryIDsForAncestor:[dictionary[@"categoryMap"] validObjectValue]];
    self.gaKey = [dictionary stringForKey:@"ga_key"];
    self.category_Name = [self categoryNameForGA];
    self.trackingInfo = [dictionary[@"tracking_info"] validObjectValue];
    
    self.moreSellers = [dictionary[@"more_sellers"] validObjectValue] ? [dictionary[@"more_sellers"] boolValue] : NO;
    self.errorCode = [dictionary[@"error_code"] validObjectValue] ? dictionary[@"error_code"] : nil;
    self.errorStr = [dictionary[@"error"] validObjectValue] ? dictionary[@"error"] : nil;

    self.aggregate_item_price = [dictionary[@"aggregate_item_price"] isNull] ? nil : dictionary[@"aggregate_item_price"];
    
    [self populatePriceBreakUpArray];
    
    // Convenience fee list
    self.convenienceFeeList = [self convenienceFeeList:[dictionary[@"conv_fee_map"] validObjectValue]];
    
    // Emi Subvention
    if([dictionary[@"emi_offers"] isKindOfClass:[NSDictionary class]]) {
        self.emiOffersDict = dictionary[@"emi_offers"];
    }
    
    //Promo SDK
    if ([dictionary[@"sku_type"] isKindOfClass:[NSString class]]) {
        self.skuType = [NSString stringWithFormat:@"%@", dictionary[@"sku_type"]];
    }
    
    if ([dictionary[@"promo_sku_parent_pids"] isKindOfClass:[NSArray class]]) {
        self.promoSkuParentPids = dictionary[@"promo_sku_parent_pids"];
    }
}

- (NSArray<JRPaymentModeConvenienceFee*>*) convenienceFeeList:(NSDictionary*)rawDictionary {
    NSMutableArray<JRPaymentModeConvenienceFee*>* list = [NSMutableArray<JRPaymentModeConvenienceFee*> new];
    
    if (nil != rawDictionary && rawDictionary.count > 0) {
        for (NSString* key in rawDictionary) {
            NSString* val = rawDictionary[key];
            
            JRPaymentModeConvenienceFee* fee = [JRPaymentModeConvenienceFee new];
            fee.modeName = key;
            fee.fee = val.doubleValue;
            [list addObject:fee];
        }
    }

    return list;
}

- (void)populatePriceBreakUpArray
{
    self.priceBreakUpArray = nil;
    self.priceBreakUpArray = [NSMutableArray array];
    
    [self populateDiscountModel];
    if ([self isCategoryMapContainsIdForCarOrBike])
    {
        [self populateConvenienceFeeForBikeOrCar];
    }else{
        if (self.needshipping)
        {
            [self populateShippingWithEstimateModel];
            [self populateConvenienceModel];
        }
    }
    [self populateOtherTaxes];
    [self populateTotalPriceModel];
}


#pragma mark - PriceBreakUpModels
- (void)populateDiscountModel
{
    JRPriceBreakUpModel *model = nil;
    if ([self.discount floatValue]>0)
    {
        model = [[JRPriceBreakUpModel alloc] init];
        model.label = @"Discount";
        model.value = [NSString stringWithFormat:@"%f",[self.discount floatValue]];
    }
    if (model) {
        [self.priceBreakUpArray addObject:model];
    }
}


- (void)populateShippingWithEstimateModel
{
    //NSString *estimatedDelivery = [NSString stringWithFormat:@"%@: %@", JRLocalizedString(@"Est. Delivery"), self.deliveryRangeInfoString];
    NSString *estimatedDelivery = @"";
    if (self.deliveryText && [self.deliveryText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        estimatedDelivery = [NSString stringWithFormat:@"(%@)", self.deliveryText];
    }
    
    NSString *shippingCost = @"Free";
    if (self.shippingCharge && [self.shippingCharge doubleValue]>0)
    {
        shippingCost = self.shippingCharge;
    }
    JRPriceBreakUpModel *model = [[JRPriceBreakUpModel alloc]init];
    model.label = [NSString stringWithFormat:@"Shipping Fee %@",estimatedDelivery];
    model.value = [NSString stringWithFormat:@"%@",shippingCost];
    if (model) {
        [self.priceBreakUpArray addObject:model];
    }
}

- (void)populateConvenienceFeeForBikeOrCar
{
    NSString *convenienceCost = @"Free";
    if (self.shippingCharge && [self.shippingCharge doubleValue]>0)
    {
        convenienceCost = self.shippingCharge;
    }
    
    JRPriceBreakUpModel *model = [[JRPriceBreakUpModel alloc] init];
    model.label = @"Convenience Fee";
    model.value = [NSString stringWithFormat:@"%@",convenienceCost];
    if (model) {
        [self.priceBreakUpArray addObject:model];
    }
}

- (void)populateConvenienceModel
{
    JRPriceBreakUpModel *model = nil;
    if (!self.convinienceFee && self.convinienceFee.intValue>0)
    {
        
        model = [[JRPriceBreakUpModel alloc] init];
        model.label = @"Convenience Fee";
        model.value = self.convinienceFee;
    }
    if (model) {
        [self.priceBreakUpArray addObject:model];
    }
}

- (void)populateTotalPriceModel
{
    JRPriceBreakUpModel *model = nil;
    if (self.totalPrice)
    {
        float totalPriceToDict = ([self.totalPrice floatValue]-[self.discount floatValue])+[self.shippingCharge floatValue];
        model = [[JRPriceBreakUpModel alloc] init];
        model.label = @"Total";
        model.value = [NSString stringWithFormat:@"%f",totalPriceToDict];
    }
    if (model) {
        [self.priceBreakUpArray addObject:model];
    }
}

- (void)populateOtherTaxes
{
//    DEBUGLOG(@"self.taxes:%@",self.taxes);
    for (NSMutableDictionary *dict in self.taxes)
    {
        JRPriceBreakUpModel *model = [[JRPriceBreakUpModel alloc]initWithDictionary:dict];
        float valueFromModel = [model.value floatValue];
        float multipliedValue = valueFromModel*[self.quantity floatValue];
        if (multipliedValue==(int)multipliedValue)
        {
            model.value = [NSString stringWithFormat:@"%d",(int)multipliedValue];
        }else{
            model.value = [NSString stringWithFormat:@"%.2f",multipliedValue];
        }
        [self.priceBreakUpArray addObject:model];
    }
}

- (NSString *)assignParentIDToCartProductFromDictionary:(NSDictionary *)dict
{
    NSString *returnParentID = @"";
    NSString *parentID = [dict[@"parent_id"] validObjectValue]?dict[@"parent_id"]:nil;
    if (parentID)
    {
        returnParentID = [NSString stringWithFormat:@"%@",parentID];
        
    }
    else
    {
        NSDictionary *tempTrackingInfoDictionary = [dict[@"tracking_info"] validObjectValue]?dict[@"tracking_info"]:nil;
        NSString *parentIDFromTrackingInfo  = [tempTrackingInfoDictionary[@"parentID"] validObjectValue]?tempTrackingInfoDictionary[@"parentID"]:nil;
        if (parentIDFromTrackingInfo)
        {
            returnParentID = [NSString stringWithFormat:@"%@",parentIDFromTrackingInfo];
        }else
        {
            returnParentID = self.productId;
        }
    }
    return returnParentID;
}


-(NSArray*)serviceoptionForAction:(NSArray*)actions
{
    NSMutableArray *options = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in actions) {
        JRServiceOption *option = [[JRServiceOption alloc]initWithDictionary:dict];
        [options addObject:option];
    }
    return options;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		[self setWithDictionary:dictionary];
	}
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.productId forKey:@"productId"];
    [dict setObject:self.quantity forKey:@"quantity"];
    return dict;
}

-(NSString*)getCategorymapForProduct:(NSArray*)categorymap
{
    __block NSString *categoryName;
    
    [categorymap enumerateObjectsUsingBlock:^(NSDictionary *categoryDictionry, NSUInteger idx, BOOL *stop) {
                  NSString *apendedString = [NSString stringWithFormat:@"%@/%@",categoryName,categoryDictionry[@"name"]];
            categoryName =  (categoryName ) ? apendedString : categoryDictionry[@"name"];
            
    }];
    return categoryName;
}

- (BOOL)hasValidPromoCode
{
    return ![_promostatus isEqualToString:@"failure"];
}


- (BOOL)isCategoryMapContainsIdForCarOrBike
{
    return ([self.vertical_id integerValue] == 49) ? YES : NO;
}


- (NSString *)categoryNameForGA{
    NSString *key;
    if (self.gaKey.length) {
        NSArray *list = [self.gaKey componentsSeparatedByString:@"/"];
        if (list.count > 3 ){
            key = list[2];
        }
    }
    return key;
}


-(NSArray*)getCategoryIDsForAncestor:(NSArray*)ancestors
{
    __block NSMutableArray *list = [NSMutableArray array];
    
    [ancestors enumerateObjectsUsingBlock:^(NSDictionary *categoryDictionry, NSUInteger idx, BOOL *stop) {
        id val = [categoryDictionry numberForKey:@"id"];
        if (!val) {
            val = [categoryDictionry stringForKey:@"id"];
        }
        if (val) {
            [list addObject:[NSString stringWithFormat:@"%@", val]];
        }
    }];
    
    return list;
}

- (NSString*) discountPercentage {
    int percentage = ((self.mrpPrice.floatValue-self.price.floatValue)/(self.mrpPrice.floatValue))*100;
    NSString *percentageText = [NSString stringWithFormat:@"%d",percentage];
    return percentageText;
}

- (NSString*)getColorSizeAttribtes {
   
    NSArray *keys = [_productAttributes allKeys];
    NSString *attributeValue = @"";
    if(keys.count > 0)
    {
        NSString *attributeKey = keys[0];
        attributeValue = [attributeValue stringByAppendingString:_productAttributes[attributeKey]];
    }
    if (keys.count > 1)
    {
        NSString *attributeKey = keys[1];
        attributeValue = [attributeValue stringByAppendingString:[NSString stringWithFormat:@", %@", _productAttributes[attributeKey]]];
    }
    return attributeValue;
    
}

-(NSInteger) getDisplayShippingCharge {
    if (self.shippingCharge) {
        return [self.shippingCharge integerValue];
    }
    return -1;
}

-(NSString*) getCartItemDetailsForGA {
    NSString *title = [NSString stringWithFormat:@"product=%@",self.name];
    if(![_category isKindOfClass:[NSNull class]] && _category.length > 0){
        title = [NSString stringWithFormat:@"%@;category=%@",title,_category];
    }
    if(![_brand isKindOfClass:[NSNull class]] && _brand.length > 0){
        title = [NSString stringWithFormat:@"%@;brand=%@",title,_brand];
    }
    if(![_productId isKindOfClass:[NSNull class]] && _productId.length > 0){
        title = [NSString stringWithFormat:@"%@;pid=%@",title,_productId];
    }
    return title;
}
@end
