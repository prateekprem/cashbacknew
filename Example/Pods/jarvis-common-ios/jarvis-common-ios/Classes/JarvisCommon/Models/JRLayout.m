//
//  JRLayout.m
//  Jarvis
//
//  Created by Sahana Kini on 27/08/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//


#import "JRLayout.h"

#import <jarvis_common_ios/jarvis_common_ios-Swift.h>
#import <jarvis_utility_ios/jarvis-utility-ios-umbrella.h>
#import <jarvis_utility_ios/NSObject+SafeKVC.h>

@implementation JRLayout

- (id)initWithDictionary:(NSDictionary *)dictionary withLayoutAPIVersionType:(JRLayoutAPIVersion)layoutAPIVersionType {
    
    if (self = [super init]) {
        
        self.lastTrackedItem = -1;
        [self setWithDictionary:dictionary withLayoutAPIVersionType:layoutAPIVersionType];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithDictionary:dictionary withLayoutAPIVersionType:Version1];
}

#pragma mark - Set Params

- (void)setWithDictionary:(NSDictionary *)dictionary withLayoutAPIVersionType:(JRLayoutAPIVersion)layoutAPIVersionType {
    
    switch (layoutAPIVersionType) {
        case Version1:
            
            [self setPropertiesAccordingToVersion1:dictionary];
            break;
        
        case Version2:
            
            [self setPropertiesAccordingToVersion2:dictionary];
            break;
            
        default:
            
            [self setPropertiesAccordingToVersion1:dictionary];
            
            break;
    }
    
}

- (void) setPropertiesAccordingToVersion1:(NSDictionary*)dictionary {
    
    self.name = [dictionary[@"name"] isNull] ? nil : dictionary[@"name"];
    self.layout = [dictionary[@"layout"] isNull] ? nil : dictionary[@"layout"];
    self.subtitle = [dictionary[@"subtitle"] isNull] ? nil : dictionary[@"subtitle"];
    self.iconImage = [dictionary[@"image_url"] isNull] ? nil : dictionary[@"image_url"];

    [self setCommonPropeties:dictionary];
}

- (void) setPropertiesAccordingToVersion2:(NSDictionary*)dictionary {
    
    self.name = [dictionary[@"title"] isNull] ? nil : dictionary[@"title"];
    self.layout = [dictionary[@"type"] isNull] ? nil : dictionary[@"type"];
    self.subtitle = [dictionary[@"subtitle"] isNull] ? nil : dictionary[@"subtitle"];
    self.iconImage = [dictionary[@"image_url"] isNull] ? nil : dictionary[@"image_url"];
    
    [self setCommonPropeties:dictionary];
}

- (void) setCommonPropeties:(NSDictionary*)dictionary {
    
    [self addDatasourcesIfPresentInDictionary:dictionary];
    
    self.catID = [dictionary doubleForKey:@"id"];
    self.html = [dictionary[@"html"] isNull] ? nil : dictionary[@"html"];
    
    self.headerImage = [dictionary[@"header_imageurl"] isNull] ? nil : dictionary[@"header_imageurl"];
    self.seeAllURL = [dictionary[@"see_all_url"] isNull] ? nil : dictionary[@"see_all_url"];
    self.seoURL = [dictionary[@"seourl"] isNull] ? self.seeAllURL : dictionary[@"seourl"];
    NSMutableArray *itemArray = [NSMutableArray array];
    
    BOOL isSmartIcon = false;
    if ([self.layout isEqualToString:JRLayoutTypeSmartIconList] || [self.layout isEqualToString: @"smart-icon-grid"]) {
        isSmartIcon = true;
    }
    
    NSInteger index = 1;
    for(id obj in dictionary[@"items"])
    {
        JRItem *item = [[JRItem alloc] initWithDictionary:obj];
        if (item.name.length || item.imageUrl.length) {
            item.listId = self.catID;
            item.datasourceType = self.datasourceType;
            item.datasourceListID = self.datasourceListID;
            item.datasourceContainerID = self.datasourceContainerID;
            item.datasourceContainerInstanceID = self.datasourceContainerInstanceID;
            item.positionInList = index;
            item.isSmartIcon = isSmartIcon;
            item.layoutType = self.layout;
            [itemArray addObject:item];
            index++;
        }
    }
    self.items = itemArray;
    self.islayoutTracked = NO;
    self.displayFields = [dictionary[@"display_fields"] isNull] ? nil : dictionary[@"display_fields"];
}

- (BOOL)isArrayNotEmpty:(NSArray *)anArray
{
    return (anArray.count>0);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.items = [aDecoder decodeObjectForKey:@"items"];
        self.displayFields = [aDecoder decodeObjectForKey:@"displayFields"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.displayFields = [aDecoder decodeObjectForKey:@"displayFields"];
        self.html = [aDecoder decodeObjectForKey:@"html"];
        self.layout = [aDecoder decodeObjectForKey:@"layout"];
        self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        self.iconImage = [aDecoder decodeObjectForKey:@"image_url"];

        NSUInteger decodeLength = 0;
        const uint8_t* decodeBytes = [aDecoder decodeBytesForKey:@"headerImage" returnedLength:&decodeLength];
        NSData* data = [NSData dataWithBytes:decodeBytes length:decodeLength];
        if (data) {
            self.headerImage = [NSString stringArchiveDecode:data];
        }
        
        decodeBytes = [aDecoder decodeBytesForKey:@"seeAllURL" returnedLength:&decodeLength];
        data = [NSData dataWithBytes:decodeBytes length:decodeLength];
        if (data) {
            self.seeAllURL = [NSString stringArchiveDecode:data];
        }
        
        self.islayoutTracked = [aDecoder decodeBoolForKey:@"islayoutTracked"];
        self.isRecommendation = [aDecoder decodeBoolForKey:@"isRecommendation"];
        self.catID = [aDecoder decodeDoubleForKey:@"catID"];
        
        //GTM
        self.gaKey = [aDecoder decodeObjectForKey:@"gaKey"];
        self.lastTrackedItem = [aDecoder decodeIntegerForKey:@"lastTrackedItem"];
        self.isFromSearch = [aDecoder decodeBoolForKey:@"isFromSearch"];
        
        //Datasources: for midgar instance ID
        self.datasourceContainerID = [aDecoder decodeDoubleForKey:@"datasourceContainerID"];
        self.datasourceListID = [aDecoder decodeDoubleForKey:@"datasourceListID"];
        self.datasourceContainerInstanceID = [aDecoder decodeObjectForKey:@"datasourceContainerInstanceID"];
        self.datasourceType = [aDecoder decodeObjectForKey:@"datasourceType"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.items forKey:@"items"];
    [aCoder encodeObject:self.displayFields forKey:@"displayFields"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.html forKey:@"html"];
    [aCoder encodeObject:self.layout forKey:@"layout"];
    [aCoder encodeObject:self.subtitle forKey:@"subtitle"];
    [aCoder encodeObject:self.iconImage forKey:@"image_url"];

    NSData* data;
    if (self.headerImage && (data = [NSString stringArchiveEncode:self.headerImage])) {
        [aCoder encodeBytes:data.bytes length:data.length forKey:@"headerImage"];
    }
    
    if (self.seeAllURL && (data = [NSString stringArchiveEncode:self.seeAllURL])) {
        [aCoder encodeBytes:data.bytes length:data.length forKey:@"seeAllURL"];
    }
    
    [aCoder encodeBool:self.islayoutTracked forKey:@"islayoutTracked"];
    [aCoder encodeBool:self.isRecommendation forKey:@"isRecommendation"];
    [aCoder encodeDouble:self.catID forKey:@"catID"];
    
    //GTM
    [aCoder encodeObject:self.gaKey forKey:@"gaKey"];
    [aCoder encodeInteger:self.lastTrackedItem forKey:@"lastTrackedItem"];
    [aCoder encodeBool:self.isFromSearch forKey:@"isFromSearch"];
//    [aCoder encodeObject:self.screenName forKey:@"screenName"];
//    [aCoder encodeObject:self.source forKey:@"source"];
    
    //Datasources: for midgar instance ID
    [aCoder encodeDouble:self.datasourceContainerID forKey:@"datasourceContainerID"];
    [aCoder encodeDouble:self.datasourceListID forKey:@"datasourceListID"];
    [aCoder encodeObject:self.datasourceContainerInstanceID forKey:@"datasourceContainerInstanceID"];
    [aCoder encodeObject:self.datasourceType forKey:@"datasourceType"];
}

- (void)addDatasourcesIfPresentInDictionary:(NSDictionary *)dictionary
{
    NSArray *dataSourcesArray = [dictionary[@"datasources"] isNull] ? nil : dictionary[@"datasources"];
    if (dataSourcesArray)
    {
        if ([self isArrayNotEmpty:dataSourcesArray])
        {
            NSDictionary *dictionary = [dataSourcesArray firstObject];
            if (dictionary)
            {
                self.datasourceContainerID = [dictionary doubleForKey:@"container_id"];
                self.datasourceContainerInstanceID = [dictionary[@"container_instance_id"] isNull] ? nil : dictionary[@"container_instance_id"];
                self.datasourceListID = [dictionary doubleForKey:@"list_id"];
                self.datasourceType = [dictionary[@"type"] isNull] ? nil : dictionary[@"type"];
            }
        }
    }
}


- (BOOL)doesMoviesHomeSupportesThisLayout
{
    if ([self.layout isEqualToString:@"carousel-1"] || [self.layout isEqualToString:@"carousel-4"] || [self.layout isEqualToString:@"carousel-5"]) {
        return YES;
    }
    return NO;
}

- (BOOL)doesThemeParkHomeSupportesThisLayout
{
    if ([self.layout isEqualToString:@"carousel-1"] || [self.layout isEqualToString:@"carousel-4"] || [self.layout isEqualToString:@"carousel-3"]) {
        return YES;
    }
    return NO;
}

+ (JRLayout *)carousel1LayoutFromLayoutList:(NSArray *)list
{
    for (JRLayout *layout in list)
    {
        if ([layout.layout isEqualToString:@"carousel-1"])
        {
            return layout;
        }
    }
    
    return nil;
}

- (BOOL)layoutIsOfTypeMainCarousel//used in case of InMobi, since we need to show info text only if home contains main carousel
{
    return [self.layout isEqualToString:JRLayoutTypeCarousel1] || [self.layout isEqualToString:JRLayoutTypeHyphenCarousel1] ? YES : NO;
}

- (NSString *)inmobiEventName
{
    if ([self.layout isEqualToString:JRLayoutTypeCarousel1]||[self.layout isEqualToString:JRLayoutTypeHyphenCarousel1])
    {
        return @"c1";
    }
    else if ([self.layout isEqualToString:JRLayoutTypeCarousel2]||[self.layout isEqualToString:JRLayoutTypeHyphenCarousel2])
    {
        return @"c2";
    }
    else if ([self.layout isEqualToString:JRLayoutTypeRow])
    {
        return @"prod";
    }
    
    return @"";
}

- (NSString *)source{
    if (self.items.count) {
       return  ((JRItem *)self.items.firstObject).source;
    }
    return @"";
}

- (NSString *)screenName{
    NSString *gKey = @"";
    if (self.gaKey.length) {
        gKey = self.gaKey;
    }
    if (self.isFromSearch) {
        gKey = [gKey stringByAppendingString: @"-search"];
    }
    if (self.name.length) {
        gKey = [NSString stringWithFormat:@"%@-%@",gKey, self.name];
    }
    if (self.source.length) {
        if ([self.source hasPrefix:@"/"]) {
            gKey = [NSString stringWithFormat:@"%@%@", gKey, self.source];
        } else {
            gKey = [NSString stringWithFormat:@"%@/%@", gKey, self.source];
        }
    }
    return gKey;
}

- (void)getItemValuesOf:(NSInteger)count forTracking:(void(^)( NSString *screenName, NSArray *productIds, NSArray *productNames, float totalPrice))handler {
    float price = 0;
    NSMutableArray *productIdSub = [NSMutableArray array];
    NSMutableArray *productNameSub = [NSMutableArray array];
    for (NSInteger i = 0; i < count && i < self.items.count ; i++) {
        JRItem *item = self.items[i];
        [productIdSub addObject:item.parentId ? :@""];
        [productNameSub addObject:item.name ? :@""];
        price += item.offerPrice.integerValue;
    }
    handler(self.screenName, productIdSub, productNameSub, price);
}

+ (NSString * )getCreativeNameForGA:(JRLayout *)item{
    return item.name;
}

+ (NSDictionary * )getPromotionsDictForLayout:(JRLayout *)item{
    NSString *datasourceContainerInstanceID = @"";
    if (item.datasourceContainerInstanceID != nil) {
        datasourceContainerInstanceID = item.datasourceContainerInstanceID;
    }
    
    NSDictionary *promotionsDict = [NSDictionary dictionaryWithObjectsAndKeys:datasourceContainerInstanceID, @"dimension40",
                                    @"", @"id", item.layout.length <= 0 ? item.name : [NSString stringWithFormat:@"%@_%@", item.name, item.layout], @"name", [JRLayout getCreativeNameForGA:item], @"creative", nil];
    return promotionsDict;
}

@end
