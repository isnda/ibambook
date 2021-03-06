//
//  iBambookAppDelegate.m
//  iBambook
//
//  Created by Neo Lee on 1/13/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import "iBambookAppDelegate.h"
#import "BBURL.h"
#import "SideBarController.h"
#import "BBContentController.h"
#import "BBShelfController.h"
#import "BBAppsController.h"
#import "BBDeviceController.h"
#import "BBDeviceShelfController.h"
#import "BBDeviceAppsController.h"
#import "BBUserController.h"


#define kMinSideBarWidth 200.0f


@implementation iBambookAppDelegate

@synthesize window;
@synthesize splitView;
@synthesize sideBarView;
@synthesize containerView;


#pragma mark - Main Window Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    SideBarController *sideBarController = [[SideBarController alloc] initWithNibName:@"SideBarController" bundle:nil];
    
    // SideBarController uses this delegate control content view switch
    [sideBarController setAppDelegate:self];
    
    NSView *v = [sideBarController view];
    [v setFrame:[sideBarView frame]];
    [sideBarView addSubview:v];
    [splitView setDividerColor:[[sideBarController sideBarView] backgroundColor]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
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


#pragma mark - Content View Switcher

- (void)removeContentView
{
	// Empty selection
	NSArray *subViews = [containerView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[containerView displayIfNeeded];	// We want the removed views to disappear right away
    
    currentContentView = nil;
}

- (void)changeContentView:(NSString *)urlString
{
    // DEBUG: Use the following line to verify BBURL url generating
//    NSLog(@"Enter changeContentView with URL=%@", urlString);

    // If nil URL is sent in, just remove current content view and return
    if (!urlString) {
        [self removeContentView];
        currentContentView = nil;
        return;
    }
    
    // Load corresponding content view via selected item's URL
    BBURL *bburl = [[BBURL alloc] initWithBBURL:urlString];
    
    BBContentController *newContentController = nil;
    if ([bburl isShelf]) {
        if ([bburl isDeviceLocal]) {
            newContentController = [[BBShelfController alloc] initWithNibName:@"BBShelfController" bundle:nil];
        } else {
            newContentController = [[BBDeviceShelfController alloc] initWithNibName:@"BBDeviceShelfController" bundle:nil];
        }
    } else if ([bburl isApps]) {
        if ([bburl isDeviceLocal]) {
            newContentController = [[BBAppsController alloc] initWithNibName:@"BBAppsController" bundle:nil];
        } else {
            newContentController = [[BBDeviceAppsController alloc] initWithNibName:@"BBDeviceAppsController" bundle:nil];
        }
    } else if ([bburl isDevice]) {
        newContentController = [[BBDeviceController alloc] initWithNibName:@"BBDeviceController" bundle:nil];
    } else if ([bburl isUser]) {
        newContentController = [[BBUserController alloc] initWithNibName:@"BBUserController" bundle:nil];
    }

    if (newContentController) {
        // Set controller properties
        [newContentController setBbURL:bburl];
        [newContentController setAppDelegate:self];
        
        NSView *newContentView = [newContentController view];
        
        // Switch to new subview
        [self removeContentView];
        
        [containerView addSubview:newContentView];
        currentContentView = newContentView;
        
        // Make sure newly added content subview is placed and resizes correctly
        [currentContentView setFrame:[[currentContentView superview] frame]];    
        [currentContentView setFrameOrigin:NSMakePoint(0,0)];
        [currentContentView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    }
}


@end
