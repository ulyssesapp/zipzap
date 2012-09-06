//
//  NSAttributedString+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+RKPersistence.h"

#import "RKAttributeSerializer.h"

#import "NSDictionary+FlagSerialization.h"

/*!
 @abstract Keys used for persistency
 */
NSString *RKPersistenceStringContentKey = @"string";
NSString *RKPersistenceAttributeRangesKey = @"attributeRanges";
NSString *RKPersistenceContextKey = @"context";

NSString *RKPersistenceAttributeRangeKey = @"attributeRange";
NSString *RKPersistenceAttributeValuesKey = @"attributeValues";

NSString *RKPersistenceRangeLocationKey = @"location";
NSString *RKPersistenceRangeLengthKey = @"length";

@interface NSAttributedString (RKPersistencePrivateMethods)

/*!
 @abstract Creates a new attributed string usign a property and a context.
 */
+ (NSAttributedString *)attributedStringWithPropertyList:(NSDictionary *)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error;

@end

@implementation NSAttributedString (RKPersistence)

NSMutableDictionary *NSAttributedStringSerializers;

+ (void)registerAttributeSerializer:(Class)serializer forAttribute:(NSString *)attributeName
{
    if (!NSAttributedStringSerializers)
        NSAttributedStringSerializers = [NSMutableDictionary new];
    
    [NSAttributedStringSerializers setObject:serializer forKey:attributeName];
}



#pragma mark - Deserialization

- (id)initWithRTFKitPropertyListRepresentation:(id)propertyList error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    // De-serialize context from property list
    RKPersistenceContext *context = [[RKPersistenceContext alloc] initWithPropertyListRepresentation:propertyList[RKPersistenceContextKey] error:error];
    if (!context)
        return nil;
    
    // De-serialize attributed string with context
    NSAttributedString *prototype = (NSAttributedString *)[self.class instanceWithRTFKitPropertyListRepresentation:propertyList usingContext:context error:error];
    if (!prototype)
        return nil;
    
    // Setup concrete attributed string with prototype
    return [self initWithAttributedString: prototype];
}

+ (NSDictionary *)attributeDictionaryFromRTFKitPropertyListRepresentation:(id)serializedAttributes usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSMutableDictionary *deserializedAttributes = [NSMutableDictionary new];
    
    [serializedAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, id serializedAttributeValue, BOOL *stop) {
        // Get handler class for attribute
        Class handler = [NSAttributedStringSerializers objectForKey: attributeName];
        id attributeValue = [handler attributeValueForPropertyList:serializedAttributeValue attributeName:attributeName context:context error:error];
        if (!attributeValue) {
            *stop = YES;
            return;
        }
        
        // Setup attributed string
        [deserializedAttributes setObject:attributeValue forKey:attributeName];
    }];
    
    return deserializedAttributes;
}



#pragma mark - Serialization methods with new context

- (id)RTFKitPropertyListRepresentation
{
    // Serialize attributed string
    RKPersistenceContext *context = [RKPersistenceContext new];
    NSMutableDictionary *propertyListRepresentation = [[self RTFKitPropertyListRepresentationUsingContext: context] mutableCopy];
    
    // Add context
    [propertyListRepresentation setObject:[context propertyListRepresentation] forKey:RKPersistenceContextKey];

    return propertyListRepresentation;
}

+ (id)RTFKitPropertyListRepresentationForAttributeDictionary:(NSDictionary *)attributes usingContext:(RKPersistenceContext *)context
{
    NSMutableDictionary *translatedAttributes = [NSMutableDictionary new];
    
    [attributes enumerateKeysAndObjectsUsingBlock:^(NSString *attributeKey, id attributeValue, BOOL *stop) {
        // Ignore nil values
        if (!attributeValue)
            return;
        
        Class handler = [NSAttributedStringSerializers objectForKey: attributeKey];
        if (handler) {
            id serializedAttributeValue = [handler propertyListForAttribute:attributeKey value:attributeValue context:context];
            if (serializedAttributeValue)
                [translatedAttributes setObject:serializedAttributeValue forKey:attributeKey];
        }
    
    }];
    
    return translatedAttributes;
}



#pragma mark - Serialization methods with predefined context

+ (NSAttributedString *)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    // Get data from property list
    NSString *deserializedString = propertyList[RKPersistenceStringContentKey];
    NSArray *attributesForRanges = propertyList[RKPersistenceAttributeRangesKey];
    
    // Create attributed string
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: deserializedString];
    
    // Setup attributes
    for (NSDictionary *attributesForRange in attributesForRanges)
    {
        NSDictionary *rangeDescriptor = attributesForRange[RKPersistenceAttributeRangeKey];
        NSDictionary *serializedAttributes = attributesForRange[RKPersistenceAttributeValuesKey];
        
        NSRange attributeRange = NSMakeRange([rangeDescriptor[RKPersistenceRangeLocationKey] unsignedIntegerValue], [rangeDescriptor[RKPersistenceRangeLengthKey] unsignedIntegerValue]);
        
        NSDictionary *deserializedAttributes = [self.class attributeDictionaryFromRTFKitPropertyListRepresentation:serializedAttributes usingContext:context error:error];
        [attributedString addAttributes:deserializedAttributes range:attributeRange];
    }
    
    return attributedString;
}

- (NSDictionary *)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    NSMutableArray *attributesForRanges = [NSMutableArray new];
    
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
        // Translate attributes in range
        NSMutableDictionary *translatedAttributes = [self.class RTFKitPropertyListRepresentationForAttributeDictionary:attributes usingContext:context];
        
        // Create descriptor for attributes in range
        NSDictionary *attributeRange = @{ RKPersistenceRangeLocationKey: @(range.location), RKPersistenceRangeLengthKey: @(range.length) };
        
        // Persist only ranges that actually contain attributes
        if (translatedAttributes.count) {
            NSDictionary *attributesForRange = @{ RKPersistenceAttributeRangeKey: attributeRange, RKPersistenceAttributeValuesKey: translatedAttributes };
            [attributesForRanges addObject: attributesForRange];
        }
    }];
    
    // Create property list
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.string,            RKPersistenceStringContentKey,
            attributesForRanges,    RKPersistenceAttributeRangesKey,
           nil];
}

@end
