//
//  NSTreeController+TCExtensions.h
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTreeController (TCExtensions)

- (NSArray *)rootNodes;
- (NSIndexPath *)indexPathForInsertion;
- (NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;

@end
