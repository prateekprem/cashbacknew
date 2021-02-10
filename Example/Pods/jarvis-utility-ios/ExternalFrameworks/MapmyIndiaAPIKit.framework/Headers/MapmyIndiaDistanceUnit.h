#import <Foundation/Foundation.h>

#pragma mark - Specifying the Distance Unit Profile

typedef NS_OPTIONS(NSUInteger, MapmyIndiaDistanceUnit) {
    MapmyIndiaDistanceUnitAutomatic = (1 << 0),
    
    MapmyIndiaDistanceUnitKilometer = (1 << 1),
    
    MapmyIndiaDistanceUnitMiles = (1 << 2),
};
