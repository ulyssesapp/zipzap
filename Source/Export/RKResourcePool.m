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
        colors = [NSMutableArray new];
    }
    
    return self;
}

- (NSUInteger)indexOfFont:(NSFont *)font
{
    NSAssert(font, @"No font given");
    
    NSString *familyName = [font familyName];
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
    
    NSColor *rgbColor = [color colorWithAlphaComponent: (CGFloat)1.0];
    NSUInteger index = [colors indexOfObject: rgbColor];
    
    if (index == NSNotFound) {
        [colors addObject: rgbColor];
        index = [colors count] - 1;
    }
    
    // RTF color indexing has offset 1
    return index + 1;
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
