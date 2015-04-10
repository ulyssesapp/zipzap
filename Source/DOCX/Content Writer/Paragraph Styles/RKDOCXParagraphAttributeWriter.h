//
//  RKDOCXParagraphAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"

#import "RKDOCXConversionContext.h"


/*!
 @abstract Generates a paragraph properties element "<w:pPr>" to be added to the parent document.
 @discussion See ISO 29500-1:2012: §17.3.1.26 (Paragraph Properties).
 */
@interface RKDOCXParagraphAttributeWriter : RKDOCXAttributedStringWriter

/*!
@abstract Returns an XML element representing the paragraph properties of a given attributed string.
*/
+ (NSXMLElement *)paragraphPropertiesElementWithPropertiesFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context;

@end

/*!
 @abstract Subclasses generate paragraph properties and return the respective XML elements.
 */
@interface RKDOCXParagraphAttributeWriter (Subclassing)

/*!
 @abstract Returns an array of XML elements containing the properties of a paragraph.
 */
+ (NSArray *)paragraphPropertiesForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

@end
