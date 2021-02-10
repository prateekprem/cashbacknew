#import <Foundation/Foundation.h>

#pragma mark - Specifying the Region Type Profile

/**
 Options determining the primary mode of transportation for the routes.
 */
typedef NSString * MMIPodTypeIdentifier NS_EXTENSIBLE_STRING_ENUM;


extern MMIPodTypeIdentifier const MMIPodTypeIdentifierNone;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierSublocality;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierLocality;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierCity;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierVillage;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierSubdistrict;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierDistrict;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierState;

extern MMIPodTypeIdentifier const MMIPodTypeIdentifierSubSubLocality;
