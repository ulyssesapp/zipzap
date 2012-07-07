//
//  NSAttributedString+PDFCoreTextConversion.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext, RKTextObject;

/*!
 @abstract Methods used to convert an attributed string into its CoreText representation as it used by the PDF converter
 */
@interface NSAttributedString (PDFCoreTextConversion)

/*!
 @abstract Registers a PDF text converter
 */
+ (void)registerConverter:(Class)converter;

/*!
 @abstract Generates a representation required for PDF conversion using a PDF rendering context.
 @discussion Calls the appropriate RKPDFRepresentationConverter classes.
 */
- (NSAttributedString *)coreTextRepresentationUsingContext:(RKPDFRenderingContext *)context;

@end
