//
//  RangeSlider.h
//  RangeSlider
//
//  Created by Mal Curtis on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RangeSlider : UIControl

@property(nonatomic) float distanceFromCenter;
@property(nonatomic) float padding;
@property(nonatomic) BOOL maxThumbOn;
@property(nonatomic) BOOL minThumbOn;

@property(nonatomic) UIImageView* minThumb;
@property(nonatomic) UIImageView* maxThumb;
@property(nonatomic) UIImageView* track;
@property(nonatomic) UIImageView* trackBackground;

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nonatomic) float minimumRange;
@property(nonatomic) float selectedMinimumValue;
@property(nonatomic) float selectedMaximumValue;

-(void)setup;
-(void)updateTrackHighlight;

@end
