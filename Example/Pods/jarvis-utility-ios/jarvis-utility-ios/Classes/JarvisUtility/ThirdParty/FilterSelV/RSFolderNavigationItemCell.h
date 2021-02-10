//
//  RSNavBarItemCell.h
//  NavigationIOS
//
//  Created by Amar Udupa on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSFolderNavigationItemCell;

@protocol RSFolderNavigationItemCellDelegate <NSObject>

-(void)deleteCell:(RSFolderNavigationItemCell*)inCell;

@end

@interface RSFolderNavigationItemCell : UIView
{
    UILabel *titleLabel;
    UIButton *deleteButton;
}

@property(nonatomic,assign)UILabel *titleLabel;
@property(nonatomic,assign)UILabel *countLabel;
@property(nonatomic,assign)UIButton *deleteButton;
@property(nonatomic,assign)UIImageView *backgroundView;

@property(nonatomic,retain)id representedItem;
@property(nonatomic,assign)id<RSFolderNavigationItemCellDelegate> delegate;
@property(nonatomic,assign)BOOL selected;

-(RSFolderNavigationItemCell*)initWithframe:(CGRect)inFrame representedItem:(id)repItem;

-(CGRect)calculateFrame;
-(void)configureCellInformation;
@end
