//
//  JRFilter.h
//  Jarvis
//
//  Created by Mahadev Prabhu on 14/11/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JRFilterValue;

typedef enum
{
    JRFilterTypeDefault,
    JRFilterTypeRectangular,
    JRFilterTypeCircular,
    JRFilterTypeList,
    JRFilterTypeSlider,
    JRFilterTypeSwitch,
    JRFilterTypeLinearRectangular,
    JRFilterTypeLinearRectangularRadio,
    JRFilterTypeCategoryTree,
    JRFilterTypeUnknown,
    JRFilterTypeDepartureTime,
    JRFilterTypeArrivalTime,
    JRFilterTypeBusType,
    JRFilterTypeBusAxle,
    JRFilterTypeBusBrand,
    JRFilterTypeBusRating,
    JRFilterTypeBusCancellable,
    JRFilterTypeBoardingPoints,
    JRFilterTypeDroppingPoints,
    JRFilterTypeBusOperators,
    JRFilterTypeBusAmenities,
    JRFilterTypeBusOperatorTags,
    JRFilterTypeBusDeals,
    JRFilterTypeBusRouteTimeID,
    JRFilterTypeBusSocialDistancing,
    
    JRFilterTypeHotelSort,
    JRFilterTypeHotelRating,
    JRFilterTypeHotelListing,
    JRFilterTypeHotelId,    
    JRFilterTypeFlightPrice,
    JRFilterTypeFlightRefundable,
    JRFilterTypeFlightDuration,
    JRFilterTypeFlightAirlines,
    JRFilterTypeFlightProvider,
    JRFilterTypeFlightStops,
    JRFilterSearchBar,
    JRFlightFilterTypeDeparture
}JRFilterType;

extern const NSInteger MaxNumberOfItems;

@interface JRFilter : NSObject<NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *displayValue;
@property (nonatomic, assign) JRFilterType filterType;
@property (nonatomic, strong) NSArray <JRFilterValue *>*values;
@property (nonatomic, copy) NSString *filterParam;
@property (nonatomic, copy) NSString *externalLinkTitle;
@property (nonatomic, copy) NSString *externalLinkURL;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSArray *appliedFilters;
@property (nonatomic, strong) NSDictionary *appliedRange; // this is only for range filters like price
@property (nonatomic, strong) NSArray *searchResultValues; // 
@property (nonatomic, assign) BOOL searchEnabled;
@property (nonatomic, assign) BOOL isSearchTextEmpty;

@property (nonatomic, strong) NSArray *treeSearchResultFilterValues;
@property (nonatomic) float selectedMinPrice;
@property (nonatomic) float selectedMaxPrice;

- (void)setWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionaryWithNoAppliedRange:(NSDictionary *)dictionary;
- (id)initWithDictionaryWithSelectedFilterValue:(NSDictionary *)dictionary;
- (JRFilter *)filterForSelectedValues:(NSArray *)values;
- (BOOL)anySelectedValues;
- (NSString *)urlFormatForSelectedValues;
- (void)selectDefaultRangeFilter;
- (NSArray *)selectedFilters;
- (BOOL) isSearchOptionAvailable;
- (NSArray *)filterValuesMatchingWithString:(NSString *)searchText;
- (NSArray *)treeFilterValuesMatchingWithString:(NSString *)searchText;
- (NSArray *)treeFilterValuesMatchingWithString:(NSString *)searchText inFilterValue:(JRFilterValue *)filterValue;
- (BOOL)shouldSupportExpand;

+ (BOOL)isAnyFilterSelectedInFilters:(NSArray *)filterList;

+ (NSArray *)walletPassbookFilters;

@end
