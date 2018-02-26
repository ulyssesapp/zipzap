//
//  RKDOCXFontAttributesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFontAttributesWriter.h"

#import "NSXMLElement+IntegerValueConvenience.h"

// Elements
NSString *RKDOCXFontAttributeBoldElementName					= @"w:b";
NSString *RKDOCXFontAttributeComplexScriptFontSizeElementName	= @"w:szCs";
NSString *RKDOCXFontAttributeFontElementName					= @"w:rFonts";
NSString *RKDOCXFontAttributeFontSizeElementName				= @"w:sz";
NSString *RKDOCXFontAttributeItalicElementName					= @"w:i";

// Attributes

// Attribute Values
NSString *RKDOCXFontAttributeAsciiFontAttributeName				= @"w:ascii";
NSString *RKDOCXFontAttributeComplexScriptFontAttributeName		= @"w:cs";
NSString *RKDOCXFontAttributeEastAsiaFontAttributeName			= @"w:eastAsia";
NSString *RKDOCXFontAttributeHighAnsiFontAttributeName			= @"w:hAnsi";

@implementation RKDOCXFontAttributesWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	CTFontRef fontAttribute = (__bridge CTFontRef)attributes[RKFontAttributeName];
	NSNumber *ignoreAttribute = attributes[RKFontMixAttributeName];
	RKFontMixMask ignoreMask = ignoreAttribute ? ignoreAttribute.unsignedIntegerValue : 0;
	
	if (!fontAttribute || ignoreMask == RKFontMixIgnoreAll)
		return nil;
	
	// Template style for comparison
	NSDictionary *characterStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:attributes[RKCharacterStyleNameAttributeName] processingDefaultStyle:isDefaultStyle];
	CTFontRef characterStyleFontAttribute = (__bridge CTFontRef)characterStyle[RKFontAttributeName];
	CTFontSymbolicTraits styleTraits = CTFontGetSymbolicTraits(characterStyleFontAttribute);
	CTFontSymbolicTraits traits = CTFontGetSymbolicTraits(fontAttribute);
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Set font name only if current character style didn't set it already
	if (![(__bridge NSString *)CTFontCopyFullName(fontAttribute) isEqual: (__bridge NSString *)CTFontCopyFullName(characterStyleFontAttribute)] && !(ignoreMask & RKFontMixIgnoreFontName)) {
		// Get font name without bold/italic traits, since these traits will be set using DOCX style tags. Preserve other traits (e.g. Condensed)
		NSString *baseFontName = [self fontNameForFont:fontAttribute withoutTraits:(traits & (kCTFontBoldTrait|kCTFontItalicTrait))];
		
		// See (§17.3.2.26)
		NSXMLElement *fontElement = [NSXMLElement elementWithName:RKDOCXFontAttributeFontElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFontAttributeAsciiFontAttributeName stringValue:baseFontName],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeComplexScriptFontAttributeName stringValue:baseFontName],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeEastAsiaFontAttributeName stringValue:baseFontName],
																															   [NSXMLElement attributeWithName:RKDOCXFontAttributeHighAnsiFontAttributeName stringValue:baseFontName]]];
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
	if ((traits & kCTFontBoldTrait) != (styleTraits & kCTFontBoldTrait) && !(ignoreMask & RKFontMixIgnoreBoldTrait)) {
		if (traits & kCTFontBoldTrait)
			[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeBoldElementName]];
		else
			[properties addObject: [NSXMLElement elementWithName:RKDOCXFontAttributeBoldElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]]];
	}
	
	// Italic Trait (§17.3.2.16)
	if ((traits & kCTFontItalicTrait) != (styleTraits & kCTFontItalicTrait) && !(ignoreMask & RKFontMixIgnoreItalicTrait)) {
		if (traits & kCTFontItalicTrait)
			[properties addObject: [NSXMLElement elementWithName: RKDOCXFontAttributeItalicElementName]];
		else
			[properties addObject: [NSXMLElement elementWithName:RKDOCXFontAttributeItalicElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]]];
	}
	
	return properties;
}

+ (NSString *)fontNameForFont:(CTFontRef)fontWithTraits withoutTraits:(CTFontSymbolicTraits)excludedTraits
{
	// Find a base font by excluding the given traits. Fall back to given font, if the font is only available with traits.
	CTFontDescriptorRef fontDescriptor = CTFontCopyFontDescriptor(fontWithTraits);
	CTFontDescriptorRef fontDescriptorWithoutTraits = CTFontDescriptorCreateCopyWithSymbolicTraits(fontDescriptor, 0, excludedTraits);
	CFRelease(fontDescriptor);
	if (!fontDescriptorWithoutTraits)
		return CFBridgingRelease(CTFontCopyFullName(fontWithTraits));
	
	// Get full name from base font
	CTFontRef baseFont = CTFontCreateWithFontDescriptor(fontDescriptorWithoutTraits, 0.0, NULL);
	NSString *fontName = CFBridgingRelease(CTFontCopyFullName(baseFont));
	CFRelease(fontDescriptorWithoutTraits);
	CFRelease(baseFont);

	return fontName;
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
	CTFontRef baseFontRef = (__bridge CTFontRef)baseFont;
	CTFontRef overridingFontRef = (__bridge CTFontRef)overridingFont;
	
	CFStringRef fontName	= (mask & RKFontMixIgnoreFontName
							   ? CTFontCopyFullName(baseFontRef)
							   : CTFontCopyFullName(overridingFontRef));
	CGFloat fontSize		= (mask & RKFontMixIgnoreFontSize
							   ? CTFontGetSize(baseFontRef)
							   : CTFontGetSize(overridingFontRef));
	BOOL enableBoldTrait	= (mask & RKFontMixIgnoreBoldTrait
							   ? CTFontGetSymbolicTraits(baseFontRef) & kCTFontBoldTrait
							   : ((CTFontGetSymbolicTraits(baseFontRef) & kCTFontBoldTrait) != (CTFontGetSymbolicTraits(overridingFontRef) & kCTFontBoldTrait)));
	BOOL enableItalicTrait	= (mask & RKFontMixIgnoreItalicTrait
							   ? CTFontGetSymbolicTraits(baseFontRef) & kCTFontItalicTrait
							   : ((CTFontGetSymbolicTraits(baseFontRef) & kCTFontItalicTrait) != (CTFontGetSymbolicTraits(overridingFontRef) & kCTFontItalicTrait)));
	
	CTFontSymbolicTraits traits = ((enableItalicTrait) ? kCTFontItalicTrait : 0) | ((enableBoldTrait) ? kCTFontBoldTrait : 0);
	
	// Create font with name and size
	CTFontRef resultingFontAttributeWithoutTraits = CTFontCreateWithName(fontName, fontSize, NULL);
	
	// Add bold and italic traits to font
	CTFontRef resultingFontAttribute = CTFontCreateCopyWithSymbolicTraits(resultingFontAttributeWithoutTraits, 0.0, NULL, traits, kCTFontItalicTrait | kCTFontBoldTrait);
	CFRelease(resultingFontAttributeWithoutTraits);
	
	return (__bridge_transfer RKFont *)resultingFontAttribute;
}

@end
