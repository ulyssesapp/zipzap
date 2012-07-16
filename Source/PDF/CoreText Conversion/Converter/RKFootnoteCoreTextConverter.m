//
//  RKFootnotePDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootnoteCoreTextConverter.h"

#import "RKFootnote.h"
#import "RKPDFFootnote.h"

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@implementation RKFootnoteCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (void)convertFootnoteAttribute:(NSString *)attributeName isEndnote:(BOOL)isEndnote ofAttributedString:(NSMutableAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    [attributedString enumerateAttribute:attributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSAttributedString *content, NSRange range, BOOL *stop) {
        if (!content)
            return;
        
        RKPDFFootnote *pdfFootnote = [[RKPDFFootnote alloc] initWithContent:content isEndnote:isEndnote context:context];
        
        [attributedString addTextObjectAttribute:pdfFootnote atIndex:range.location];
    }];
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];
    
    [self convertFootnoteAttribute:RKFootnoteAttributeName isEndnote:NO ofAttributedString:converted usingContext:context];
    [self convertFootnoteAttribute:RKEndnoteAttributeName isEndnote:YES ofAttributedString:converted usingContext:context];
    
    return converted;
}

@end
