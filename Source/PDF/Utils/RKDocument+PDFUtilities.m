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


@implementation RKDocument (PDFUtilities)


#pragma mark - Layouting

- (CGRect)pdfMediaBox
{
	// Use given page size for media box. Width and Height are already adjusted when another page orientation is used.
    return CGRectMake(0, 0, self.pageSize.width, self.pageSize.height);
}

- (NSDictionary *)pdfMetadata
{
    NSDictionary *originalMetaData = self.metadata;
    NSMutableDictionary *metaData = [NSMutableDictionary new];

    if (originalMetaData[RKAuthorDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextAuthor] = originalMetaData[RKAuthorDocumentAttribute];

    if (originalMetaData[RKTitleDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextTitle] = originalMetaData[RKTitleDocumentAttribute];
    
    if (originalMetaData[RKSubjectDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextSubject] = originalMetaData[RKSubjectDocumentAttribute];

    if (originalMetaData[RKKeywordsDocumentAttribute])
        metaData[(__bridge id)kCGPDFContextKeywords] = originalMetaData[RKKeywordsDocumentAttribute];
    
    return metaData;
}

- (CGRect)contentBoundingBoxForPageNumber:(NSUInteger)pageNumber
{
	CGFloat leftMargin = 0;
	CGFloat rightMargin = 0;
	CGFloat gutter = (self.pageBinding == RKPageBindingNone) ? 0 : self.pageGutterWidth;
	
	if ([self isLeftPageForPageNumber: pageNumber]) {
		leftMargin = self.pageInsets.right;
		rightMargin = self.pageInsets.left + gutter;
	}
	else {
		leftMargin = self.pageInsets.left + gutter;
		rightMargin = self.pageInsets.right;
	}
	
	CGRect boundingBox = self.pdfMediaBox;
    boundingBox.origin.x += leftMargin;
    boundingBox.origin.y += self.pageInsets.bottom;
    boundingBox.size.height -= self.pageInsets.top + self.pageInsets.bottom;
    boundingBox.size.width -= leftMargin + rightMargin;
	
    return boundingBox;
}

- (CGRect)boundingBoxForColumn:(NSUInteger)column pageNumber:(NSUInteger)pageNumber section:(RKSection *)section withHeader:(CGRect)header footer:(CGRect)footer
{
    CGRect pageBounds = [self contentBoundingBoxForPageNumber: pageNumber];

    // Shrink page for footer, if needed
    if ((footer.origin.y + footer.size.height) > (pageBounds.origin.y - self.footerSpacingBefore)) {
        pageBounds.origin.y = footer.origin.y + footer.size.height + self.footerSpacingBefore;
        pageBounds.size.height -= (footer.origin.y + footer.size.height - pageBounds.origin.y + self.footerSpacingAfter);
    }
    
    // Shrink page for header, if needed
    if (((pageBounds.origin.y + pageBounds.size.height) > (header.origin.y - self.headerSpacingAfter)) && (header.size.height)) {
        pageBounds.size.height -= (pageBounds.origin.y + pageBounds.size.height) - (header.origin.y - self.headerSpacingAfter);
    }

    // Determine column size and position
    NSUInteger columnWidth = (pageBounds.size.width - (section.columnSpacing * (section.numberOfColumns - 1))) / section.numberOfColumns;
    
    pageBounds.size.width = columnWidth;
    pageBounds.origin.x = pageBounds.origin.x + (columnWidth + section.columnSpacing) * column;

    return pageBounds;
}

- (CGRect)boundingBoxForPageFooterOfSection:(RKSection *)section pageNumber:(NSUInteger)pageNumber
{
    CGRect boundingBox = [self contentBoundingBoxForPageNumber: pageNumber];
    
    // The footer section may occupy at most the half of the page
    boundingBox.origin.y = self.footerSpacingAfter;
    boundingBox.size.height = boundingBox.size.height / 2;
    
    return boundingBox;
}

- (CGRect)boundingBoxForPageHeaderOfSection:(RKSection *)section pageNumber:(NSUInteger)pageNumber
{
    CGRect boundingBox = [self contentBoundingBoxForPageNumber: pageNumber];
    
    // The header section may occupy at most the half of the page
    boundingBox.origin.y = self.pdfMediaBox.size.height - self.headerSpacingBefore - (boundingBox.size.height / 2.0f);
    boundingBox.size.height = boundingBox.size.height / 2.0f;
    
    return boundingBox;
}


#pragma mark - Footnote handling

- (CGRect)boundingBoxForFootnotesFromColumnRect:(CGRect)columnRect height:(CGFloat)height
{
    CGRect footnoteRect = columnRect;
    footnoteRect.size.height = height - self.footnoteSpacingBefore;
    
    return footnoteRect;
}

- (void)drawFootnoteSeparatorForBoundingBox:(CGRect)boundingBox toContext:(RKPDFRenderingContext *)context
{
    CGContextRef pdfContext = context.pdfContext;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGColorRef black = CGColorCreate(colorSpace, (CGFloat[]){0, 1.0});

    CGContextSaveGState(pdfContext);
    
    CGContextSetStrokeColorWithColor(pdfContext, black);
    CGContextSetLineWidth(pdfContext, 1.0f);
    
    CGFloat separatorWidth = (boundingBox.size.width > 100) ? 100 : (boundingBox.size.width / 5);
    
    CGPoint startPoint = CGPointMake(boundingBox.origin.x, boundingBox.origin.y + boundingBox.size.height + 2);
    CGPoint endPoint = CGPointMake(startPoint.x + separatorWidth, startPoint.y);
    
    CGContextStrokeLineSegments(pdfContext, (CGPoint[]){startPoint, endPoint}, 2);
    CGContextRestoreGState(pdfContext);
    
    CFRelease(black);
    CFRelease(colorSpace);
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

- (BOOL)isLeftPageForPageNumber:(NSUInteger)pageNumber
{
	switch (self.pageBinding) {
		case RKPageBindingNone:
			return NO;
			
		case RKPageBindingLeft:
			return ((pageNumber % 2) == 0);
			
		case RKPageBindingRight:
			return ((pageNumber % 2) == 1);
	}
}

@end
