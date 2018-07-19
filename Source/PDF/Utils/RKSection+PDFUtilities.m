//
//  RKSection+PDFUtilities.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection+PDFUtilities.h"
#import "RKPDFRenderingContext.h"
#import "RKDocument+PDFUtilities.h"

#import "NSString+RKNumberFormatting.h"

@implementation RKSection (PDFUtilities)

- (NSString *)stringForPageNumber:(NSUInteger)pageNumber
{
    switch (self.pageNumberingStyle) {
        case RKPageNumberingAlphabeticLowerCase:
            return [NSString rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger: pageNumber];
            
        case RKPageNumberingAlphabeticUpperCase:
            return [NSString rk_upperCaseAlphabeticNumeralsFromUnsignedInteger: pageNumber];

        case RKPageNumberingRomanLowerCase:
            return [NSString rk_lowerCaseRomanNumeralsFromUnsignedInteger: pageNumber];

        case RKPageNumberingRomanUpperCase:
            return [NSString rk_upperCaseRomanNumeralsFromUnsignedInteger: pageNumber];
            
        case RKPageNumberingDecimal:
            return [NSString stringWithFormat: @"%lu", pageNumber];
    }
    
    NSAssert(false, @"Invalid page numbering style");
    return nil;
}

- (RKPageSelectionMask)pageSelectorForContext:(RKPDFRenderingContext *)renderingContext
{
	RKPageSelectionMask mask = 0;
	
    if (renderingContext.pageNumberOfCurrentSection == 1)
        mask |= RKPageSelectionFirst;

    if ([renderingContext.document isLeftPageForPageNumber: renderingContext.currentPageNumber])
        return mask | RKPageSelectionLeft;
    else
        return mask | RKPageSelectionRight;
}

@end
