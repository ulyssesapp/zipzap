//
//  RKHeaderDefinitionsContainer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderDefinitionsContainer.h"
#import "RKSection.h"

@class RKDocument, RKSection;

@interface RKHeaderDefinitionsContainer()
{
    NSMutableArray *fonts;
    NSMutableArray *colors;
}

- (RKHeaderDefinitionsContainer *)init;

/*!
  @abstract Adds the name of the font (without traits) to the set of registered fonts
 */
- (void)addFontAttribute:(NSFont *)font;

/*!
 @abstract Adds a color as RGB color to the set of registered colors
 */
- (void)addColorAttribute:(NSColor *)color;

@end

@implementation RKHeaderDefinitionsContainer

+ (RKHeaderDefinitionsContainer *)headerDefinitionsFromDocument:(RKDocument *)document
{
    RKHeaderDefinitionsContainer *definitions = [[RKHeaderDefinitionsContainer alloc] init];
    
    for (RKSection *section in document.sections) {
        NSRange fullRange = NSMakeRange(0, [section.content length]);
        
        [section.content enumerateAttributesInRange:fullRange options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
                [definitions addFontAttribute:[attributes objectForKey:NSFontAttributeName]];
                [definitions addColorAttribute:[attributes objectForKey:NSBackgroundColorAttributeName]];
                [definitions addColorAttribute:[attributes objectForKey:NSForegroundColorAttributeName]];
            }];
    }
    
    return definitions;
}

- (RKHeaderDefinitionsContainer *)init
{
    self = [super init];
    
    if (self) {
        fonts = [NSMutableArray array];
        colors = [NSMutableArray array];
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
    return [fonts indexOfObject: [font familyName]];
}

- (NSUInteger)indexOfColor:(NSColor *)color
{
    return [colors indexOfObject: [color colorWithAlphaComponent: (CGFloat)1.0]];
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
