#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, MMIDistanceVehicleType) {
    /// For Quickest Route
    MMIDistanceVehicleTypePassenger = (1 << 0),
    
    /// For Shortest Route
    MMIDistanceVehicleTypeTaxi = (1 << 1),
    
    MMIDistanceVehicleTypeNone = (1 << 2)
};
