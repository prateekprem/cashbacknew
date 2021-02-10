//
//  NSObject+SafeKVC.h
//  iAccount
//
//  Created by Sahana Kini on 31/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//This category ensures to return a safe value if the required key value is not
//found in the container such as a dictionary. For instance, it ensures to return nil, if an
//object is missing, or a 0 if an integer value is missing, etc.

@interface NSObject (SafeKVC)


- (id)valueForKey:(NSString *)key ofClass:(Class)class;
- (id)valueForKeyPath:(NSString *)keyPath ofClass:(Class)class;

- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKeyPath:(NSString *)keyPath;
- (NSString *)nonEmptyStringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (double)doubleForKeyPath:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (int)intForKeyPath:(NSString *)keyPath;
- (NSNumber *)numberForKey:(NSString *)key;

@end
