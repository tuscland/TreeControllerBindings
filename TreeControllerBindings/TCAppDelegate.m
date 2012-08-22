//
//  TCAppDelegate.m
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import "TCObject.h"
#import "NSTreeController+TCExtensions.h"
#import "NSTreeNode+TCExtensions.h"
#import "TCAppDelegate.h"


static char *const ObservationContext = "com.wildora.TCControllerBindings.observation";
static NSString *const ObjectsObservationKey = @"objects";
static NSString *const ChildrenObservationKey = @"children";

static NSString *const PasteboardType = @"com.wildora.TCControllerBindings.pbtype";


@interface TCAppDelegate ()

- (void)observeObject:(TCObject *)object;
- (void)unobserveObject:(TCObject *)object;
- (void)updateNodesExpansion;

@end


@implementation TCAppDelegate

- (void)awakeFromNib
{
    [self.outlineView registerForDraggedTypes:@[PasteboardType]];

    self.undoManager = [[NSUndoManager alloc] init];
    self.manager = [[TCManager alloc] init];
    self.manager.undoManager = self.undoManager;
    [self.manager addObserver:self
               forKeyPath:ObjectsObservationKey
                  options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                  context:ObservationContext];
}

- (NSUndoManager*)windowWillReturnUndoManager:(NSWindow *)window
{
    return self.undoManager;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == ObservationContext) {
        if ([keyPath isEqual:ObjectsObservationKey] || [keyPath isEqual:ChildrenObservationKey]) {
			id added = [change objectForKey:NSKeyValueChangeNewKey];
			id removed = [change objectForKey:NSKeyValueChangeOldKey];
            
            if ([removed isEqual:[NSNull null]] == NO) {
                for (TCObject *object in removed) {
                    [self unobserveObject:object];
                }
            }
            
            if ([added isEqual:[NSNull null]] == NO) {
                for (TCObject *object in added) {
                    [self observeObject:object];
                }
            }

            [self updateNodesExpansion];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (IBAction)newObject:(id)sender
{
    id object = [[TCObject alloc] init];
    TCObject *selectedObject = self.treeController.selectedObjects.lastObject;

    if (selectedObject && selectedObject.isLeaf == NO) {
        [selectedObject addChild:object];
    } else {
        [self.manager addObject:object];
    }
}

- (IBAction)deleteObjects:(id)sender
{
    [self.treeController removeObjectsAtArrangedObjectIndexPaths:self.treeController.selectionIndexPaths];
}

- (void)observeObject:(TCObject *)object
{
    NSLog(@"add observer for object %@", object);
    [object addObserver:self
             forKeyPath:ChildrenObservationKey
                options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                context:ObservationContext];

    // child object are observed through the observation of the children key path
}

- (void)unobserveObject:(TCObject *)object
{
    NSLog(@"remove observer for object %@", object);
    
    if (object.isLeaf == NO) {
        for (TCObject *child in object.children) {
            [self unobserveObject:child];
        }
    }

    [object removeObserver:self forKeyPath:ChildrenObservationKey];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)nodes toPasteboard:(NSPasteboard *)pasteboard
{
	[pasteboard declareTypes:@[PasteboardType] owner:self];
	[pasteboard setData:[NSKeyedArchiver archivedDataWithRootObject:[nodes valueForKey:@"indexPath"]]
				forType:PasteboardType];
	return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)__unused outlineView
                  validateDrop:(id <NSDraggingInfo>)info
                  proposedItem:(id)proposedParentNode
            proposedChildIndex:(NSInteger)proposedChildIndex
{
	if (proposedChildIndex == -1) { // will be -1 if the mouse is hovering over a leaf node
		return NSDragOperationNone;
    }
    
	NSArray *draggedIndexPaths = [NSKeyedUnarchiver unarchiveObjectWithData:[[info draggingPasteboard]
                                                                dataForType:PasteboardType]];
    
	BOOL targetIsValid = YES;
    
	for (NSIndexPath *indexPath in draggedIndexPaths) {
		NSTreeNode *node = [self.treeController nodeAtIndexPath:indexPath];
		if (!node.isLeaf) {
			if ([proposedParentNode isDescendantOfNode:node] || // can't drop a collection on one of its descendants
				proposedParentNode == node ||
				(proposedParentNode != nil && [proposedParentNode isLeaf] == NO)) {
				targetIsValid = NO;
				break;
			}
		}
	}
    
	if (targetIsValid) {
		if (([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask) > 0) {
			return NSDragOperationCopy;
        }
        
        return NSDragOperationMove;
	}
    
    return NSDragOperationNone;
}

- (BOOL)outlineView:(NSOutlineView *)__unused outlineView
         acceptDrop:(id <NSDraggingInfo>)info
               item:(id)proposedParentNode
         childIndex:(NSInteger)proposedChildIndex
{
	NSArray *draggedIndexPaths = [NSKeyedUnarchiver
								  unarchiveObjectWithData:[[info draggingPasteboard]
														   dataForType:PasteboardType]];

    // Move
    NSIndexPath *proposedParentIndexPath;
    
    if (proposedParentNode == nil) {
        proposedParentIndexPath = [[NSIndexPath alloc] init];
    } else {
        proposedParentIndexPath = [proposedParentNode indexPath];
    }
    
    NSMutableArray *draggedNodes = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in draggedIndexPaths) {
        [draggedNodes addObject:[self.treeController nodeAtIndexPath:indexPath]];
    }
    
    NSIndexPath *dropIndexPath = [proposedParentIndexPath indexPathByAddingIndex:proposedChildIndex];
    
    // TODO: fix drag and drop
    [self.treeController moveNodes:draggedNodes toIndexPath:dropIndexPath];
	
	[self updateNodesExpansion];    
	return YES;
}

- (void)updateNodesExpansion
{
	for (NSTreeNode *node in [self.treeController rootNodes]) {
		if (node.isLeaf == NO) {
			[self.outlineView expandItem:node];
		}
	}
}

@end
