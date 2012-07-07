//
//  RKDocument+PDFUtilities.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument+PDFUtilities.h"

#import "NSString+RKNumberFormatting.h"

@implementation RKDocument (PDFUtilities)

- (CGRect)pdfMediaBox
{
    if (self.pageOrientation == RKPageOrientationLandscape)
        return NSMakeRect(0 , 0, self.pageSize.height, self.pageSize.width);
    else
        return NSMakeRect(0 , 0, self.pageSize.width, self.pageSize.height);
}

- (NSDictionary *)pdfMetadata
{
    NSDictionary *originalMetaData = self.metadata;
    NSMutableDictionary *metaData = [NSMutableDictionary new];

    if (originalMetaData[NSAuthorDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextAuthor] = originalMetaData[NSAuthorDocumentAttribute];

    if (originalMetaData[NSTitleDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextTitle] = originalMetaData[NSTitleDocumentAttribute];
    
    if (originalMetaData[NSSubjectDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextSubject] = originalMetaData[NSSubjectDocumentAttribute];

    if (originalMetaData[NSKeywordsDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextKeywords] = originalMetaData[NSKeywordsDocumentAttribute];
    
    return metaData;
}

- (CGRect)boundingBoxForColumn:(NSUInteger)column section:(RKSection *)section withHeight:(CGFloat)height
{
    NSAssert(false, @"Not implemented yet");
    return CGRectMake(0, 0, 0, 0);
}

- (CGRect)boundingBoxForPageFooterOfSection:(RKSection *)section withHeight:(CGFloat)height
{
    NSAssert(false, @"Not implemented yet");
    return CGRectMake(0, 0, 0, 0);
}

- (CGRect)boundingBoxForPageHeaderOfSection:(RKSection *)section withHeight:(CGFloat)height
{
    NSAssert(false, @"Not implemented yet");
    return CGRectMake(0, 0, 0, 0);
}

+ (NSString *)footnoteMarkerForIndex:(NSUInteger)index usingEnumerationStyle:(RKFootnoteEnumerationStyle)enumerationStyle
{
    switch (enumerationStyle) {
        case RKFootnoteEnumerationAlphabeticLowerCase:
            return [NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationAlphabeticUpperCase:
            return [NSString upperCaseAlphabeticNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationRomanLowerCase:
            return [NSString lowerCaseRomanNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationRomanUpperCase:
            return [NSString upperCaseRomanNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationDecimal:
            return [NSString stringWithFormat:@"%lu", index];
            
        case RKFootnoteEnumerationChicagoManual:
            return [NSString chicagoManualOfStyleNumeralsFromUnsignedInteger: index];
    }
    
}

@end
