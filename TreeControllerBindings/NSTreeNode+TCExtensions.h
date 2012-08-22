//
//  NSTreeNode+TCExtensions.h
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTreeNode (TCExtensions)

- (NSIndexPath *)adjacentIndexPath;
- (NSArray *)descendants;
- (BOOL)isDescendantOfNode:(NSTreeNode *)node;

@end
