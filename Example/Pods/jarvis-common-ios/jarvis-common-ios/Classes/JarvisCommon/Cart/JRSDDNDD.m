//
//  JRSDDNDD.m
//  Jarvis
//
//  Created by Ayush Goel on 04/05/17.
//  Copyright © 2017 One97. All rights reserved.
//

#import "JRSDDNDD.h"
#import <jarvis_common_ios/jarvis_common_ios-Swift.h>

@implementation JRSDDNDD

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        [self setWithDictionary:dictionary];
    }
    return self;
}


- (void)setWithDictionary:(NSDictionary *)dictionary
{    
    self.isPFA = [[dictionary valueForKeyPath:@"is_pfa"] isNull] ? false : [[dictionary valueForKeyPath:@"is_pfa"] boolValue];
    self.deliveryType = [[dictionary valueForKeyPath:@"delivery_type"] isNull] ? 0 : [[dictionary valueForKeyPath:@"delivery_type"] integerValue];
    self.imageURL = [[dictionary valueForKeyPath:@"imageURL"] isNull] ? @"" : [dictionary valueForKeyPath:@"imageURL"];

    switch (self.deliveryType) {
        case JRSDDNDDType_STANDARD:
            self.deliveryText = @"Standard Delivery";
            break;
        case JRSDDNDDType_SDD:
            self.deliveryText = @"Delivery by Today";
            break;
        case JRSDDNDDType_NDD:
            self.deliveryText = @"Delivery by Tomorrow";
            break;
    }
}

@end
