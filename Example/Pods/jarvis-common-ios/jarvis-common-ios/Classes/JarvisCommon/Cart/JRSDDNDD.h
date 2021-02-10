//
//  JRSDDNDD.h
//  Jarvis
//
//  Created by Ayush Goel on 04/05/17.
//  Copyright © 2017 One97. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JRSDDNDDType) {
    JRSDDNDDType_STANDARD = 0,
    JRSDDNDDType_SDD,
    JRSDDNDDType_NDD
};

@interface JRSDDNDD : NSObject

@property (nonatomic, assign) BOOL isPFA;
@property (nonatomic, copy) NSString *deliveryText;
@property (nonatomic, assign) JRSDDNDDType deliveryType;
@property (nonatomic, copy) NSString *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

