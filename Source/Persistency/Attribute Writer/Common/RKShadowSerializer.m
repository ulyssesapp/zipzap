//
//  RKShadowSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKShadowSerializer.h"
#import "RKShadow.h"

#import "RKColorSerializer.h"

NSString *RKShadowOffsetWidthPersistenceKey     = @"shadowOffsetWidth";
NSString *RKShadowOffsetHeightPersistenceKey    = @"shadowOffsetHeight";
NSString *RKShadowBlurRadiusPersistenceKey      = @"shadowBlurRadius";
NSString *RKShadowColorPersistenceKey           = @"shadowColor";

@implementation RKShadowSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKShadowAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if(![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    #if !TARGET_OS_IPHONE
        NSShadow *shadow = [NSShadow new];
    #else
        RKShadow *shadow = [RKShadow new];
    #endif
    
    shadow.shadowOffset = CGSizeMake([[propertyList objectForKey: RKShadowOffsetWidthPersistenceKey] floatValue], [[propertyList objectForKey: RKShadowOffsetHeightPersistenceKey] floatValue]);
    shadow.shadowBlurRadius = [[propertyList objectForKey: RKShadowBlurRadiusPersistenceKey] floatValue];
    
    #if !TARGET_OS_IPHONE
        shadow.shadowColor = [RKColorSerializer attributeValueForPropertyList:[propertyList objectForKey: RKShadowColorPersistenceKey] attributeName:NSShadowAttributeName context:context error:error];
    #else
        shadow.shadowColor = [RKColorSerializer attributeValueForPropertyList:[propertyList objectForKey: RKShadowColorPersistenceKey] attributeName:RKShadowAttributeName context:context error:error];
    #endif
    
    return shadow;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    #if !TARGET_OS_IPHONE
        NSShadow *shadow = attributeValue;
        NSDictionary *serializedColor = [RKColorSerializer propertyListForAttribute:RKShadowColorPersistenceKey value:shadow.shadowColor context:context];
    #else
        RKShadow *shadow = attributeValue;
        NSDictionary *serializedColor = [RKColorSerializer propertyListForAttribute:RKShadowColorPersistenceKey value:shadow.shadowColor context:context];
    #endif
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat: shadow.shadowOffset.width],      RKShadowOffsetWidthPersistenceKey,
            [NSNumber numberWithFloat: shadow.shadowOffset.height],     RKShadowOffsetHeightPersistenceKey,
            [NSNumber numberWithFloat: shadow.shadowBlurRadius],        RKShadowBlurRadiusPersistenceKey,
            serializedColor,                                            RKShadowColorPersistenceKey,
            nil];
}

@end
