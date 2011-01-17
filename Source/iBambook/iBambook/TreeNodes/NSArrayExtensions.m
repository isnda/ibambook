//  Copyright 2009 Apple Inc. All rights reserved.
//  Migrated from Apple's sample code by Neo Lee on 1/14/11.

#import "NSArrayExtensions.h"

@implementation NSArray (MyArrayExtensions)

- (BOOL)containsObjectIdenticalTo:(id)obj
{ 
	return [self indexOfObjectIdenticalTo:obj] != NSNotFound; 
}

- (BOOL)containsAnyObjectsIdenticalTo:(NSArray*)objects
{
	NSEnumerator *e = [objects objectEnumerator];
	id obj;
	while ((obj = [e nextObject]))
	{
		if ([self containsObjectIdenticalTo:obj])
			return YES;
	}
	return NO;
}

- (NSIndexSet*)indexesOfObjects:(NSArray*)objects
{
	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
	NSEnumerator *enumerator = [objects objectEnumerator];
	id obj = nil;
	NSInteger index;
	while ((obj = [enumerator nextObject]))
	{
		index = [self indexOfObject:obj];
		if (index != NSNotFound)
			[indexSet addIndex:index];
	}
	return indexSet;
}

@end
