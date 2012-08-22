//
//  TCManager.h
//  TreeControllerBindings
//
//  Created by Camille Troillard on 23/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCManager : NSObject

@property (readonly, retain) NSArray *objects;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)addObject:(TCObject *)object;
- (void)removeObject:(TCObject *)object;

@end
