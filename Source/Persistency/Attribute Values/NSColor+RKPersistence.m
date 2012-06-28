//
//  NSColor+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSColor+RKPersistence.h"

NSString *NSColorRedComponentPersistenceKey = @"red";
NSString *NSColorGreenComponentPersistenceKey = @"green";
NSString *NSColorBlueComponentPersistenceKey = @"blue";
NSString *NSColorAlphaComponentPersistenceKey = @"alpha";

@implementation NSColor (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    CGFloat red = [propertyList[NSColorRedComponentPersistenceKey] floatValue];
    CGFloat green = [propertyList[NSColorGreenComponentPersistenceKey] floatValue];
    CGFloat blue = [propertyList[NSColorBlueComponentPersistenceKey] floatValue];
    CGFloat alpha = [propertyList[NSColorAlphaComponentPersistenceKey] floatValue];
    
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    return @{
        NSColorRedComponentPersistenceKey:      @(self.redComponent),
        NSColorGreenComponentPersistenceKey:    @(self.greenComponent),
        NSColorBlueComponentPersistenceKey:     @(self.blueComponent),
        NSColorAlphaComponentPersistenceKey:    @(self.alphaComponent)
    };
}

@end
