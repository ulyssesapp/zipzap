//
//  RKStyleNamingAttributeSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStyleNamingAttributeSerializer.h"

@implementation RKStyleNamingAttributeSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self.class forAttribute:RKCharacterStyleNameAttributeName];
        [NSAttributedString registerAttributeSerializer:self.class forAttribute:RKParagraphStyleNameAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if (![propertyList isKindOfClass: NSString.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    return propertyList;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    return attributeValue;
}

@end
