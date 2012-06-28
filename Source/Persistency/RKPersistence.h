//
//  RKPersistence.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPersistenceContext;

/*!
 @abstract A protocol that describes an object which can be serialized / deserialized by RTFKit
 */
@protocol RKPersistence <NSObject>

/*!
 @abstract Initializes an object from its property list representation
 */
+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error;

/*!
@abstract Serializes an attributed string to a property list representation
*/
- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context;

@end
