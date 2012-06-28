//
//  NSShadow+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSShadow+RKPersistence.h"
#import "NSColor+RKPersistence.h"

NSString *NSShadowOffsetWidthPersistenceKey     = @"shadowOffsetWidth";
NSString *NSShadowOffsetHeightPersistenceKey    = @"shadowOffsetHeight";
NSString *NSShadowBlurRadiusPersistenceKey      = @"shadowBlurRadius";
NSString *NSShadowColorPersistenceKey           = @"shadowColor";

@implementation NSShadow (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    NSShadow *shadow = [NSShadow new];
    
    shadow.shadowOffset = NSMakeSize([propertyList[NSShadowOffsetWidthPersistenceKey] floatValue], [propertyList[NSShadowOffsetHeightPersistenceKey] floatValue]);
    shadow.shadowBlurRadius = [propertyList[NSShadowBlurRadiusPersistenceKey] floatValue];
    shadow.shadowColor = (NSColor *)[NSColor instanceWithRTFKitPropertyListRepresentation:propertyList[NSShadowColorPersistenceKey] usingContext:context error:error];
    
    return shadow;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    return @{
        NSShadowOffsetWidthPersistenceKey:      @(self.shadowOffset.width),
        NSShadowOffsetHeightPersistenceKey:     @(self.shadowOffset.height),
        NSShadowBlurRadiusPersistenceKey:       @(self.shadowBlurRadius),
        NSShadowColorPersistenceKey:            [self.shadowColor RTFKitPropertyListRepresentationUsingContext: context]
    };
}

@end
