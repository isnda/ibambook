//
//  iBambookAppDelegate.h
//  iBambook
//
//  Created by Neo Lee on 1/13/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHSplitView.h"

@interface iBambookAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSView *currentContentView;
    
    NSWindow *window;
    SHSplitView *splitView;
    NSView *sideBarView;
    NSView *containerView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SHSplitView *splitView;
@property (assign) IBOutlet NSView *sideBarView;
@property (assign) IBOutlet NSView *containerView;

- (void)removeContentView;
- (void)changeContentView:(NSString *)urlString;

@end
