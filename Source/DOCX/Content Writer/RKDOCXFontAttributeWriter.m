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
	NSXMLElement *sizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:[NSString stringWithFormat: @"%0.0f", [attributes[RKFontAttributeName] pointSize] * 2]]]];
	NSXMLElement *complexSizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeComplexScriptFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:[NSString stringWithFormat: @"%0.0f", [attributes[RKFontAttributeName] pointSize] * 2]]]];
	
	return @[fontElement, sizeElement, complexSizeElement];
}

@end
