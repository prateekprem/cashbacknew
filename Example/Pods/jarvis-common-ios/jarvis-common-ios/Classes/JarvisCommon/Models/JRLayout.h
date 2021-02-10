//
//  JRLayout.h
//  Jarvis
//
//  Created by Sahana Kini on 27/08/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JRItem;

typedef enum : NSUInteger {
    Version1,
    Version2,
    
} JRLayoutAPIVersion;

@interface JRLayout : NSObject<NSCoding>

@property (nonatomic, strong) NSArray<JRItem *> *items;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *html;
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, copy) NSString *headerImage;
@property (nonatomic, copy) NSString *seeAllURL;
@property (nonatomic, copy) NSString *seoURL;
@property (nonatomic, assign) BOOL islayoutTracked;
@property (nonatomic, assign) BOOL isRecommendation;
@property (nonatomic, assign) double catID;
@property (nonatomic, strong) NSArray *displayFields;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *iconImage;


//GTM
@property (nonatomic, copy) NSString *gaKey;
@property (nonatomic, assign)NSInteger lastTrackedItem;
@property (nonatomic, assign)BOOL isFromSearch;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, strong) NSString *source; //for recommended product its reco
@property (nonatomic, strong) NSDictionary *similarProductsGAInfo; //for recommended product its reco
@property (nonatomic, assign) BOOL isFromPDP;

//Datasources: for midgar instance ID
@property (nonatomic, assign) double datasourceContainerID;
@property (nonatomic, assign) double datasourceListID;
@property (nonatomic, copy) NSString *datasourceContainerInstanceID;
@property (nonatomic, copy) NSString *datasourceType;

// For UI (Common Elements)
@property (nonatomic, assign) BOOL hideDivider;
@property (nonatomic, assign) BOOL viewMoreTapped;

+ (JRLayout *)carousel1LayoutFromLayoutList:(NSArray *)list;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary withLayoutAPIVersionType:(JRLayoutAPIVersion)layoutAPIVersionType;
- (BOOL)doesThemeParkHomeSupportesThisLayout;
- (BOOL)doesMoviesHomeSupportesThisLayout;
- (BOOL)layoutIsOfTypeMainCarousel; //used in case of InMobi, since we need to show info text only if home contains main carousel
- (NSString *)inmobiEventName;

- (void)getItemValuesOf:(NSInteger)count forTracking:(void(^)( NSString *screenName, NSArray *productIds, NSArray *productNames, float totalPrice))handler;
+ (NSString * )getCreativeNameForGA:(JRLayout *)item;
+ (NSDictionary * )getPromotionsDictForLayout:(JRLayout *)item;

@end
