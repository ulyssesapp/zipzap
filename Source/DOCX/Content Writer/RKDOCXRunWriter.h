//
//  RKDOCXRunWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Specifies the type of the run that is to be translated.
 
 @const RKDOCXRunStandardType	The string is a usual run without any special elements.
 @const RKDOCXRunDeletedType	The string contains deleted text.
 @const RKDOCXRunInsertedType	The string contains inserted text.
 */
typedef enum : NSUInteger {
	RKDOCXRunStandardType,
	RKDOCXRunDeletedType,
	RKDOCXRunInsertedType,
} RKDOCXRunType;

/*!
 @abstract Generates a run element "<w:r>" to be added to the parent paragraph.
 @discussion See ISO 29500-1:2012: §17.3.2 (Run) and §17.3.3 (Run Content).
 */
@interface RKDOCXRunWriter : NSObject

/*!
 @abstract Returns an array of XML elements representing one or more runs with the given attributes and the corresponding text.
 @discussion The text is built using the attributed string and the range.
 */
+ (NSArray *)runElementsForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range runType:(RKDOCXRunType)runType usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element representing a run with the given properties and content elements.
 */
+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes contentElement:(NSXMLElement *)contentElement usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element representing a run property element with the given property elements.
 */
+ (NSXMLElement *)runPropertiesElementWithProperties:(NSArray *)properties;

/*!
 @abstract Returns an array of XML elements containing the run style properties of the given attributes.
 @discussion If specified, the property elements will be generated to create the default style. I.E. template style settings will be ignored. Otherwise, only differences to default and paragraph template styles will be returned.
 */
+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle;

/*!
 @abstract Returns an XML element representing a text element with the given string value.
 @discussion The text element is created with an 'xml:space="preserve"' attribute.
 */
+ (NSXMLElement *)textElementOfType:(RKDOCXRunType)runType withStringValue:(NSString *)stringValue;

@end
