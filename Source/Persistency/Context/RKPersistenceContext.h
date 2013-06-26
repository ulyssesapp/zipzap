//
//  RKPersistenceContext.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Manages additional information during persistency
 */
@interface RKPersistenceContext : NSObject

/*!
 @abstract Serializes the persistency context to a property list
 */
- (id)propertyListRepresentation;

/*!
 @abstract Initializes the persistency context from a property list
 */
- (id)initWithPropertyListRepresentation:(id)propertyList error:(NSError **)error;

@end
