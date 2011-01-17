//  Copyright 2009 Apple Inc. All rights reserved.
//  Migrated from Apple's sample code by Neo Lee on 1/14/11.

#import <Cocoa/Cocoa.h>

#import "BaseNode.h"

@interface ChildNode : BaseNode
{
	NSString *description;
	NSTextStorage *text;
}

- (void)setDescription:(NSString *)newDescription;
- (NSString *)description;
- (void)setText:(id)newText;
- (NSTextStorage *)text;

@end
