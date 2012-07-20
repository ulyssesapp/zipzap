//
//  RKPersistenceContext+PrivateStorageAccessors.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPersistenceContext.h"

@interface RKPersistenceContext ()

/*!
 @abstract Creates an unique index for the given regular file wrapper and registers it to the persistency context
 */
- (NSUInteger)indexForFileWrapper:(NSFileWrapper *)fileWrapper;

/*!
 @abstract Provides a file wrapper for an index registered to the context
 */
- (NSFileWrapper *)fileWrapperForIndex:(NSUInteger)index;

/*!
 @abstract Creates a unique index for the given list style and registers it to the persistency context
 */
- (NSUInteger)indexForListStyle:(RKListStyle *)listStyle;

/*!
 @abstract Provide a list style for a n index registered to the context
 */
- (RKListStyle *)listStyleForIndex:(NSUInteger)index;

/*!
 @abstract Registers an object and returns YES, if the object was visited twice.
 */
- (BOOL)registerUniqueObject:(id)object;

@end
