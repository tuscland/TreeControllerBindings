//
//  TCAppDelegate.h
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TCManager.h"


@interface TCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSOutlineView *outlineView;
@property (assign) IBOutlet NSTreeController *treeController;
@property (retain) TCManager *manager;
@property (retain) NSUndoManager *undoManager;

- (IBAction)newObject:(id)sender;
- (IBAction)deleteObjects:(id)sender;

@end
