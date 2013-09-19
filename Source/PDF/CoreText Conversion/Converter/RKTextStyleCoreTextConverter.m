//
//  RKTextStylePDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextStyleCoreTextConverter.h"

#import "RKPDFTextDecorationRenderer.h"

#import "RKFontAdditions.h"
#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@implementation RKTextStyleCoreTextConverter

+ (void)load
{
	#if !TARGET_OS_IPHONE
    // We assume the following application kit attributes to be directly convertable
    NSAssert([(__bridge id)kCTStrokeWidthAttributeName isEqual: NSStrokeWidthAttributeName], @"Styles not convertable");
    NSAssert([(__bridge id)kCTKernAttributeName isEqual: NSKernAttributeName], @"Styles not convertable");
    NSAssert([(__bridge id)kCTLigatureAttributeName isEqual: NSLigatureAttributeName], @"Styles not convertable");
    NSAssert([(__bridge id)kCTVerticalFormsAttributeName isEqual: NSVerticalGlyphFormAttributeName], @"Styles not convertable");
    #endif
	
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];

    // Emulate strikethrough
    [attributedString enumerateAttribute:RKStrikethroughStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject)
            return;
        
        [converted addTextRenderer:RKPDFTextDecorationRenderer.class forRange:range];
    }];

    // Emulate underline
    [attributedString enumerateAttribute:(__bridge NSString *)kCTUnderlineStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject)
            return;
        
        [converted addTextRenderer:RKPDFTextDecorationRenderer.class forRange:range];
    }];
    
    // Emulate superscript / subscript
    [attributedString enumerateAttribute:RKSuperscriptAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject.floatValue)
            return;

        CTFontRef font = (__bridge CTFontRef)[attributedString attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
        if (!font)
            font = RKGetDefaultFont();

		// Adapt font to 2/3 of its original size
		CGFloat fontSize = CTFontGetSize(font);
		CGFloat adaptedFontSize = CTFontGetSize(font) * 0.66;
        CTFontRef adaptedFont = CTFontCreateCopyWithAttributes(font, adaptedFontSize, NULL, NULL);
		
		[converted addAttribute:RKFontAttributeName value:(__bridge id)adaptedFont range:range];

		// Apply baseline offset for super / subscript
		CGFloat ascenderPos = CTFontGetAscent(font);
		CGFloat descenderPos = CTFontGetDescent(font);
		CGFloat baselineOffset = (modeObject.integerValue > 0) ? (ascenderPos - (fontSize - adaptedFontSize)) : (-descenderPos);
		
        [converted addAttribute:RKBaselineOffsetAttributeName value:[NSNumber numberWithFloat: baselineOffset] range:range];
        [converted removeAttribute:RKSuperscriptAttributeName range:range];
    }];
    
    return converted;
}

@end
