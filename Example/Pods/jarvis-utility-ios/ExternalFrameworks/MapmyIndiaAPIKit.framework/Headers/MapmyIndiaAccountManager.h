#import <Foundation/Foundation.h>

#import "MMIRegionType.h"
#import "MapmyIndiaDistanceUnit.h"
//#import "MGLFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The MapmyIndiaAccountManager object provides a global way to set a Mapbox API access
 token.
 */

@interface MapmyIndiaAccountManager : NSObject

#pragma mark Authorizing Access

/**
 Set the
 <a href="http://www.mapmyindia.com/api/login/">MapmyIndia API Keys</a>
 to be used by all instances of MGLMapView in the current application.

 Mapbox-hosted vector tiles and styles require an API access token, which you
 can obtain from the
 <a href="http://www.mapmyindia.com/api/login/">MapmyIndia API Keys</a>.
 API Keys associate requests to MapmyIndia’s vector tile and style APIs with
 your MapmyIndia account. They also deter other developers from using your styles
 without your permission.

 @param mapSDKKey A Mapbox access token. Calling this method with a value of
    `nil` has no effect.

 @note You must set the mapSDKKey before attempting to load any MapmyIndia-hosted
    style. Therefore, you should generally set it before creating an instance of
    MGLMapView. The recommended way to set an mapSDKKey is to add an entry to
    your application’s Info.plist file with the key `MapmyIndiaSDKKey` and
    the type String. Alternatively, you may call this method from your
    application delegate’s `-applicationDidFinishLaunching:` method.
 */
+ (void)setMapSDKKey:(nullable NSString *)mapSDKKey;

+ (void)setRestAPIKey:(nullable NSString *)restAPIKey;

+ (void)setAtlasClientId:(nullable NSString *)atlasClientId;

+ (void)setAtlasClientSecret:(nullable NSString *)atlasClientSecret;

+ (void)setAtlasGrantType:(nullable NSString *)atlasGrantType;

+ (void)setAtlasAPIVersion:(nullable NSString *)atlasAPIVersion;

+ (void)setTileEncryptionEnabled:(BOOL)tileEncryptionEnabled;

+ (void)setDefaultDistanceUnit:(MapmyIndiaDistanceUnit)defaultDistanceUnit;

+ (void)setDefaultRegion:(MMIRegionTypeIdentifier)defaultRegion;

//+ (void)initializeSDK:(nullable void (^)(bool success, NSError * _Nullable error))completionHandler;

/**
 Returns the
 <a href="http://www.mapmyindia.com/api/login/">MapmyIndia API Keys</a>
 in use by instances of MGLMapView in the current application.
 */
+ (nullable NSString *)mapSDKKey;

+ (nullable NSString *)restAPIKey;

+ (nullable NSString *)atlasClientId;

+ (nullable NSString *)atlasClientSecret;

+ (nullable NSString *)atlasGrantType;

+ (nullable NSString *)atlasAPIVersion;

+ (BOOL)tileEncryptionEnabled;

+ (MapmyIndiaDistanceUnit)defaultDistanceUnit;

+ (MMIRegionTypeIdentifier)defaultRegion;

@end

NS_ASSUME_NONNULL_END
