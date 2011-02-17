//
//  SHSplitView.m
//  iBambook
//
//  Created by Neo Lee on 2/17/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import "SHSplitView.h"


@implementation SHSplitView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


// Override these methods to display divider like iTunes' one
- (CGFloat)dividerThickness {
    return 1.0;
}

- (NSColor *)dividerColor {
    return customDividerColor;
}

- (void)setDividerColor:(NSColor *) color {
    customDividerColor = color;
}

@end
