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
 @abstract Builds header and footer files as requested by the section writer. Not to be called by the main DOCX writer.
 */
@interface RKDOCXHeaderFooterWriter : RKDOCXPartWriter

/*!
 @abstract Builds a header or footer file for the given attributed string and adds it to the conversion context.
 @discussion The file number is used for filename generation.
 */
+ (void)buildHeaderOrFooterWithFileNumber:(NSNumber *)fileNumber forAttributedString:(NSAttributedString *)contentString usingContext:(RKDOCXConversionContext *)context isHeaderFile:(BOOL)isHeader;

/*!
 @abstract Returns the filename of the header or footer in the format "header1.xml" / "footer1.xml".
 */
+ (NSString *)filenameForNumber:(NSNumber *)fileNumber isHeaderFile:(BOOL)isHeader;

@end
