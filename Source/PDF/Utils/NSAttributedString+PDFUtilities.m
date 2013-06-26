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
#import "RKFontAdditions.h"

NSString *RKFootnoteObjectKey               = @"footnote";
NSString *RKFootnoteEnumerationStringKey    = @"enumerationString";

NSString *RKTextObjectAttributeName         = @"RKTextObject";
NSString *RKTextRendererAttributeName       = @"RKTextRenderer";
NSString *RKPDFAnchorAttributeName          = @"RKAnchor";
NSString *RKPDFAnchorLinkAttributeName      = @"RKAnchorLink";
NSString *RKHyphenationCharacterAttributeName = @"RKHyphenationCharacter";

@implementation NSAttributedString (PDFUtilities)

+ (NSAttributedString *)attributedStringWithNote:(RKPDFFootnote *)note enumerationString:(NSString *)enumerationString
{
    NSMutableAttributedString *noteString = [note.footnoteContent mutableCopy];
	CTFontRef fontRef = NULL;
	id paragraphStyle;
	
	if (noteString.length) {
		fontRef = (__bridge CTFontRef)[noteString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
		paragraphStyle = [noteString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
	}
	
    NSAttributedString *enumerator = [NSAttributedString footnoteEnumeratorFromString:enumerationString usingFont:fontRef enumeratorFactor: 1.25];
    
    // Add enumerator and spacing
    [noteString insertAttributedString:[[NSAttributedString alloc] initWithString: @"\t"] atIndex:0];
    [noteString insertAttributedString:enumerator atIndex:0];

    // Setup paragraph style
    if (paragraphStyle)
        [noteString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, enumerator.length + 1)];
    
    // Add anchor for enumerator
    [noteString addLocalDestinationAnchor:note.footnoteAnchor forRange:NSMakeRange(0, 1)];

    // Indent newlines
    NSMutableString *content = [noteString mutableString];
    [content replaceOccurrencesOfString:@"\n" withString:@"\n\t" options:0 range:NSMakeRange(0, content.length)];
    
    return noteString;
}

+ (NSAttributedString *)noteListFromNotes:(NSArray *)notes
{
    NSMutableAttributedString *noteList = [NSMutableAttributedString new];
    
    for (NSDictionary *noteDescriptor in notes) {
        NSAttributedString *note = [self attributedStringWithNote:[noteDescriptor objectForKey: RKFootnoteObjectKey] enumerationString:[noteDescriptor objectForKey: RKFootnoteEnumerationStringKey]];
        
        if ((noteList.length > 0) && ![noteList.string hasSuffix: @"\n"])
            [noteList.mutableString appendString: @"\n"];
        
        [noteList appendAttributedString: note];
    }
    
    return noteList;
}

+ (NSAttributedString *)footnoteEnumeratorFromString:(NSString *)enumeratorString usingFont:(CTFontRef)font enumeratorFactor:(CGFloat)enumeratorFactor
{
    NSMutableAttributedString *enumerator = [[NSMutableAttributedString alloc] initWithString:enumeratorString];
    
    // Style footnote
    if (!font)
        font = RKGetDefaultFont();
    
    CGFloat pointSize = CTFontGetSize(font) / enumeratorFactor;
    CTFontRef subscriptFont = CTFontCreateCopyWithAttributes(font, pointSize, NULL, NULL);
    
    [enumerator addAttribute:NSFontAttributeName value:(__bridge id)subscriptFont range:NSMakeRange(0, enumerator.length)];
    [enumerator addAttribute:RKBaselineOffsetAttributeName value:[NSNumber numberWithFloat: CTFontGetSize(font) / (enumeratorFactor + 1.0f)] range:NSMakeRange(0, enumerator.length)];
    
    CFRelease(subscriptFont);    
    return enumerator;
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
