//
//  NSAttributedString+PDFUtilities.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+PDFUtilities.h"

#import "RKAnchorRenderer.h"
#import "RKAnchorLinkRenderer.h"

#import "RKFootnote.h"
#import "RKPDFFootnote.h"
#import "RKPDFRenderingContext.h"
#import "RKFontAdditions.h"
#import "RKParagraphStyleWrapper.h"
#import "RKTextTabWrapper.h"

#import "NSAttributedString+PDFCoreTextConversion.h"

NSString *RKFootnoteObjectKey               = @"footnote";
NSString *RKFootnoteEnumerationStringKey    = @"enumerationString";

NSString *RKTextObjectAttributeName         = @"RKTextObject";
NSString *RKTextRendererAttributeName       = @"RKTextRenderer";
NSString *RKPDFAnchorAttributeName          = @"RKAnchor";
NSString *RKPDFAnchorLinkAttributeName      = @"RKAnchorLink";
NSString *RKHyphenationCharacterAttributeName = @"RKHyphenationCharacter";

@implementation NSAttributedString (PDFUtilities)

+ (NSAttributedString *)attributedStringWithNote:(RKPDFFootnote *)note enumerationString:(NSString *)enumerationString context:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *noteString = [note.footnoteContent mutableCopy];
	CTFontRef fontRef = NULL;
	RKParagraphStyleWrapper *paragraphStyle;
	
	if (noteString.length) {
		fontRef = (__bridge CTFontRef)[noteString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
		paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle: (__bridge CTParagraphStyleRef)[noteString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL]];
	}
	
    NSAttributedString *enumerator = [[[NSAttributedString alloc] initWithString:enumerationString attributes:context.document.footnoteAreaAnchorAttributes] coreTextRepresentationUsingContext: context];
    
    // Add enumerator and spacing. Use tabs before and after divider for placement and alignment.
	[noteString insertAttributedString:[[NSAttributedString alloc] initWithString: @"\t"] atIndex:0];
	[noteString insertAttributedString:enumerator atIndex:0];
	[noteString insertAttributedString:[[NSAttributedString alloc] initWithString: @"\t"] atIndex:0];
	
    // Setup paragraph style
    if (paragraphStyle) {
		NSMutableArray *tabStops = [paragraphStyle.tabStops mutableCopy] ?: [NSMutableArray new];

		[tabStops insertObject:[[RKTextTabWrapper alloc] initWithLocation:(context.document.footnoteAreaAnchorInset ?: 1) alignment:context.document.footnoteAreaAnchorAlignment] atIndex:0];
		[tabStops insertObject:[[RKTextTabWrapper alloc] initWithLocation:(context.document.footnoteAreaContentInset ?: 1) alignment:NSNaturalTextAlignment] atIndex:1];
		
		paragraphStyle.tabStops = tabStops;
		
        [noteString addAttribute:NSParagraphStyleAttributeName value:(__bridge id)paragraphStyle.newCTParagraphStyle range:NSMakeRange(0, enumerator.length + 2)];
	}
    
    // Add anchor for enumerator
    [noteString addLocalDestinationAnchor:note.footnoteAnchor forRange:NSMakeRange(0, 1)];

    // Indent newlines to be aligned to the footnote content
    NSMutableString *content = [noteString mutableString];
	
	[content replaceOccurrencesOfString:@"\n" withString:@"\n\t\t" options:0 range:NSMakeRange(0, content.length)];
    
    return noteString;
}

+ (NSAttributedString *)noteListFromNotes:(NSArray *)notes context:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *noteList = [NSMutableAttributedString new];
    
    for (NSDictionary *noteDescriptor in notes) {
        NSAttributedString *note = [self attributedStringWithNote:[noteDescriptor objectForKey: RKFootnoteObjectKey] enumerationString:[noteDescriptor objectForKey: RKFootnoteEnumerationStringKey] context:context];
        
        if ((noteList.length > 0) && ![noteList.string hasSuffix: @"\n"])
            [noteList.mutableString appendString: @"\n"];
        
        [noteList appendAttributedString: note];
    }
    
    return noteList;
}

+ (NSAttributedString *)spacingWithHeight:(CGFloat)height width:(CGFloat)width
{
    static NSCharacterSet *spacingCharacterSet;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		spacingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\u202f"];
	});
    
    CTFontRef baseFont = CTFontCreateWithName(CFSTR("Helvetica"), height, NULL);

    NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat: width], kCTFontFixedAdvanceAttribute,
                                    spacingCharacterSet, kCTFontCharacterSetAttribute,
                                    nil
                                   ];
    
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)fontAttributes);
    CTFontRef fixedFont = CTFontCreateCopyWithAttributes(baseFont, 0.0, NULL, fontDescriptor);
    
    NSAttributedString *spacer = [[NSAttributedString alloc] initWithString:@"\u202f" attributes:[NSDictionary dictionaryWithObjectsAndKeys: (__bridge id)fixedFont, (__bridge id)kCTFontAttributeName, nil]];
    
    CFRelease(fontDescriptor);
    CFRelease(fixedFont);
    CFRelease(baseFont);
    
    return spacer;
}

@end

@implementation NSMutableAttributedString (PDFUtilities)

- (void)addTextObjectAttribute:(RKPDFTextObject *)textObject atIndex:(NSUInteger)index
{
    [self addAttribute:RKTextObjectAttributeName value:textObject range:NSMakeRange(index, 1)];
}

- (void)addTextRenderer:(Class)textRenderer forRange:(NSRange)range
{
    // Update existing renderer ranges
    [self enumerateAttribute:RKTextRendererAttributeName inRange:range options:0 usingBlock:^(NSArray *renderer, NSRange range, BOOL *stop) {
        // Set new renderer
        if (!renderer) {
            [self addAttribute:RKTextRendererAttributeName value:[NSArray arrayWithObject: textRenderer] range:range];
            return;
        }
        
        // Update existing renderer
        NSMutableArray *updatedRenderer = [renderer mutableCopy];
        
        [updatedRenderer addObject: textRenderer];
        [updatedRenderer sortUsingComparator:^NSComparisonResult(Class rendererA, Class rendererB) {
            if ([rendererA priority] < [rendererB priority])
                return NSOrderedAscending;
            else
                return NSOrderedDescending;
        }];
        
        [self addAttribute:RKTextRendererAttributeName value:updatedRenderer range:range];
    }];
}

- (void)addLocalDestinationAnchor:(NSString *)anchorName forRange:(NSRange)range
{
    [self addAttribute:RKPDFAnchorAttributeName value:anchorName range:range];
    [self addTextRenderer:RKAnchorRenderer.class forRange:range];
}

- (void)addLocalDestinationLinkForAnchor:(NSString *)anchorName forRange:(NSRange)range
{
    [self addAttribute:RKPDFAnchorLinkAttributeName value:anchorName range:range];
    [self addTextRenderer:RKAnchorLinkRenderer.class forRange:range];
}

@end
