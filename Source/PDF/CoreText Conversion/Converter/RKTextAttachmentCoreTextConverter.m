//
//  RKTextAttachmentPDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextAttachmentCoreTextConverter.h"

#import "RKPDFImage.h"

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@implementation RKTextAttachmentCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];
    
    // Emulate superscript
    [attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSTextAttachment *attachment, NSRange range, BOOL *stop) {
        if (!attachment)
            return;
        
        RKPDFImage *pdfImage = [[RKPDFImage alloc] initWithFileWrapper:attachment.fileWrapper context:context];
        
        [converted addTextObjectAttribute:pdfImage atIndex:range.location];
    }];
    
    return converted;
}

@end
