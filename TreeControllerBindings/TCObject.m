//
//  TCObject.m
//  TreeControllerBindings
//
//  Created by Camille Troillard on 22/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import "TCObject.h"

@interface TCObject ()
{
    NSMutableArray *_children;
}


- (NSUInteger)countOfChildren;
- (id)objectInChildrenAtIndex:(NSUInteger)index;
- (void)insertObject:(TCObject *)object inChildrenAtIndex:(NSUInteger)index;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index;

@end


@implementation TCObject

- (id)init
{
    self = [super init];
    
    if (self) {
        static NSUInteger objectCount = 1;
        self.name = [NSString stringWithFormat:@"Object %ld", objectCount++];
        _children = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)setUndoManager:(NSUndoManager *)undoManager
{
    if (_undoManager != undoManager) {
        _undoManager = undoManager;
        if (self.isLeaf == NO) {
            for (TCObject *object in self.children) {
                object.undoManager = undoManager;
            }
        }
    }
}

- (void)addChild:(TCObject *)child
{
    child.isLeaf = YES;
    [self insertObject:child inChildrenAtIndex:[self countOfChildren]];
}

- (void)removeChild:(TCObject *)child
{
    [self removeObjectFromChildrenAtIndex:[_children indexOfObject:child]];
}

- (NSUInteger)countOfChildren
{
    return [_children count];
}

- (id)objectInChildrenAtIndex:(NSUInteger)index
{
    return [_children objectAtIndex:index];
}

- (void)insertObject:(TCObject *)object inChildrenAtIndex:(NSUInteger)index
{
    [[self.undoManager prepareWithInvocationTarget:self] removeObjectFromChildrenAtIndex:index];
    [_children insertObject:object atIndex:index];
}

- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index
{
    TCObject *object = [_children objectAtIndex:index];
    [[self.undoManager prepareWithInvocationTarget:self] insertObject:object inChildrenAtIndex:index];
    [_children removeObjectAtIndex:index];
}

@end
