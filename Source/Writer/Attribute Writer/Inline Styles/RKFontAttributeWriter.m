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

@implementation RKFontAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:NSFontAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSFont *)font resources:(RKResourcePool *)resources
{
    NSMutableString *openingTag = [NSMutableString new];
    
    // Default font is "Helvetica", 12pt
    if (!font)
        font = [NSFont RTFDefaultFont];
    
    NSUInteger fontIndex = [resources indexOfFont:font];
    
    // Add font and size tag
    [openingTag appendFormat:@"\\f%u ", fontIndex];
    // Note: RTF uses half-points to define the font size
    // Cocoa has a more precise, proprietary size tag which must directly follow "fsize"
    [openingTag appendFormat:@"\\fs%u", (NSUInteger)(font.pointSize * 2)];
    [openingTag appendFormat:@"\\fsmilli%u ", (NSUInteger)(font.pointSize * 1000)];    
    
    // Add trait tags
    NSUInteger fontTraits = [[NSFontManager sharedFontManager] traitsOfFont:font];
    
    if (fontTraits & NSBoldFontMask) {
        [openingTag appendString:@"\\b "];
    }
    
    if (fontTraits & NSItalicFontMask) {
        [openingTag appendString:@"\\i "];
    }
    
    return openingTag;
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(NSFont *)font resources:(RKResourcePool *)resources
{
    NSMutableString *closingTag = [NSMutableString new];
    
    // Add trait tags
    NSUInteger fontTraits = [[NSFontManager sharedFontManager] traitsOfFont:font];
    
    if (fontTraits & NSBoldFontMask) {
        [closingTag appendString: @"\\b0 "];
    }
    
    if (fontTraits & NSItalicFontMask) {
        [closingTag appendString: @"\\i0 "];
    }
    
    return closingTag;
}

@end
