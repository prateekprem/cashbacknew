//
//  NSObject+SafeKVC.m
//  iAccount
//
//  Created by Sahana Kini on 31/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "NSObject+SafeKVC.h"

@implementation NSObject (SafeKVC)


- (id)valueForKey:(NSString *)key ofClass:(Class)class
{
    if ([self respondsToSelector:@selector(objectForKey:)] ||
        [self respondsToSelector:NSSelectorFromString(key)])
    {
        id value = [self valueForKey:key];
        return ([value isKindOfClass:class ?: [NSObject class]])? value: nil;
    }
    return nil;
}

- (id)valueForKeyPath:(NSString *)keyPath ofClass:(Class)class
{
    id value = [self valueForKeyPath:keyPath];
    return ([value isKindOfClass:class ?: [NSObject class]])? value: nil;
}

- (NSString *)stringForKey:(NSString *)key
{
    return [self valueForKey:key ofClass:[NSString class]] ?: @"";
}

- (NSString *)stringForKeyPath:(NSString *)keyPath
{
    return [self valueForKeyPath:keyPath ofClass:[NSString class]] ? : @"";
}

- (NSNumber *)numberForKey:(NSString *)key
{
    double val =  [self doubleForKey:key];
    return [NSNumber numberWithDouble:val];
}

- (NSString *)nonEmptyStringForKey:(NSString *)key
{
    NSString *string = [self stringForKey:key];
    return ([string length])? string: nil;
}

- (NSArray *)arrayForKey:(NSString *)key
{
    return [self valueForKey:key ofClass:[NSArray class]];
}

- (double)doubleForKey:(NSString *)key
{
    id value = [self valueForKey:key ofClass:nil];
    if ([value respondsToSelector:@selector(doubleValue)])
    {
        return [value doubleValue];
    }
    return 0.0;
}


- (double)doubleForKeyPath:(NSString *)key
{
    id value = [self valueForKeyPath:key ofClass:nil];
    if ([value respondsToSelector:@selector(doubleValue)])
    {
        return [value doubleValue];
    }
    return 0.0;
}


- (float)floatForKey:(NSString *)key
{
    id value = [self valueForKey:key ofClass:nil];
    if ([value respondsToSelector:@selector(floatValue)])
    {
        return [value floatValue];
    }
    return 0.0f;
}

- (int)intForKey:(NSString *)key
{
    id value = [self valueForKey:key ofClass:nil];
    if ([value respondsToSelector:@selector(intValue)])
    {
        return [value intValue];
    }
    return 0;
}


- (int)intForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath ofClass:nil];
    
    if ([value respondsToSelector:@selector(intValue)])
    {
        return [value intValue];
    }
    return 0;

}

@end
