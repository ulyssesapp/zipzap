//
//  RKPlaceholderPDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPlaceholderCoreTextConverter.h"

#import "RKPlaceholder.h"
#import "RKPDFPlaceholder.h"

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@implementation RKPlaceholderCoreTextConverter

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
    [attributedString enumerateAttribute:RKPlaceholderAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *placeholder, NSRange range, BOOL *stop) {
        if (!placeholder)
            return;
        
        RKPDFPlaceholder *pdfPlaceholder = [[RKPDFPlaceholder alloc] initWithPlaceholderType:placeholder.unsignedIntegerValue];
        
        [converted addTextObjectAttribute:pdfPlaceholder atIndex:range.location];
    }];
    
    return converted;
}

@end
