//
//  RKPDFFootnote.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFFootnote.h"

#import "RKPDFRenderingContext.h"

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@interface RKPDFFootnote ()
{
    NSAttributedString *_footnoteContent;
    BOOL _isEndnote;
}

@end

@implementation RKPDFFootnote

@synthesize footnoteContent=_footnoteContent, isEndnote=_isEndnote;

- (id)initWithContent:(NSAttributedString *)footnoteContent isEndnote:(BOOL)isEndnote context:(RKPDFRenderingContext *)context
{
    self = [self init];
    
    if (self) {
        _footnoteContent = [footnoteContent coreTextRepresentationUsingContext: context];
        _isEndnote = isEndnote;
    }
    
    return self;
}

- (void)renderUsingContext:(RKPDFRenderingContext *)context run:(CTRunRef)run
{
    return;
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)index
{
    // Enumerate and register footnote
    NSString *enumerator = [context enumeratorForNote:self.footnoteContent isFootnote:!self.isEndnote];
    
    // Create a replacement string (using superscript)
    NSMutableAttributedString *replacementString = [[NSMutableAttributedString alloc] initWithString:enumerator attributes:[attributedString attributesAtIndex:index effectiveRange:NULL]];
    [replacementString addAttribute:(__bridge id)kCTSuperscriptAttributeName value:[NSNumber numberWithInteger: 1] range:NSMakeRange(0, replacementString.length)];
    
    return replacementString;
}

@end
