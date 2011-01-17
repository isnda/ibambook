//  Copyright 2009 Apple Inc. All rights reserved.
//  Migrated from Apple's sample code by Neo Lee on 1/14/11.

#import <Foundation/Foundation.h>

@interface NSArray (MyArrayExtensions)
- (BOOL)containsObjectIdenticalTo:(id)object;
- (BOOL)containsAnyObjectsIdenticalTo:(NSArray *)objects;
- (NSIndexSet *)indexesOfObjects:(NSArray *)objects;
@end
