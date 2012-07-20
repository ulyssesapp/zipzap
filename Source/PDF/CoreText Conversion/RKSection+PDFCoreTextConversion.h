//
//  RKSection+PDFCoreTextConversion.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"

@class RKPDFRenderingContext, RKTextObject;

/*!
 @abstract Methods used to convert an attributed string into its CoreText representation as it used by the PDF converter
 */
@interface RKSection (PDFCoreTextConversion)

/*!
 @abstract Generates a representation of the section required for PDF conversion using a PDF rendering context.
 @discussion All text objects are registered to the given context according to the enumeration policy of the section.
 */
- (RKSection *)coreTextRepresentationUsingContext:(RKPDFRenderingContext *)context;

@end