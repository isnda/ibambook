//
//  BBURLParser.m
//  iBambook
//
//  Created by Neo Lee on 1/20/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import "BBURL.h"


@implementation BBURL

- (id)initWithURL:(NSString *)url
{
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}


- (id)init {
    return [self initWithURL:nil];
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
