//  Copyright 2009 Apple Inc. All rights reserved.
//  Migrated from Apple's sample code by Neo Lee on 1/14/11.

#import "BaseNode.h"
#import "NSArrayExtensions.h"

@implementation BaseNode

- (id)init
{
	if ((self = [super init]))
	{
		[self setNodeTitle:@"BaseNode Untitled"];
		[self setChildren:[NSArray array]];
		[self setLeaf:NO];			// Container by default
	}
	return self;
}

- (id)initLeaf
{
	if ((self = [self init]))
	{
		[self setLeaf:YES];
	}
	return self;
}

- (void)dealloc
{
	[nodeTitle release];
	[children release];
	
	[super dealloc];
}

- (void)setNodeTitle:(NSString *)newNodeTitle
{
	[newNodeTitle retain];
	[nodeTitle release];
	nodeTitle = newNodeTitle;
}

- (NSString *)nodeTitle
{
	return nodeTitle;
}

- (void)setNodeIcon:(NSImage *)icon
{
    if (!nodeIcon || ![nodeIcon isEqual:icon])
	{
		[nodeIcon release];
		nodeIcon = [icon retain];
    }
}

- (NSImage *)nodeIcon
{
    return nodeIcon;
}

- (void)setChildren:(NSArray *)newChildren
{
	if (children != newChildren)
    {
        [children autorelease];
        children = [[NSMutableArray alloc] initWithArray:newChildren];
    }
}

- (NSMutableArray *)children
{
	return children;
}

- (void)setLeaf:(BOOL)flag
{
	isLeaf = flag;
	if (isLeaf)
		[self setChildren:[NSArray arrayWithObject:self]];
	else
		[self setChildren:[NSArray array]];
}

- (BOOL)isLeaf
{
	return isLeaf;
}

- (void)setURL:(NSString *)urlStr
{ 
    if (!urlString || ![urlString isEqualToString:urlStr])
	{
		[urlString release]; 
		urlString = [urlStr retain]; 
    }
}

- (NSString *)urlString
{ 
    return urlString; 
}

- (NSComparisonResult)compare:(BaseNode *)aNode
{
	return [[[self nodeTitle] lowercaseString] compare:[[aNode nodeTitle] lowercaseString]];
}


#pragma mark - Drag and Drop

- (BOOL)isDraggable
{
	BOOL result = YES;
	if ([[self urlString] isAbsolutePath] || [self nodeIcon] == nil)
		result = NO;	// Don't allow file system objects to be dragged or special group nodes
	return result;
}

// --------------------------------------------------------------------
//	Finds the receiver's parent from the nodes contained in the array.
// --------------------------------------------------------------------
- (id)parentFromArray:(NSArray *)array
{
	id result = nil;
	
	for (id node in array)
	{
		if (node == self)	// If we are in the root array, return nil
			break;
		
		if ([[node children] containsObjectIdenticalTo:self])
		{
			result = node;
			break;
		}
		
		if (![node isLeaf])
		{
			id innerNode = [self parentFromArray:[node children]];
			if (innerNode)
			{
				result = innerNode;
				break;
			}
		}
	}
	
	return result;
}

// --------------------------------------------------------------------
//	Recursive method which searches children and children of all sub-nodes
//	to remove the given object.
// --------------------------------------------------------------------
- (void)removeObjectFromChildren:(id)obj
{
	// Remove object from children or the children of any sub-nodes
	NSEnumerator *enumerator = [children objectEnumerator];
	id node = nil;
	
	while ((node = [enumerator nextObject]))
	{
		if (node == obj)
		{
			[children removeObjectIdenticalTo:obj];
			return;
		}
		
		if (![node isLeaf])
			[node removeObjectFromChildren:obj];
	}
}

// --------------------------------------------------------------------
//	Generates an array of all descendants.
// --------------------------------------------------------------------
- (NSArray *)descendants
{
	NSMutableArray *descendants = [NSMutableArray array];
	NSEnumerator *enumerator = [children objectEnumerator];
	id node = nil;
	
	while ((node = [enumerator nextObject]))
	{
		[descendants addObject:node];
		
		if (![node isLeaf])
			[descendants addObjectsFromArray:[node descendants]];	// Recursive - will go down the chain to get all
	}
	return descendants;
}

// --------------------------------------------------------------------
//	Generates an array of all leafs in children and children of all 
//	sub-nodes. Useful for generating a list of leaf-only nodes.
// --------------------------------------------------------------------
- (NSArray *)allChildLeafs
{
	NSMutableArray *childLeafs = [NSMutableArray array];
	NSEnumerator *enumerator = [children objectEnumerator];
	id node = nil;
	
	while ((node = [enumerator nextObject]))
	{
		if ([node isLeaf])
			[childLeafs addObject:node];
		else
			[childLeafs addObjectsFromArray:[node allChildLeafs]];	// Recursive - will go down the chain to get all
	}
	return childLeafs;
}

// --------------------------------------------------------------------
//	Returns only the children that are group nodes.
// --------------------------------------------------------------------
- (NSArray *)groupChildren
{
	NSMutableArray *groupChildren = [NSMutableArray array];
	NSEnumerator *childEnumerator = [children objectEnumerator];
	BaseNode *child;
	
	while ((child = [childEnumerator nextObject]))
	{
		if (![child isLeaf])
			[groupChildren addObject:child];
	}
	return groupChildren;
}

// --------------------------------------------------------------------
//	Returns YES if self is contained anywhere inside the children or
//	children of sub-nodes of the nodes contained inside the given array.
// --------------------------------------------------------------------
- (BOOL)isDescendantOfOrOneOfNodes:(NSArray *)nodes
{
    // Returns YES if we are contained anywhere inside the array passed in, including inside sub-nodes
    NSEnumerator *enumerator = [nodes objectEnumerator];
	id node = nil;
	
    while ((node = [enumerator nextObject]))
	{
		if (node == self)
			return YES;		// we found ourselv
		
		// check all the sub-nodes
		if (![node isLeaf])
		{
			if ([self isDescendantOfOrOneOfNodes:[node children]])
				return YES;
		}
    }
	
    return NO;
}

// --------------------------------------------------------------------
//	Returns YES if any node in the array passed in is an ancestor of ours.
// --------------------------------------------------------------------
- (BOOL)isDescendantOfNodes:(NSArray *)nodes
{
    NSEnumerator *enumerator = [nodes objectEnumerator];
	id node = nil;
	
    while ((node = [enumerator nextObject]))
	{
		// Check all the sub-nodes
		if (![node isLeaf])
		{
			if ([self isDescendantOfOrOneOfNodes:[node children]])
				return YES;
		}
    }

	return NO;
}

// --------------------------------------------------------------------
//	Returns the index path of within the given array,
//	useful for drag and drop.
// --------------------------------------------------------------------
- (NSIndexPath *)indexPathInArray:(NSArray *)array
{
	NSIndexPath *indexPath = nil;
	NSMutableArray *reverseIndexes = [NSMutableArray array];
	id parent, doc = self;
	NSInteger index;
	
	while ((parent = [doc parentFromArray:array]))
	{
		index = [[parent children] indexOfObjectIdenticalTo:doc];
		if (index == NSNotFound)
			return nil;
		
		[reverseIndexes addObject:[NSNumber numberWithInt:index]];
		doc = parent;
	}
	
	// If parent is nil, we should just be in the parent array
	index = [array indexOfObjectIdenticalTo:doc];
	if (index == NSNotFound)
		return nil;
	[reverseIndexes addObject:[NSNumber numberWithInt:index]];
	
	// Now build the index path
	NSEnumerator *re = [reverseIndexes reverseObjectEnumerator];
	NSNumber *indexNumber;
	while ((indexNumber = [re nextObject]))
	{
		if (indexPath == nil)
			indexPath = [NSIndexPath indexPathWithIndex:[indexNumber intValue]];
		else
			indexPath = [indexPath indexPathByAddingIndex:[indexNumber intValue]];
	}
	
	return indexPath;
}


#pragma mark - Archiving And Copying Support

// --------------------------------------------------------------------
//	Override this method to maintain support for archiving and copying.
// --------------------------------------------------------------------
- (NSArray *)mutableKeys
{
	return [NSArray arrayWithObjects:
		@"nodeTitle",
		@"isLeaf",		// isLeaf MUST come before children for initWithDictionary: to work
		@"children", 
		@"nodeIcon",
		@"urlString",
		nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [self init];
	NSEnumerator *keysToDecode = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while ((key = [keysToDecode nextObject]))
	{
		if ([key isEqualToString:@"children"])
		{
			if ([[dictionary objectForKey:@"isLeaf"] boolValue])
				[self setChildren:[NSArray arrayWithObject:self]];
			else
			{
				NSArray *dictChildren = [dictionary objectForKey:key];
				NSMutableArray *newChildren = [NSMutableArray array];
				
				for (id node in dictChildren)
				{
					id newNode = [[[self class] alloc] initWithDictionary:node];
					[newChildren addObject:newNode];
					[newNode release];
				}
				[self setChildren:newChildren];
			}
		}
		else
			[self setValue:[dictionary objectForKey:key] forKey:key];
	}
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	NSEnumerator *keysToCode = [[self mutableKeys] objectEnumerator];
	NSString *key;
	
	while ((key = [keysToCode nextObject]))
	{
		// Convert all children to dictionaries
		if ([key isEqualToString:@"children"])
		{
			if (!isLeaf)
			{
				NSMutableArray *dictChildren = [NSMutableArray array];
				for (id node in children)
				{
					[dictChildren addObject:[node dictionaryRepresentation]];
				}
				
				[dictionary setObject:dictChildren forKey:key];
			}
		}
		else if ([self valueForKey:key])
		{
			[dictionary setObject:[self valueForKey:key] forKey:key];
		}
	}
	return dictionary;
}

- (id)initWithCoder:(NSCoder *)coder
{		
	self = [self init];
	NSEnumerator *keysToDecode = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while ((key = [keysToDecode nextObject]))
		[self setValue:[coder decodeObjectForKey:key] forKey:key];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{	
	NSEnumerator *keysToCode = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while ((key = [keysToCode nextObject]))
		[coder encodeObject:[self valueForKey:key] forKey:key];
}

- (id)copyWithZone:(NSZone *)zone
{
	id newNode = [[[self class] allocWithZone:zone] init];
	
	NSEnumerator *keysToSet = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while ((key = [keysToSet nextObject]))
		[newNode setValue:[self valueForKey:key] forKey:key];
	
	return newNode;
}

// --------------------------------------------------------------------
//	Override this for any non-object values
// --------------------------------------------------------------------
- (void)setNilValueForKey:(NSString *)key
{
	if ([key isEqualToString:@"isLeaf"])
		isLeaf = NO;
	else
		[super setNilValueForKey:key];
}

@end
