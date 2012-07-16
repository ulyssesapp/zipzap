//
//  RKDocument+PDFUtilities.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument+PDFUtilities.h"

#import "NSString+RKNumberFormatting.h"

#define RKHeaderSpacing         5.0
#define RKFooterSpacing         5.0
#define RKColumnSpacing         5.0

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

- (CGRect)boundingBoxForContent
{
    CGRect boundingBox = self.pdfMediaBox;
    boundingBox.origin.x += self.pageInsets.left;
    boundingBox.origin.y += self.pageInsets.bottom;
    boundingBox.size.height -= self.pageInsets.top + self.pageInsets.bottom;
    boundingBox.size.width -= self.pageInsets.right + self.pageInsets.left;
    
    return boundingBox;
}

- (CGRect)boundingBoxForColumn:(NSUInteger)column section:(RKSection *)section withHeader:(CGSize)header footer:(CGSize)footer
{
    CGRect pageBounds = self.boundingBoxForContent;
/*
    pageBounds.origin.y += footer.height + RKFooterSpacing;
    pageBounds.size.height -= header.height + RKHeaderSpacing;
    
    NSUInteger columnWidth = (pageBounds.size.width - (RKColumnSpacing * section.numberOfColumns) / section.numberOfColumns);
    
    pageBounds.size.width = columnWidth;
    pageBounds.origin.x = (columnWidth + RKColumnSpacing) * column;
 */   
    return pageBounds;
}

- (CGRect)boundingBoxForPageFooterOfSection:(RKSection *)section
{
    CGRect boundingBox = self.boundingBoxForContent;
    
    // The footer section may occupy at most the half of the page
    boundingBox.size.height = boundingBox.size.height / 2;
    
    return boundingBox;
}

- (CGRect)boundingBoxForPageHeaderOfSection:(RKSection *)section
{
    CGRect boundingBox = self.boundingBoxForContent;
    
    // The header section may occupy at most the half of the page
    boundingBox.origin.y = boundingBox.size.height - boundingBox.size.height / 2;
    boundingBox.size.height = boundingBox.size.height / 2;
    
    return boundingBox;
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
