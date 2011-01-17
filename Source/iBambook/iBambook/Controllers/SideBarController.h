//
//  SideBarController.h
//  iBambook
//
//  Created by Neo Lee on 1/14/11.
//  Copyright 2011 Ragnarok Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iBambookAppDelegate.h"

@class SeparatorCell;

@interface SideBarController : NSViewController {
@private
	NSMutableArray *contents;
    
	BOOL duringStartUp; // Signifies building the sidebar at startup
    
	NSImage *imageFolder;
	NSImage *imageURL;
	NSImage *imageDefault;
    
    SeparatorCell *separatorCell;
    
    iBambookAppDelegate *appDelegate;

    NSSplitView *splitView;
    NSTreeController *treeController;
    NSOutlineView *sideBarView;
}
@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSTreeController *treeController;
@property (assign) IBOutlet NSOutlineView *sideBarView;

@property (assign) iBambookAppDelegate *appDelegate;


- (void)setContents:(NSArray *)newContents;
- (NSMutableArray *)contents;

- (void)populateSideBarContents:(id)inObject;

@end
