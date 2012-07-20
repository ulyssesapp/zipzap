//
//  RKLinkPDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKLinkCoreTextConverter.h"

#import "RKPDFLinkRenderer.h"

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@implementation RKLinkCoreTextConverter

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
    [attributedString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSNumber *modeObject, NSRange range, BOOL *stop) {
        if (!modeObject)
            return;
        
        [converted addTextRenderer:RKPDFLinkRenderer.class forRange:range];
    }];
    
    return converted;
}

@end
