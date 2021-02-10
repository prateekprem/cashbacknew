//Created Automatically By JSONToClassConverter
//To change, Change in ClassHTemplate.txt


#import <Foundation/Foundation.h>
#import <jarvis_utility_ios/RSFolderNavigationBar.h>

@class JRFilter;
@interface JRFilterValue : NSObject <RSFolderNavigationBarItem, NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSString *filterId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL userDeselected;
@property (nonatomic, assign) BOOL notVisible;
@property (nonatomic, assign) BOOL isFilterApplied;
@property (nonatomic, weak) JRFilter *filter;
@property (nonatomic, strong) NSArray<JRFilterValue *> *categories;
@property (nonatomic, weak) JRFilterValue *parentValue;

// This should contain any extra info related with filter value
@property (nonatomic) NSDictionary *userInfo;

//-----------------------------------------------------
// These properties are only for the Product Level Filter
@property (nonatomic, copy) NSString *productUrl;
@property (nonatomic, copy) NSString *productID;

// category tree related
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int fontSize;
@property (nonatomic, assign) BOOL isCategorySelected;
@property (nonatomic, assign) BOOL isSiblingWithoutChild;
@property (nonatomic, assign) BOOL isLastCategory;

- (NSArray <JRFilterValue *>*)getSiblings;
- (NSString *)categoryTree;
- (NSString *)categoryLevel;

@property (nonatomic, getter = isApplied) BOOL applied;
@property (nonatomic, getter = isExist) BOOL exist;
//-----------------------------------------------------

//-----------------------------------------------------
// These properties are only for the Price Filter
@property (nonatomic) float selectedMinPrice;
@property (nonatomic) float selectedMaxPrice;
@property (nonatomic) float minPrice;
@property (nonatomic) float maxPrice;
@property (nonatomic, copy) NSString *filterValuePrefix;
@property (nonatomic, copy) NSString *filterValueSuffix;
@property (nonatomic, copy) NSString *minimumValueLabel;
@property (nonatomic, copy) NSString *maximumValueLabel;
//-----------------------------------------------------

// These properties are only for the Bus duration Filter
@property (nonatomic) float selectedMinDuration;
@property (nonatomic) float selectedMaxDuration;
@property (nonatomic) float minDuration;
@property (nonatomic) float maxDuration;
//-----------------------------------------------------

//-----------------------------------------------------
// These properties are used by bus departure time filters
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *selectedMinDepartureTime;
@property (nonatomic, copy) NSString *selectedMaxDepartureTime;

//-----------------------------------------------------

//-----------------------------------------------------
// These properties are used by all bus filters
@property (nonatomic, copy) NSString *keyName; //since we wont get key name from server,we need to use this
@property (nonatomic, strong) id holderObject; //using to hold location object and bus operator object
//-----------------------------------------------------

- (id)initWithDictionary:(NSDictionary *)dictionary needSelectedFilter:(BOOL)needSelectedFilter level:(int)level;
- (void)setWithDictionary:(NSDictionary *)dictionary needSelectedFilter:(BOOL)needSelectedFilter level:(int)level;
- (id)initWithDictionary:(NSDictionary *)dictionary andFilter:(JRFilter *)filter level:(int)level;

- (NSString *)title;
- (NSString*)uniqueId;
- (NSArray *)ancestorFilterValues;


@end
