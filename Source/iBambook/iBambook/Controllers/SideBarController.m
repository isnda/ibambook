//
//  SideBarController.m
//  iBambook
//
//  Created by Neo Lee on 1/14/11.
//  Copyright 2011 Ragnarok Studio. All rights reserved.
//

#import "SideBarController.h"
#import "BBURL.h"
#import "ChildNode.h"
#import "ImageAndTextCell.h"
#import "SeparatorCell.h"


#define COLUMNID_NAME		@"COLUMN_MAIN"

// TODO: All following should be put in an i18n string list
#define LIBRARY_NAME        @"LIBRARY"
#define DEVICES_NAME        @"DEVICES"
#define ACCOUNTS_NAME       @"ACCOUNTS"

#define DEFAULT_NODE_TITLE  @"Untitled Node"
#define DEFAULT_NODE_URL    @""


// --------------------------------------------------------------------
//  TreeAdditionObj
//
//   This object is used for passing data between the main and secondary
//   thread which populates the sidebar content.
// --------------------------------------------------------------------
@interface TreeAdditionObj : NSObject
{
	NSIndexPath *indexPath;
	NSString *nodeURL;
	NSString *nodeName;
	BOOL selectItsParent;
}

@property (readonly) NSIndexPath *indexPath;
@property (readonly) NSString *nodeURL;
@property (readonly) NSString *nodeName;
@property (readonly) BOOL selectItsParent;

@end


@implementation TreeAdditionObj

@synthesize indexPath, nodeURL, nodeName, selectItsParent;

- (id)initWithURL:(NSString *)url withName:(NSString *)name selectItsParent:(BOOL)select
{
	self = [super init];
	
	nodeName = name;
	nodeURL = url;
	selectItsParent = select;
	
	return self;
}

@end


// --------------------------------------------------------------------
//  SideBarController
// --------------------------------------------------------------------
@implementation SideBarController

@synthesize splitView;
@synthesize treeController;
@synthesize sideBarView;

@synthesize appDelegate;


// --------------------------------------------------------------------
//	Property: contents
// --------------------------------------------------------------------
- (void)setContents:(NSArray*)newContents
{
	if (contents != newContents)
	{
		[contents release];
		contents = [[NSMutableArray alloc] initWithArray:newContents];
	}
}

- (NSMutableArray *)contents
{
	return contents;
}


#pragma mark - SideBarController Lifecycle

// --------------------------------------------------------------------
//	SideBarController Lifecycle
// --------------------------------------------------------------------
- (void)initReusedIcons {
    // Cache the reused icon images.
    // TODO: These icons are just for demo
    imageFolder = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)] retain];
    [imageFolder setSize:NSMakeSize(16, 16)];
    
    imageURL = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericURLIcon)] retain];
    [imageURL setSize:NSMakeSize(16, 16)];

    imageDefault = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode('DOCU')] retain];
    [imageDefault setSize:NSMakeSize(16, 16)];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        contents = [[NSMutableArray alloc] init];
        
        [self initReusedIcons];
    }
    
    return self;
}

- (void)dealloc {
    [contents release];
    [imageFolder release];
    [imageURL release];
    
    [super dealloc];
}

- (void)awakeFromNib {
	// Apply our custom ImageAndTextCell for rendering the first column's cells
	NSTableColumn *tableColumn = [sideBarView tableColumnWithIdentifier:COLUMNID_NAME];
	ImageAndTextCell *imageAndTextCell = [[[ImageAndTextCell alloc] init] autorelease];
	[imageAndTextCell setEditable:YES];
	[tableColumn setDataCell:imageAndTextCell];
    
	separatorCell = [[SeparatorCell alloc] init];
    [separatorCell setEditable:NO];

    // Init sidebar content on a separate thread for some portions may involve device access and time consuming
    [NSThread detachNewThreadSelector:@selector(populateSideBarContents:)
                             toTarget:self		// We are the target!
                           withObject:nil];
    
    // Scroll to the top in case the outline contents is very long
	[[[sideBarView enclosingScrollView] verticalScroller] setFloatValue:0.0];
	[[[sideBarView enclosingScrollView] contentView] scrollToPoint:NSMakePoint(0,0)];
	
	// Make our side bar the SourceList style i.e. gradient selection, and behave like the Finder, iTunes, etc.
	[sideBarView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
}


#pragma mark - Side Bar Population

// --------------------------------------------------------------------
// Side bar population and all helper methods
// --------------------------------------------------------------------
- (void)selectParentFromSelection
{
	if ([[treeController selectedNodes] count] > 0)
	{
		NSTreeNode *firstSelectedNode = [[treeController selectedNodes] objectAtIndex:0];
		NSTreeNode *parentNode = [firstSelectedNode parentNode];
		if (parentNode) {
			NSIndexPath* parentIndex = [parentNode indexPath];
			[treeController setSelectionIndexPath:parentIndex];
		} 
		else {
			// No parent exists (we are at the top of tree), so make no selection in our outline
			NSArray* selectionIndexPaths = [treeController selectionIndexPaths];
			[treeController removeSelectionIndexPaths:selectionIndexPaths];
		}
	}
}

- (void)performAddFolder:(TreeAdditionObj *)treeAddition
{
	// NSTreeController inserts objects using NSIndexPath, so we need to calculate this
	NSIndexPath *indexPath = nil;
	
	// If there is no selection, we will add a new group to the end of the contents array
	if ([[treeController selectedObjects] count] == 0) {
		indexPath = [NSIndexPath indexPathWithIndex:[contents count]];
	}
	else {
		// Get the index of the currently selected node, then add the number of its children to the path -
		//  this will give us an index which will allow us to add a node to the end of the currently 
        //  selected node's children array.
		indexPath = [treeController selectionIndexPath];
		if ([[[treeController selectedObjects] objectAtIndex:0] isLeaf]) {
			// User is trying to add a folder on a selected child,
			//  so deselect child and select its parent for addition
			[self selectParentFromSelection];
		}
		else {
			indexPath = [indexPath indexPathByAddingIndex:[[[[treeController selectedObjects] objectAtIndex:0] children] count]];
		}
	}
	
	ChildNode *node = [[ChildNode alloc] init];
	[node setNodeTitle:[treeAddition nodeName]];
	[node setURL:[treeAddition nodeURL]];
	
	// The user is adding a child node, tell the controller directly
	[treeController insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];
    
	// Adding a child automatically becomes selected by NSOutlineView, so keep its parent selected if required
    if ([treeAddition selectItsParent])
		[self selectParentFromSelection];
}

- (void)addFolder:(NSString *)folderName withURL:(NSString *)url selectParent:(BOOL)select
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:url withName:folderName selectItsParent:select];
	
	if (duringStartUp) {
		[self performSelectorOnMainThread:@selector(performAddFolder:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else {
		[self performAddFolder:treeObjInfo];
	}
    
	[treeObjInfo release];
}

- (void)addFolder:(NSString *)folderName
{
    [self addFolder:folderName withURL:nil selectParent:NO];
}

- (void)performAddChild:(TreeAdditionObj *)treeAddition
{
	if ([[treeController selectedObjects] count] > 0) {
		if ([[[treeController selectedObjects] objectAtIndex:0] isLeaf]) {
			[self selectParentFromSelection];
		}
	}
	
	NSIndexPath *indexPath;
	if ([[treeController selectedObjects] count] > 0) {
		indexPath = [treeController selectionIndexPath];
		indexPath = [indexPath indexPathByAddingIndex:[[[[treeController selectedObjects] objectAtIndex:0] children] count]];
	}
	else {
		indexPath = [NSIndexPath indexPathWithIndex:[contents count]];
	}
	
	ChildNode *node = [[ChildNode alloc] initLeaf];
	[node setURL:[treeAddition nodeURL]];
	
	if ([treeAddition nodeURL]) {
		if ([[treeAddition nodeURL] length] > 0) {
			if ([treeAddition nodeName])
				[node setNodeTitle:[treeAddition nodeName]];
			else
                // TODO: All nodes with URL but without name, should go through the protocol analysis
				[node setNodeTitle:[[NSFileManager defaultManager] displayNameAtPath:[node urlString]]];
		}
		else {
			[node setNodeTitle:DEFAULT_NODE_TITLE];
			[node setURL:DEFAULT_NODE_URL];
		}
	}
	
	// The user is adding a child node, tell the controller directly
	[treeController insertObject:node atArrangedObjectIndexPath:indexPath];
    
	[node release];
	
	// Adding a child automatically becomes selected by NSOutlineView, so keep its parent selected if required
	if ([treeAddition selectItsParent])
		[self selectParentFromSelection];
}

- (void)addChild:(NSString *)nodeName withURL:(NSString *)url selectParent:(BOOL)select
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:url withName:nodeName selectItsParent:select];
	
	if (duringStartUp) {
		[self performSelectorOnMainThread:@selector(performAddChild:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else {
		[self performAddChild:treeObjInfo];
	}
	
	[treeObjInfo release];
}

- (void)addLibrarySection {
	[self addFolder:LIBRARY_NAME];
	
	// Add all local library resource
    // TODO: These child nodes are just for demo
    [self addChild:@"Books" withURL:[BBURL makeShelfURL] selectParent:YES];
    [self addChild:@"Apps" withURL:[BBURL makeAppsURL] selectParent:YES];
    
	[self selectParentFromSelection];
}

- (void)addDevicesSection {
	[self addFolder:DEVICES_NAME];
    
	// Add all connected devices
    // TODO: These child nodes are just for demo
    NSString *deviceID = @"bb01";
    
    [self addFolder:@"Neo's Bambook" withURL:[BBURL makeDeviceURLWithDevice:deviceID] selectParent:NO];
    [self addChild:@"Books" withURL:[BBURL makeShelfURLWithDevice:deviceID] selectParent:YES];
    [self addChild:@"Apps" withURL:[BBURL makeAppsURLWithDevice:deviceID] selectParent:YES];
	[self selectParentFromSelection];
    
    // TODO: Here we can add other devices

	[self selectParentFromSelection];
}

- (void)addAccountsSection {
    [self addFolder:ACCOUNTS_NAME];
    
	// Add all managed accounts
    // TODO: These child nodes are just for demo
    NSString *userID = @"neo";
    
    [self addChild:@"Neo Lee" withURL:[BBURL makeUserURL:userID] selectParent:NO];
    
    [self selectParentFromSelection];
}

- (void)populateSideBarContents:(id)inObject
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	duringStartUp = YES;
    
	[sideBarView setHidden:YES];
	
	[self addLibrarySection];
	[self addDevicesSection];
	[self addAccountsSection];
	
	duringStartUp = NO;
	
	// Remove current selection
	NSArray *selection = [treeController selectionIndexPaths];
	[treeController removeSelectionIndexPaths:selection];
	
	[sideBarView setHidden:NO];
	
	[pool release];
}


#pragma mark - NSOutlineView Delegate

// --------------------------------------------------------------------
// Side bar delegation
// --------------------------------------------------------------------
- (BOOL)isSpecialGroup:(BaseNode *)groupNode
{
    // Using node title to determine the topest level(i.e. special) folder
    // TODO: Should be more general
	return ([groupNode nodeIcon] == nil &&
			[[groupNode nodeTitle] isEqualToString:LIBRARY_NAME] || 
            [[groupNode nodeTitle] isEqualToString:DEVICES_NAME] || 
            [[groupNode nodeTitle] isEqualToString:ACCOUNTS_NAME]);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
	BaseNode* node = [item representedObject];
	return (![self isSpecialGroup:node]);
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSCell* returnCell = [tableColumn dataCell];
	
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME]) {
		// We are being asked for the cell for the single and only column
		BaseNode* node = [item representedObject];
        
        // If node has no icon nor title, it should be a separator
		if ([node nodeIcon] == nil && [[node nodeTitle] length] == 0)
			returnCell = separatorCell;
	}
	
	return returnCell;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	return !([[fieldEditor string] length] == 0);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	BOOL result = YES;
	
	item = [item representedObject];
	if ([self isSpecialGroup:item]) {
		result = NO;
	}
	else {
		// TODO: Other tests for whether a cell is editable
        
	}
	
	return result;
}


- (NSImage *)prepareIconForItem:(id)item {
    // Check if it's a special folder (RESOURCE, DEVICES or ACCOUNTS), we don't want it to have an icon
    if ([self isSpecialGroup:item]) {
        return nil;
    }

    NSImage *imageIcon = nil;
    
    if (item) {
        NSString *urlStr = [item urlString];
        BBURL *bburl = [[BBURL alloc] initWithBBURL:urlStr];
        
        // DEBUG: Use the following line to verify BBURL parsing
//        NSLog(@"BBURL:{%@, %d, %@, %@}", [bburl urlString], [bburl urlProtocol], [bburl deviceID], [bburl resourceID]);
        
        // TODO: Set corresponding icons via node protocol
        if ([bburl isFile])
            imageIcon = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
        else if ([bburl isHTTP])
            imageIcon = imageURL;
        else if ([bburl isDevice])
            imageIcon = imageDefault;
        else if ([bburl isShelf])
            imageIcon = imageDefault;
        else if ([bburl isApps])
            imageIcon = imageDefault;
        else if ([bburl isBook])
            imageIcon = imageDefault;
        else if ([bburl isApp])
            imageIcon = imageDefault;
        else if ([bburl isUser])
            imageIcon = imageDefault;
        else
            imageIcon = imageDefault;
    }
    
    return imageIcon;
}

- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{	 
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME]) {
		if ([cell isKindOfClass:[ImageAndTextCell class]]) {
            item = [item representedObject];

			NSImage *imageIcon = [self prepareIconForItem:item];
            [item setNodeIcon:imageIcon];
            
			[(ImageAndTextCell*)cell setImage:[item nodeIcon]];
		}
	}
}

- (BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item
{
	return ([self isSpecialGroup:[item representedObject]]);
}

- (void)removeContentView {
    [appDelegate removeContentView];
}

- (void)changeContentView {
    NSArray *selection = [treeController selectedNodes];	
	BaseNode *node = [[selection objectAtIndex:0] representedObject];
	NSString *urlStr = [node urlString];
    
    [appDelegate changeContentView:urlStr];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	if (duringStartUp)	// During startup don't change any view selections
		return;
    
	// Ask the tree controller for the current selection
	NSArray *selection = [treeController selectedObjects];
	if ([selection count] > 1)
	{
		// Multiple selection - clear the right side view
		[self removeContentView];
	}
	else
	{
		if ([selection count] == 1)
		{
			// Single selection
			[self changeContentView];
		}
		else
		{
			// There is no current selection - no view to display
			[self removeContentView];
		}
	}
}



@end
