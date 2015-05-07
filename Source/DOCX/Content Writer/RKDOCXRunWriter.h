//
//  RKDOCXRunAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Generates a run element "<w:r>" to be added to the parent paragraph.
 @discussion See ISO 29500-1:2012: §17.3.2 (Run) and §17.3.3 (Run Content).
 */
@interface RKDOCXRunWriter : NSObject

/*!
 @abstract Returns an array of XML elements representing one or more runs with the given attributes and the corresponding text.
 @discussion The text is built using the attributed string and the range.
 */
+ (NSArray *)runElementsForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element representing a run with the given properties and content elements.
 */
+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes contentElement:(NSXMLElement *)contentElement usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an array of XML elements containing the run style properties of the given attributes.
 */
+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element representing a text element with the given string value.
 @discussion The text element is created with an 'xml:space="preserve"' attribute.
 */
+ (NSXMLElement *)textElementWithStringValue:(NSString *)stringValue;

@end
