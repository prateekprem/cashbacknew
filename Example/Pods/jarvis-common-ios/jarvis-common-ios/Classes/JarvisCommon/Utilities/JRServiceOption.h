//
//  JRServiceOption.h
//  Jarvis
//
//  Created by Chaithra T V on 07/08/15.
//  Copyright (c) 2015 One97. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRServiceOption : NSObject

//@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *billAmount;
//@property (nonatomic, copy) NSString *okButton;
//@property (nonatomic, copy) NSString *title;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)setWithDictionary:(NSDictionary *)dictionary;

@end
