//
//  JRFilter.m
//  Jarvis
//
//  Created by Mahadev Prabhu on 14/11/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import "JRFilter.h"
#import "JRFilterValue.h"
#import <jarvis_utility_ios/jarvis_utility_ios-Swift.h>

const NSInteger MaxNumberOfItems = 20;

@implementation JRFilter

- (instancetype)copyWithZone:(NSZone *)zone
{
    JRFilter *filter = [[[self class] allocWithZone:zone]init];
    filter.title = [_title copyWithZone:zone];
    filter.displayValue = [_displayValue copyWithZone:zone];
    [filter setValues:self.values];
    filter.filterParam = [_filterParam copyWithZone:zone];
    filter.externalLinkTitle = [_externalLinkTitle copyWithZone:zone];
    filter.externalLinkURL = [_externalLinkURL copyWithZone:zone];
    filter.identifier = [_identifier copyWithZone:zone];
    filter.appliedFilters = [_appliedFilters copyWithZone:zone];
    filter.appliedRange = [_appliedRange copyWithZone:zone];
    filter.searchResultValues = [_searchResultValues copyWithZone:zone];
    filter.treeSearchResultFilterValues = [_treeSearchResultFilterValues copyWithZone:zone];
    [filter setFilterType:self.filterType];
    [filter setSelected:self.selected];
    [filter setSearchEnabled:self.searchEnabled];
    [filter setIsSearchTextEmpty:self.isSearchTextEmpty];
    [filter setSelectedMinPrice:self.selectedMinPrice];
    [filter setSelectedMaxPrice:self.selectedMaxPrice];
    return filter;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    JRFilter *filter = [[[self class] allocWithZone:zone] init];
    filter.title = [_title mutableCopyWithZone:zone];
    filter.displayValue = [_displayValue mutableCopyWithZone:zone];
    filter.values = [_values mutableCopyWithZone:zone];
    filter.filterParam = [_filterParam mutableCopyWithZone:zone];
    filter.externalLinkTitle = [_externalLinkTitle mutableCopyWithZone:zone];
    filter.externalLinkURL = [_externalLinkURL mutableCopyWithZone:zone];
    filter.identifier = [_identifier mutableCopyWithZone:zone];
    filter.appliedFilters = [_appliedFilters mutableCopyWithZone:zone];
    filter.appliedRange = [_appliedRange mutableCopyWithZone:zone];
    filter.searchResultValues = [_searchResultValues mutableCopyWithZone:zone];
    filter.treeSearchResultFilterValues = [_treeSearchResultFilterValues mutableCopyWithZone:zone];
    return filter;
}

- (void)setWithDictionary:(NSDictionary *)dictionary needAppliedRange:(BOOL)value needSelectedFilter:(BOOL)needSelectedFilter
{
    self.title = [dictionary[@"title"] validObjectValue];
    self.displayValue = [dictionary[@"display_value"] validObjectValue];
    self.filterParam = [dictionary[@"filter_param"] validObjectValue];
    self.filterType = [self typeForTypeString:[dictionary[@"type"] validObjectValue]];
    self.identifier = [self cellIdentifierForFilterType:self.filterType];
    NSMutableArray *array1 = [NSMutableArray array];

    for (NSDictionary *filterdic in [dictionary[@"applied"] validObjectValue])
    {
        JRFilterValue *val = [[JRFilterValue alloc] initWithDictionary:filterdic needSelectedFilter:needSelectedFilter level: 0];
        val.filter = self;
        self.selected = true;
        [array1 addObject:val];
    }
    self.appliedFilters = array1;
    if (value)
    {
    self.appliedRange = (dictionary[@"applied_range"] && [dictionary[@"applied_range"] count]> 0) ? dictionary[@"applied_range"] : nil; //[NSDictionary dictionaryWithObjectsAndKeys:@"10",@"min",@"100",@"max", nil];
    }
    
    NSMutableArray *array0 = [NSMutableArray array];

    if (self.filterType == JRFilterTypeSlider)
    {
        NSArray *value = [dictionary[@"values"] validObjectValue];

        if ([value respondsToSelector:@selector(count)] && value.count > 0)
        {
            NSDictionary *priceDictionary = [value firstObject];
            JRFilterValue *priceVal = [[JRFilterValue alloc] init];
            
            priceVal.filter = self;
            priceVal.name = self.title;
            priceVal.minPrice = [[([priceDictionary[@"min"] validObjectValue]) stringValue] floatValue];
            priceVal.maxPrice = [[([priceDictionary[@"max"] validObjectValue]) stringValue]floatValue];
            priceVal.filterValuePrefix = [priceDictionary[@"filter_value_prefix"] validObjectValue] ? [priceDictionary[@"filter_value_prefix"] validObjectValue] : @"";
            
            priceVal.filterValueSuffix = [priceDictionary[@"filter_value_suffix"] validObjectValue] ? [priceDictionary[@"filter_value_suffix"] validObjectValue] : @"";
            
            [array0 addObject:priceVal];
            self.values = array0;
            
            //set default filter if any
            [self selectDefaultRangeFilter];
        }
    }
    else
    {
        NSArray *values = [dictionary[@"values"] validObjectValue];
        if ([values isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *filterdic in values)
            {
                JRFilterValue *val = [[JRFilterValue alloc] initWithDictionary:[filterdic validObjectValue] needSelectedFilter:needSelectedFilter level: 0];
                val.filter = self;
                if (self.filterType != JRFilterTypeSwitch) {

                NSInteger index = [self.appliedFilters indexOfObjectPassingTest:^BOOL(JRFilterValue *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    *stop = [obj.filterId isEqualToString:val.filterId];
                    return *stop;
                }];
                val.selected = (index != NSNotFound);
                }
                [array0 addObject:val];
            }
        }
        else if([values isKindOfClass:[NSDictionary class]])
        {
            JRFilterValue *val = [[JRFilterValue alloc] initWithDictionary:(NSDictionary *)values andFilter:self level: 0];
            val.filter = self;
            if (self.filterType != JRFilterTypeSwitch) {
            NSInteger index = [self.appliedFilters indexOfObjectPassingTest:^BOOL(JRFilterValue *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                *stop = [obj.filterId isEqualToString:val.filterId];
                return *stop;
            }];
                val.selected = (index != NSNotFound);
            }
            [array0 addObject:val];
        }
        
        if (needSelectedFilter) {
            self.values = [array0 sortedArrayUsingComparator:^NSComparisonResult(JRFilterValue *obj1, JRFilterValue *obj2) {
                return obj1.name > obj2.name;
            }];
        }
        else {
            self.values = array0;
        }
        //set default filter if any
        [self selectDefaultfilters];
    }
    
}

- (void)setWithDictionary:(NSDictionary *)dictionary
{
    [self setWithDictionary:dictionary needAppliedRange:YES needSelectedFilter:false];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		[self setWithDictionary:dictionary needAppliedRange:YES needSelectedFilter:false];
	}
    return self;
}

- (id)initWithDictionaryWithNoAppliedRange:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        [self setWithDictionary:dictionary needAppliedRange:NO needSelectedFilter:false];
    }
    return self;
}

- (id)initWithDictionaryWithSelectedFilterValue:(NSDictionary *)dictionary {
    
    if (self = [super init])
    {
        [self setWithDictionary:dictionary needAppliedRange:NO needSelectedFilter:true];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = [decoder decodeObjectForKey:@"title"];
    self.displayValue = [decoder decodeObjectForKey:@"displayValue"];
    self.filterType = (int)[decoder decodeIntegerForKey:@"filterType"];
    self.values = [decoder decodeObjectForKey:@"values"];
    self.filterParam = [decoder decodeObjectForKey:@"filterParam"];
    self.externalLinkTitle = [decoder decodeObjectForKey:@"externalLinkTitle"];
    self.externalLinkURL = [decoder decodeObjectForKey:@"externalLinkURL"];
    self.identifier = [decoder decodeObjectForKey:@"identifier"];

    self.selected = [decoder decodeBoolForKey:@"selected"];

    self.appliedFilters = [decoder decodeObjectForKey:@"appliedFilters"];
    self.appliedRange = [decoder decodeObjectForKey:@"appliedRange"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.displayValue forKey:@"displayValue"];
    [encoder encodeInteger:self.filterType forKey:@"filterType"];
    [encoder encodeObject:self.values forKey:@"values"];
    [encoder encodeObject:self.filterParam forKey:@"filterParam"];
    [encoder encodeObject:self.externalLinkTitle forKey:@"externalLinkTitle"];
    [encoder encodeObject:self.externalLinkURL forKey:@"externalLinkURL"];
    [encoder encodeObject:self.identifier forKey:@"identifier"];

    [encoder encodeBool:self.selected forKey:@"selected"];
    
    [encoder encodeObject:self.appliedFilters forKey:@"appliedFilters"];
    [encoder encodeObject:self.appliedRange forKey:@"appliedRange"];

}

#pragma mark - Helper Methods

- (JRFilterType)typeForTypeString:(NSString *)str
{
    
    if ([str.lowercaseString isEqualToString:@"rectangular"]) return JRFilterTypeRectangular;
    else if ([str.lowercaseString isEqualToString:@"range-slider"]) return JRFilterTypeSlider;
    else if ([str.lowercaseString isEqualToString:@"circular"]) return JRFilterTypeCircular;
    else if ([str.lowercaseString isEqualToString:@"boolean"]) return JRFilterTypeSwitch;
    else if ([str.lowercaseString isEqualToString:@"list"]) return JRFilterTypeList;
    else if ([str.lowercaseString isEqualToString:@"linear-rectangular"]) return JRFilterTypeLinearRectangular;
    else if ([str.lowercaseString isEqualToString:@"tree"]) return JRFilterTypeCategoryTree;
    else if ([str.lowercaseString isEqualToString:@"linear-rectangular-radio"]) return JRFilterTypeLinearRectangularRadio;

    return JRFilterTypeUnknown;
}

- (NSString *)cellIdentifierForFilterType:(JRFilterType)filterType
{
    if (filterType == JRFilterTypeSlider) return @"PriceCell";
    else if (filterType == JRFilterTypeSwitch) return @"SwitchCell";
    else if (filterType == JRFilterTypeRectangular) return @"ColorCell";
    else if (filterType == JRFilterTypeCircular) return @"SizeCell";
    else if (filterType == JRFilterTypeLinearRectangular) return @"BrandCell";
    else if (filterType == JRFilterTypeList) return @"DefaultCell";
    else if (filterType == JRFilterTypeCategoryTree) return @"TreeCell";
    else if (filterType == JRFilterTypeHotelSort) return @"SortCell";
    else if (filterType == JRFilterTypeLinearRectangularRadio) return @"BrandCell";

    return @"UnknownCell";
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (!selected)
    {
        for (JRFilterValue *fv in self.values)
        {
            fv.selected = selected;
        }
    }
}

- (BOOL)anySelectedValues
{
    if (self.selected)
    {
        for (JRFilterValue *fv in self.values)
        {
            if (self.filterType == JRFilterTypeCategoryTree)
            {
                return [self itirateWithItems:fv.categories];
            }
            if (fv.selected)
            {
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray* )selectedFilters
{
    NSMutableArray *selectedFilters = [NSMutableArray array];
    if (self.selected)
    {
        for (JRFilterValue *fv in self.values)
        {
            if (self.filterType == JRFilterTypeCategoryTree)
            {
                [self itirateWithItems:fv.categories resultArray:selectedFilters];
            }
            if (fv.selected)
            {
                [selectedFilters addObject:fv];
            }
        }
    }
    return selectedFilters;

}

- (BOOL)itirateWithItems:(NSArray *)items
{
    NSInteger index = [items indexOfObjectPassingTest:^BOOL(JRFilterValue *obj, NSUInteger idx, BOOL *stop) {
        
        if (obj.selected)
        {
            *stop = YES;
        }
        else
        {
            *stop = [self itirateWithItems:obj.categories];
        }
        return *stop;
    }];
    
    if (index != NSNotFound)
    {
        return YES;
    }
    return NO;
}

- (void)itirateWithItems:(NSArray *)items resultArray:(NSMutableArray *)resultArray
{
    
    [items indexOfObjectPassingTest:^BOOL(JRFilterValue *obj, NSUInteger idx, BOOL *stop)
     {
         [self itirateWithItems:obj.categories resultArray:resultArray];
         if (obj.selected)
         {
             [resultArray addObject:obj];
         }
         return NO;
     }];
}

- (JRFilter *)filterForSelectedValues:(NSArray *)values
{
    JRFilter *selectedFilter = [[JRFilter alloc]init];
    selectedFilter.title = self.title;
    selectedFilter.filterType = self.filterType;
    selectedFilter.identifier = self.identifier;
    selectedFilter.values = values;
    return selectedFilter;
}

- (NSString *)urlFormatForSelectedValues
{
    if (!self.selected) return @"";
        
    NSString *formatStr = @"";

    if (self.filterType == JRFilterTypeSlider)
    {
        JRFilterValue *value = self.values[0];
        if (value.selected)
        {
            BOOL isChangedValue = true;
            if (self.selectedMinPrice == value.selectedMinPrice || self.selectedMaxPrice == value.selectedMaxPrice){
                isChangedValue = false ;
            }
            
            self.selectedMinPrice = value.selectedMinPrice ;
            self.selectedMaxPrice = value.selectedMaxPrice ;
            
            if (isChangedValue){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"priceFilterApplied" object:nil userInfo:@{@"minPrice" : [NSString stringWithFormat:@"%d", (int)value.selectedMinPrice] , @"maxPrice" :[NSString stringWithFormat:@"%d", (int)value.selectedMaxPrice]}];
            }
            
            formatStr = [NSString stringWithFormat:@"%.0f,%.0f",value.selectedMinPrice,value.selectedMaxPrice];
        }
    }
    else if (self.filterType == JRFilterTypeSwitch)
    {
       // JRFilterValue *value = self.values[0];
        for (JRFilterValue *value in self.values)
        {
            if (value.selected)
            {
                formatStr = [formatStr stringByAppendingString:[NSString stringWithFormat:@",%d", value.selected]];
            }
        }
    }
    else
    {
        for (JRFilterValue *value in self.values)
        {
            if (value.selected)
            {
                formatStr = [formatStr stringByAppendingString:[NSString stringWithFormat:@",%@", value.filterId]];
            }
            if (self.filterType == JRFilterTypeCategoryTree)
            {
                NSMutableArray *arr = [NSMutableArray array];

                [self itirateWithItems:value.categories resultArray:arr];
                for (JRFilterValue *category in arr)
                {
                    formatStr = [formatStr stringByAppendingString:[NSString stringWithFormat:@",%@", category.filterId ]];
                }
            }
        }
    }
    
    formatStr = [formatStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    if ([formatStr isEqualToString:@""] || [formatStr isNull] || (formatStr == nil))
    {
        return @"";
    }
    return [NSString stringWithFormat:@"&%@=%@",self.filterParam,formatStr];
}

- (BOOL) isSearchOptionAvailable
{
    switch (self.filterType) {
        case JRFilterTypeRectangular:
            return YES;
            break;
        case JRFilterTypeCircular:
            return YES;
            break;
        case JRFilterTypeLinearRectangular:
            return YES;
            break;
        case JRFilterTypeCategoryTree:
            return YES;
            break;
        case JRFilterTypeList:
            return YES;
            break;
        case JRFilterTypeLinearRectangularRadio:
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

- (NSArray *)filterValuesMatchingWithString:(NSString *)searchText;
{
    NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[c] %@",searchText];


    NSMutableArray *filterValues = [NSMutableArray arrayWithArray:[self.values
                                                                            filteredArrayUsingPredicate:predicate]];
    return filterValues;
}

- (void)itirateToFindMatchingString:(NSString *)searchText WithItems:(NSArray *)items resultArray:(NSMutableArray *)resultArray
{
    
    [items indexOfObjectPassingTest:^BOOL(JRFilterValue *obj, NSUInteger idx, BOOL *stop)
     {
         [self itirateToFindMatchingString:searchText WithItems:obj.categories resultArray:resultArray];
         NSPredicate *predicate = nil;
         predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[c] %@",searchText];
         
         [resultArray addObjectsFromArray:[NSMutableArray arrayWithArray:[obj.categories
                                                                        filteredArrayUsingPredicate:predicate]]];
        return NO;
     }];
}

- (NSArray *)treeFilterValuesMatchingWithString:(NSString *)searchText
{
    NSMutableArray *matchedFilters = [NSMutableArray array];
    
    for (JRFilterValue *fv in self.values)
    {
        [self itirateToFindMatchingString:searchText WithItems:fv.categories resultArray:matchedFilters];
    }
    return matchedFilters;
}

- (NSArray *)treeFilterValuesMatchingWithString:(NSString *)searchText inFilterValue:(JRFilterValue *)filterValue
{
    NSMutableArray *matchedFilters = [NSMutableArray array];

    if ([filterValue.name.lowercaseString hasPrefix:searchText.lowercaseString]) {
        [matchedFilters addObject:filterValue];
    }

    for (JRFilterValue *value in filterValue.categories)
    {
        if ([value.name.lowercaseString hasPrefix:searchText.lowercaseString]) {
            [matchedFilters addObject:value];
        }

    }
    [self itirateToFindMatchingString:searchText WithItems:filterValue.categories resultArray:matchedFilters];

    for (JRFilterValue *fv in filterValue.categories)
    {
        [self itirateToFindMatchingString:searchText WithItems:fv.categories resultArray:matchedFilters];
    }
    return matchedFilters;
}

- (BOOL)shouldSupportExpand
{
    return ((self.filterType == JRFilterTypeLinearRectangular || self.filterType == JRFilterTypeLinearRectangularRadio) && self.values.count > MaxNumberOfItems);
}

#pragma mark - default filter selection

- (void)selectDefaultfilters
{
//    for (JRFilterValue *filterValue in self.values)
//    {
//        if ([self isFilterApplied:filterValue] )
//        {
//            filterValue.selected = YES;
//        }
//    }
    if (self.appliedFilters.count > 0)
    {
        self.selected = YES;
        if (self.filterType == JRFilterTypeSwitch) {
           JRFilterValue *filterValue = self.values.firstObject;
            filterValue.selected = true;
        }
    }
}

- (BOOL) isFilterApplied:(JRFilterValue *)filter
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueId like %@", filter.uniqueId];
    NSArray *filteredArray = [self.appliedFilters filteredArrayUsingPredicate:predicate];
    return filteredArray.count > 0 ? YES : NO;
}

- (void)selectDefaultRangeFilter
{
    if (self.appliedRange)
    {
        JRFilterValue *filter = self.values[0];
        if(![self.appliedRange[@"min"] isNull] && ![self.appliedRange[@"max"] isNull])
        {
            self.selected = YES;

            filter.selected = YES;
            filter.selectedMinPrice = [self.appliedRange[@"min"] integerValue];
            filter.selectedMaxPrice = [self.appliedRange[@"max"] integerValue];
        }
        
    }
}

+ (BOOL)isAnyFilterSelectedInFilters:(NSArray *)filterList
{
    BOOL isFilterSelected = NO;
    for (JRFilter *filter in filterList)
    {
        isFilterSelected = [filter anySelectedValues];
        if (isFilterSelected)
        {
            break;
        }
    }
    return isFilterSelected;
}


+ (NSArray *)walletPassbookFilters
{

    NSMutableArray *filterArray = [NSMutableArray new];
    
    JRFilter *filter = [[JRFilter alloc] init];
    filter.title = @"Filter By Transaction";
    filter.filterType = JRFilterTypeLinearRectangular;
    filter.identifier = @"BrandCell";
    filter.searchEnabled = NO;
    
    
    NSArray *transactionArray = [NSArray arrayWithObjects:@"Paytm Cashback",@"Money Added",@"Refund",@"Paytm Balance Received",@"Paid for orders",@"Paytm Balance Sent",@"Sent to Bank",nil];
    NSMutableArray *array0 = [NSMutableArray array];
    
    for (NSInteger index = 0; index < transactionArray.count; index++)
    {
        JRFilterValue *value = [[JRFilterValue alloc]init];
        value.filter = filter;
        value.keyName = transactionArray[index];
        value.filterId = transactionArray[index];
        value.name = transactionArray[index];
        [array0 addObject:value];
    }
    
    filter.values = array0;
    JRFilter *filter2 = [[JRFilter alloc] init];
    filter2.title = @"Filter By Status";
    filter2.filterType = JRFilterTypeLinearRectangular;
    filter2.identifier = @"BrandCell";
    filter2.searchEnabled = NO;
    
    //NSArray *statusArray = [NSArray arrayWithObjects:JRLocalizedString(@"jr_ac_failed"),JRLocalizedString(@"Pending"),JRLocalizedString(@"Successful"), nil];
    NSArray *statusArray = [NSArray arrayWithObjects:@"Failed",@"Pending",@"Successful", nil];
    NSMutableArray *array1 = [NSMutableArray array];
    
    for (NSInteger index = 0; index < statusArray.count; index++)
    {
        JRFilterValue *value = [[JRFilterValue alloc]init];
        value.filter = filter2;
        value.keyName = statusArray[index];
        value.name = statusArray[index];
        value.filterId = statusArray[index];
        [array1 addObject:value];
    }
    filter2.values = array1;
    
    [filterArray addObject:filter];
    [filterArray addObject:filter2];
    
    JRFilter *searchTextFilter = [[JRFilter alloc] init];
    searchTextFilter.title = @"";
    searchTextFilter.filterType = JRFilterSearchBar;
    searchTextFilter.searchEnabled = NO;
    
    array1 = [NSMutableArray new];
    JRFilterValue *value = [[JRFilterValue alloc]init];
    value.filter = searchTextFilter;
    value.keyName = @"";
    value.filterId = @"";
    value.name = @"";
    [array1 addObject:value];
    searchTextFilter.values = array1;
    [filterArray addObject:searchTextFilter];

    return [NSArray arrayWithArray:filterArray];
}

@end
