//
//  RKPersistencyContext.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Manages additional information during persistency
 */
@interface RKPersistencyContext : NSObject

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
 @abstract Serializes the persistency context to a property list
 */
- (id)propertyListRepresentation;

/*!
 @abstract Initializes the persistency context from a property list
 */
- (id)initWithPropertyListRepresentation:(id)propertyList error:(NSError **)error;

@end
