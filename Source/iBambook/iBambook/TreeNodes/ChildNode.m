//  Copyright 2009 Apple Inc. All rights reserved.
//  Migrated from Apple's sample code by Neo Lee on 1/14/11.

#import "ChildNode.h"

@implementation ChildNode

- (id)init
{
	if ((self = [super init]))
	{
		nodeTitle = [[NSString alloc] initWithString:@""];
		description = [[NSString alloc] initWithString:@"Empty description"];
		text = [[NSTextStorage alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[description release];
	[text release];
	[super dealloc];
}

- (void)setDescription:(NSString*)newDescription
{
	[newDescription retain];
	[description release];
	description = newDescription;
}

- (NSString*)description
{
	return description;
}

- (void)setText:(id)newText
{
	if ([newText isKindOfClass:[NSAttributedString class]])
		[text replaceCharactersInRange:NSMakeRange(0, [text length]) withAttributedString:newText];
	else
		[text replaceCharactersInRange:NSMakeRange(0, [text length]) withString:newText];
}

- (NSTextStorage*)text
{
	return text;
}

// -------------------------------------------------------------------------------
//	Maintain support for archiving and copying.
// -------------------------------------------------------------------------------
- (NSArray*)mutableKeys
{
	return [[super mutableKeys] arrayByAddingObjectsFromArray:
				[NSArray arrayWithObjects:@"description", @"text", nil]];
}

@end
