//
//  RKTextStylePDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextStyleCoreTextConverter.h"

#import "RKPDFStrikethroughRenderer.h"

#import "RKFontAdditions.h"
#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@implementation RKTextStyleCoreTextConverter

+ (void)load
{
    // We assume the following application kit attributes to be directly convertable
    NSAssert([(__bridge id)kCTUnderlineStyleAttributeName isEqual: NSUnderlineStyleAttributeName], @"Styles not convertable");
    NSAssert([(__bridge id)kCTStrokeWidthAttributeName isEqual: NSStrokeWidthAttributeName], @"Styles not convertable");
    NSAssert([(__bridge id)kCTKernAttributeName isEqual: NSKernAttributeName], @"Styles not convertable");
    NSAssert([(__bridge id)kCTLigatureAttributeName isEqual: NSLigatureAttributeName], @"Styles not convertable");
    NSAssert([(__bridge id)kCTVerticalFormsAttributeName isEqual: NSVerticalGlyphFormAttributeName], @"Styles not convertable");
    
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];

    // Emulate strikethrough
    [attributedString enumerateAttribute:NSStrikethroughStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject)
            return;
        
        [converted addTextRenderer:RKPDFStrikethroughRenderer.class forRange:range];
    }];
    
    // Emulate superscript / subscript
    [attributedString enumerateAttribute:NSSuperscriptAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject)
            return;

        NSFont *font = [attributedString attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
        if (!font)
            font = [NSFont RTFDefaultFont];
        
        [converted addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat: (font.pointSize / 2.0f) * modeObject.floatValue] range:range];
    }];
    
    return converted;
}

@end
