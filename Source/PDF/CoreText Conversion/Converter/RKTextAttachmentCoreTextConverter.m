//
//  RKTextAttachmentPDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextAttachmentCoreTextConverter.h"

#import "RKPDFImage.h"
#import "RKImageAttachment.h"

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
    
    __block NSUInteger offset = 0;
    
    [attributedString enumerateAttribute:RKImageAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(RKImageAttachment *attachment, NSRange range, BOOL *stop) {
        NSRange fixedRange = NSMakeRange(range.location + offset, range.length);

        if (!attachment)
            return;

        // Create image
        RKPDFImage *pdfImage = [[RKPDFImage alloc] initWithImageAttachment:attachment context:context];

        if (pdfImage) {
            [converted addTextObjectAttribute:pdfImage atIndex:fixedRange.location];
        }
        else {
            NSMutableString *convertedString = converted.mutableString;
            [convertedString replaceCharactersInRange:fixedRange withString:@""];
            
            offset -= range.length;
        }

    }];
    
    return converted;
}

@end
