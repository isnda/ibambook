//
//  iBambookAppDelegate.m
//  iBambook
//
//  Created by Neo Lee on 1/13/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import "iBambookAppDelegate.h"

#define kMinSideBarWidth 200.0f


@implementation iBambookAppDelegate

@synthesize window;
@synthesize splitView;
@synthesize sideBarView;
@synthesize contentView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    SideBarController* sideBarController = [[SideBarController alloc] initWithNibName:@"SideBarController" bundle:nil];
    
    NSView* v1 = [sideBarController view];
    [v1 setFrame:[sideBarView frame]];
    [sideBarView addSubview:v1];
}


#pragma mark - Split View Delegation

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate + kMinSideBarWidth;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate - kMinSideBarWidth;
}

- (void)splitView:(NSSplitView*)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
	NSRect newFrame = [sender frame]; // Get the new size of the whole splitView
	NSView *left = [[sender subviews] objectAtIndex:0];
	NSRect leftFrame = [left frame];
	NSView *right = [[sender subviews] objectAtIndex:1];
	NSRect rightFrame = [right frame];
    
	CGFloat dividerThickness = [sender dividerThickness];
    
	leftFrame.size.height = newFrame.size.height;
    
	rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
	rightFrame.size.height = newFrame.size.height;
	rightFrame.origin.x = leftFrame.size.width + dividerThickness;
    
	[left setFrame:leftFrame];
	[right setFrame:rightFrame];
}


@end
