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

#import "objc/objc-runtime.h"

/*!
 @abstract A common bitmask of the NSUnderlinePattern constant
 */
#define RKUnderlinePatternMask          0x700

@interface RKInlineStyleWriter ()
/*!
 @abstract Generates the required opening and closing tags of a single font attribute
 */
+ (void)addTagsForFont:(NSFont *)font toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a background color attribute
 */
+ (void)addTagsForBackgroundColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a foreground color attribute
 */
+ (void)addTagsForForegroundColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a underline style attribute
 */
+ (void)addTagsForUnderlineStyle:(NSNumber *)underlineStyleObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a underline color attribute
 */
+ (void)addTagsForUnderlineColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a strikethrough style attribute
 */
+ (void)addTagsForStrikethroughStyle:(NSNumber *)strikethroughStyleObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a strikethrough color attribute
 */
+ (void)addTagsForStrikethroughColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a stroke width attribute
 */
+ (void)addTagsForStrokeWidth:(NSNumber *)strokeWidthObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a stroke color attribute
 */
+ (void)addTagsForStrokeColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a shadow style attribute
 */
+ (void)addTagsForShadow:(NSShadow *)shadow toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the required tag of a superscript style attribute
 */
+ (void)addTagsForSuperscriptMode:(NSNumber *)superScriptModeObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

@end

@implementation RKInlineStyleWriter

NSDictionary *inlineAttributesDispatchTable;

+ (void)load
{
    inlineAttributesDispatchTable = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"addTagsForFont:toTaggedString:inRange:resources:",                NSFontAttributeName,
                            @"addTagsForBackgroundColor:toTaggedString:inRange:resources:",     NSBackgroundColorAttributeName,
                            @"addTagsForForegroundColor:toTaggedString:inRange:resources:",     NSForegroundColorAttributeName,
                            @"addTagsForUnderlineStyle:toTaggedString:inRange:resources:",      NSUnderlineStyleAttributeName,
                            @"addTagsForUnderlineColor:toTaggedString:inRange:resources:",      NSUnderlineColorAttributeName,
                            @"addTagsForStrikethroughStyle:toTaggedString:inRange:resources:",  NSStrikethroughStyleAttributeName,
                            @"addTagsForStrikethroughColor:toTaggedString:inRange:resources:",  NSStrikethroughColorAttributeName,
                            @"addTagsForStrokeWidth:toTaggedString:inRange:resources:",         NSStrokeWidthAttributeName,
                            @"addTagsForStrokeColor:toTaggedString:inRange:resources:",         NSStrokeColorAttributeName,
                            @"addTagsForShadow:toTaggedString:inRange:resources:",              NSShadowAttributeName,
                            @"addTagsForSuperscriptMode:toTaggedString:inRange:resources:",     NSSuperscriptAttributeName,
                            nil
                        ];
}

+ (void)addTagsForAttributedString:(NSAttributedString *)attributedString toTaggedString:(RKTaggedString *)taggedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    // Iterate over all dispatch entries available for attributes
    [inlineAttributesDispatchTable enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, NSString *methodSignature, BOOL *stop) {
        SEL methodSelector = NSSelectorFromString(methodSignature);
        
        NSAssert([self respondsToSelector: methodSelector], @"Invalid selector for attribute method");
        
        // For each attribute name call an appropriate method to tag the output string
        [attributedString enumerateAttribute:attributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            objc_msgSend(self, methodSelector, value, taggedString, range, resources);
        }];
    }];
}

+ (void)addTagsForFont:(NSFont *)font toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
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

+ (void)addTagsForBackgroundColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger colorIndex = (color == nil) ? 1 : [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\cb%lu ", colorIndex] forPosition:range.location];
}

+ (void)addTagsForForegroundColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger colorIndex = (color == nil) ? 0 : [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\cf%lu ", colorIndex] forPosition:range.location];
}

+ (void)addTagsForUnderlineStyle:(NSNumber *)underlineStyleObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger underlineStyle = [underlineStyleObject unsignedIntegerValue];
    
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

+ (void)addTagsForUnderlineColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulc%U ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulc0 ", colorIndex] forPosition:(range.location + range.length)];
}

+ (void)addTagsForStrikethroughStyle:(NSNumber *)strikethroughStyleObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSUInteger strikethroughStyle = [strikethroughStyleObject unsignedIntegerValue];

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

+ (void)addTagsForStrikethroughColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikec%u ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikec0 ", colorIndex] forPosition:(range.location + range.length)];
}

+ (void)addTagsForStrokeWidth:(NSNumber *)strokeWidthObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSInteger strokeWidth = [strokeWidthObject integerValue];
    
    if (strokeWidth == 0)
        return;
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\outl\\strokewidth%li ", strokeWidth] forPosition:range.location];
    [taggedString registerTag:@"\\outl0\\strokewidth0 " forPosition:(range.location + range.length)];
}

+ (void)addTagsForStrokeColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\strokec%U ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\strokec0 ", colorIndex] forPosition:(range.location + range.length)];
}

+ (void)addTagsForShadow:(NSShadow *)shadow toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
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

+ (void)addTagsForSuperscriptMode:(NSNumber *)superScriptModeObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSInteger mode = [superScriptModeObject integerValue];
    
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

