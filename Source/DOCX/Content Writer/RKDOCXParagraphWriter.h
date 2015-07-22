//
//  RKDOCXParagraphWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Generates a paragraph properties element "<w:pPr>" to be added to the parent document.
 @discussion See ISO 29500-1:2012: §17.3.1.26 (Paragraph Properties).
 */
@interface RKDOCXParagraphWriter : NSObject

/*!
 @abstract Returns an XML element representing a paragraph including properties and runs.
 @discussion See ISO 29500-1:2012: §17.3.1 (Paragraphs).
 */
+ (NSXMLElement *)paragraphElementFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element with the given property and run elements (if any).
 */
+ (NSXMLElement *)paragraphElementWithProperties:(NSArray *)properties runElements:(NSArray *)runElements;

/*!
 @abstract Returns an XML element representing a paragraph property element with the given property elements.
 */
+ (NSXMLElement *)paragraphPropertiesElementWithProperties:(NSArray *)properties;

/*!
 @abstract Returns an array of XML elements containing the paragraph style properties of the given attributes.
 @discussion If specified, the property elements will be generated to create the default style. I.E. template style settings will be ignored. Otherwise, only differences to default and paragraph template styles will be returned.
 */
+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle;

/*!
 @abstract Returns an XML element representing a paragraph including a run with a page break.
 */
+ (NSXMLElement *)paragraphElementWithPageBreak;

/*!
 @abstract Returns an XML element representing the paragraph properties of a numbering defintion.
 */
+ (NSXMLElement *)paragraphPropertiesElementForMarkerLocation:(NSUInteger)markerLocation markerWidth:(NSUInteger)markerWidth;

/*!
 @abstract Returns an XML element representing a paragraph containing a separator element and its properties.
 */
+ (NSXMLElement *)paragraphElementForSeparatorElement:(NSXMLElement *)separatorElement usingContext:(RKDOCXConversionContext *)context;

@end
