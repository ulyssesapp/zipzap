//
//  RKDOCXFontAttributesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFontAttributesWriter.h"

#import "NSXMLElement+IntegerValueConvenience.h"

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

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	CTFontRef fontAttribute = (__bridge CTFontRef)attributes[RKFontAttributeName];
	NSNumber *ignoreAttribute = attributes[RKFontMixAttributeName];
	RKFontMixMask ignoreMask = ignoreAttribute ? ignoreAttribute.unsignedIntegerValue : 0;
	
	if (!fontAttribute || ignoreMask == RKFontMixIgnoreAll)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	NSUInteger traits = CTFontGetSymbolicTraits(fontAttribute);
	
	// Template style for comparison
	NSDictionary *characterStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:attributes[RKCharacterStyleNameAttributeName] processingDefaultStyle:isDefaultStyle];
	CTFontRef characterStyleFontAttribute = (__bridge CTFontRef)characterStyle[RKFontAttributeName];
	NSUInteger styleTraits = CTFontGetSymbolicTraits(characterStyleFontAttribute);
	
	// Font Name (§17.3.2.26)
	NSString *fontName;
	BOOL fullFontNameRequired = [context isFullNameRequieredForFont: (__bridge ULFont *)fontAttribute];
	if (fullFontNameRequired)
		fontName = (__bridge NSString *)CTFontCopyFullName(fontAttribute);
	else
		fontName = (__bridge NSString *)CTFontCopyFamilyName(fontAttribute);
	
	if (![(__bridge NSString *)CTFontCopyFullName(fontAttribute) isEqual: (__bridge NSString *)CTFontCopyFullName(characterStyleFontAttribute)] && !(ignoreMask & RKFontMixIgnoreFontName)) {
		NSXMLElement *fontElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFontAttributeAsciiFontAttributeValue stringValue:fontName],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeComplexScriptFontAttributeValue stringValue:fontName],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeEastAsiaFontAttributeValue stringValue:fontName],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeHighAnsiFontAttributeValue stringValue:fontName]]];
		[properties addObject: fontElement];
	}
	
	// Font Size (§17.3.2.38/§17.3.2.39)
	if (CTFontGetSize(fontAttribute) != CTFontGetSize(characterStyleFontAttribute) && !(ignoreMask & RKFontMixIgnoreFontSize)) {
		NSUInteger wordFontSize = [self wordFontSizeFromPointSize: CTFontGetSize(fontAttribute)];
		NSXMLElement *sizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontSizeElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName integerValue:wordFontSize]]];
		NSXMLElement *complexSizeElement = [NSXMLElement elementWithName:RKDOCXFontAttributeComplexScriptFontSizeElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName integerValue:wordFontSize]]];
		[properties addObjectsFromArray: @[sizeElement, complexSizeElement]];
	}
	
	// Bold Trait (§17.3.2.1)
	if (((traits & kCTFontBoldTrait) != (styleTraits & kCTFontBoldTrait) && !(ignoreMask & RKFontMixIgnoreBoldTrait)) && !fullFontNameRequired) {
		if (traits & kCTFontBoldTrait)
			[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeBoldElementName]];
		else
			[properties addObject: [NSXMLElement elementWithName:RKDOCXFontAttributeBoldElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]]];
	}
	
	// Italic Trait (§17.3.2.16)
	if (((traits & kCTFontItalicTrait) != (styleTraits & kCTFontItalicTrait) && !(ignoreMask & RKFontMixIgnoreItalicTrait)) && !fullFontNameRequired) {
		if (traits & kCTFontItalicTrait)
			[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeItalicElementName]];
		else
			[properties addObject: [NSXMLElement elementWithName:RKDOCXFontAttributeItalicElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]]];
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

+ (RKFont *)fontByMixingFont:(RKFont *)baseFont withOverridingFont:(RKFont *)overridingFont usingMask:(RKFontMixMask)mask
{
	if (mask == 0)
		return overridingFont;
	else if (mask == RKFontMixIgnoreAll)
		return baseFont;
	
	CTFontRef baseFontRef = (__bridge CTFontRef)baseFont;
	CTFontRef overridingFontRef = (__bridge CTFontRef)overridingFont;
	
	CFStringRef fontName	= (mask & RKFontMixIgnoreFontName) ? CTFontCopyFullName(baseFontRef) : CTFontCopyFullName(overridingFontRef);
	CGFloat fontSize		= (mask & RKFontMixIgnoreFontSize) ? CTFontGetSize(baseFontRef) : CTFontGetSize(overridingFontRef);
	BOOL enableBoldTrait	= (mask & RKFontMixIgnoreBoldTrait) ? CTFontGetSymbolicTraits(baseFontRef) & kCTFontBoldTrait : CTFontGetSymbolicTraits(overridingFontRef) & kCTFontBoldTrait;
	BOOL enableItalicTrait	= (mask & RKFontMixIgnoreItalicTrait) ? CTFontGetSymbolicTraits(baseFontRef) & kCTFontItalicTrait : CTFontGetSymbolicTraits(overridingFontRef) & kCTFontItalicTrait;
	
	CTFontSymbolicTraits traits = ((enableItalicTrait) ? kCTFontItalicTrait : 0) | ((enableBoldTrait) ? kCTFontBoldTrait : 0);
	
	// Create font with name and size
	CTFontRef resultingFontAttribute = CTFontCreateWithName(fontName, fontSize, NULL);
	
	// Add bold and italic traits to font
	resultingFontAttribute = CTFontCreateCopyWithSymbolicTraits(resultingFontAttribute, 0.0, NULL, traits, kCTFontItalicTrait | kCTFontBoldTrait);
	
	return (__bridge RKFont *)resultingFontAttribute;
}

@end
