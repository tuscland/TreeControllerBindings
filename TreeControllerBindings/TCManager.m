//
//  TCManager.m
//  TreeControllerBindings
//
//  Created by Camille Troillard on 23/08/12.
//  Copyright (c) 2012 Wildora. All rights reserved.
//

#import "TCObject.h"
#import "TCManager.h"


@interface TCManager ()
{
    NSMutableArray *_objects;
}

- (NSUInteger)countOfObjects;
- (id)objectInObjectsAtIndex:(NSUInteger)index;
- (void)insertObject:(TCObject *)object inObjectsAtIndex:(NSUInteger)index;
- (void)removeObjectFromObjectsAtIndex:(NSUInteger)index;

@end


@implementation TCManager

- (id)init
{
    self = [super init];
    
    if (self) {
        _objects = [[NSMutableArray alloc] init];
        
        TCObject *root = [[TCObject alloc] init];
        root.name = @"First root";
        [root addChild:[[TCObject alloc] init]];
        [_objects addObject:root];
        
        root = [[TCObject alloc] init];
        root.name = @"Second root";
        [root addChild:[[TCObject alloc] init]];
        [root addChild:[[TCObject alloc] init]];
        [root addChild:[[TCObject alloc] init]];
        [_objects addObject:root];
    }

    return self;
}

- (void)setUndoManager:(NSUndoManager *)undoManager
{
    if (_undoManager != undoManager) {
        _undoManager = undoManager;
        for (TCObject *object in self.objects) {
            object.undoManager = undoManager;
        }
    }
}

- (void)addObject:(TCObject *)object
{
    [self insertObject:object inObjectsAtIndex:_objects.count];
}

- (void)removeObject:(TCObject *)object
{
    [self removeObjectFromObjectsAtIndex:[_objects indexOfObject:object]];
}

- (NSUInteger)countOfObjects
{
    return _objects.count;
}

- (id)objectInObjectsAtIndex:(NSUInteger)index
{
    return [_objects objectAtIndex:index];
}

- (void)insertObject:(TCObject *)object inObjectsAtIndex:(NSUInteger)index
{
    [[self.undoManager prepareWithInvocationTarget:self] removeObjectFromObjectsAtIndex:index];
    [_objects insertObject:object atIndex:index];
}

- (void)removeObjectFromObjectsAtIndex:(NSUInteger)index
{
    TCObject *object = [_objects objectAtIndex:index];
    [[self.undoManager prepareWithInvocationTarget:self] insertObject:object inObjectsAtIndex:index];
    [_objects removeObjectAtIndex:index];
}

@end
