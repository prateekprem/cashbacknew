//
//  JROrderPayment.h
//  Jarvis
//
//  Created by Rajan Kumar Tiwari on 17/12/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JROrderPayment : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *transcationID;
@property (nonatomic, copy) NSString *pgAmount;
@property (nonatomic, copy) NSString *pgResponseCode;
@property (nonatomic, copy) NSString *gateway;
@property (nonatomic, copy) NSString *payementMethod;
@property (nonatomic, assign) NSNumber *orderId;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (void)setWithDictionary:(NSDictionary*)dictionary;


@end
