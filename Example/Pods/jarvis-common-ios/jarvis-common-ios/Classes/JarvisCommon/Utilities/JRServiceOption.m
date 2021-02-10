//
//  JRServiceOption.m
//  Jarvis
//
//  Created by Chaithra T V on 07/08/15.
//  Copyright (c) 2015 One97. All rights reserved.
//

#import "JRServiceOption.h"
#import <jarvis_utility_ios/jarvis_utility_ios-Swift.h>
@implementation JRServiceOption
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
  //  self.label = ([dictionary[@"label"] isBlank] || [dictionary[@"label"] isNull]) ? nil : dictionary[@"label"];
    self.message = ([dictionary[@"message"] isBlank] || [dictionary[@"message"] isNull]) ? nil : dictionary[@"message"];
    id billAmount = dictionary[@"billAmount"];
    if ([billAmount isKindOfClass:[NSString class]] && [billAmount isBlank] == false && [billAmount isNull] == false) {
        self.billAmount = billAmount;
    } else if ([billAmount isKindOfClass:[NSNumber class]]) {
        self.billAmount = [billAmount stringValue];
    }
 //  self.okButton = ([dictionary[@"okButton"] isBlank] || [dictionary[@"okButton"] isNull]) ? nil : dictionary[@"okButton"];
  //  self.title = ([dictionary[@"title"] isBlank] || [dictionary[@"title"] isNull]) ? nil : dictionary[@"title"];
}

@end
