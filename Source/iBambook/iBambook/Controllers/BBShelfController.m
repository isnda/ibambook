//
//  BBShelfController.m
//  iBambook
//
//  Created by Neo Lee on 1/19/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import "BBShelfController.h"
#import "MGScopeBar.h"


// Keys for our scope bar data
#define GROUP_LABEL				@"Label"			// string
#define GROUP_SEPARATOR			@"HasSeparator"		// BOOL as NSNumber
#define GROUP_SELECTION_MODE	@"SelectionMode"	// MGScopeBarGroupSelectionMode (int) as NSNumber
#define GROUP_ITEMS				@"Items"			// array of dictionaries, each containing the following keys:
#define ITEM_IDENTIFIER			@"Identifier"		// string
#define ITEM_NAME				@"Name"				// string

@implementation BBShelfController

@synthesize scopeGroups;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Initialize the scope bar
        self.scopeGroups = [NSMutableArray arrayWithCapacity:0];
        scopeBar.smartResizeEnabled = NO;
        scopeBar.delegate = self;
        
        // Add the unique group of items
        NSArray *items = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"ByName", ITEM_IDENTIFIER, @"Name", ITEM_NAME, nil], 
                          [NSDictionary dictionaryWithObjectsAndKeys:@"ByAuthor", ITEM_IDENTIFIER, @"Author", ITEM_NAME, nil], 
                          [NSDictionary dictionaryWithObjectsAndKeys:@"ByCategory", ITEM_IDENTIFIER, @"Category", ITEM_NAME, nil], 
                          [NSDictionary dictionaryWithObjectsAndKeys:@"ByUpdate", ITEM_IDENTIFIER, @"Update", ITEM_NAME, nil], 
                          [NSDictionary dictionaryWithObjectsAndKeys:@"ByDate", ITEM_IDENTIFIER, @"Date", ITEM_NAME, nil], 
                          nil];
        
        [self.scopeGroups addObject:[NSDictionary dictionaryWithObjectsAndKeys:
//                                     @"Sort by", GROUP_LABEL, 
                                     [NSNumber numberWithBool:NO], GROUP_SEPARATOR, 
                                     [NSNumber numberWithInt:MGRadioSelectionMode], GROUP_SELECTION_MODE, // single selection group.
                                     items, GROUP_ITEMS, 
                                     nil]];
        
        // Tell the scope bar to ask us for data (since we're the scope-bar's delegate).
        [scopeBar reloadData];
        
        // Since our first group is a radio-mode group, the scope bar will automatically select its first item.
        // The scope bar will take care of deselecting other items when you select a new item in a radio-mode group.
    }
    
    return self;
}

- (void)awakeFromNib {
}


- (void)dealloc {
    [scopeGroups release];
    
    [super dealloc];
}


#pragma mark MGScopeBarDelegate

- (int)numberOfGroupsInScopeBar:(MGScopeBar *)theScopeBar
{
	return [self.scopeGroups count];
}


- (NSArray *)scopeBar:(MGScopeBar *)theScopeBar itemIdentifiersForGroup:(int)groupNumber
{
	return [[self.scopeGroups objectAtIndex:groupNumber] valueForKeyPath:[NSString stringWithFormat:@"%@.%@", GROUP_ITEMS, ITEM_IDENTIFIER]];
}


- (NSString *)scopeBar:(MGScopeBar *)theScopeBar labelForGroup:(int)groupNumber
{
	return [[self.scopeGroups objectAtIndex:groupNumber] objectForKey:GROUP_LABEL]; // Might be nil, which is fine (nil means no label).
}


- (NSString *)scopeBar:(MGScopeBar *)theScopeBar titleOfItem:(NSString *)identifier inGroup:(int)groupNumber
{
	NSArray *items = [[self.scopeGroups objectAtIndex:groupNumber] objectForKey:GROUP_ITEMS];
	if (items) {
		// We'll iterate here, since this is just a demo. This avoids having to keep an NSDictionary of identifiers 
		// for each group as well as an array for ordering. In a more realistic scenario, you'd probably want to be 
		// able to look-up an item by its identifier in constant time.
		for (NSDictionary *item in items) {
			if ([[item objectForKey:ITEM_IDENTIFIER] isEqualToString:identifier]) {
				return [item objectForKey:ITEM_NAME];
				break;
			}
		}
	}
	return nil;
}


- (MGScopeBarGroupSelectionMode)scopeBar:(MGScopeBar *)theScopeBar selectionModeForGroup:(int)groupNumber
{
	return [[[self.scopeGroups objectAtIndex:groupNumber] objectForKey:GROUP_SELECTION_MODE] intValue];
}


- (BOOL)scopeBar:(MGScopeBar *)theScopeBar showSeparatorBeforeGroup:(int)groupNumber
{
	// Optional method. If not implemented, all groups except the first will have a separator before them.
	return [[[self.scopeGroups objectAtIndex:groupNumber] objectForKey:GROUP_SEPARATOR] boolValue];
}


- (NSImage *)scopeBar:(MGScopeBar *)scopeBar imageForItem:(NSString *)identifier inGroup:(int)groupNumber
{	
	return nil;
}


- (NSView *)accessoryViewForScopeBar:(MGScopeBar *)scopeBar
{
	// Optional method. If not implemented (or if you return nil), the scope-bar will not have an accessory view.
	return nil;
}


- (void)scopeBar:(MGScopeBar *)theScopeBar selectedStateChanged:(BOOL)selected 
		 forItem:(NSString *)identifier inGroup:(int)groupNumber
{
	// TODO: Scope bar event log
	NSString *displayString = [NSString stringWithFormat:@"\"%@\" %@ in group %d.", 
							   [self scopeBar:theScopeBar titleOfItem:identifier inGroup:groupNumber], 
							   (selected) ? @"selected" : @"deselected", 
							   groupNumber];
	NSLog(@"%@", displayString);
}


@end
