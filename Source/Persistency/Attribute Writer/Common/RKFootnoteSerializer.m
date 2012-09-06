//
//  RKFootnoteSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootnoteSerializer.h"

#import "NSAttributedString+RKPersistence.h"

@implementation RKFootnoteSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKFootnoteAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKEndnoteAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if (![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    return [NSAttributedString instanceWithRTFKitPropertyListRepresentation:propertyList usingContext:context error:error];
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    return [attributeValue RTFKitPropertyListRepresentationUsingContext:context];
}

@end
