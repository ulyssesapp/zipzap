//
//  RKDOCXHeaderFooterWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 22.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

/*!
 @abstract Represents a page element type.
 
 @const RKDOCXHeader	Page element represents a header.
 @const RKDOCXFooter	Page element represents a footer.
 */
typedef enum : NSUInteger {
	RKDOCXHeader,
	RKDOCXFooter,
} RKDOCXPageElementType;

/*!
 @abstract Builds header and footer files as requested by the section writer. Not to be called by the main DOCX writer.
 */
@interface RKDOCXHeaderFooterWriter : RKDOCXPartWriter

/*!
 @abstract Builds a header or footer file for the given attributed string and adds it to the conversion context.
 @discussion The file number is used for filename generation.
 */
+ (void)buildPageElement:(RKDOCXPageElementType)pageElement withIndex:(NSUInteger)index forAttributedString:(NSAttributedString *)contentString usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns the filename of the header or footer in the format "header1.xml" / "footer1.xml".
 */
+ (NSString *)filenameForPageElement:(RKDOCXPageElementType)pageElement withIndex:(NSUInteger)index;

@end
