//
//  JRUtilities.m
//  Jarvis
//
//  Created by Rajan Kumar Tiwari on 04/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <sys/utsname.h>
#import "JRUtilities.h"
#import <jarvis_utility_ios/NSString+AES.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#import <jarvis_common_ios/jarvis_common_ios-Swift.h>

#define AES128_KEY @"1234567890123456"

struct utsname systemInfo;

@implementation JRUtilities

+ (JRDeviceType)getDeviceType
{
    JRDeviceType deviceType = JRDeviceTypeNone;
    
    CGFloat mainScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    switch (((int)(mainScreenHeight))) {
        case 480:
            deviceType = JRDeviceTypeiPhone4S;
            break;
        case 568:
            deviceType = JRDeviceTypeiPhone5Series;
            break;
        case 667:
            deviceType = JRDeviceTypeiPhone6;
            break;
        case 736:
            deviceType = JRDeviceTypeiPhone6Plus;
            break;
        case 812:
            deviceType = JRDeviceTypeiPhoneX;
            break;
        default:
            deviceType = JRDeviceTypeiPhoneLessThan4s;
            break;
    }
    
    return deviceType;
}

+(BOOL)isDeviceIPhoneX
{
    if([JRUtilities getDeviceType] == JRDeviceTypeiPhoneX)
    {
        return YES;
    }
    return NO;
}

+ (UIInterfaceOrientation)currentDeviceOrientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)object cancelButton:(NSString*)cancelButtonTitle otherButton:(NSString*)otherButtonTitle
{
   
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [JRCommonManager.shared.navigation presentWithViewController:alert animated:true completion:nil];
}

+ (NSString*)getFloatFormatedValue:(float)value
{
    NSString *formateSpecifier = (value - (int)value > 0.0) ? @"%.2f" : @"%.0f";
    return [NSString stringWithFormat:formateSpecifier,value];;
}

+ (NSString*)alwaysFloatFormatedValue:(float)value
{
    return [NSString stringWithFormat: @"%.2f",value];;
}

+ (BOOL)isNetworkReachable
{
    return [JRNetworkUtilityObjc isNetworkReachable];
}

+ (BOOL)isNetworkConnectionAvailable
{
    return [JRNetworkUtilityObjc isNetworkReachable];
}

#pragma mark - Deep Linking Supporter

+ (BOOL)isProductTypePaytmCash:(NSInteger)productID
{
    BOOL productTypePaytmCash = NO;
    if (JRRemoteConfHelper.PaytmCashProductID.intValue == productID || JRRemoteConfHelper.PaytmPaymentBankProductID.intValue == productID)
    {
        productTypePaytmCash = YES;
    }
    return productTypePaytmCash;
}

+ (BOOL)isValidDeeplinkUrl:(NSString *)deeplinkUrl
{
    if ([deeplinkUrl hasPrefix:@"paytmmall://"] || [deeplinkUrl hasPrefix:@"paytmmp://"] || [deeplinkUrl hasPrefix:@"upi://"] || [deeplinkUrl hasPrefix:@"https://qr.paytm.in"] || [deeplinkUrl hasPrefix:@"https://secure.paytm.in"] || [deeplinkUrl hasPrefix:@"https://securegw.paytm.in"] || [deeplinkUrl hasPrefix:@"paytm://"]) {
        return YES;
    }
    
    BOOL isValid = NO;
    NSString *regex1 = @"(https?:\\/\\/(?:www\\.|(?!www))(([a-zA-Z]*\\.)|())(paytm.com)|www\\.(paytm.com))";
    NSString *regex2 = @"(https?:\\/\\/(?:www\\.|(?!www))(([a-zA-Z]*\\.)|())(paytmmall.com)|www\\.(paytmmall.com))";
    // for insurance
    NSString *regex3 = @"(https?:\\/\\/(?:www\\.|(?!www))(([a-zA-Z]*\\.)|())(paytminsurance.co.in)|www\\.(paytminsurance.co.in))";

    if ([JRUtility doesWithTheString:deeplinkUrl matchesRegularExpression:regex1] || [JRUtility doesWithTheString:deeplinkUrl matchesRegularExpression:regex2] || [JRUtility doesWithTheString:deeplinkUrl matchesRegularExpression:regex3]) {
        isValid = YES;
    }
    
    if (!isValid) {
        NSArray<NSString *> *whitelistedDeeplinkUrls = [JRRemoteConfHelper getWhiteListedDeeplinkUrls];
        for (NSString *url in whitelistedDeeplinkUrls) {
            if ([deeplinkUrl hasPrefix:url]) {
                isValid = YES;
                break;
            }
        }
    }
    
    return isValid;
}

+ (void)navigateToPaytmWithDeeplinkUrl:(NSString *)deeplinkUrl
{
    NSURL *url = [NSURL URLWithString:deeplinkUrl];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        if (!success) {
            NSURL *url = [NSURL URLWithString:JRPaytmAppStoreUrl];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
}

+ (void)setApperarence
{
}

+(NSString *)getDecryptedStringFromAES256:(NSString *)encryptedString key:(NSString*)keyString iv:(NSString*)initializationVector{
    return [encryptedString AES256DecryptWithKey:keyString andIV:initializationVector];
}


+(NSString *)getEncryptedStringFromAES256:(NSString *)plainString key:(NSString*)keyString iv:(NSString*)initializationVector{
    return [plainString AES256EncryptWithKey:keyString andIV:initializationVector];
}

+(NSString *)getDecryptedString:(NSString *)encryptedString{
    return [encryptedString AES128DecryptWithKey:AES128_KEY];
}

+(NSString *)getEncryptedString:(NSString *)plainString{
    return [plainString AES128EncryptWithKey:AES128_KEY];
}


+(NSAttributedString*)fetchOfferTerms:(NSString*)terms
{
    NSString *initial = terms;
    NSString *text = [initial stringByReplacingOccurrencesOfString:@"*" withString:@"●  "];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(●  )" options:kNilOptions error:nil];
    
    
    NSRange range = NSMakeRange(0,text.length);
    
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setParagraphSpacing:4];
    [paragrahStyle setParagraphSpacingBefore:3];
    [paragrahStyle setFirstLineHeadIndent:0.0f];  // First line is the one with bullet point
    [paragrahStyle setHeadIndent:20.0f];    // Set the indent for given bullet character and size font
    
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:14],
                               NSForegroundColorAttributeName : [UIColor colorRGB:226 green:235 blue:238],
                               NSParagraphStyleAttributeName : paragrahStyle
                               };
    
    [regex enumerateMatchesInString:text options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttributes:attrDict range:subStringRange];
    }];
    
    return mutableAttributedString;

}

+ (NSString *)hmvString
{
    NSString *platformString = [JRUtility platformString];
    NSMutableArray *platformStringArray = [[platformString componentsSeparatedByString:@" "] mutableCopy];
    if (platformStringArray) {
        if (platformStringArray.count)
        {
            [platformStringArray removeObjectAtIndex:0];
            platformString = [platformStringArray componentsJoinedByString:@""];
        }
    }
    return (platformString&&platformString.length>0)?platformString:@"";
}

+ (NSString*) appSchemeURL {
    NSString* appScheme = @"paytmmp";
#if PAYTM_MALL
    appScheme = @"paytmmall";
#endif
    
    return appScheme;
}

+ (NSString *)appStoreUpdateURL {
#if PAYTM_MALL
    return @"https://itunes.apple.com/in/app/paytm-mall-bazaar/id1157845438?mt=8";
#else
    return @"https://itunes.apple.com/in/app/paytm-recharge-bill-payments/id473941634?mt=8";
#endif
}

+ (Boolean) isAppSchemeTypeURL:(NSString*)urlString {
    return [urlString.lowercaseString containsString:[self appSchemeURL]];
}

+ (BOOL)isValidGSTIN:(NSString *)gstInString
{
    NSString *gstInRegex = @"^\\d{2}[A-Z]{5}\\d{4}[A-Z]{1}[A-Z\\d]{1}[Z]{1}[A-Z\\d]{1}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gstInRegex];
    
    return [predicate evaluateWithObject: gstInString];
}


+(BOOL) isValidPaytmSmartLink:( NSString * _Nullable )smartLink {
    if(smartLink == nil || smartLink.length == 0) {
        return false;
    }
    BOOL valid = false;
    if([smartLink hasPrefix:@"http://m.p-y.tm"]
       || [smartLink hasPrefix:@"https://m.p-y.tm"]
       || [smartLink hasPrefix:@"http://p-y.tm"]) {
        valid = true;
    }
    
    return valid;
}

+(BOOL) isValidPaytmMallSmartLink:( NSString * _Nullable )smartLink {
    if(smartLink == nil || smartLink.length == 0) {
        return false;
    }
    BOOL valid = false;
    if([smartLink hasPrefix:@"http://pytm.ml"]
       || [smartLink hasPrefix:@"https://pytm.ml"]) {
        valid = true;
    }

    return valid;
}
/*
 * Added temporarily to support objective c files
 * New method is in JRUtility.swift
 * This method is only being used in objective c files, Once converted to swift please use new method from JRUtility
 */

+ (NSString *)updatedStringOfText:(NSString *)text afterChangingCharactersInrange:(NSRange)range replacementString:(NSString *)string
{
    NSString *finalString = [JRUtility strippedStringOfString:string];
    
    //The case of copy-pasting a number from the phonebook
    NSString *updatedText  = nil;
    if (finalString) {
        updatedText = [text stringByReplacingCharactersInRange:range withString:finalString];
    }
    
    else {
        updatedText = [text stringByReplacingCharactersInRange:range withString:string];
    }
    if (![updatedText hasPrefix:JRPrefixCountryCode])
    {
        updatedText = [NSString stringWithFormat:@"%@%@", JRPrefixCountryCode, updatedText];
    }
    
    return updatedText;
}

@end
