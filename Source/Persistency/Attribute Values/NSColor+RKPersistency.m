//
//  NSColor+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSColor+RKPersistency.h"

NSString *NSColorRedComponentPersistencyKey = @"red";
NSString *NSColorGreenComponentPersistencyKey = @"green";
NSString *NSColorBlueComponentPersistencyKey = @"blue";
NSString *NSColorAlphaComponentPersistencyKey = @"alpha";

@implementation NSColor (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    CGFloat red = [propertyList[NSColorRedComponentPersistencyKey] floatValue];
    CGFloat green = [propertyList[NSColorGreenComponentPersistencyKey] floatValue];
    CGFloat blue = [propertyList[NSColorBlueComponentPersistencyKey] floatValue];
    CGFloat alpha = [propertyList[NSColorAlphaComponentPersistencyKey] floatValue];
    
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    return @{
        NSColorRedComponentPersistencyKey:      @(self.redComponent),
        NSColorGreenComponentPersistencyKey:    @(self.greenComponent),
        NSColorBlueComponentPersistencyKey:     @(self.blueComponent),
        NSColorAlphaComponentPersistencyKey:    @(self.alphaComponent)
    };
}

@end
