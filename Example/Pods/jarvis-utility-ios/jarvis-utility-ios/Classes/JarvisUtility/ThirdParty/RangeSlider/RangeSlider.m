//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Mal Curtis on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RangeSlider.h"
#import "ViewUtils.h"

@interface RangeSlider ()
@property(nonatomic, assign) BOOL rectIntersected;
-(float)xForValue:(float)value;
-(float)valueForX:(float)x;
@end

@implementation RangeSlider

- (void)setMinimumValue:(float)minimumValue
{
    if (_minimumValue != minimumValue)
    {
        _minimumValue = minimumValue;
        [self reloadViews];
    }
}

- (void)setMaximumValue:(float)maximumValue
{
    if (_maximumValue != maximumValue)
    {
        _maximumValue = maximumValue;
        [self reloadViews];
    }
}

- (void)setMinimumRange:(float)minimumRange
{
    if (_minimumRange != minimumRange)
    {
        _minimumRange = minimumRange;
        [self reloadViews];
    }
}

- (void)setSelectedMaximumValue:(float)selectedMaximumValue
{
    if (_selectedMaximumValue != selectedMaximumValue)
    {
        _selectedMaximumValue = selectedMaximumValue;
        [self reloadViews];
    }
}

- (void)setSelectedMinimumValue:(float)selectedMinimumValue
{
    if (_selectedMinimumValue != selectedMinimumValue)
    {
        _selectedMinimumValue = selectedMinimumValue;
        [self reloadViews];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reloadViews];
}

- (void)reloadViews
{
    // Set the initial state
    _minThumb.center = CGPointMake([self xForValue:_selectedMinimumValue], self.center.y);
    
    _maxThumb.center = CGPointMake([self xForValue:_selectedMaximumValue], self.center.y);
    
    
    NSLog(@"Tapable size %f", _minThumb.bounds.size.width);
    [self updateTrackHighlight];
}


- (void)setup
{
    
    _minThumbOn = false;
    _maxThumbOn = false;
    _padding = 10;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"slider_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 17, 1, 17)];
    _trackBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, backgroundImage.size.height)];
    _trackBackground.image = backgroundImage;
    _trackBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;

//    _trackBackground.center = self.center;
    _trackBackground.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_trackBackground];
    
    _track = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider"]];
    _track.center = self.center;
    _track.contentMode = UIViewContentModeScaleToFill;
    
    _trackBackground.top = _track.top;

    [self addSubview:_track];
    
    _minThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_thumb"] highlightedImage:[UIImage imageNamed:@"slider_thumb"]];
    _minThumb.frame = CGRectMake(0,0, self.frame.size.height/2, self.frame.size.height);
    _minThumb.contentMode = UIViewContentModeCenter;
    [self addSubview:_minThumb];
    
    _maxThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_thumb"] highlightedImage:[UIImage imageNamed:@"slider_thumb"]];
    _maxThumb.frame = CGRectMake(0,0, self.frame.size.height/2, self.frame.size.height);
    _maxThumb.contentMode = UIViewContentModeCenter;
    [self addSubview:_maxThumb];
}

-(float)xForValue:(float)value{
    return (self.frame.size.width-(_padding*2))*((value - _minimumValue) / MAX(_maximumValue - _minimumValue, 1))+_padding;
}

-(float) valueForX:(float)x{
    return _minimumValue + (x-_padding) / (self.frame.size.width-(_padding*2)) *  MAX(_maximumValue - _minimumValue, 1);
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_minThumbOn && !_maxThumbOn){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint prevPoint = [touch previousLocationInView:self];
    
    if(self.rectIntersected && touchPoint.x - prevPoint.x > 0){
        _maxThumbOn = true;
        _minThumbOn = false;
        self.rectIntersected = false;
    }
    
    if(self.rectIntersected && prevPoint.x - touchPoint.x > 0){
        _minThumbOn = true;
        _maxThumbOn = false;
        self.rectIntersected = false;
    }
    
    if(_minThumbOn){
        _minThumb.center = CGPointMake(MAX([self xForValue:_minimumValue],MIN(touchPoint.x - _distanceFromCenter, [self xForValue:_selectedMaximumValue - _minimumRange])), _minThumb.center.y);
        _selectedMinimumValue = [self valueForX:_minThumb.center.x];
        
    }
    if(_maxThumbOn){
        _maxThumb.center = CGPointMake(MIN([self xForValue:_maximumValue], MAX(touchPoint.x - _distanceFromCenter, [self xForValue:_selectedMinimumValue + _minimumRange])), _maxThumb.center.y);
        _selectedMaximumValue = [self valueForX:_maxThumb.center.x];
    }
    [self updateTrackHighlight];
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    self.rectIntersected = false;
    
    if(CGRectContainsPoint(_minThumb.frame, touchPoint)){
        _minThumbOn = true;
        _distanceFromCenter = touchPoint.x - _minThumb.center.x;
    }
    else if(CGRectContainsPoint(_maxThumb.frame, touchPoint)){
        _maxThumbOn = true;
        _distanceFromCenter = touchPoint.x - _maxThumb.center.x;
        
    }
    
    if (CGRectIntersection(_maxThumb.frame, _minThumb.frame).size.width == CGRectGetWidth(_maxThumb.frame)){
        self.rectIntersected = true;
    }
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
    _minThumbOn = false;
    _maxThumbOn = false;
    
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

-(void)updateTrackHighlight{
	_track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
