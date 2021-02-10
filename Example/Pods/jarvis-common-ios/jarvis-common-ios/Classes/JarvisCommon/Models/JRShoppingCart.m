//
//  JRShoppingCart.h
//  Jarvis
//
//  Created by Shwetha Mugeraya on 05/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//


#import "JRShoppingCart.h"

//#import "JRAddress.h"
#import "JRCartProduct.h"
#import "JRConstants.h"
#import <jarvis_common_ios/jarvis_common_ios-Swift.h>
#import <jarvis_utility_ios/NSObject+SafeKVC.h>

@implementation JRShoppingCart

- (void)setWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary[@"error"])
    {
        if ([dictionary[@"status"] isKindOfClass:[NSDictionary class]])
            self.status = [[JRStatus alloc] initWithDictionary:dictionary[@"status"]];
        
        NSDictionary *cartDictionary = dictionary[@"cart"];
        self.conv_fee = [cartDictionary[@"conv_fee"] isNull] ? nil : cartDictionary[@"conv_fee"];
        self.aggregate_item_price = [cartDictionary[@"aggregate_item_price"] isNull] ? nil : cartDictionary[@"aggregate_item_price"];
        self.orderTotal = [cartDictionary[@"order_total"] isNull] ? nil : cartDictionary[@"order_total"];
        self.placeOrderUrl = [cartDictionary[@"place_order_url"] isNull] ? nil : cartDictionary[@"place_order_url"];
        self.shippingCharges = [cartDictionary[@"shipping_charges"] validObjectValue];
        self.promoFailureText = [cartDictionary[@"promofailuretext"] isNull] ? nil : cartDictionary[@"promofailuretext"];
        self.paytmPromocode = [cartDictionary[@"paytm_promocode"] isNull] ? nil : cartDictionary[@"paytm_promocode"];
        
        self.paytmCashback = [cartDictionary[@"paytm_cashback"] isNull]? nil : cartDictionary[@"paytm_cashback"];
        self.finalPrice = [cartDictionary[@"final_price"] isNull] ? nil : cartDictionary[@"final_price"];
        self.grandtotalExcludingConvfee = [cartDictionary[@"grandtotal_excluding_convfee"] isNull] ? nil : cartDictionary[@"grandtotal_excluding_convfee"];
        self.aggregatePgConvFee = [cartDictionary[@"aggregate_pg_conv_fee"] isNull] ? nil : cartDictionary[@"aggregate_pg_conv_fee"];
        self.effectivePrice = [cartDictionary[@"effective_price"] isNull] ||([(NSString*)cartDictionary[@"effective_price"] floatValue] < 0.00) ? nil : cartDictionary[@"effective_price"];
        NSMutableArray *array1 = [NSMutableArray array];
        
        if ([[dictionary valueForKeyPath:@"cart.address"] isKindOfClass:[NSArray class]])
        {
            for(id obj in [dictionary valueForKeyPath:@"cart.address"])
            {
                [array1 addObject:[[JRAddress alloc] initWithDictionary:obj]];
            }
        }
        else if([[dictionary valueForKeyPath:@"cart.address"] isKindOfClass:[NSDictionary class]])
        {
            [array1 addObject:[[JRAddress alloc] initWithDictionary:[dictionary valueForKeyPath:@"cart.address"]]];
        }
        
        self.addresses = array1;
        
        if([[cartDictionary valueForKeyPath:@"gstinfo"] isKindOfClass:[NSDictionary class]])
        {
            self.selectedGST = [[JRGSTModel alloc] initWithDictionary:[cartDictionary valueForKey:@"gstinfo"]];
        }
        
        NSMutableArray *array0 = [NSMutableArray array];
        for(id obj in cartDictionary[@"cart_items"])
        {
            [array0 addObject:[[JRCartProduct alloc] initWithDictionary:obj]];
        }
        self.imageURL = [[cartDictionary valueForKeyPath:@"product_promise_logo_url"] isNull] ? @"" : [cartDictionary valueForKeyPath:@"product_promise_logo_url"];
        self.cartItems = array0;
        
        self.count = [cartDictionary[@"count"] isNull]? 0 : [cartDictionary[@"count"] integerValue];
        self.customerId = [cartDictionary[@"customer_id"] isNull] ? nil : cartDictionary[@"customer_id"];
        self.needShipping = [cartDictionary[@"need_shipping"] boolValue];
        self.promotext = [cartDictionary[@"promotext"] isNull] ? nil : cartDictionary[@"promotext"];
        self.promocode = [cartDictionary[@"paytm_promocode"] isNull] ? nil : cartDictionary[@"paytm_promocode"];
        // after S2S implemetation cart will not return paytm_promocode key, so adding a fallback logic to "promocode" key
        NSArray *cartItems = [cartDictionary[@"cart_items"] isArrayEmpty] ? nil : cartDictionary[@"cart_items"];
        if (self.promocode == nil && cartItems != nil) {
            NSDictionary *firstCartItems = cartItems[0];
            self.promocode = [firstCartItems[@"promocode"] isNull] ? nil : firstCartItems[@"promocode"];
        }
        self.promostatus = [cartDictionary[@"promostatus"] isNull] ? nil : cartDictionary[@"promostatus"];
        if([[cartDictionary valueForKeyPath:@"promoMetaData"] isKindOfClass:[NSDictionary class]]) {
            self.promoMetaData = [cartDictionary[@"promoMetaData"] validObjectValue];
        }
        self.discount = [cartDictionary[@"paytm_discount"] isNull] ||([(NSString*)cartDictionary[@"paytm_discount"] floatValue] <= 0.00) ? nil : cartDictionary[@"paytm_discount"];
        self.finalPriceExpecptShipping = [cartDictionary[@"final_price_excl_shipping"] isNull] ? nil : cartDictionary[@"final_price_excl_shipping"];
        if([cartDictionary [@"error"] isKindOfClass:[NSString class]])
        {
            self.error = [cartDictionary [@"error"] isNull] ? nil : cartDictionary [@"error"];
        }
        // In case of bank : add money to casa error handles
        else if ([cartDictionary [@"error"] isKindOfClass:[NSDictionary class]]) {
            self.error = [[cartDictionary valueForKeyPath:@"error.response"] isNull] ? nil : [cartDictionary valueForKeyPath:@"error.response"];
        }
        
        self.retrunPolicyDisplay = [cartDictionary[@"return_policy_display"] validObjectValue] ? [cartDictionary[@"return_policy_display"] boolValue] : NO;
        self.cashback_text = [cartDictionary[@"cashback_text"] validObjectValue] ? cartDictionary[@"cashback_text"] : nil;
        self.errorTitle = [dictionary[@"error_title"] isNull] ? nil : dictionary[@"error_title"];
        self.containServiceOptions = [cartDictionary[@"service_options"] boolValue];
        self.errorCode = [cartDictionary[@"error_code"] validObjectValue];
        self.error_info = [cartDictionary stringForKey:@"error_info"];
        self.taxes = [cartDictionary[@"total_other_taxes"] validObjectValue];
        if([cartDictionary[@"paytm_cashback"] validObjectValue] && [cartDictionary[@"paytm_cashback"] integerValue] != 0)
        {
            self.cashbackPriceValue = [NSString stringWithFormat:@"%@",cartDictionary[@"paytm_cashback"]];
            
        }
        else if([cartDictionary[@"paytm_goldback"] validObjectValue] && [cartDictionary[@"paytm_goldback"] integerValue] != 0)
        {
            self.cashbackPriceValue = [NSString stringWithFormat:@"%@",cartDictionary[@"paytm_goldback"]];
            
        }
        //        NSDictionary *taxData = taxes.count > 0 ? taxes[0] : nil;
        //        self.valueAddedTax = [taxData[@"value_added_tax"] floatValue];
        //        self.stateEntryTax = [taxData[@"value"] floatValue];
        for (NSDictionary *dic in self.taxes) {
            float value = [(NSString*)dic[@"value"] floatValue];
            self.totalTax += value;
            
        }
        [self populatePriceBreakUpSet];
        
        //additon of Convenience Fee and payment instruments on Verify call (JIRA IDs: CAI-17624, CAI-17646), edited on 4th June, 2019, by @Ashutosh Lasod
        if([[cartDictionary valueForKeyPath:@"payment_instruments"] isKindOfClass:[NSDictionary class]]) {
            self.paymentInstruments = [cartDictionary[@"payment_instruments"] validObjectValue];
        }
        
        if([[cartDictionary valueForKeyPath:@"paymentInfo"] isKindOfClass:[NSDictionary class]]) {
            // --- SAMAR to check
            self.paymentInfo = [[JRConvFeesPaymentInfo alloc] initWithDictionary:[cartDictionary valueForKey:@"paymentInfo"]];
        }
        self.isConvFeeApplicable = [cartDictionary[@"is_conv_fee_applicable"] boolValue];
        
        //EMI Plan Parsing
        if([[dictionary valueForKeyPath:@"emi_plans"] isKindOfClass:[NSDictionary class]]) {
            self.emiPlan = [[EmiSubPlansModel alloc] initWithDictionary:[dictionary[@"emi_plans"] validObjectValue]];
        }
        if([[dictionary valueForKeyPath:@"emi_plan"] isKindOfClass:[NSDictionary class]]) {
            self.selectedTenureModel = [[EmiSubTenureModel alloc] initWithDictionary:[dictionary[@"emi_plan"] validObjectValue]];
        }
        
    } else {
        if ([dictionary[@"status"] isKindOfClass:[NSDictionary class]])
            self.status = [[JRStatus alloc] initWithDictionary:dictionary[@"status"]];
        self.error = [dictionary[@"error"] isNull] ? nil : dictionary[@"error"];
        self.errorTitle = [dictionary[@"error_title"] isNull] ? nil : dictionary[@"error_title"];
        self.errorCode = [dictionary[@"errorCode"] isNull] ? nil : dictionary[@"errorCode"];
    }
}

- (void)populatePriceBreakUpSet
{
    if (!self.priceBreakUpSet) {
        self.priceBreakUpSet = [NSMutableArray array];
    }
//    the order is important here. Dont change it.
    [self subTotalModel];
    [self discountModel];
    if ([self isCategoryMapContainsIdForCarOrBike])
    {
        [self populateConvenienceFeeForBikeOrCar];
    }else{
        if (self.needShipping)
        {
            [self shippingModel];
            [self convenienceModel];
        }
    }
    [self otherTaxesModel];
    [self totalModel];
}

- (void)subTotalModel
{
    JRPriceBreakUpModel *model = nil;
    if (self.aggregate_item_price.floatValue>0.00)
    {
        model = [[JRPriceBreakUpModel alloc]init];
        model.label = @"Subtotal";
        model.value = [NSString stringWithFormat:@"%f",self.aggregate_item_price.floatValue];
    }
    if (model) {
        [self.priceBreakUpSet addObject:model];
        model = nil;
    }
}


- (void)discountModel
{
    JRPriceBreakUpModel *model = nil;
    if (self.discount.floatValue>0.00)
    {
        model = [[JRPriceBreakUpModel alloc]init];
        model.label = @"Discount";
        model.value = [NSString stringWithFormat:@"%f",self.discount.floatValue];
    }
    if (model) {
        [self.priceBreakUpSet addObject:model];
        model = nil;
    }
}

- (void)shippingModel
{
    JRPriceBreakUpModel *model = nil;
    if (self.shippingCharges && self.shippingCharges.floatValue > 0.00)
    {
        model = [[JRPriceBreakUpModel alloc]init];
        model.label = @"Shipping Charges";
        model.value = [NSString stringWithFormat:@"%f",self.shippingCharges.floatValue];
    }else if(self.shippingCharges && [self.shippingCharges floatValue] == 0.00)
    {
        model = [[JRPriceBreakUpModel alloc]init];
        model.label = @"Shipping Charges";
        model.value = @"Free";
    }
    if (model) {
        [self.priceBreakUpSet addObject:model];
        model = nil;
    }
}

- (void)populateConvenienceFeeForBikeOrCar
{
    NSString *convenienceCost = @"Free";
    if (self.shippingCharges && [self.shippingCharges doubleValue]>0)
    {
        if ([self.shippingCharges floatValue]==[self.shippingCharges intValue])
        {
            convenienceCost = [NSString stringWithFormat:@"%d",[self.shippingCharges intValue]];
        }else{
            convenienceCost = [NSString stringWithFormat:@"%.2f",[self.shippingCharges floatValue]];
        }
    }
    
    JRPriceBreakUpModel *model = [[JRPriceBreakUpModel alloc] init];
    model.label = @"Convenience";
    model.value = [NSString stringWithFormat:@"%@",convenienceCost];
    if (model) {
        [self.priceBreakUpSet addObject:model];
    }
}

- (void)convenienceModel
{
    JRPriceBreakUpModel *model = nil;
    if (self.conv_fee.floatValue>0.00)
    {
        model = [[JRPriceBreakUpModel alloc]init];
        model.label = @"Convenience Fee";
        model.value = [NSString stringWithFormat:@"%f",self.conv_fee.floatValue];
    }
    if (model) {
        [self.priceBreakUpSet addObject:model];
        model = nil;
    }
}

- (void)totalModel
{
    JRPriceBreakUpModel *model = nil;
    if (self.finalPrice.floatValue>0.00)
    {
        model = [[JRPriceBreakUpModel alloc]init];
        model.label = @"Bag Total";
        model.value = [NSString stringWithFormat:@"%f",self.finalPrice.floatValue];
    }
    if (model) {
        [self.priceBreakUpSet addObject:model];
        model = nil;
    }
}

- (void)otherTaxesModel
{
    for (NSMutableDictionary *dict in self.taxes)
    {
        JRPriceBreakUpModel *model = [[JRPriceBreakUpModel alloc]initWithDictionary:dict];
        [self.priceBreakUpSet addObject:model];
        model = nil;
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		[self setWithDictionary:dictionary];
	}
    return self;
}

- (NSInteger)numberOfCartItemWithPromoStatusAs:(BOOL)success
{
    NSInteger count = 0;
    for (JRCartProduct *product in self.cartItems)
    {
        if ([product hasValidPromoCode])
        {
            count++;
        }
    }
    return success ? count : (self.cartItems.count - count);
}

- (void)getProductIDandProductNames:(void(^)(NSArray *productIDs, NSArray *productNames, NSString* price))handler {
    NSMutableArray *productIDs = [NSMutableArray array];
    NSMutableArray *productNames = [NSMutableArray array];
    
    for (JRCartProduct *product in self.cartItems) {
        if (product.productId && product.name.length) {
            [productIDs addObject: [NSString stringWithFormat:@"%@",product.productId]];
            [productNames addObject:product.name];
        }
    }
    if (handler) {
        handler(productIDs, productNames, [NSString stringWithFormat:@"%@",self.finalPrice]);
    }
}

- (void)getProductIDandProductNamesWithCategory:(void(^)(NSArray *productIDs, NSArray *productNames, NSArray *categoryIds,NSArray *categoryNames,NSString* price))handler {
    NSMutableArray *productIDs = [NSMutableArray array];
    NSMutableArray *productNames = [NSMutableArray array];
    NSMutableArray *categoryIds = [NSMutableArray array];
    NSMutableArray *categoryNames= [NSMutableArray array];

    for (JRCartProduct *product in self.cartItems) {
        if (product.productId.length && product.name.length) {
            [productIDs addObject:product.productId];
            [productNames addObject:product.name];
            [categoryIds addObject:product.category_ids.lastObject? :@(0)];
            [categoryNames addObject:product.gaKey? :@""];
        }
    }
    if (handler) {
        handler(productIDs, productNames,categoryIds,categoryNames, [NSString stringWithFormat:@"%@",self.finalPrice]);
    }
}

- (BOOL)isCategoryMapContainsIdForCarOrBike
{
    BOOL returnAnswer = NO;
    if (self.cartItems.count==1)
    {
        JRCartProduct *cartProduct = self.cartItems.firstObject;
        if (([cartProduct.vertical_id integerValue] == 49))
        {
            returnAnswer = YES;
        }
    }
    return returnAnswer;
}
@end
