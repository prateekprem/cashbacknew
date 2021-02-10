//
//  RSNavBar.m
//  NavigationIOS
//
//  Created by Amar Udupa on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSFolderNavigationBar.h"

#define CELL_WIDTH 40
#define IPHONE_CELL_HEIGHT 30
#define IPAD_CELL_HEIGHT 40

#define CELL_SPACING 5
#define CELL_LEFT_SPACING 5


@interface RSFolderNavigationBar()
{
@private
    NSMutableArray *barItemCells;
    NSMutableArray *barItems;
    NSInteger currentSelectedIndex;
    CGFloat previousWidth;
    BOOL forceLayout;
}

@property(nonatomic,retain)NSMutableArray *barItemCells;
@property(nonatomic,retain)NSMutableArray *barItems;
@property(nonatomic,assign)NSInteger currentSelectedIndex;
@property(nonatomic,retain)NSMutableIndexSet *selectedIndexes;

-(CGRect )nextCellFrameForRect : (CGRect )inRect;
-(NSUInteger)cellSpacing;
-(NSUInteger)leftSpacing;
- (void)reloadData;
-( void )removeCellsAtIndexes : ( NSIndexSet *)indexset;
-( void )removeAllSelection;

-(void)changeSelectionToIndex:(NSInteger)inIndex;
-(void)selectItemAtCellIndex:(NSNumber*)inIndex;

@end
@implementation RSFolderNavigationBar

@synthesize navBarDelegate;
@synthesize barItemCells;
@synthesize barItems;
@synthesize currentSelectedIndex;
@synthesize selectedIndexes;
@synthesize selectInsertedItem;

#pragma initialize

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [selectedIndexes release];
    selectedIndexes = nil;
    [barItems release];
    barItems = nil;
    [barItemCells release];
    barItemCells = nil;
    [super dealloc];
}


#pragma --

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectedIndexes = [NSMutableIndexSet indexSet];
	self.barItems = [NSMutableArray array];
    self.clipsToBounds = YES;
}

#pragma layout Subviews

-(void)layoutSubviews
{
    [super layoutSubviews];
   	NSInteger i, j, item_count, old_view_count;
	id item;
	RSFolderNavigationItemCell *view;
	NSMutableArray *old_views;
	CGFloat x, y;
	CGRect bounds, frame;
	
	bounds = [self bounds];
    if (previousWidth != bounds.size.width || forceLayout == YES)
    {
        item_count = [self.barItems count];
		old_views = [NSMutableArray arrayWithArray:self.barItemCells];
		old_view_count = [self.barItemCells count];
        self.barItemCells = nil;
        
		self.barItemCells = [[[NSMutableArray alloc] init] autorelease];
        x = [self leftSpacing];
		CGFloat cellHeight = IPHONE_CELL_HEIGHT;
		y = (self.bounds.size.height - cellHeight)*0.5;
        
		previousWidth = bounds.size.width;
		CGRect nxtRect;

		for (i = 0; i < item_count; i++)
		{
			frame = CGRectMake (x, y, CELL_WIDTH, cellHeight);
			item = [self.barItems objectAtIndex:i];
			
			for (j = 0; j < old_view_count; j++)
			{
				view = [old_views objectAtIndex:j];
				if ([[[view representedItem] filterId] isEqualToString:[item filterId]])
				{
                    CGRect viewFrame = view.frame;
                    frame.size.width = viewFrame.size.width;
                    frame.size.height = viewFrame.size.height;

					[view setFrame:frame];
					[old_views removeObjectAtIndex:j];
					old_view_count--;
					goto got_view;
				}
			}
			
			view = [[RSFolderNavigationItemCell alloc] initWithframe:frame representedItem:item];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
			[view addGestureRecognizer:tapGesture];
            tapGesture.cancelsTouchesInView = NO;
			tapGesture.numberOfTouchesRequired = 1;
			[tapGesture release];
            
            view.delegate = self;
            [view configureCellInformation];
            
            CGRect viewFrame = view.frame;
            frame.size.width = viewFrame.size.width;
            frame.size.height = viewFrame.size.height;
            
            view.opaque =  YES ;
            
			[self addSubview:view];
            [view release];
		got_view:
			[self.barItemCells addObject:view];
			
			nxtRect = [self nextCellFrameForRect:frame];
			x = nxtRect.origin.x;
			y = nxtRect.origin.y;			
		}
        float cntwdth = x;
        float cntHgt=[ self bounds].size.height;
        [self setContentSize:CGSizeMake (cntwdth ,cntHgt)];
		for (view in old_views)
		{
			[view removeFromSuperview];
		}
		if(forceLayout)
			[ UIView commitAnimations];
    }
    if (self.barItemCells.count == 0)
    {
        [self.selectedIndexes removeAllIndexes];
    }
    if(forceLayout == YES)
	{
		//To show selection during the launch - Praveen
		NSUInteger index=[self.selectedIndexes firstIndex];
		while(index != NSNotFound)
		{
			RSFolderNavigationItemCell *cell = [self.barItemCells objectAtIndex:index];
			[cell setSelected:YES];
			index=[self.selectedIndexes indexGreaterThanIndex: index];
		}
		forceLayout = NO;
	}
}

#pragma reorder cells
-(void)reorderCells
{
	NSInteger i, item_count ;
	RSFolderNavigationItemCell *view;
	CGFloat x, y;
	CGRect viewBounds, frame;
	
	viewBounds = [self bounds];
	
	item_count = [self.barItemCells count];
	
	x = [self leftSpacing];
	CGFloat cellHeight = IPHONE_CELL_HEIGHT;
    y = (CGRectGetHeight(viewBounds)-cellHeight)*0.5;
    
	[UIView beginAnimations:NULL  context:NULL ];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.4];
	CGRect nxtRect;
	for (i = 0; i < item_count; i++)
	{
        view = [self.barItemCells objectAtIndex:i];
        frame = [view calculateFrame];
        frame.origin = CGPointMake(x,y);
		[view setFrame:frame];
		nxtRect = [ self nextCellFrameForRect:frame];
		x = nxtRect.origin.x;
		y = nxtRect.origin.y;
	}
	
	CGFloat cntwdth = viewBounds.size.width;
    CGFloat cntHgt=viewBounds.size.height;
    if(x > viewBounds.size.width)
        cntwdth = x;	
	[self setContentSize:CGSizeMake (cntwdth ,cntHgt)];
	[UIView commitAnimations];
}

#pragma cell spacing


-(NSUInteger)cellSpacing
{
	return CELL_SPACING;
}

-(NSUInteger)leftSpacing
{
	return CELL_LEFT_SPACING;
}

-(CGRect )nextCellFrameForRect : (CGRect )inRect
{
    CGRect newRect = inRect;
	newRect.origin.x += inRect.size.width + [self cellSpacing];
	return newRect;
}

#pragma reload items
- (void)reloadData
{
	forceLayout = YES;
	[self setNeedsLayout];
}

#pragma gesture handler

-(void)handleTap:(UIGestureRecognizer*)inGesture
{
    RSFolderNavigationItemCell *cell = (RSFolderNavigationItemCell*)[ inGesture view];
    if(!CGRectContainsPoint(cell.deleteButton.frame, [inGesture locationInView:cell]))
    {
        [self removeAllSelection];
        if ([self.barItemCells count])
        {
            NSUInteger index = [self.barItemCells indexOfObject:cell];
            if (index != NSNotFound)
            {
                [self.selectedIndexes addIndex:index];
                [cell setSelected:YES];
                [self changeSelectionToIndex:index];
            }
        }
    }
}

#pragma setter methods
-(void)setItems:(NSArray*)inItems
{
    self.barItems = [NSMutableArray arrayWithArray:inItems];
    [self reloadData];
}

-(void)insertItem:(id<RSFolderNavigationBarItem>)inItem
{
    if(NSNotFound == [self.barItems indexOfObjectIdenticalTo:inItem])
    {
        [self.barItems addObject:inItem];
        [self reloadData];
        if(self.selectInsertedItem)
            [self performSelector:@selector(selectItemAtCellIndex:) withObject:@([self.barItems count]-1) afterDelay:0.1];
    }
}

-(void)insertItem:(id<RSFolderNavigationBarItem>)inItem atIndex:(NSInteger)inIndex
{
    if(NSNotFound == [self.barItems indexOfObjectIdenticalTo:inItem])
    {
        if (inIndex == 0 && self.contentSize.width > self.frame.size.width && self.disableInsertAnimation == NO)
        {
            CGSize requiredSize = [[inItem title] boundingRectWithSize:CGSizeMake(FLT_MAX, IPHONE_CELL_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            
            float x_offset = requiredSize.width + 60;// 40 is padding
            [self setContentOffset:CGPointMake(x_offset, 0.0f)];
        }
        
        [self.barItems insertObject:inItem atIndex:inIndex];
        [self reloadData];
        [self setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
        if(self.selectInsertedItem)
            [self performSelector:@selector(selectItemAtCellIndex:) withObject:@(inIndex) afterDelay:0.1];
    }
}

-(void)deleteItem:(id<RSFolderNavigationBarItem>)inItem
{
    if(NSNotFound != [self.barItems indexOfObjectIdenticalTo:inItem])
    {
        NSInteger index = [self.barItems indexOfObjectIdenticalTo:inItem];
        
        [self removeCellsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    }
}

-(void)deleteItemAtIndex:(NSInteger)inIndex
{
    if(inIndex < self.barItemCells.count)
    {
        [self removeCellsAtIndexes:[NSIndexSet indexSetWithIndex:inIndex]];
    }
}

#pragma private methods
-(void)removeCellsAtIndexes: (NSIndexSet*)indexset
{
	if (indexset && self.barItemCells.count)
	{
		NSArray *array = [self.barItemCells objectsAtIndexes:indexset];
		UIView *view = nil;
		
		for (view in array)
		{
            [self scrollRectToVisible:view.frame animated:NO];
            
			[UIView beginAnimations:NULL context:view];
			[UIView setAnimationCurve:UIViewAnimationCurveLinear];
			[UIView setAnimationDuration:0.2];
			[UIView setAnimationDelegate:self];
			CGAffineTransform transform = CGAffineTransformIdentity;
			transform = CGAffineTransformScale(transform, 0.05, 0.05);
			view.transform = transform;
			[UIView commitAnimations];
		}
        if (self.barItemCells.count)
        {
            [self.barItemCells removeObjectsAtIndexes:indexset];
        }
		indexset = [[indexset copy] autorelease];
		[self.selectedIndexes removeAllIndexes];
        if (self.barItems.count)
        {
            [self.barItems removeObjectsAtIndexes:indexset];
        }
	}
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[(UIView*)context removeFromSuperview];
	[self reorderCells];
}

#pragma nav bar item cell callback
-(void)deleteCell:(RSFolderNavigationItemCell*)cell
{
    NSUInteger index = [ self.barItemCells indexOfObject:cell];
    
    if (index != NSNotFound) {
        [self removeCellsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
        
        if([self.navBarDelegate respondsToSelector:@selector(navBar:removeItemAtIndex:)])
        {
            [self.navBarDelegate navBar:self removeItemAtIndex:index];
        }
    }
}

#pragma selection
-( void )removeAllSelection
{
	NSInteger index = [self.selectedIndexes firstIndex];
	while (index != NSNotFound) {
		[ [ self.barItemCells objectAtIndex:index] setSelected:NO];
		index = [ self.selectedIndexes indexGreaterThanIndex:index];
		
	}
	[ self.selectedIndexes removeAllIndexes];
}

-(void)selectItemAtCellIndex:(NSNumber*)inIndex
{
    [self removeAllSelection];
    RSFolderNavigationItemCell *cell = (RSFolderNavigationItemCell*)[self.barItemCells objectAtIndex:[inIndex integerValue]];
    [self.selectedIndexes addIndex:[inIndex integerValue]];
    CGRect frame = cell.frame;
    [self scrollRectToVisible:frame animated:TRUE];
    [cell setSelected:YES];
    [self changeSelectionToIndex:[inIndex integerValue]];
}

-(void)changeSelectionToIndex:(NSInteger)inIndex
{
	if ([self.navBarDelegate respondsToSelector:@selector(navBarItemSelectionDidChange:toIndex:)]) 
	{
		[ (id<RSNavBarDeleagte>)self.navBarDelegate navBarItemSelectionDidChange:self toIndex:inIndex];
	}
}

-(void)selectItemAtIndex:(NSInteger)inIndex
{
    [self selectItemAtCellIndex:[NSNumber numberWithInteger:inIndex]];
}
@end
