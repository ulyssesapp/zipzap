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
#import "RKFontAdditions.h"

@interface RKPDFFootnote ()
{
    NSAttributedString *_footnoteContent;
    BOOL _isEndnote;
    NSString *_footnoteAnchor;
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
        _footnoteAnchor = [context newFootnoteAnchor];
    }
    
    return self;
}

- (void)renderUsingContext:(RKPDFRenderingContext *)context run:(CTRunRef)run
{
    return;
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)index frameSize:(CGSize)frameSize
{
    // Enumerate and register footnote
    NSString *enumerator = [context enumeratorForNote:self];
    
    // Create replacement string
    NSFont *font = [attributedString attribute:NSFontAttributeName atIndex:index effectiveRange:NULL];
    NSMutableAttributedString *replacement = [[NSAttributedString footnoteEnumeratorFromString:enumerator usingFont:font] mutableCopy];

    // Add "," to enumerator, if other footnote follows
    BOOL hasSeparator = (attributedString.length > index+1) && ([attributedString attribute:RKFootnoteAttributeName atIndex:index+1 effectiveRange:NULL] || [attributedString attribute:RKEndnoteAttributeName atIndex:index+1 effectiveRange:NULL]);
    
    if (hasSeparator)
        [replacement.mutableString appendString: @","];

    // Add link to footnote
    [replacement addLocalDestinationLinkForAnchor:_footnoteAnchor forRange:NSMakeRange(0, replacement.length - (hasSeparator ? 1 : 0))];
    
    return replacement;
}

@end
