//
//  JROrderPayment.m
//  Jarvis
//
//  Created by Rajan Kumar Tiwari on 17/12/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import "JROrderPayment.h"
#import <jarvis_utility_ios/jarvis_utility_ios-Swift.h>

@implementation JROrderPayment

- (void)setWithDictionary:(NSDictionary*)dictionary {
    self.status = [dictionary[@"status"] isNull] ? @"" :dictionary[@"status"];
    self.bankName = [dictionary[@"payment_bank"] isNull] ? @"" :dictionary[@"payment_bank"];
    self.transcationID = [dictionary[@"bank_transaction_id"] isNull] ? @"" :dictionary[@"bank_transaction_id"];
    self.pgAmount = [NSString stringWithFormat:@"%@",[dictionary [@"pg_amount"] isNull]
                     ? @"0" : dictionary[@"pg_amount"]];
    self.pgResponseCode = [NSString stringWithFormat:@"%@", [dictionary [@"pg_response_code"] isNull]
                           ? @"" : dictionary[@"pg_response_code"]];
    self.gateway = [dictionary[@"gateway"] isNull] ? @"" :dictionary[@"gateway"];
    self.payementMethod = dictionary [@"payment_method"];
    self.orderId = dictionary [@"order_id"];
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        [self setWithDictionary:dictionary];
    }
    return self;
}

@end
