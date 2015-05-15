//
//  RKDOCXFontAttributesWriter.m
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
	
	RKFontOverrideMask overrideMask = [attributes[RKFontOverrideAttributeName] unsignedIntegerValue];
	NSUInteger traits = CTFontGetSymbolicTraits(fontAttribute);
	
	// Character style for comparison
	NSDictionary *characterStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:attributes[RKCharacterStyleNameAttributeName]];
	CTFontRef characterStyleFontAttribute = (__bridge CTFontRef)characterStyle[RKFontAttributeName];
	NSUInteger styleTraits = CTFontGetSymbolicTraits(characterStyleFontAttribute);
	
	if ((traits & kCTFontItalicTrait) != (styleTraits & kCTFontItalicTrait) && !(overrideMask & RKFontOverrideItalicTrait)) {
		if (traits & kCTFontItalicTrait)
			[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeItalicElementName]];
		else
			[properties addObject: [NSXMLElement elementWithName:RKDOCXFontAttributeItalicElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]]];
	}
	
	if ((traits & kCTFontBoldTrait) != (styleTraits & kCTFontBoldTrait) && !(overrideMask & RKFontOverrideBoldTrait)) {
		if (traits & kCTFontBoldTrait)
			[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeBoldElementName]];
		else
			[properties addObject: [NSXMLElement elementWithName:RKDOCXFontAttributeBoldElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]]];
	}
	
	if (![(__bridge NSString *)CTFontCopyFamilyName(fontAttribute) isEqual: (__bridge NSString *)CTFontCopyFamilyName(characterStyleFontAttribute)] && !(overrideMask & RKFontOverrideFontName)) {
		NSXMLElement *fontElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFontAttributeAsciiFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeComplexScriptFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeEastAsiaFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeHighAnsiFontAttributeValue stringValue:(__bridge NSString *)CTFontCopyFamilyName(fontAttribute)]]];
		[properties addObject: fontElement];
	}
	
	if (CTFontGetSize(fontAttribute) != CTFontGetSize(characterStyleFontAttribute) && !(overrideMask & RKFontOverrideFontSize)) {
		NSUInteger wordFontSize = [self wordFontSizeFromPointSize: CTFontGetSize(fontAttribute)];
		NSString *fontSize = [@(wordFontSize) stringValue];
		NSXMLElement *sizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontSizeElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue: fontSize]]];
		NSXMLElement *complexSizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeComplexScriptFontSizeElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue: fontSize]]];
		[properties addObjectsFromArray: @[sizeElement, complexSizeElement]];
	}
	
	return properties;
}

+ (NSUInteger)wordFontSizeFromPointSize:(CGFloat)pointSize
{
	// Font sizes are saved in half points, so the point size has to be doubled
	CGFloat wordFontSize = pointSize * 2;
	
	// For now we round the font size
	return (NSUInteger)round(wordFontSize);
}

+ (RKFont *)overridingFontPropertiesForCharacterAttributes:(NSDictionary *)characterAttributes paragraphAttributes:(NSDictionary *)paragraphAttributes
{
	CTFontRef characterFontAttribute = (__bridge CTFontRef)characterAttributes[RKFontAttributeName];
	CTFontRef paragraphFontAttribute = (__bridge CTFontRef)paragraphAttributes[RKFontAttributeName];
	RKFontOverrideMask overrideMask = [characterAttributes[RKFontOverrideAttributeName] unsignedIntegerValue];
	
	if (overrideMask == 0)
		return (__bridge RKFont *)characterFontAttribute;
	else if (overrideMask == RKFontOverrideAll)
		return (__bridge RKFont *)paragraphFontAttribute;
	
	CFStringRef fontName	= (overrideMask & RKFontOverrideFontName) ? CTFontCopyFamilyName(paragraphFontAttribute) : CTFontCopyFamilyName(characterFontAttribute);
	CGFloat fontSize		= (overrideMask & RKFontOverrideFontSize) ? CTFontGetSize(paragraphFontAttribute) : CTFontGetSize(characterFontAttribute);
	BOOL enableItalicTrait	= (overrideMask & RKFontOverrideItalicTrait) ? CTFontGetSymbolicTraits(paragraphFontAttribute) & kCTFontItalicTrait : CTFontGetSymbolicTraits(characterFontAttribute) & kCTFontItalicTrait;
	BOOL enableBoldTrait	= (overrideMask & RKFontOverrideBoldTrait) ? CTFontGetSymbolicTraits(paragraphFontAttribute) & kCTFontBoldTrait : CTFontGetSymbolicTraits(characterFontAttribute) & kCTFontBoldTrait;
	
	CTFontSymbolicTraits traits = ((enableItalicTrait) ? kCTFontItalicTrait : 0) | ((enableBoldTrait) ? kCTFontBoldTrait : 0);
	
	// Create font with name and size
	CTFontRef resultingFontAttribute = CTFontCreateWithName(fontName, fontSize, NULL);
	
	// Add bold and italic traits to font
	resultingFontAttribute = CTFontCreateCopyWithSymbolicTraits(resultingFontAttribute, 0.0, NULL, traits, kCTFontItalicTrait | kCTFontBoldTrait);
	
	return (__bridge RKFont *)resultingFontAttribute;
}

@end
