//
//  NSAttributedString+RKPersistence.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPersistenceContext, RKAttributeSerializer;

/*!
 @abstract Allows to serialize an attributed string that uses RTFKit features to a property list
 */
@interface NSAttributedString (RKPersistence)

/*!
 @abstract Registers an attribute serializer to the RTFKit serialization 
 */
+ (void)registerAttributeSerializer:(Class)serializer forAttribute:(NSString *)attributeName;

/*!
 @abstract Initializes an attributed string from its property list representation
 */
- (id)initWithRTFKitPropertyListRepresentation:(id)propertyList error:(NSError **)error;

/*!
 @abstract Serializes an attributed string to a property list representation
 @discussion Serializes all attributes as specified by 'persistableAttributeTypes'.
 */
- (id)RTFKitPropertyListRepresentation;

/*!
 @abstract Initializes an attributed string from its property list representation
 */
+ (NSAttributedString *)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error;

/*!
 @abstract Serializes an attributed string to a property list representation
 @discussion Serializes all attributes as specified by 'persistableAttributeTypes'.
 */
- (NSDictionary *)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context;

/*!
 @abstract Creates an attribute dictionary from its property list representation
 @discussion A persistence context must be provided that serializes additional data for certain attributes.
 */
+ (NSDictionary *)attributeDictionaryFromRTFKitPropertyListRepresentation:(id)serializedAttributes usingContext:(RKPersistenceContext *)context error:(NSError **)error;

/*!
 @abstract Serializes an attribute dictionary to its property list representation
 @discussion A persistence context must be provided that serializes additional data for certain attributes.
 */
+ (id)RTFKitPropertyListRepresentationForAttributeDictionary:(NSDictionary *)attributes usingContext:(RKPersistenceContext *)context;

@end
