//
//  RKResourcePool.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourcePool.h"
#import "RKSection.h"

@class RKDocument, RKSection;

@interface RKResourcePool()
{
    NSMutableArray *fonts;
    NSMutableArray *colors;
}

@end

@implementation RKResourcePool

- (id)init
{
    self = [super init];
    
    if (self) {
        fonts = [NSMutableArray new];
        colors = [NSMutableArray arrayWithObject: [NSColor blackColor]];
    }
    
    return self;
}

- (NSUInteger)indexOfFont:(NSFont *)font
{
    NSAssert(font, @"No font given");
    
    NSString *familyName = font.familyName;
    NSUInteger index = [fonts indexOfObject: familyName];
    
    if (index == NSNotFound) {
        [fonts addObject: familyName];
        index = [fonts count] - 1;
    }
    
    return index;
}

- (NSUInteger)indexOfColor:(NSColor *)color
{
    NSAssert(color, @"No color given");
    
    NSColor *opaqueColor = [color colorWithAlphaComponent: 1.0];
    NSUInteger index = [colors indexOfObject: opaqueColor];
    
    if (index == NSNotFound) {
        [colors addObject: opaqueColor];
        index = [colors count] - 1;
    }
    
    return index;
}

- (NSArray *)fontFamilyNames
{
    return [fonts copy];
}

- (NSArray *)colors
{
    return [colors copy];
}

@end
