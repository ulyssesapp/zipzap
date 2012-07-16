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

NSString *RKFootnoteContentKey              = @"content";
NSString *RKFootnoteEnumerationStringKey    = @"enumerationString";

NSString *RKTextObjectAttributeName         = @"RKTextObject";
NSString *RKTextRendererAttributeName       = @"RKTextRenderer";
NSString *RKPDFAnchorAttributeName          = @"RKAnchor";
NSString *RKPDFAnchorLinkAttributeName      = @"RKAnchorLink";

@implementation NSAttributedString (PDFUtilities)

- (NSAttributedString *)noteWithEnumerationString:(NSString *)enumerationString
{
    NSMutableAttributedString *enumerator = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat: @"%@\t", enumerationString]];
    [enumerator addAttribute:(__bridge id)kCTSuperscriptAttributeName value:@(1) range:NSMakeRange(0, enumerationString.length)];
        
    NSMutableAttributedString *note = [self mutableCopy];
    
    [note insertAttributedString:enumerator atIndex:0];

    return note;
}

+ (NSAttributedString *)noteListWithNotes:(NSArray *)notes
{
    NSMutableAttributedString *noteList = [NSMutableAttributedString new];
    
    for (NSDictionary *noteDescriptor in notes) {
        NSAttributedString *note = [noteDescriptor[RKFootnoteContentKey] noteWithEnumerationString: noteDescriptor[RKFootnoteEnumerationStringKey]];
        
        if (![noteList.string hasSuffix: @"\n"])
            [noteList appendAttributedString: [[NSAttributedString alloc] initWithString: @"\n"]];
        
        [noteList appendAttributedString: note];
    }
    
    return noteList;
}

+ (NSAttributedString *)spacingWithHeight:(CGFloat)height width:(CGFloat)width
{
    CTFontRef baseFont = CTFontCreateWithName(CFSTR("Helvetica"), height, NULL);

    NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat: width], kCTFontFixedAdvanceAttribute,
                                    nil
                                   ];
    
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)fontAttributes);
    CTFontRef fixedFont = CTFontCreateCopyWithAttributes(baseFont, 0.0, NULL, fontDescriptor);
    
    NSAttributedString *spacer = [[NSAttributedString alloc] initWithString:@" " attributes:[NSDictionary dictionaryWithObjectsAndKeys: (__bridge id)fixedFont, (__bridge id)kCTFontAttributeName, nil]];
    
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
