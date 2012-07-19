//
//  RKDocument+PDFUtilitites.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"

@class RKPDFRenderingContext;

/*!
 @abstract Utility methods for PDF generation
 */
@interface RKDocument (PDFUtilities)

/*!
 @abstract Provides the media box for the PDF document according to the size constraints of the RKDocument.
 */
- (CGRect)pdfMediaBox;

/*!
 @abstract Creates a dictionary with all PDF meta data extracted from the document
 */
- (NSDictionary *)pdfMetadata;

/*!
 @abstract Provides the bounding box that can be used for content according to the page insets of a document
 */
- (CGRect)boundingBoxForContent;

/*!
 @abstract Provides a bounding box for a column with a certain height
 */
- (CGRect)boundingBoxForColumn:(NSUInteger)column section:(RKSection *)section withHeader:(CGRect)header footer:(CGRect)footer;

/*!
 @abstract Provides a bounding box for footnotes based on the bounding box of a certain column limited by a given height
 */
- (CGRect)boundingBoxForFootnotesFromColumnRect:(CGRect)columnRect height:(CGFloat)height;

/*!
 @abstract Provides a bounding box for the header of a section page
 */
- (CGRect)boundingBoxForPageHeaderOfSection:(RKSection *)section;

/*!
 @abstract Provides a preliminiary bounding box for the footer of a section page
 */
- (CGRect)boundingBoxForPageFooterOfSection:(RKSection *)section;

/*!
 @abstract Generates a footnote marker for the given index according to the style setting
 */
+ (NSString *)footnoteMarkerForIndex:(NSUInteger)index usingEnumerationStyle:(RKFootnoteEnumerationStyle)enumerationStyle;

/*!
 @abstract Draws a footnote separator to a given context using the given bounding box around the footnotes
 */
- (void)drawFootnoteSeparatorForBoundingBox:(CGRect)boundingBox toContext:(RKPDFRenderingContext *)context;

/*!
 @abstract Converts the number of a section to a string according to the sectionNumberingStyle of the document
 */
- (NSString *)stringForSectionNumber:(NSUInteger)sectionNumber;

@end
