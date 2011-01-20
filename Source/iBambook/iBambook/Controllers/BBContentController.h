//
//  BBContentController.h
//  iBambook
//
//  Created by Neo Lee on 1/20/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BBURL.h"
#import "iBambookAppDelegate.h"


@interface BBContentController : NSViewController {
@private
    BBURL *bbURL;
    iBambookAppDelegate *appDelegate;
}
@property (assign) BBURL *bbURL;
@property (assign) iBambookAppDelegate *appDelegate;

@end
