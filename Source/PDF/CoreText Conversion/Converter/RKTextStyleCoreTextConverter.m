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
		[converted addAttribute:RKPDFRendererStrikethroughAttributeName value:modeObject range:range];
		
		[converted removeAttribute:RKStrikethroughStyleAttributeName range:range];
    }];

    // Emulate underline
    [attributedString enumerateAttribute:(__bridge NSString *)kCTUnderlineStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject)
            return;
		
		// Make sure underline attributes are not applied to line breaks
		[attributedString.string enumerateSubstringsInRange:range options:NSStringEnumerationByLines usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
			[converted addTextRenderer:RKPDFTextDecorationRenderer.class forRange:substringRange];
			[converted addAttribute:RKPDFRendererUnderlineAttributeName value:modeObject range:substringRange];
		}];
		
		[converted removeAttribute:(id)kCTUnderlineStyleAttributeName range:range];
    }];
    
    // Emulate superscript / subscript
    [attributedString enumerateAttribute:RKSuperscriptAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject.floatValue)
            return;

        CTFontRef font = (__bridge CTFontRef)[attributedString attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
        if (!font)
            font = RKGetDefaultFont();

		// Adapt font to 2/3 of its original size
		CGFloat adaptedFontSize = CTFontGetSize(font) * 0.66;
        CTFontRef adaptedFont = CTFontCreateCopyWithAttributes(font, adaptedFontSize, NULL, NULL);
		
		[converted addAttribute:RKFontAttributeName value:(__bridge id)adaptedFont range:range];

		// Apply baseline offset for super / subscript
		CGFloat baselineOffset = (modeObject.integerValue > 0) ? (CTFontGetAscent(font) - CTFontGetAscent(adaptedFont)) : (- CTFontGetDescent(font));
		
		// Note: NSBaselineOffsetAttributeName seems to be ignored by CoreText in OS X < 10.12. However, OS X 10.12 seems to recognize this attribute, even though it is undocumented. Thus, we just use a different attribute name and emulate the offset by our own.
        [converted addAttribute:RKPDFRendererBaselineOffsetAttributeName value:[NSNumber numberWithFloat: baselineOffset] range:range];
        [converted removeAttribute:RKSuperscriptAttributeName range:range];
    }];
	
    return converted;
}

@end
