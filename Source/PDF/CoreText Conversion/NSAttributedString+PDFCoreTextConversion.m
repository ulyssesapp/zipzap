//
//  NSAttributedString+PDFCoreTextConversion.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+PDFCoreTextConversion.h"

#import "RKAttributedStringWriter.h"
#import "RKCoreTextRepresentationConverter.h"

@implementation NSAttributedString (PDFCoreTextConversion)

NSMutableArray *NSAttributedStringCoreTextConverters;

+ (void)registerConverter:(Class)converter
{
    NSParameterAssert([converter isSubclassOfClass: RKCoreTextRepresentationConverter.class]);
    
    if (!NSAttributedStringCoreTextConverters)
        NSAttributedStringCoreTextConverters = [NSMutableArray new];
    
    [NSAttributedStringCoreTextConverters addObject: converter];
}

- (NSAttributedString *)coreTextRepresentationUsingContext:(RKPDFRenderingContext *)context
{
    // Preprocess styles as it is done for RTF output
    NSAttributedString *convertedString = [RKAttributedStringWriter attributedStringByAdjustingStyles: self];
    
    // Convert styles to CoreText representation
    for (Class converter in NSAttributedStringCoreTextConverters) {
        convertedString = [converter coreTextRepresentationForAttributedString:convertedString usingContext:context];
    }
    
    return convertedString;
}

@end
