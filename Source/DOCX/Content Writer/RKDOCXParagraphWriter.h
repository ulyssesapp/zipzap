//
//  RKDOCXParagraphWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Parent element of paragraph properties.
 */
extern NSString *RKDOCXParagraphPropertiesElementName;

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
 @abstract Returns an array of XML elements containing the paragraph style properties of the given attributes.
 @discussion If the passed attributes dictionary contains a reference to a paragraph style template (RKParagraphStyleNameAttributeName) this method will only create paragraph properties that are overriding the given template.
 */
+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element representing a paragraph including a run with a page break.
 */
+ (NSXMLElement *)paragraphElementWithPageBreak;

/*!
 @abstract Returns an XML element representing the paragraph properties of a numbering defintion.
 */
+ (NSXMLElement *)paragraphPropertiesElementForMarkerLocationKey:(NSUInteger)markerLocationKey markerWidthKey:(NSUInteger)markerWidthKey;

@end
