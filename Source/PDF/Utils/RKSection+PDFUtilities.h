//
//  RKSection+PDFUtilities.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"

@class RKPDFRenderingContext;

@interface RKSection (PDFUtilities)

/*!
 @abstract Provides a page number string for a page number based on the numbering style of the section
 */
- (NSString *)stringForPageNumber:(NSUInteger)pageNumber;

/*!
 @abstract Provides a page selector according to the page number from a rendering context
 */
- (RKPageSelectionMask)pageSelectorForContext:(RKPDFRenderingContext *)renderingContext;

@end
