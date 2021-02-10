//
//  JROrderSummaryTransactionDetails.h
//  Jarvis
//
//  Created by Rajan Kumar Tiwari on 20/01/14.
//  Copyright (c) 2014 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JROrderSummaryTransactionDetails : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *type;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)setWithDictionary:(NSDictionary *)dictionary;


@end
