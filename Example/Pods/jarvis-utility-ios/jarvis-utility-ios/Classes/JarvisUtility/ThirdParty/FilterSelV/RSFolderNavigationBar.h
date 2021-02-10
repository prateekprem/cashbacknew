//
//  RSNavBar.h
//  NavigationIOS
//
//  Created by Amar Udupa on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSFolderNavigationItemCell.h"

@class RSFolderNavigationBar;

@protocol RSFolderNavigationBarItem <NSObject>

@required
- (NSString *) title;  
- (NSString*)uniqueId;
@end


@protocol RSNavBarDeleagte <NSObject>

@optional

-(void)navBarItemSelectionDidChange:(RSFolderNavigationBar*)inNavBar toIndex:(NSInteger)index;

-(void)navBar:(RSFolderNavigationBar*)inNavBar itemsAddedAtIndexex:( NSIndexSet *)indexSet;;

-(void)navBar:(RSFolderNavigationBar*)inNavBar removeItemsAtIndexes:( NSIndexSet *)indexSet;

-(void)navBar:(RSFolderNavigationBar*)inNavBar removeItemAtIndex:( NSUInteger )index;
@end

@interface RSFolderNavigationBar : UIScrollView <RSFolderNavigationItemCellDelegate>

@property(nonatomic,assign) id <RSNavBarDeleagte> navBarDelegate;
@property(nonatomic,assign) BOOL selectInsertedItem;

/**
 *  Override point for insert animation. Insert at index animation seems to break for index 0.
 *  Need a proper analysis for it. When the frame of the item changes then it gives extra offsets.
 *  Default value is NO.
 */
@property(nonatomic,assign) BOOL disableInsertAnimation;

-(void)setItems:(NSArray*)inItems;
-(void)insertItem:(id<RSFolderNavigationBarItem>)inItem;
-(void)insertItem:(id<RSFolderNavigationBarItem>)inItem atIndex:(NSInteger)inIndex;
-(void)deleteItem:(id<RSFolderNavigationBarItem>)inItem;
-(void)deleteItemAtIndex:(NSInteger)inIndex;
-(void)selectItemAtIndex:(NSInteger)inIndex;
@end
