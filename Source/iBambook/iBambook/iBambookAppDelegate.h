//
//  iBambookAppDelegate.h
//  iBambook
//
//  Created by Neo Lee on 1/13/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SideBarController.h"

@interface iBambookAppDelegate : NSObject <NSApplicationDelegate> {

    NSWindow *window;
    NSSplitView *splitView;
    NSView *sideBarView;
    NSView *contentView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSView *sideBarView;
@property (assign) IBOutlet NSView *contentView;

@end
