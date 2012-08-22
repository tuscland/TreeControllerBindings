//
//  NSTreeController+TCExtensions.m
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import "NSTreeNode+TCExtensions.h"
#import "NSTreeController+TCExtensions.h"


@implementation NSTreeController (TCExtensions)

- (NSArray *)rootNodes;
{
	return [[self arrangedObjects] childNodes];
}

- (NSIndexPath *)indexPathForInsertion
{
	NSUInteger rootTreeNodesCount = [[self rootNodes] count];
	NSArray *selectedNodes = [self selectedNodes];
	NSTreeNode *selectedNode = nil;
	NSIndexPath *indexPath;
	
	if (selectedNodes.count == 0) {
		indexPath = [NSIndexPath indexPathWithIndex:rootTreeNodesCount];
    } else if ([selectedNodes count] == 1) {
        selectedNode = selectedNodes[0];

		if ([selectedNode isLeaf] == NO) {
			indexPath = [[selectedNode indexPath] indexPathByAddingIndex:0];
		} else {
			if ([selectedNode parentNode])
				indexPath = [selectedNode adjacentIndexPath];
			else
				indexPath = [NSIndexPath indexPathWithIndex:rootTreeNodesCount];
		}
	} else {
		indexPath = [selectedNodes.lastObject adjacentIndexPath];
	}
    
	return indexPath;
}

- (NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self arrangedObjects] descendantNodeAtIndexPath:indexPath];
}

@end
