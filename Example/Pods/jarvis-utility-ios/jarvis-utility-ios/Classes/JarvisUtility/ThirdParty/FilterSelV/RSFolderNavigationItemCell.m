//
//  RSNavBarItemCell.m
//  NavigationIOS
//
//  Created by Amar Udupa on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSFolderNavigationItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewUtils.h"

#define DELETE_BUTTON_SIZE 30
#define OFFSET_BETWEEN_BUTTON_TEXT 5
#define X_AXIS_OFFSET 10

@implementation RSFolderNavigationItemCell

@synthesize representedItem;
@synthesize delegate;
@synthesize selected;
@synthesize deleteButton;
@synthesize titleLabel;
@synthesize countLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(RSFolderNavigationItemCell*)initWithframe:(CGRect)inFrame representedItem:(id)repItem
{
    self = [super initWithFrame:inFrame];
    if(self)
    {
        CGRect titleRect = inFrame;
        titleRect.origin.x = X_AXIS_OFFSET;
        titleRect.origin.y = 0;
        titleRect.size.width = CGRectGetWidth(inFrame) - DELETE_BUTTON_SIZE;
        
        self.backgroundView = [[[UIImageView alloc] initWithFrame:titleRect] autorelease];
        self.backgroundView.image = [[UIImage imageNamed:@"filter_button_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 15, 5, 15)];
        [self addSubview:self.backgroundView];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:titleRect] autorelease];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont helveticaNeueFontOfSize:12.0f];
        [self addSubview:self.titleLabel];
        
        self.countLabel = [[[UILabel alloc] initWithFrame:inFrame] autorelease];
        self.countLabel.left = self.titleLabel.right + 5;
        self.countLabel.height = (self.titleLabel.height / 2.0f) + 2;

        self.countLabel.top = (self.titleLabel.height - self.countLabel.height)/2.0f;
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.font = [UIFont helveticaNeueFontOfSize:10.0f];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.layer.cornerRadius = 8;
        self.countLabel.layer.borderWidth = 0.5f;
        self.countLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:self.countLabel];
        
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton setImage:[UIImage imageNamed:@"remove_filter_button"] forState:UIControlStateNormal];
        self.deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.deleteButton.backgroundColor = [UIColor clearColor];
        
        CGRect deleteButtonFrame = inFrame;
        deleteButtonFrame.origin.x = CGRectGetMaxX(titleRect) + 30 - OFFSET_BETWEEN_BUTTON_TEXT;
        deleteButtonFrame.origin.y = (CGRectGetHeight(inFrame)-DELETE_BUTTON_SIZE)*0.5;
        deleteButtonFrame.size.width = DELETE_BUTTON_SIZE;
        deleteButtonFrame.size.height = DELETE_BUTTON_SIZE;
        self.deleteButton.frame = deleteButtonFrame;
        [self addSubview:self.deleteButton];
        
        self.representedItem = repItem;

    }
    return self;
}

- (void)dealloc {
    [representedItem release];
    representedItem = nil;
    titleLabel = nil;
    deleteButton = nil;    
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma layout subviews
-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma configure cell informations
-(void)configureCellInformation
{
    [self.titleLabel setText:[self.representedItem title]];
    [self.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.representedItem count]]];
    CGRect frameReq = [self calculateFrame];
    self.frame = frameReq;
    
    self.titleLabel.width = [self.titleLabel sizeThatFits:CGSizeMake(INFINITY, self.titleLabel.height)].width;
    self.countLabel.left = self.titleLabel.right + OFFSET_BETWEEN_BUTTON_TEXT;
    self.countLabel.width = [self.countLabel sizeThatFits:CGSizeMake(INFINITY, self.countLabel.height)].width + 10;
    if ([representedItem count] == 0)
    {
        self.countLabel.width = 0;
        self.deleteButton.left = self.titleLabel.right - OFFSET_BETWEEN_BUTTON_TEXT;
        self.countLabel.hidden = YES;
    }
    else
    {
        self.deleteButton.left = self.countLabel.right -  OFFSET_BETWEEN_BUTTON_TEXT;
        self.countLabel.hidden = NO;

    }
    self.backgroundView.frame = self.bounds;
}

-(CGRect)calculateFrame
{
    CGRect requiredFrame = self.frame;
    CGRect titleRect = [self.titleLabel frame];
    
    CGSize requiredSize = [[self.representedItem title] boundingRectWithSize:CGSizeMake(FLT_MAX, titleRect.size.height) options:NSStringDrawingUsesLineFragmentOrigin                                                                   attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    
    self.countLabel.width = [self.countLabel sizeThatFits:CGSizeMake(INFINITY, self.countLabel.height)].width + 10;

    
//    if(titleRect.size.width < requiredSize.width)
    {
        requiredFrame.size.width = requiredSize.width + DELETE_BUTTON_SIZE + OFFSET_BETWEEN_BUTTON_TEXT + (([self.representedItem count] == 0) ? 0 : OFFSET_BETWEEN_BUTTON_TEXT + self.countLabel.width);
    }
    return requiredFrame;
}

#pragma button action

-(void)deleteItem:(id)sender
{
    if([self.delegate respondsToSelector:@selector(deleteCell:)])
        [self.delegate deleteCell:self];
}

#pragma selection

-(void)setSelected:(BOOL)isSelected
{
//    if(isSelected)
//    {
//        self.layer.borderWidth = 1.0f;
//        self.layer.borderColor = [UIColor blueColor].CGColor;
//    }
//    else
//    {
//        self.layer.borderWidth = 0.0f;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//    }
}
@end
