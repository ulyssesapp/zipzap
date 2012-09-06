//
//  RKAttributeSerializer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPersistenceContext;

extern NSString *RKSerializationErrorDomain;

typedef enum : NSUInteger {
    RKInvalidSerializationFormatError = 1
}RKSerializationErrorCode;

/*!
 @abstarct (Semi-Abstract) Provides methods for attribute serialization
 */
@interface RKAttributeSerializer : NSObject

/*!
 @abstract (Abstract Method) De-serializes a serialized attribute using a property list and an attribute name
 */
+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error;

/*!
 @abstract (Abstract Method) De-serializes a serialized attribute using a property list and an attribute name
 */
+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)propertyList context:(RKPersistenceContext *)context;

/*!
 @abstract Creates an "invalid format" error for a certain attribute name and value
 */
+ (NSError *)invalidFormatForAttribute:(NSString *)attributeName value:(id)propertyList;

@end
