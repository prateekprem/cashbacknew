#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, MMIDistanceAvoidsType) {
    
    MMIDistanceAvoidsTypeAvoidToll = (1 << 1),
    
    MMIDistanceAvoidsTypeAvoidFerries = (1 << 2),
    
    MMIDistanceAvoidsTypeAvoidUnpaved = (1 << 6),
    
    MMIDistanceAvoidsTypeAvoidHighways = (1 << 10),
    
    MMIDistanceAvoidsTypeNone = (1 << 11)
};
