//
//  SideBarController.h
//  Sandbox
//
//  Created by Neo Lee on 1/14/11.
//  Copyright 2011 Ragnarok Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SeparatorCell;

@interface SideBarController : NSViewController {
@private
    IBOutlet NSSplitView *splitView;
    
	NSMutableArray *contents;
    
	NSImage *folderImage;
	NSImage *urlImage;

	BOOL duringStartUp; // Signifies building the sidebar at startup
    
    SeparatorCell *separatorCell;

    NSTreeController *treeController;
    NSOutlineView *sideBarView;
}
@property (assign) IBOutlet NSTreeController *treeController;
@property (assign) IBOutlet NSOutlineView *sideBarView;

- (void)setContents:(NSArray *)newContents;
- (NSMutableArray *)contents;

- (void)populateSideBarContents:(id)inObject;

@end
