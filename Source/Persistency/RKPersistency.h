//
//  RKPersistency.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPersistencyContext;

/*!
 @abstract A protocol that describes an object which can be serialized / deserialized by RTFKit
 */
@protocol RKPersistency <NSObject>

/*!
 @abstract Initializes an object from its property list representation
 */
+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error;

/*!
@abstract Serializes an attributed string to a property list representation
*/
- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context;

@end
