//
//  BBContentController.m
//  iBambook
//
//  Created by Neo Lee on 1/20/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import "BBContentController.h"


@implementation BBContentController

@synthesize bbURL, appDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
    }
    
    return self;
}

- (void)dealloc {
    [bbURL release];
    [appDelegate release];
    
    [super dealloc];
}

@end
