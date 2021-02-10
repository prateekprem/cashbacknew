//
//  MapmyIndiaMapView.h
//  dynamic
//
//  Created by Akram on 06/07/18.
//  Copyright © 2018 Mapbox. All rights reserved.
//

#import "MGLMapView.h"

@class MapmyIndiaMapView;

@protocol MapmyIndiaMapViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol MapmyIndiaMapViewDelegate<NSObject, MGLMapViewDelegate>

#pragma mark authorization
@optional

/**
 This will be called whenever map successfully received its key for tiles Authorization.
 
 @param mapView Insance of self i.e 'MapmyIndiaMapView' will be returned.
 @param isSuccess If `YES`, key for tile is exists in system otherwise 'NO'
 */
- (void)mapView:(MapmyIndiaMapView *)mapView authorizationCompleted:(BOOL)isSuccess;

@end

MGL_EXPORT IB_DESIGNABLE
@interface MapmyIndiaMapView : MGLMapView

#pragma mark Creating Instances

#pragma mark Accessing the Delegate

/**
 The receiver’s delegate.
 
 A map view sends messages to its delegate to notify it of changes to its
 contents or the viewpoint. The delegate also provides information about
 annotations displayed on the map, such as the styles to apply to individual
 annotations.
 */
@property(nonatomic, weak, nullable) IBOutlet id<MapmyIndiaMapViewDelegate> delegate;

#pragma mark Configuring the Map’s Appearance

/**
 Initializes and returns a newly allocated map view with the specified frame
 and the default style.
 
 @param frame The frame for the view, measured in points.
 @return An initialized map view.
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 Initializes and returns a newly allocated map view with the specified frame
 and style URL.
 
 @param frame The frame for the view, measured in points.
 @param styleURL URL of the map style to display. The URL may be a full HTTP
 or HTTPS URL.
 @return An initialized map view.
 */
- (instancetype)initWithFrame:(CGRect)frame styleURL:(nullable NSURL *)styleURL;

/**
 Initializes and returns a newly allocated map view with the specified frame
 and style URL.
 */
- (void)reAuthorizeMap;

@end

NS_ASSUME_NONNULL_END
