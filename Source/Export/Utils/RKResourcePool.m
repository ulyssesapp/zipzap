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
        
        // Adding the two default colors (black is required; white is useful for \cb1
        [self indexOfColor: [NSColor colorWithSRGBRed:0 green:0.0 blue:0.0 alpha:1.0]];
        [self indexOfColor: [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    }
        
    return self;
}

- (NSUInteger)indexOfFont:(NSFont *)font
{
    NSAssert(font, @"No font given");
    
    NSString *familyName = [[[NSFontManager sharedFontManager] convertFont:font toNotHaveTrait:NSBoldFontMask|NSItalicFontMask] fontName];
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
    
    // Ensure that no alpha is used and that the color is converted to the RGB color space
    NSColor *opaqueColor = [[color colorUsingColorSpace: [NSColorSpace sRGBColorSpace]] colorWithAlphaComponent: 1.0];
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
