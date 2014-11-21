//
//  RKParagraphStylePDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "RKParagraphStyleCoreTextConverter.h"
#import "RKParagraphStyleWrapper.h"

@implementation RKParagraphStyleCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];
    
    [attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id unwrappedParagraphStyle, NSRange range, BOOL *stop) {
        if (!unwrappedParagraphStyle)
            return;
        
        // Convert paragraph style to wrapper style
        RKParagraphStyleWrapper *paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: unwrappedParagraphStyle];
		
        // Convert style settings
        CTParagraphStyleRef convertedStyle = paragraphStyle.newCTParagraphStyle;
        
        [converted removeAttribute:NSParagraphStyleAttributeName range:range];
        [converted addAttribute:(__bridge id)kCTParagraphStyleAttributeName value:(__bridge id)convertedStyle range:range];
        
        CFRelease(convertedStyle);
    }];

    return converted;
}

@end
