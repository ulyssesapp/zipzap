//
//  RKDOCXFontAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFontAttributesWriter.h"

NSString *RKDOCXFontAttributeAsciiFontAttributeValue			= @"w:ascii";
NSString *RKDOCXFontAttributeBoldElementName					= @"w:b";
NSString *RKDOCXFontAttributeComplexScriptFontAttributeValue	= @"w:cs";
NSString *RKDOCXFontAttributeComplexScriptFontSizeElementName	= @"w:szCs";
NSString *RKDOCXFontAttributeEastAsiaFontAttributeValue			= @"w:eastAsia";
NSString *RKDOCXFontAttributeFontElementName					= @"w:rFonts";
NSString *RKDOCXFontAttributeFontSizeElementName				= @"w:sz";
NSString *RKDOCXFontAttributeHighAnsiFontAttributeValue			= @"w:hAnsi";
NSString *RKDOCXFontAttributeItalicElementName					= @"w:i";

@implementation RKDOCXFontAttributesWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	CTFontRef fontAttribute = (__bridge CTFontRef)attributes[RKFontAttributeName];
	if (!fontAttribute)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	NSUInteger traits = CTFontGetSymbolicTraits(fontAttribute);
	
	if (traits & kCTFontItalicTrait)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeItalicElementName]];
	
	if (traits & kCTFontBoldTrait)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeBoldElementName]];
	
	NSXMLElement *fontElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontElementName
													 children:nil
												   attributes:@[
																[NSXMLElement attributeWithName:RKDOCXFontAttributeAsciiFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeComplexScriptFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeEastAsiaFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																[NSXMLElement attributeWithName:RKDOCXFontAttributeHighAnsiFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)]
																]];
	
	NSUInteger wordFontSize = [self wordFontSizeFromPointSize: CTFontGetSize(fontAttribute)];
	NSString *fontSize = [@(wordFontSize) stringValue];
	
	NSXMLElement *sizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontSizeElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue: fontSize]]];
	NSXMLElement *complexSizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeComplexScriptFontSizeElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue: fontSize]]];
	
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
