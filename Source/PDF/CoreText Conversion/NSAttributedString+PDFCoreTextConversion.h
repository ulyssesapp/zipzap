//
//  NSAttributedString+PDFCoreTextConversion.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext, RKTextObject;


/*!
 @abstract A special attribute that indicates a text object
 @discussion Reference to a RKPDFTextObject
 */
extern NSString *RKTextObjectAttributeName;

/*!
 @abstract A special attribute that indicates the reqirement of a custom text renderer
 @discussion Reference to an Array of RKPDFTextRenderer classes
 */
extern NSString *RKTextRendererAttributeName;


/*!
 @abstract Methods used to convert an attributed string into its CoreText representation as it used by the PDF converter
 */
@interface NSAttributedString (PDFCoreTextConversion)

/*!
 @abstract Registers a PDF text converter
 */
+ (void)registerConverter:(Class)converter;

/*!
 @abstract Generates a representation required for PDF conversion using a PDF rendering context
 */
- (NSAttributedString *)pdfRepresentationUsingContext:(RKPDFRenderingContext *)context;

@end

@interface NSMutableAttributedString (PDFCoreTextConversion)

/*!
 @abstract Sets the given character as text object using custom rendering
 */
- (void)addTextObjectAttribute:(RKTextObject *)textObject atIndex:(NSUInteger)index;

/*!
 @abstract Adds a custom text render to an attributed string range respecting the priority of the renderer class
 @discussion The renderer must be a class derived from RKPDFTextRenderer
 */
- (void)addTextRenderer:(Class)textRender forRange:(NSRange)range;

/*!
 @abstract Adds a local destination attribute to an attributed string and setups the required text renderer
 */
- (void)addLocalDestinationAnchor:(NSString *)anchorName forRange:(NSRange)range;

/*!
 @abstract Adds a local destination link to an attributed string and setups the required text renderer
 */
- (void)addLocalDestinationLinkForAnchor:(NSString *)anchorName forRange:(NSRange)range;

@end
