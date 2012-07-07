//
//  NSAttributedString+PDFUtilities.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+PDFUtilities.h"

#import "RKFootnote.h"
#import "RKPDFFootnote.h"

NSString *RKFootnoteContentKey              = @"content";
NSString *RKFootnoteEnumerationStringKey    = @"enumerationString";

NSString *RKTextObjectAttributeName         = @"RKTextObject";
NSString *RKTextRendererAttributeName       = @"RKTextRenderer";
NSString *RKPDFAnchorName                   = @"RKAnchor";
NSString *RKPDFAnchorReferenceName          = @"RKAnchorLink";

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

@end

@implementation NSMutableAttributedString (PDFUtilities)

- (void)addTextObjectAttribute:(RKTextObject *)textObject atIndex:(NSUInteger)index
{
    CTR
    
   [self addAttribute:kCTRunDelegateAttributeName value:(__bridge_transfer id)runDelegate range:NSMakeRange(index, 1)];
}

- (void)addTextRenderer:(Class)textRender forRange:(NSRange)range
{
    NSAssert(false, @"Not implemented yet");
}

- (void)addLocalDestinationAnchor:(NSString *)anchorName forRange:(NSRange)range
{
    NSAssert(false, @"Not implemented yet");
}

- (void)addLocalDestinationLinkForAnchor:(NSString *)anchorName forRange:(NSRange)range
{
    NSAssert(false, @"Not implemented yet");
}

@end
