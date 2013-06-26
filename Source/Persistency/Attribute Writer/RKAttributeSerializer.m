//
//  RKAttributeSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeSerializer.h"

NSString *RKSerializationErrorDomain = @"RKSerializationErrorDomain";

@implementation RKAttributeSerializer

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    NSAssert(false, @"Abstract method called");
    return nil;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    NSAssert(false, @"Abstract method called");
    return nil;
}

+ (NSError *)invalidFormatForAttribute:(NSString *)attributeName value:(id)propertyList
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat: @"Invalid serialization format. Attribute %@ has invalid value %@.", attributeName, propertyList], NSLocalizedDescriptionKey,
                              nil];
    
    return [NSError errorWithDomain:RKSerializationErrorDomain code:RKInvalidSerializationFormatError userInfo:userInfo];
}


@end
