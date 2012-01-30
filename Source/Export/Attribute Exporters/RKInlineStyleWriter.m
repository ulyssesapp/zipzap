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

/*!
 @abstract A common bitmask of the NSUnderlinePattern constant
 */
#define RKUnderlinePatternMask          0x700

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
+ (void)tag:(RKTaggedString *)taggedString withUnderlineStyle:(NSUInteger)underlineStyle inRange:(NSRange)range;

/*!
 @abstract Generates the required tag of a underline color attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withUnderlineColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a strikethrough style attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withStrikethroughStyle:(NSUInteger)underlineStyle inRange:(NSRange)range;

/*!
 @abstract Generates the required tag of a strikethrough color attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withStrikethroughColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a stroke width attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withStrokeWidth:(CGFloat)strokeWidth inRange:(NSRange)range;

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
+ (void)tag:(RKTaggedString *)taggedString withSuperscriptMode:(NSInteger)mode inRange:(NSRange)range;

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

+ (void)tag:(RKTaggedString *)taggedString withUnderlineStyle:(NSUInteger)underlineStyle inRange:(NSRange)range
{
    // No underlining
    if (underlineStyle == NSUnderlineStyleNone)
        return;
    
    // Word-wise underlining (must precede other tags)
    if (underlineStyle & NSUnderlineByWordMask) {
        [taggedString associateTag:@"\\ulw" atPosition:range.location];
    }

    // Never write \\ulw \\ul, since this is misinterpreted by several RTF interpreters
    if (underlineStyle != (NSUnderlineByWordMask | NSUnderlineStyleSingle)) {
        // Determine pattern flag
        NSString *patternString = @"";
        
        switch (underlineStyle & RKUnderlinePatternMask) {
            case NSUnderlinePatternDash:
                patternString = @"dash";
                break;
            case NSUnderlinePatternDashDot:
                patternString = @"dashd";
                break;
            case NSUnderlinePatternDashDotDot:
                patternString = @"dashdd";
                break;
        }

        // Determine style flag
        NSString *styleString = @"";

        if ((underlineStyle & NSUnderlineStyleDouble) == NSUnderlineStyleDouble) {
            // Underlining mode double (cannot be combined with dash-styles
            styleString = @"db";
            patternString = @"";
        }
        else if ((underlineStyle & NSUnderlineStyleThick) == NSUnderlineStyleThick) {
            styleString = @"th";
        }
        
        // Generate \\ul<STYLE><PATTERN> flag
        [taggedString associateTag:[NSString stringWithFormat:@"\\ul%@%@", styleString, patternString] atPosition:range.location];
    }
    
    // Add the deactivating tag
    [taggedString associateTag:@"\\ulnone " atPosition:(range.location + range.length)];

    // We add the Apple proprietary tag, to ensure full support of the text system
    [taggedString associateTag:[NSString stringWithFormat:@"\\ulstyle%U ", underlineStyle] atPosition:range.location];
}

+ (void)tag:(RKTaggedString *)taggedString withUnderlineColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString associateTag:[NSString stringWithFormat:@"\\ulc%U ", colorIndex] atPosition:range.location];
    [taggedString associateTag:[NSString stringWithFormat:@"\\ulc0 ", colorIndex] atPosition:(range.location + range.length)];
}

+ (void)tag:(RKTaggedString *)taggedString withStrikethroughStyle:(NSUInteger)strikethroughStyle inRange:(NSRange)range
{
    // No strike through
    if (strikethroughStyle == NSUnderlineStyleNone)
        return;

    // Convert unsupported strikethrough styles to \strike, 
    NSString *opening = @"\\strike";
    NSString *closing = @"\\strike0 ";

    // Currently only \\strikedN is supported as alternative
    if ((strikethroughStyle & NSUnderlineStyleDouble) == NSUnderlineStyleDouble) {
        opening = @"\\striked1";
        closing = @"\\striked0 ";
    }
    
    [taggedString associateTag:opening atPosition:range.location];
    [taggedString associateTag:closing atPosition:(range.location + range.length)];
    
    // We add the Apple proprietary tag, to ensure full support of the text system
    [taggedString associateTag:[NSString stringWithFormat:@"\\strikestyle%U ", strikethroughStyle] atPosition:range.location];

}

+ (void)tag:(RKTaggedString *)taggedString withStrikethroughColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString associateTag:[NSString stringWithFormat:@"\\strikec%U ", colorIndex] atPosition:range.location];
    [taggedString associateTag:[NSString stringWithFormat:@"\\strikec0 ", colorIndex] atPosition:(range.location + range.length)];
}

@end
