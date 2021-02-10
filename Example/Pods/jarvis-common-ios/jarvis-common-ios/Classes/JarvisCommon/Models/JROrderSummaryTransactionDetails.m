//
//  JROrderSummaryTransactionDetails.m
//  Jarvis
//
//  Created by Rajan Kumar Tiwari on 20/01/14.
//  Copyright (c) 2014 Robosoft. All rights reserved.
//

#import "JROrderSummaryTransactionDetails.h"
#import <jarvis_utility_ios/jarvis_utility_ios-Swift.h>

@implementation JROrderSummaryTransactionDetails

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		[self setWithDictionary:dictionary];
	}
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dictionary
{
    self.title = [dictionary[@"title"] isNull] ? @"" :dictionary[@"title"];
    self.value = [dictionary[@"value"] isNull] ? @"" :dictionary[@"value"];
    self.type = [dictionary[@"type"] isNull] ? @"" :dictionary[@"type"];
}


@end
