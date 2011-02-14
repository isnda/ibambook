//
//  BBShelfController.h
//  iBambook
//
//  Created by Neo Lee on 1/19/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BBContentController.h"
#import "MGScopeBarDelegateProtocol.h"


@interface BBShelfController : BBContentController <MGScopeBarDelegate> {
@private
    IBOutlet MGScopeBar *scopeBar;

	NSMutableArray *scopeGroups;
}

@property(retain) NSMutableArray *scopeGroups;

@end
