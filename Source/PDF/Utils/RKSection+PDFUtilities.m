//
//  RKSection+PDFUtilities.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection+PDFUtilities.h"
#import "RKPDFRenderingContext.h"

#import "NSString+RKNumberFormatting.h"

@implementation RKSection (PDFUtilities)

- (NSString *)stringForPageNumber:(NSUInteger)pageNumber
{
    switch (self.pageNumberingStyle) {
        case RKPageNumberingAlphabeticLowerCase:
            return [NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger: pageNumber];
            
        case RKPageNumberingAlphabeticUpperCase:
            return [NSString upperCaseAlphabeticNumeralsFromUnsignedInteger: pageNumber];

        case RKPageNumberingRomanLowerCase:
            return [NSString lowerCaseRomanNumeralsFromUnsignedInteger: pageNumber];

        case RKPageNumberingRomanUpperCase:
            return [NSString upperCaseRomanNumeralsFromUnsignedInteger: pageNumber];
            
        case RKPageNumberingDecimal:
            return [NSString stringWithFormat: @"%lu", pageNumber];
    }
    
    NSAssert(false, @"Invalid page numbering style");
    return nil;
}

- (RKPageSelectionMask)pageSelectorForContext:(RKPDFRenderingContext *)renderingContext
{
    if (renderingContext.pageNumberOfCurrentSection == 0)
        return RKPageSelectionFirst;

    if (renderingContext.currentPageNumber % 2)
        return RKPageSelectionRight;
    else
        return RKPageSelectionLeft;
}

@end
