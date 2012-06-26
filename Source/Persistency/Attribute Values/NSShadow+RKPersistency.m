//
//  NSShadow+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSShadow+RKPersistency.h"
#import "NSColor+RKPersistency.h"

NSString *NSShadowOffsetWidthPersistencyKey     = @"shadowOffsetWidth";
NSString *NSShadowOffsetHeightPersistencyKey    = @"shadowOffsetHeight";
NSString *NSShadowBlurRadiusPersistencyKey      = @"shadowBlurRadius";
NSString *NSShadowColorPersistencyKey           = @"shadowColor";

@implementation NSShadow (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    NSShadow *shadow = [NSShadow new];
    
    shadow.shadowOffset = NSMakeSize([propertyList[NSShadowOffsetWidthPersistencyKey] floatValue], [propertyList[NSShadowOffsetHeightPersistencyKey] floatValue]);
    shadow.shadowBlurRadius = [propertyList[NSShadowBlurRadiusPersistencyKey] floatValue];
    shadow.shadowColor = (NSColor *)[NSColor instanceWithRTFKitPropertyListRepresentation:propertyList[NSShadowColorPersistencyKey] usingContext:context error:error];
    
    return shadow;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    return @{
        NSShadowOffsetWidthPersistencyKey:      @(self.shadowOffset.width),
        NSShadowOffsetHeightPersistencyKey:     @(self.shadowOffset.height),
        NSShadowBlurRadiusPersistencyKey:       @(self.shadowBlurRadius),
        NSShadowColorPersistencyKey:            [self.shadowColor RTFKitPropertyListRepresentationUsingContext: context]
    };
}

@end
