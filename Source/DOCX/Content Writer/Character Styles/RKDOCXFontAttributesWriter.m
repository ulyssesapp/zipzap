//
//  RKDOCXFontAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFontAttributesWriter.h"

NSString *RKDOCXFontAttributeAsciiFontName						= @"w:ascii";
NSString *RKDOCXFontAttributeBoldPropertyName					= @"w:b";
NSString *RKDOCXFontAttributeComplexScriptFontName				= @"w:cs";
NSString *RKDOCXFontAttributeComplexScriptFontSizePropertyName	= @"w:szCs";
NSString *RKDOCXFontAttributeEastAsiaFontName					= @"w:eastAsia";
NSString *RKDOCXFontAttributeFontPropertyName					= @"w:rFonts";
NSString *RKDOCXFontAttributeFontSizePropertyName				= @"w:sz";
NSString *RKDOCXFontAttributeHighAnsiFontName					= @"w:hAnsi";
NSString *RKDOCXFontAttributeItalicPropertyName					= @"w:i";

@implementation RKDOCXFontAttributesWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	CTFontRef fontAttribute = (__bridge CTFontRef)attributes[RKFontAttributeName];
	if (!fontAttribute)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	NSUInteger traits = CTFontGetSymbolicTraits(fontAttribute);
	
	if (traits & kCTFontItalicTrait)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeItalicPropertyName]];
	
	if (traits & kCTFontBoldTrait)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeBoldPropertyName]];
	
	NSXMLElement *fontElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontPropertyName
													 children:nil
												   attributes:@[
																[NSXMLElement attributeWithName:RKDOCXFontAttributeAsciiFontName stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeComplexScriptFontName stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeEastAsiaFontName stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeHighAnsiFontName stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)]
																]];
	
	NSUInteger wordFontSize = [self wordFontSizeFromPointSize: CTFontGetSize(fontAttribute)];
	NSString *fontSize = [@(wordFontSize) stringValue];
	
	NSXMLElement *sizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue: fontSize]]];
	NSXMLElement *complexSizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeComplexScriptFontSizePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue: fontSize]]];
	
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
