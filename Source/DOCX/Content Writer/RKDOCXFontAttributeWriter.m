//
//  RKDOCXFontAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFontAttributeWriter.h"

NSString *RKDOCXFontAttributeAsciiFontName						= @"w:ascii";
NSString *RKDOCXFontAttributeBoldPropertyName					= @"w:b";
NSString *RKDOCXFontAttributeComplexScriptFontName				= @"w:cs";
NSString *RKDOCXFontAttributeComplexScriptFontSizePropertyName	= @"w:szCs";
NSString *RKDOCXFontAttributeEastAsiaFontName					= @"w:eastAsia";
NSString *RKDOCXFontAttributeFontPropertyName					= @"w:rFonts";
NSString *RKDOCXFontAttributeFontSizePropertyName				= @"w:sz";
NSString *RKDOCXFontAttributeHighAnsiFontName					= @"w:hAnsi";
NSString *RKDOCXFontAttributeItalicPropertyName					= @"w:i";


@implementation RKDOCXFontAttributeWriter

+ (NSArray *)runPropertiesForAttributes:(NSDictionary *)attributes
{
	NSFont *fontAttribute = attributes[RKFontAttributeName];
	if (!fontAttribute)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	NSFontTraitMask traits = [NSFontManager.sharedFontManager traitsOfFont: fontAttribute];
	
	if (traits & NSItalicFontMask)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeItalicPropertyName]];
	
	if (traits & NSBoldFontMask)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeBoldPropertyName]];
	
	NSXMLElement *fontElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontPropertyName
													 children:nil
												   attributes:@[
																[NSXMLElement attributeWithName:RKDOCXFontAttributeAsciiFontName stringValue:fontAttribute.familyName],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeComplexScriptFontName stringValue:[fontAttribute familyName]],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeEastAsiaFontName stringValue:fontAttribute.familyName],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeHighAnsiFontName stringValue:fontAttribute.familyName]
																]];
	
	NSUInteger wordFontSize = [self wordFontSizeFromPointSize: fontAttribute.pointSize];
	NSString *fontSize = [@(wordFontSize) stringValue];
	
	NSXMLElement *sizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue: fontSize]]];
	NSXMLElement *complexSizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeComplexScriptFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue: fontSize]]];
	
	[properties addObjectsFromArray: @[fontElement, sizeElement, complexSizeElement]];
	
	return properties;
}

+ (NSUInteger)wordFontSizeFromPointSize:(CGFloat)pointSize
{
	// Font sizes are saved in half points, so the point size has to be doubled
	CGFloat wordFontSize = pointSize * 2;
	
	// For now we round the font size
	return (NSUInteger)round(wordFontSize);
}

@end
