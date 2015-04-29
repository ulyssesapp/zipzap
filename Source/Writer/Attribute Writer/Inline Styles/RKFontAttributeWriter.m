//
//  RKFontAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKFontAttributeWriter.h"
#import "RKFontAdditions.h"

@interface RKFontAttributeWriter ()

/*!
 @abstract Generates the required font tags for a font with a certain index, point size and trait setting.
 */
+ (NSString *)openingTagsWithFontIndex:(NSUInteger)fontIndex pointSize:(CGFloat)pointSize isBoldFont:(BOOL)isBoldFont isItalicFont:(BOOL)isItalicFont;

/*!
 @abstract Generates a closing font tag for the given traits
 */
+ (NSString *)closingTagWithIsBoldFont:(BOOL)isBoldFont isItalicFont:(BOOL)isItalicFont;

@end

@implementation RKFontAttributeWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKFontAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    }
}



#pragma mark - Plattform-dependent tag generation

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(id)fontObject resources:(RKResourcePool *)resources
{
    CTFontRef font = (__bridge CTFontRef)fontObject;
    
    // Default font is "Helvetica", 12pt
    if (!font)
        font = RKGetDefaultFont();
    
    NSUInteger fontIndex = [resources indexOfFont: font];
    CTFontSymbolicTraits fontTraits = CTFontGetSymbolicTraits(font);

    return [self openingTagsWithFontIndex:fontIndex pointSize:CTFontGetSize(font) isBoldFont:(fontTraits & kCTFontBoldTrait) isItalicFont:(fontTraits & kCTFontItalicTrait)];
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(id)font resources:(RKResourcePool *)resources
{
    // Add trait tags
    NSUInteger fontTraits = CTFontGetSymbolicTraits((__bridge CTFontRef)font);

    return [self closingTagWithIsBoldFont:(fontTraits & kCTFontBoldTrait) isItalicFont:(fontTraits & kCTFontItalicTrait)];
}



#pragma mark - Plattform-independent tag generation

+ (NSString *)openingTagsWithFontIndex:(NSUInteger)fontIndex pointSize:(CGFloat)pointSize isBoldFont:(BOOL)isBoldFont isItalicFont:(BOOL)isItalicFont
{
    NSMutableString *openingTag = [NSMutableString new];
    
    // Add font and size tag
    [openingTag appendFormat:@"\\f%lu ", fontIndex];
    // Note: RTF uses half-points to define the font size
    // Cocoa has a more precise, proprietary size tag which must directly follow "fsize"
    [openingTag appendFormat:@"\\fs%lu", (NSUInteger)(pointSize * 2)];
    [openingTag appendFormat:@"\\fsmilli%lu ", (NSUInteger)(pointSize * 1000)];
    
    // Add trait tags
    if (isBoldFont)
        [openingTag appendString:@"\\b "];
    
    if (isItalicFont)
        [openingTag appendString:@"\\i "];
    
    return openingTag;
}

+ (NSString *)closingTagWithIsBoldFont:(BOOL)isBoldFont isItalicFont:(BOOL)isItalicFont
{
    NSMutableString *closingTag = [NSMutableString new];
    
    if (isBoldFont)
        [closingTag appendString: @"\\b0 "];
    
    if (isItalicFont)
        [closingTag appendString: @"\\i0 "];
    
    return closingTag;
}

@end