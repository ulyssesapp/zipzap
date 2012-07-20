//
//  RKDocument+PDFUtilities.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument+PDFUtilities.h"

#import "RKPDFRenderingContext.h"

#import "NSString+RKNumberFormatting.h"

#define RKFootnoteSpacing       5.0
#define RKHeaderSpacing         10.0
#define RKFooterSpacing         10.0
#define RKColumnSpacing         10.0

@implementation RKDocument (PDFUtilities)



#pragma mark - Layouting

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

- (CGRect)boundingBoxForColumn:(NSUInteger)column section:(RKSection *)section withHeader:(CGRect)header footer:(CGRect)footer
{
    CGRect pageBounds = self.boundingBoxForContent;

    // Shrink page for footer, if needed
    if ((footer.origin.y + footer.size.height) > (pageBounds.origin.y - RKFooterSpacing)) {
        pageBounds.origin.y = footer.origin.y + footer.size.height + RKFooterSpacing;
        pageBounds.size.height -= (footer.origin.y + footer.size.height - pageBounds.origin.y + RKFooterSpacing);
    }
    
    // Shrink page for header, if needed
    if (((pageBounds.origin.y + pageBounds.size.height) > (header.origin.y - RKHeaderSpacing)) && (header.size.height)) {
        pageBounds.size.height -= (pageBounds.origin.y + pageBounds.size.height) - (header.origin.y - RKHeaderSpacing);
    }

    // Determine column size and position
    NSUInteger columnWidth = (pageBounds.size.width - (section.columnSpacing * (section.numberOfColumns - 1))) / section.numberOfColumns;
    
    pageBounds.size.width = columnWidth;
    pageBounds.origin.x = pageBounds.origin.x + (columnWidth + section.columnSpacing) * column;

    return pageBounds;
}

- (CGRect)boundingBoxForPageFooterOfSection:(RKSection *)section
{
    CGRect boundingBox = self.boundingBoxForContent;
    
    // The footer section may occupy at most the half of the page
    boundingBox.origin.y = self.footerSpacing;
    boundingBox.size.height = boundingBox.size.height / 2;
    
    return boundingBox;
}

- (CGRect)boundingBoxForPageHeaderOfSection:(RKSection *)section
{
    CGRect boundingBox = self.boundingBoxForContent;
    
    // The header section may occupy at most the half of the page
    boundingBox.origin.y = self.pdfMediaBox.size.height - self.headerSpacing - (boundingBox.size.height / 2.0f);
    boundingBox.size.height = boundingBox.size.height / 2.0f;
    
    return boundingBox;
}


#pragma mark - Footnote handling

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

- (CGRect)boundingBoxForFootnotesFromColumnRect:(CGRect)columnRect height:(CGFloat)height
{
    CGRect footnoteRect = columnRect;
    footnoteRect.size.height = height - RKFootnoteSpacing;
    
    return footnoteRect;
}

- (void)drawFootnoteSeparatorForBoundingBox:(CGRect)boundingBox toContext:(RKPDFRenderingContext *)context
{
    CGContextRef pdfContext = context.pdfContext;
    CGColorRef black = CGColorCreateGenericGray(0, 1);
    
    CGContextSaveGState(pdfContext);
    
    CGContextSetStrokeColorWithColor(pdfContext, black);
    CGContextSetLineWidth(pdfContext, 1.0f);
    
    CGFloat separatorWidth = (boundingBox.size.width > 100) ? 100 : (boundingBox.size.width / 5);
    
    CGPoint startPoint = CGPointMake(boundingBox.origin.x, boundingBox.origin.y + boundingBox.size.height + 2);
    CGPoint endPoint = CGPointMake(startPoint.x + separatorWidth, startPoint.y);
    
    CGContextStrokeLineSegments(pdfContext, (CGPoint[]){startPoint, endPoint}, 2);
    CGContextRestoreGState(pdfContext);
    
    CFRelease(black);
}

- (NSString *)stringForSectionNumber:(NSUInteger)sectionNumber
{
    switch (self.sectionNumberingStyle) {
        case RKPageNumberingAlphabeticLowerCase:
            return [NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger: sectionNumber];
            
        case RKPageNumberingAlphabeticUpperCase:
            return [NSString upperCaseAlphabeticNumeralsFromUnsignedInteger: sectionNumber];
            
        case RKPageNumberingRomanLowerCase:
            return [NSString lowerCaseRomanNumeralsFromUnsignedInteger: sectionNumber];
            
        case RKPageNumberingRomanUpperCase:
            return [NSString upperCaseRomanNumeralsFromUnsignedInteger: sectionNumber];
            
        case RKPageNumberingDecimal:
            return [NSString stringWithFormat: @"%lu", sectionNumber];
    }
    
    NSAssert(false, @"Invalid section numbering style");
    return nil;
}

@end
