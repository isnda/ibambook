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

	BOOL buildingSideBar; // Signifies we are building the sidebar content at launch time
    
    SeparatorCell *separatorCell;

    NSTreeController *treeController;
    NSOutlineView *sidebarView;
}
@property (assign) IBOutlet NSTreeController *treeController;
@property (assign) IBOutlet NSOutlineView *sidebarView;

- (void)setContents:(NSArray *)newContents;
- (NSMutableArray *)contents;

- (void)populateSideBarContents:(id)inObject;

@end
