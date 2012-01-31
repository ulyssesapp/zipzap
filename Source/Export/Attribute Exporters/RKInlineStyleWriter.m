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
    [attributedString enumerateAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSColor *color, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withBackgroundColor:color inRange:range resources:resources];
    }];   

    // Tag foreground color styles
    [attributedString enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSColor *color, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withForegroundColor:color inRange:range resources:resources];
    }];   

    // Tag underline styles
    [attributedString enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSNumber *style, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withUnderlineStyle:[style unsignedIntegerValue] inRange:range];
    }];   
    
    // Tag underline color styles
    [attributedString enumerateAttribute:NSUnderlineColorAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSColor *color, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withUnderlineColor:color inRange:range resources:resources];
    }];     

    // Tag strikethrough styles
    [attributedString enumerateAttribute:NSStrikethroughStyleAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSNumber *style, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withStrikethroughStyle:[style unsignedIntegerValue] inRange:range];
    }];   
    
    // Tag strikethrough color styles
    [attributedString enumerateAttribute:NSStrikethroughColorAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSColor *color, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withStrikethroughColor:color inRange:range resources:resources];
    }];        
    
    // Tag stroke width styles
    [attributedString enumerateAttribute:NSStrokeWidthAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSNumber *style, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withStrokeWidth:[style doubleValue] inRange:range];
    }];   
    
    // Tag stroke color styles
    [attributedString enumerateAttribute:NSStrokeColorAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSColor *color, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withStrokeColor:color inRange:range resources:resources];
    }];   

    // Tag shadow styles
    [attributedString enumerateAttribute:NSShadowAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSShadow *style, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withShadowStyle:style inRange:range resources:resources];
    }];   

    // Tag superscript / subscript styles
    [attributedString enumerateAttribute:NSSuperscriptAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSNumber *style, NSRange range, BOOL *stop) {
        [RKInlineStyleWriter tag:taggedString withSuperscriptMode:[style integerValue] inRange:range];
    }];   
}

+ (void)tag:(RKTaggedString *)taggedString withFont:(NSFont *)font inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger openPosition = range.location;
    NSUInteger closePosition = range.location + range.length;
    
    // Default font is "Helvetica", 12pt
    if (!font)
        font = [NSFont fontWithName:@"Helvetica" size:12];
    
    NSUInteger fontIndex = [resources indexOfFont:font];
    
    // Add font and size tag
    [taggedString registerTag:[NSString stringWithFormat:@"\\f%u ", fontIndex] forPosition:openPosition];
    [taggedString registerTag:[NSString stringWithFormat:@"\\fs%u ", (NSUInteger)font.pointSize] forPosition:openPosition];
    
    // Add trait tags
    NSUInteger fontTraits = [[NSFontManager sharedFontManager] traitsOfFont:font];
    
    if (fontTraits & NSBoldFontMask) {
        [taggedString registerTag:@"\\b " forPosition:openPosition];
        [taggedString registerTag:@"\\b0 " forPosition:closePosition];
    }
    
    if (fontTraits & NSItalicFontMask) {
        [taggedString registerTag:@"\\i " forPosition:openPosition];
        [taggedString registerTag:@"\\i0 " forPosition:closePosition];
    }   
}

+ (void)tag:(RKTaggedString *)taggedString withBackgroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger colorIndex = (color == nil) ? 1 : [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\cb%lu ", colorIndex] forPosition:range.location];
}

+ (void)tag:(RKTaggedString *)taggedString withForegroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger colorIndex = (color == nil) ? 0 : [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\cf%lu ", colorIndex] forPosition:range.location];
}

+ (void)tag:(RKTaggedString *)taggedString withUnderlineStyle:(NSUInteger)underlineStyle inRange:(NSRange)range
{
    // No underlining
    if (underlineStyle == NSUnderlineStyleNone)
        return;
    
    // Word-wise underlining (must precede other tags)
    if (underlineStyle & NSUnderlineByWordMask) {
        [taggedString registerTag:@"\\ulw" forPosition:range.location];
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
        [taggedString registerTag:[NSString stringWithFormat:@"\\ul%@%@", styleString, patternString] forPosition:range.location];
    }
    
    // Add the deactivating tag
    [taggedString registerTag:@"\\ulnone " forPosition:(range.location + range.length)];

    // We add the Apple proprietary tag, to ensure full support of the text system
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulstyle%U ", underlineStyle] forPosition:range.location];
}

+ (void)tag:(RKTaggedString *)taggedString withUnderlineColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulc%U ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulc0 ", colorIndex] forPosition:(range.location + range.length)];
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
    
    [taggedString registerTag:opening forPosition:range.location];
    [taggedString registerTag:closing forPosition:(range.location + range.length)];
    
    // We add the Apple proprietary tag, to ensure full support of the text system
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikestyle%u ", strikethroughStyle] forPosition:range.location];

}

+ (void)tag:(RKTaggedString *)taggedString withStrikethroughColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikec%u ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikec0 ", colorIndex] forPosition:(range.location + range.length)];
}

+ (void)tag:(RKTaggedString *)taggedString withStrokeWidth:(CGFloat)strokeWidth inRange:(NSRange)range
{
    if (strokeWidth == 0)
        return;
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\outl\\strokewidth%i ", (NSUInteger)strokeWidth] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\outl0\\strokewidth0 ", (NSUInteger)strokeWidth] forPosition:(range.location + range.length)];
}

+ (void)tag:(RKTaggedString *)taggedString withStrokeColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\strokec%U ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\strokec0 ", colorIndex] forPosition:(range.location + range.length)];
}

+ (void)tag:(RKTaggedString *)taggedString withShadowStyle:(NSShadow *)shadow inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (shadow == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:[shadow shadowColor]];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\shad\\shadx%u\\shady%u\\shadr%u\\shadc%u ",
                                (NSUInteger)RKPointsToTwips([shadow shadowOffset].width),
                                (NSUInteger)RKPointsToTwips([shadow shadowOffset].height),
                                (NSUInteger)RKPointsToTwips([shadow shadowBlurRadius]),
                                colorIndex
                               ]
                    forPosition:range.location];
    
    [taggedString registerTag:@"\\shad0 " forPosition:(range.location + range.length)];
}

+ (void)tag:(RKTaggedString *)taggedString withSuperscriptMode:(NSInteger)mode inRange:(NSRange)range
{
    if (mode == 0) 
        return;
    
    if (mode > 0) {
        [taggedString registerTag:[NSString stringWithFormat:@"\\sup "] forPosition:range.location];
        [taggedString registerTag:[NSString stringWithFormat:@"\\sup0 "] forPosition:(range.location + range.length)];
    }
    else if (mode < 0) {
        [taggedString registerTag:[NSString stringWithFormat:@"\\sub "] forPosition:range.location];
        [taggedString registerTag:[NSString stringWithFormat:@"\\sub0 "] forPosition:(range.location + range.length)];
    }
}
    
@end

