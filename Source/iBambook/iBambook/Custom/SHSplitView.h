//
//  SHSplitView.h
//  iBambook
//
//  Created by Neo Lee on 2/17/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SHSplitView : NSSplitView {
@private
    NSColor *customDividerColor;
}

- (void)setDividerColor:(NSColor *) color;

@end
