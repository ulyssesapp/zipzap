//
//  RKDOCXFontAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFontAttributeWriter.h"

NSString *RKDOCXFontAttributeAsciiFontName						= @"w:ascii";
NSString *RKDOCXFontAttributeComplexScriptFontName				= @"w:cs";
NSString *RKDOCXFontAttributeComplexScriptFontSizePropertyName	= @"w:szCs";
NSString *RKDOCXFontAttributeEastAsiaFontName					= @"w:eastAsia";
NSString *RKDOCXFontAttributeFontPropertyName					= @"w:rFonts";
NSString *RKDOCXFontAttributeHighAnsiFontName					= @"w:hAnsi";
NSString *RKDOCXFontAttributeFontSizePropertyName				= @"w:sz";


@implementation RKDOCXFontAttributeWriter

+ (NSArray *)runPropertiesForAttributes:(NSDictionary *)attributes
{
	if (!attributes[RKFontAttributeName])
		return nil;
	
	NSXMLElement *fontElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontPropertyName
													 children:nil
												   attributes:@[
																[NSXMLElement attributeWithName:RKDOCXFontAttributeAsciiFontName stringValue:[attributes[RKFontAttributeName] familyName]],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeComplexScriptFontName stringValue:[attributes[RKFontAttributeName] familyName]],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeEastAsiaFontName stringValue:[attributes[RKFontAttributeName] familyName]],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeHighAnsiFontName stringValue:[attributes[RKFontAttributeName] familyName]]
																]];
	
	NSUInteger wordFontSize = [self wordFontSizeFromPointSize: [attributes[RKFontAttributeName] pointSize]];
	NSString *fontSize = [@(wordFontSize) stringValue];
	
	NSXMLElement *sizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue: fontSize]]];
	NSXMLElement *complexSizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeComplexScriptFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue: fontSize]]];
	
	return @[fontElement, sizeElement, complexSizeElement];
}

+ (NSUInteger)wordFontSizeFromPointSize:(CGFloat)pointSize
{
	// Font sizes are saved in half points, so the point size has to be doubled
	CGFloat wordFontSize = pointSize * 2;
	
	// For now we round the font size
	return (NSUInteger)round(wordFontSize);
}

@end
