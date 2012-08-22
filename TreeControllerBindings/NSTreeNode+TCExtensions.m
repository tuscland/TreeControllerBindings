//
//  NSTreeNode+TCExtensions.m
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import "NSTreeNode+TCExtensions.h"

@implementation NSTreeNode (TCExtensions)

-(NSIndexPath *)adjacentIndexPath;
{
    NSIndexPath *indexPath = self.indexPath;
    NSUInteger lastIndex = 0;
    
    if (indexPath.length) {
        lastIndex = [indexPath indexAtPosition:[indexPath length] - 1];
        indexPath = [indexPath indexPathByRemovingLastIndex];
    }

    return [indexPath indexPathByAddingIndex:++lastIndex];
}

- (NSArray *)descendants
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *child in [self childNodes]) {
		[array addObject:child];
		if (![child isLeaf])
			[array addObjectsFromArray:[child descendants]];
	}
	return [NSArray arrayWithArray:array];
}

- (BOOL)isDescendantOfNode:(NSTreeNode *)node
{
	return [[node descendants] containsObject:self];
}

@end
