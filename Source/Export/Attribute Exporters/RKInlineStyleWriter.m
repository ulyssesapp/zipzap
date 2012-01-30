//
//  RKInlineStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKInlineStyleWriter.h"
#import "RKTaggedString.h"
#import "RKResourcePool.h"

@interface RKInlineStyleWriter ()

/*!
 @abstract Generates the required opening and closing tags of a single font attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withFont:(NSFont *)font inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a background color attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withBackgroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a foreground color attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withForegroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a underline style attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withUnderlineStyle:(NSUInteger)underlineStyle inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a underline color attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withUnderlineColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a strikethrough style attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withStrikethroughStyle:(NSUInteger)underlineStyle inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a strikethrough color attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withStrikethroughColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a stroke width attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withStrokeWidth:(CGFloat)strokeWidth inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a stroke color attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withStrokeColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a shadow style attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withShadowStyle:(NSShadow *)shadow inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a superscript style attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withSuperscriptMode:(NSInteger)mode inRange:(NSRange)range resources:(RKResourcePool *)resources;

@end

@implementation RKInlineStyleWriter

+ (void)tag:(RKTaggedString *)taggedString withInlineStylesOfAttributedString:(NSAttributedString *)attributedString resources:(RKResourcePool *)resources
{
    // Tag font styles
    [attributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSFont *font, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withFont:font inRange:range resources:resources];
    }];
    
    // Tag background color styles
    
}

+ (void)tag:(RKTaggedString *)taggedString withFont:(NSFont *)font inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger openPosition = range.location;
    NSUInteger closePosition = range.location + range.length;
    
    // Default font is "Helvetica", 12pt
    if (!font)
        font = [NSFont fontWithName:@"Helvetica" size:12];
    
    NSUInteger fontIndex = [resources indexOfFont:font];
    NSUInteger fontSize = [font pointSize];
    NSUInteger fontTraits = [[NSFontManager sharedFontManager] traitsOfFont:font];
    
    // Add font and size tag
    [taggedString associateTag:[NSString stringWithFormat:@"\\f%U ", fontIndex] atPosition:openPosition];
    [taggedString associateTag:[NSString stringWithFormat:@"\\fs%U ", fontSize] atPosition:openPosition];
    
    // Add trait tags
    if (fontTraits & NSBoldFontMask) {
        [taggedString associateTag:@"\\b " atPosition:openPosition];
        [taggedString associateTag:@"\\b0 " atPosition:closePosition];
    }
    
    if (fontTraits & NSItalicFontMask) {
        [taggedString associateTag:@"\\i " atPosition:openPosition];
        [taggedString associateTag:@"\\i0 " atPosition:closePosition];
    }   
}

+ (void)tag:(RKTaggedString *)taggedString withBackgroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger colorIndex;
    
    if (color == nil) {
        colorIndex = 1;
    }
     else {
        colorIndex = [resources indexOfColor:color];
     }
    
    [taggedString associateTag:[NSString stringWithFormat:@"\\cb%lu ", colorIndex] atPosition:range.location];
}

+ (void)tag:(RKTaggedString *)taggedString withForegroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger colorIndex;
    
    if (color == nil) {
        colorIndex = 0;
    }
    else {
        colorIndex = [resources indexOfColor:color];
    }
    
    [taggedString associateTag:[NSString stringWithFormat:@"\\cf%lu ", colorIndex] atPosition:range.location];
}

@end
