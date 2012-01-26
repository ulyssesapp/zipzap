//
//  RKHeaderDefinitionsContainer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourceManager.h"
#import "RKSection.h"

@class RKDocument, RKSection;

@interface RKResourceManager()
{
    NSMutableArray *fonts;
    NSMutableArray *colors;
}

/*!
  @abstract Adds the name of the font (without traits) to the set of registered fonts
 */
- (void)addFontAttribute:(NSFont *)font;

/*!
 @abstract Adds a color as RGB color to the set of registered colors
 */
- (void)addColorAttribute:(NSColor *)color;

@end

@implementation RKResourceManager

- (id)init
{
    self = [super init];
    
    if (self) {
        fonts = [NSMutableArray new];
        colors = [NSMutableArray new];
    }
    
    return self;
}

- (void)addFontAttribute:(NSFont *)font
{
    NSString *fontFamily = [font familyName];
    
    if (![fonts containsObject:fontFamily] && fontFamily)
        [fonts addObject:fontFamily];
}


- (void)addColorAttribute:(NSColor *)color
{
    NSColor *rgbColor = [color colorWithAlphaComponent: (CGFloat)1.0];
    
    if (![colors containsObject:rgbColor] && rgbColor)
        [colors addObject:rgbColor];
   
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
    
    return index + 1;
}

- (NSArray *)collectedFonts
{
    return [fonts copy];
}

- (NSArray *)collectedColors
{
    return [colors copy];
}

@end
