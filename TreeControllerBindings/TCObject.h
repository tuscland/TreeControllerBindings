//
//  TCObject.h
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCObject : NSObject

@property (readonly, retain) NSArray *children;
@property (copy) NSString *name;
@property BOOL isLeaf;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)addChild:(TCObject *)child;
- (void)removeChild:(TCObject *)child;

@end
