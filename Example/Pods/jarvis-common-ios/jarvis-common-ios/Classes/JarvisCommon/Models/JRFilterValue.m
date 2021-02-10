//Created Automatically By JSONToClassConverter
//To change, Change in ClassMTemplate.txt


#import "JRFilterValue.h"
#import "JRFilter.h"
#import "RSFolderNavigationBar.h"
#import "NSObject+SafeKVC.h"
#import <jarvis_utility_ios/jarvis_utility_ios-Swift.h>

static NSUInteger itemLevel = 0;

@interface JRFilterValue ()

@end
@implementation JRFilterValue


- (instancetype)copyWithZone:(NSZone *)zone
{
    
    JRFilterValue *filter = [[[self class] allocWithZone:zone]init];
    filter.filterId = [_filterId copyWithZone:zone];
    filter.name = [_name copyWithZone:zone];
    filter.categories = [_categories copyWithZone:zone];
    filter.productUrl = [_productUrl copyWithZone:zone];
    filter.productID = [_productID copyWithZone:zone];
    filter.filterValuePrefix = [_filterValuePrefix copyWithZone:zone];
    filter.filterValueSuffix = [_filterValueSuffix copyWithZone:zone];
    filter.minimumValueLabel = [_minimumValueLabel copyWithZone:zone];
    filter.maximumValueLabel = [_maximumValueLabel copyWithZone:zone];
    filter.imageName = [_imageName copyWithZone:zone];
    filter.selectedMinDepartureTime = [_selectedMinDepartureTime copyWithZone:zone];

    filter.keyName = [_keyName copyWithZone:zone];
    filter.holderObject = [_holderObject copyWithZone:zone];
    
    [filter setSelected:self.selected];
    [filter setNotVisible:self.notVisible];
    [filter setIsFilterApplied:self.isFilterApplied];
    [filter setApplied:self.applied];
    [filter setExist:self.exist];
    [filter setSelectedMinPrice:self.selectedMinPrice];
    [filter setSelectedMaxPrice:self.selectedMaxPrice];
    [filter setMinPrice:self.minPrice];
    [filter setMaxPrice:self.maxPrice];
    [filter setCount:self.count];
    
    [filter setSelectedMinDuration:self.selectedMinDuration];
    [filter setSelectedMaxDuration:self.selectedMaxDuration];
    [filter setMinDuration:self.minDuration];
    [filter setMaxDuration:self.maxDuration];

    return filter;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    JRFilterValue *filter = [[[self class] allocWithZone:zone] init];
    filter.filterId = [_filterId mutableCopyWithZone:zone];
    filter.name = [_name mutableCopyWithZone:zone];
    [filter setCount:self.count];
    filter.categories = [_categories mutableCopyWithZone:zone];
    filter.productUrl = [_productUrl mutableCopyWithZone:zone];
    filter.productID = [_productID mutableCopyWithZone:zone];
    filter.filterValuePrefix = [_filterValuePrefix mutableCopyWithZone:zone];
    filter.filterValueSuffix = [_filterValueSuffix mutableCopyWithZone:zone];
    filter.minimumValueLabel = [_minimumValueLabel mutableCopyWithZone:zone];
    filter.maximumValueLabel = [_maximumValueLabel mutableCopyWithZone:zone];
    filter.imageName = [_imageName mutableCopyWithZone:zone];
    filter.selectedMinDepartureTime = [_selectedMinDepartureTime mutableCopyWithZone:zone];
    
    filter.keyName = [_keyName mutableCopyWithZone:zone];
    filter.holderObject = [_holderObject mutableCopyWithZone:zone];
    
    [filter setSelected:self.selected];
    [filter setNotVisible:self.notVisible];
    [filter setIsFilterApplied:self.isFilterApplied];
    [filter setApplied:self.applied];
    [filter setExist:self.exist];
    [filter setSelectedMinPrice:self.selectedMinPrice];
    [filter setSelectedMaxPrice:self.selectedMaxPrice];
    [filter setMinPrice:self.minPrice];
    [filter setMaxPrice:self.maxPrice];
    
    [filter setSelectedMinDuration:self.selectedMinDuration];
    [filter setSelectedMaxDuration:self.selectedMaxDuration];
    [filter setMinDuration:self.minDuration];
    [filter setMaxDuration:self.maxDuration];

    return filter;
}


- (void)setWithDictionary:(NSDictionary *)dictionary needSelectedFilter:(BOOL)needSelectedFilter level:(int)level
{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return;
    id value = [dictionary[@"id"] validObjectValue];
    
    if ([value isKindOfClass:[NSString class]])
    {
        self.filterId = value;
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        self.filterId = [value stringValue];
    }
    else
    {
        self.filterId = @"";
    }
    self.level = level;
    self.name = [dictionary stringForKey:@"name"];
    self.productUrl = [dictionary stringForKey:@"url"];
    if (needSelectedFilter) {
        self.applied = [[dictionary[@"applied"] validObjectValue] boolValue];
    }
    else {
        self.applied = false;
    }
    self.isFilterApplied = [[dictionary[@"applied"] validObjectValue] boolValue];
    self.exist = [[dictionary numberForKey:@"exist"] boolValue];
    self.count = [[dictionary numberForKey:@"count"] integerValue];

    NSMutableArray *categories = [NSMutableArray array];

    for(NSDictionary *obj in [dictionary[@"cats"] validObjectValue])
    {
        itemLevel ++;
        JRFilterValue *category = [[JRFilterValue alloc] initWithDictionary:[obj validObjectValue] needSelectedFilter:false level: level + 1];
        category.filter = self.filter;
        [categories addObject:category];
        itemLevel --;
    }
    
    self.categories = categories;
    self.productID = [dictionary objectForKey:@"product_id"];
    self.fontSize = self.level ? 14.0f : 15.0f;
    self.fontSize = self.categories.count ? self.fontSize : 13.0f;
    [self checkIsSiblingWithoutChild];
}

- (id)initWithDictionary:(NSDictionary *)dictionary needSelectedFilter:(BOOL)needSelectedFilter level:(int)level
{
	if (self = [super init])
	{
        [self setWithDictionary:dictionary needSelectedFilter:needSelectedFilter level: level];
	}
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary andFilter:(JRFilter *)filter level:(int)level
{
    if (self = [super init])
    {
        [self setWithDictionary:dictionary withFilter:filter level: level];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dictionary withFilter:(JRFilter *)filter level:(int)level
{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return;
    if (![dictionary[@"id"] isNull])
    {
        if ([dictionary[@"id"] isKindOfClass:[NSString class]])
        {
            self.filterId = dictionary[@"id"];
        }
        else if ([dictionary[@"id"] isKindOfClass:[NSNumber class]])
        {
            self.filterId = [dictionary[@"id"] stringValue];
        }
        else
        {
            self.filterId = @"";
        }
    }
    else
    {
        self.filterId = @"";
    }
    self.level = level;
    self.name = [dictionary stringForKey:@"name"];
    
    self.productUrl = dictionary[@"url"];
    self.applied = [dictionary[@"applied"] boolValue];
    self.exist = [dictionary[@"exist"] boolValue];
    self.count = [dictionary[@"count"] isNull] ? 0 : [dictionary[@"count"] integerValue];
    
    NSMutableArray *categories = [NSMutableArray array];
    
    for(NSDictionary *obj in dictionary[@"cats"])
    {
        itemLevel ++;
        JRFilterValue *category = [[JRFilterValue alloc] initWithDictionary:obj andFilter:filter level:level + 1];
        category.filter = filter;
        category.parentValue = self;
        [categories addObject:category];
        itemLevel --;
    }
    
    self.categories = categories;
    self.productID = [dictionary objectForKey:@"product_id"];
   

    self.fontSize = self.level ? 14.0f : 15.0f;
    self.fontSize = self.categories.count ? self.fontSize : 13.0f;
    [self checkIsSiblingWithoutChild];

}

//Implemented just to support 'Cancel' option in Bus filters
//In that case we need deep copy of array 'filters' so either we have to loop through the array or we need to create deep copy using NSCoder,so opted this :)
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.filterId = [decoder decodeObjectForKey:@"filterId"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.count = [decoder decodeIntegerForKey:@"count"];
    self.productUrl = [decoder decodeObjectForKey:@"productUrl"];
    self.applied = [decoder decodeBoolForKey:@"applied"];
    self.exist = [decoder decodeBoolForKey:@"exist"];
    self.selected = [decoder decodeBoolForKey:@"selected"];
    self.productID = [decoder decodeObjectForKey:@"product_id"];
    self.categories = [decoder decodeObjectForKey:@"categories"];
    self.parentValue = [decoder decodeObjectForKey:@"parentValue"];
    self.level = [decoder decodeIntForKey:@"level"];
    self.fontSize = [decoder decodeIntForKey:@"fontSize"];
    self.isSiblingWithoutChild = [decoder decodeBoolForKey:@"isSiblingWithoutChild"];
    self.isCategorySelected = [decoder decodeBoolForKey:@"isCategorySelected"];
    self.isLastCategory = [decoder decodeBoolForKey:@"isLastCategory"];

    self.selectedMinPrice = [decoder decodeFloatForKey:@"selectedMinPrice"];
    self.selectedMaxPrice = [decoder decodeFloatForKey:@"selectedMaxPrice"];
    self.minPrice = [decoder decodeFloatForKey:@"minPrice"];
    self.maxPrice = [decoder decodeFloatForKey:@"maxPrice"];
    self.filterValuePrefix = [decoder decodeObjectForKey:@"filterValuePrefix"];
    self.filterValueSuffix = [decoder decodeObjectForKey:@"filterValueSuffix"];
    
    self.selectedMinDuration = [decoder decodeFloatForKey:@"selectedMinDuration"];
    self.selectedMaxDuration = [decoder decodeFloatForKey:@"selectedMaxDuration"];
    self.minDuration = [decoder decodeFloatForKey:@"minDuration"];
    self.maxDuration = [decoder decodeFloatForKey:@"maxDuration"];

    self.imageName = [decoder decodeObjectForKey:@"imageName"];
    self.selectedMinDepartureTime = [decoder decodeObjectForKey:@"selectedMinDepartureTime"];
    self.selectedMaxDepartureTime = [decoder decodeObjectForKey:@"selectedMaxDepartureTime"];

    self.keyName = [decoder decodeObjectForKey:@"keyName"];

    self.filter = [decoder decodeObjectForKey:@"filter"];
    
    //TODO:since i don't want holder object deep copy ,will need to retain the same
    //Please check whether it is possible?
    self.holderObject = [decoder decodeObjectForKey:@"holderObject"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.filterId forKey:@"filterId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInteger:self.count forKey:@"count"];
    [encoder encodeObject:self.productUrl forKey:@"productUrl"];
    [encoder encodeBool:self.applied forKey:@"applied"];
    [encoder encodeBool:self.exist forKey:@"exist"];
    [encoder encodeBool:self.selected forKey:@"selected"];
    [encoder encodeObject:self.productID forKey:@"product_id"];
    [encoder encodeObject:self.categories forKey:@"categories"];
    [encoder encodeObject:self.parentValue forKey:@"parentValue"];
    [encoder encodeInt:self.level forKey:@"level"];
    [encoder encodeInt:self.fontSize forKey:@"fontSize"];

    [encoder encodeFloat:self.selectedMinPrice forKey:@"selectedMinPrice"];
    [encoder encodeFloat:self.selectedMaxPrice forKey:@"selectedMaxPrice"];
    [encoder encodeFloat:self.minPrice forKey:@"minPrice"];
    [encoder encodeFloat:self.maxPrice forKey:@"maxPrice"];
    [encoder encodeObject:self.filterValuePrefix forKey:@"filterValuePrefix"];
    [encoder encodeObject:self.filterValueSuffix forKey:@"filterValueSuffix"];
    [encoder encodeBool:self.isCategorySelected forKey:@"isCategorySelected"];
    [encoder encodeBool:self.isSiblingWithoutChild forKey:@"isSiblingWithoutChild"];
    [encoder encodeBool:self.isLastCategory forKey:@"isLastCategory"];
    
    [encoder encodeFloat:self.selectedMinDuration forKey:@"selectedMinDuration"];
    [encoder encodeFloat:self.selectedMaxDuration forKey:@"selectedMaxDuration"];
    [encoder encodeFloat:self.minDuration forKey:@"minDuration"];
    [encoder encodeFloat:self.maxDuration forKey:@"maxDuration"];

    [encoder encodeObject:self.imageName forKey:@"imageName"];
    [encoder encodeObject:self.selectedMinDepartureTime forKey:@"selectedMinDepartureTime"];
    [encoder encodeObject:self.selectedMaxDepartureTime forKey:@"selectedMaxDepartureTime"];

    [encoder encodeObject:self.keyName forKey:@"keyName"];

    [encoder encodeObject:self.filter forKey:@"filter"];

    [encoder encodeObject:self.holderObject forKey:@"holderObject"];
}

#pragma mark - Helper Methods

- (NSString *)title
{
    if (self.filter.filterType == JRFilterTypeSlider)
    {
        return [NSString stringWithFormat:@"%@: %@ - %@",self.name,[JRUtility getCommaFormattedPricingForPrice:(int)self.selectedMinPrice] ,[JRUtility getCommaFormattedPricingForPrice:(int)self.selectedMaxPrice]];
    }
    
    else if (self.filter.filterType == JRFilterTypeSwitch)
    {
        return self.filter.title;
    }
    
    else if (self.filter.filterType == JRFilterTypeDepartureTime)
    {
        return [NSString stringWithFormat:@"%@", [self.name stringByReplacingOccurrencesOfString:@"\n" withString:@" to "]];
    }
    
    else if (self.filter.filterType == JRFilterTypeBoardingPoints)
    {
        return [NSString stringWithFormat:@"B.Pt: %@",self.name];
    }
    
    else if (self.filter.filterType == JRFilterTypeDroppingPoints)
    {
        return [NSString stringWithFormat:@"D.Pt: %@",self.name];
    }
    
    else if (self.filter.filterType == JRFilterTypeBusOperators)
    {
        return [NSString stringWithFormat:@"Opr: %@",self.name];
    }
    else if (self.filter.filterType == JRFilterTypeCategoryTree)
    {
        if ([self.name.lowercaseString isEqualToString:@"all"])
        {
            return [NSString stringWithFormat:@"All - %@", self.parentValue.name] ;
        }
        else
        {
            return self.name;
        }
    }

    return self.name;
}

- (NSString*)uniqueId
{
    return [NSString stringWithFormat:@"%@%@%@",self.name, self.name, self.filter.title];
}

- (NSArray *)ancestorFilterValues
{
    NSMutableArray *ancestorFilters = [NSMutableArray array];
    JRFilterValue *fv = self;
    while (fv)
    {
        [ancestorFilters addObject:fv];
        fv = fv.parentValue;
    }
    [ancestorFilters removeLastObject]; //remove paytm key
    NSMutableArray *reverseArray = [NSMutableArray array];
    NSEnumerator *enumerator = [ancestorFilters reverseObjectEnumerator];
    for (id element in enumerator) {
        [reverseArray addObject:element];
    }
    return reverseArray;
}

- (void)itirateItemsToSearchFilterValue:(JRFilterValue *)filterValue WithItems:(NSArray *)items resultArray:(NSMutableArray *)resultArray
{
    [items indexOfObjectPassingTest:^BOOL(JRFilterValue *obj, NSUInteger idx, BOOL *stop)
     {
         [self itirateItemsToSearchFilterValue:filterValue WithItems:obj.categories resultArray:resultArray];
         if ([obj.categories containsObject:filterValue])
         {
             [resultArray addObject:obj];
         }
         return NO;
     }];
}

- (void)itireateToGetResultArray:(NSArray *)items TofindItem:(JRFilterValue *)filterValue result:(NSMutableArray *)resultsArray
{
    NSInteger index = NSNotFound;
    index = [items indexOfObjectPassingTest:^BOOL(JRFilterValue *obj, NSUInteger idx, BOOL *stop)
             {
                 *stop = ([obj.filterId integerValue] == filterValue.filterId.integerValue);
                 return *stop;
             }];
    if (index != NSNotFound)
    {
        //handling main category and subcategory ahving same id case. Eg. "Other Store" id (18713) and its first child "All Other Store"(18713) are same
        NSArray *subItems = ((JRFilterValue *)items[index]).categories;
        [self itireateToGetResultArray:subItems TofindItem:filterValue result:resultsArray];
    }
    if (index != NSNotFound)
    {
        [resultsArray addObject:items[index]];
    }
}

-(void)checkIsSiblingWithoutChild
{
    BOOL isSiblingContainChild = NO;
    for (JRFilterValue *category in self.categories)
    {
        if(category.categories.count)
        {
            isSiblingContainChild = YES;
            break;
        }
    }
    
    if(isSiblingContainChild)
    {
        for (JRFilterValue *category in self.categories)
        {
            category.isSiblingWithoutChild = category.categories.count ? NO : YES;
        }
    }
}

- (NSArray<JRFilterValue *> *)getSiblings
{
    return self.parentValue ? self.parentValue.categories : nil;
}

- (NSString *)categoryTree {
    NSString *tree = @"";
    if (self.parentValue) {
        tree = [self.parentValue categoryTree];
    }
    if (self.name.length) {
        if (tree.length) {
            tree = [NSString stringWithFormat:@"%@/%@",tree, self.name];
        } else {
            tree = self.name;
        }
    }
    return tree;
}

- (NSString *)categoryLevel {
    NSInteger index = 1;
    JRFilterValue *node = self.parentValue;
    while (node) {
        index++;
        node = node.parentValue;
    }
    return [NSString stringWithFormat:@"L%ld",(long)index];
}

@end
