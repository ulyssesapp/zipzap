//
//  RKDocument+PDFUtilitites.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"

/*!
 @abstract Utility methods for PDF generation
 */
@interface RKDocument (PDFUtilitites)

/*!
 @abstract Provides the media box for the PDF document according to the size constraints of the RKDocument.
 */
- (CGRect)pdfMediaBox;

/*!
 @abstract Creates a dictionary with all PDF meta data extracted from the document
 */
- (NSDictionary *)pdfMetadata;

/*!
 @abstract Provides a bounding box for a column with a certain height
 */
- (CGRect)boundingBoxForColumn:(NSUInteger)column section:(RKSection *)section withHeight:(CGFloat)height;

/*!
 @abstract Provides a bounding box for the header of a section page
 */
- (CGRect)boundingBoxForPageHeaderOfSection:(RKSection *)section withHeight:(CGFloat)height;

/*!
 @abstract Provides a preliminiary bounding box for the footer of a section page
 */
- (CGRect)boundingBoxForPageFooterOfSection:(RKSection *)section withHeight:(CGFloat)height;

@end
