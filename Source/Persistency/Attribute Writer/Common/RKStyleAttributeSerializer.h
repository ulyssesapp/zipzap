//
//  RKStyleAttributeSerializer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeSerializer.h"

@interface RKStyleAttributeSerializer : RKAttributeSerializer

/*!
 @abstract Registers the serialization of a flag-based attribute using the given mapping from flag names to flag values.
 */
+ (void)registerAttributeWithName:(NSString *)attributeName usingFlags:(NSDictionary *)flagStyles;

/*!
@abstract Registers the serialization of an enumeration-based attribute using the given mapping from enumeration identifiers to values.
*/
+ (void)registerAttributeWithName:(NSString *)attributeName usingEnumeration:(NSDictionary *)enumerationStyles;

/*!
@abstract Registers the serialization of a numeric attribute.
*/
+ (void)registerNumericAttributeWithName:(NSString *)attributeName;

@end
