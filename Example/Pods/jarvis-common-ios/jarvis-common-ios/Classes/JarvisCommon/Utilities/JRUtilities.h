//
//  JRUtilities.h
//  Jarvis
//
//  Created by Rajan Kumar Tiwari on 04/09/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, JRDeviceType)
{
    JRDeviceTypeiPhone4S,
    JRDeviceTypeiPhone5Series,
    JRDeviceTypeiPhone6,
    JRDeviceTypeiPhone6Plus,
    JRDeviceTypeiPhoneX,
    JRDeviceTypeiPhoneLessThan4s,
    JRDeviceTypeNone = -1
};

@interface JRUtilities : NSObject

+ (JRDeviceType)getDeviceType;
+ (UIInterfaceOrientation)currentDeviceOrientation;
+ (BOOL)isNetworkReachable;
+ (BOOL)isNetworkConnectionAvailable;

+ (NSString*)getFloatFormatedValue:(float)value;
+ (NSString*)alwaysFloatFormatedValue:(float)value;
+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)object cancelButton:(NSString*)cancelButtonTitle otherButton:(NSString*)otherButtonTitle;

// limited in use
+ (BOOL)isProductTypePaytmCash:(NSInteger)productID;
+ (BOOL)isValidDeeplinkUrl:(NSString *)deeplinkUrl;
+ (void)navigateToPaytmWithDeeplinkUrl:(NSString *)deeplinkUrl;
+ (void)setApperarence;
// ---


+ (NSString *)getDecryptedStringFromAES256:(NSString *)encryptedString key:(NSString*)keyString iv:(NSString*)initializationVector;

+ (NSString *)getEncryptedStringFromAES256:(NSString *)plainString key:(NSString*)keyString iv:(NSString*)initializationVector;

+ (NSString *)getDecryptedString:(NSString *)encryptedString;
+ (NSString *)getEncryptedString:(NSString *)plainString;

+ (NSAttributedString*)fetchOfferTerms:(NSString*)terms;

+ (NSString *)hmvString;

+ (NSString*)appSchemeURL;
+ (NSString *)appStoreUpdateURL;
+ (Boolean)isAppSchemeTypeURL:(NSString*)urlString;
+ (BOOL)isValidGSTIN:(NSString *)gstInString;

+ (BOOL)isDeviceIPhoneX;

+ (NSString*)uaKeyProd;
+ (NSString*)uaSecretProd;
+ (NSString*)uaKeyDev;
+ (NSString*)uaSecretDev;


+ (NSString *)updatedStringOfText:(NSString *)text
   afterChangingCharactersInrange:(NSRange)range
                replacementString:(NSString *)string;

+ (BOOL)isValidPaytmMallSmartLink:( NSString * _Nullable )smartLink;
+ (BOOL)isValidPaytmSmartLink:( NSString * _Nullable )smartLink;

@end
