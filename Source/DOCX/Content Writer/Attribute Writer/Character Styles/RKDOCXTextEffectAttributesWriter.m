//
//  RKDOCXTextEffectAttributesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 07.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXTextEffectAttributesWriter.h"

#import "RKColor.h"

NSString *RKDOCXTextEffectsBaselineAttributeValue			= @"baseline";
NSString *RKDOCXTextEffectsCharacterSpacingElementName		= @"w:spacing";
NSString *RKDOCXTextEffectsColorAutoAttributeValue			= @"auto";
NSString *RKDOCXTextEffectsNoHighlightAttributeValue		= @"none";
NSString *RKDOCXTextEffectsColorElementName					= @"w:color";
NSString *RKDOCXTextEffectsDoubleStrikethroughElementName	= @"w:dstrike";
NSString *RKDOCXTextEffectsHighlightElementValue			= @"w:highlight";
NSString *RKDOCXTextEffectsLigatureAttributeName			= @"w14:val";
NSString *RKDOCXTextEffectsLigatureElementName				= @"w14:ligatures";
NSString *RKDOCXTextEffectsLigatureAllAttributeValue		= @"all";
NSString *RKDOCXTextEffectsLigatureDefaultAttributeValue	= @"historicalDiscretional"; // alternatively: standardContextual
NSString *RKDOCXTextEffectsLigatureNoneAttributeValue		= @"none";
NSString *RKDOCXTextEffectsNoUnderlineAttributeValue		= @"none";
NSString *RKDOCXTextEffectsOutlineElementName				= @"w:outline";
NSString *RKDOCXTextEffectsShadowElementName				= @"w:shadow";
NSString *RKDOCXTextEffectsSingleStrikethroughElementName	= @"w:strike";
NSString *RKDOCXTextEffectsSingleUnderlineAttributeValue	= @"single";
NSString *RKDOCXTextEffectsSubscriptAttributeValue			= @"subscript";
NSString *RKDOCXTextEffectsSuperscriptAttributeValue		= @"superscript";
NSString *RKDOCXTextEffectsSuperscriptElementName			= @"w:vertAlign";
NSString *RKDOCXTextEffectsUnderlineColorElementName		= @"w:color";
NSString *RKDOCXTextEffectsUnderlineElementName				= @"w:u";

@implementation RKDOCXTextEffectAttributesWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSMutableArray *properties = [NSMutableArray new];
	
	// Font color (§17.3.2.6)
	NSXMLElement *foregroundColorProperty = [self foregroundColorPropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (foregroundColorProperty)
		[properties addObject: foregroundColorProperty];
	
	// Highlight color (§17.3.2.15). Don't need to ignore style templates, since highlight color is not inherited from templates.
	NSXMLElement *highlightColorProperty = [self highlightColorPropertyForAttributes:attributes usingContext:context];
	if (highlightColorProperty)
		[properties addObject: highlightColorProperty];
	
	// Outline (§17.3.2.23)
	NSXMLElement *strokeWidthProperty = [self strokeWidthPropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (strokeWidthProperty)
		[properties addObject: strokeWidthProperty];
	
	// Shadow (§17.3.2.31)
	NSXMLElement *shadowProperty = [self shadowPropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (shadowProperty)
		[properties addObject: shadowProperty];
	
	// Character Spacing (§17.3.2.35)
	NSXMLElement *spacingProperty = [self spacingPropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (spacingProperty)
		[properties addObject: spacingProperty];
	
	// Strikethrough (§17.3.2.9/§17.3.2.37)
	NSXMLElement *strikethroughProperty = [self strikethroughPropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (strikethroughProperty)
		[properties addObject: strikethroughProperty];
	
	// Underline (§17.3.2.40)
	NSXMLElement *underlineProperty = [self underlinePropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (underlineProperty)
		[properties addObject: underlineProperty];
	
	// Subscript/Superscript (§17.3.2.42)
	NSXMLElement *superscriptProperty = [self superscriptPropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (superscriptProperty)
		[properties addObject: superscriptProperty];
	
	// Ligatures (no mention in official standard)
	NSXMLElement *ligatureProperty = [self ligaturePropertyForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (ligatureProperty)
		[properties addObject: ligatureProperty];
	
	return properties;
}

+ (NSXMLElement *)foregroundColorPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	RKColor *fontColorAttribute = attributes[RKForegroundColorAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKForegroundColorAttributeName fromAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle])
		return nil;
	
	NSXMLElement *foregroundColorProperty = [NSXMLElement elementWithName:RKDOCXTextEffectsColorElementName];
	
	if (!fontColorAttribute)
		[foregroundColorProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsColorAutoAttributeValue]];
	else
		[foregroundColorProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:fontColorAttribute.rk_hexRepresentation]];
	
	return foregroundColorProperty;
}

+ (NSXMLElement *)highlightColorPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	static NSDictionary *highlightColors;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		// Color definitions taken from ST_HighlightColor: §17.18.40
		highlightColors = @{
							@"black":		[RKColor rk_colorWithHexRepresentation: @"000000"],
							@"blue":		[RKColor rk_colorWithHexRepresentation: @"0000FF"],
							@"cyan":		[RKColor rk_colorWithHexRepresentation: @"00FFFF"],
							@"darkBlue":	[RKColor rk_colorWithHexRepresentation: @"00008B"],
							@"darkCyan":	[RKColor rk_colorWithHexRepresentation: @"008B8B"],
							@"darkGray":	[RKColor rk_colorWithHexRepresentation: @"A9A9A9"],
							@"darkGreen":	[RKColor rk_colorWithHexRepresentation: @"006400"],
							@"darkMagenta":	[RKColor rk_colorWithHexRepresentation: @"800080"],
							@"darkRed":		[RKColor rk_colorWithHexRepresentation: @"8B0000"],
							@"darkYellow":	[RKColor rk_colorWithHexRepresentation: @"808000"],
							@"green":		[RKColor rk_colorWithHexRepresentation: @"00FF00"],
							@"lightGray":	[RKColor rk_colorWithHexRepresentation: @"D3D3D3"],
							@"magenta":		[RKColor rk_colorWithHexRepresentation: @"FF00FF"],
							@"red":			[RKColor rk_colorWithHexRepresentation: @"FF0000"],
							@"yellow":		[RKColor rk_colorWithHexRepresentation: @"FFFF00"],
							@"white":		[RKColor rk_colorWithHexRepresentation: @"FFFFFF"]
						   };
	});

	RKColor *highlightColorAttribute = attributes[RKBackgroundColorAttributeName];
	
	// No color: just ignore.
	if (!highlightColorAttribute)
		return nil;

	// Get closest color
	CGFloat highlightHue, highlightSaturation, highlightBrightness;
	[highlightColorAttribute getHue:&highlightHue saturation:&highlightSaturation brightness:&highlightBrightness alpha:NULL];

	__block NSString *nearestColorName = nil;
	__block CGFloat nearestColorDistance = INFINITY;

	[highlightColors enumerateKeysAndObjectsUsingBlock:^(NSString *colorName, RKColor *currentColor, BOOL *stop) {
		CGFloat currentHue, currentSaturation, currentBrightness;
		[currentColor getHue:&currentHue saturation:&currentSaturation brightness:&currentBrightness alpha:NULL];
		
		// Ignore colors without saturation, if the color itself has saturation
		if ((currentSaturation <= 0.01) != (highlightSaturation <= 0.01))
			return;

		// Otherwise determine distance to color
		CGFloat currentDistance = pow(highlightHue - currentHue, 2) + pow(highlightSaturation - currentSaturation, 2) + pow(highlightBrightness - currentBrightness, 2);
		if (currentDistance <= nearestColorDistance) {
			nearestColorDistance = currentDistance;
			nearestColorName = colorName;
		}
	}];

	// Highlight color is always translated, since it is ignored when being part of a style definition
	return [NSXMLElement elementWithName:RKDOCXTextEffectsHighlightElementValue children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:nearestColorName]]];
}

+ (NSXMLElement *)strokeWidthPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	if (![self shouldTranslateAttributeWithName:RKStrokeWidthAttributeName fromAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle])
		return nil;
	
	NSXMLElement *strokeWidthProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsOutlineElementName];
	
	if (!attributes[RKStrokeWidthAttributeName] || ([attributes[RKStrokeWidthAttributeName] integerValue] <= 0))
		[strokeWidthProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return strokeWidthProperty;
}

+ (NSXMLElement *)shadowPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	if (![self shouldTranslateAttributeWithName:RKShadowAttributeName fromAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle])
		return nil;
	
	NSXMLElement *shadowProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsShadowElementName];
	
	if (!attributes[RKShadowAttributeName])
		[shadowProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return shadowProperty;
}

+ (NSXMLElement *)spacingPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	if (![self shouldTranslateAttributeWithName:RKKernAttributeName fromAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle])
		return nil;
	
	NSString *spacingValue;
	if (!attributes[RKKernAttributeName])
		spacingValue = RKDOCXAttributeWriterOffAttributeValue;
	else
		spacingValue = @(RKPointsToTwips([attributes[RKKernAttributeName] integerValue])).stringValue;

	return [NSXMLElement elementWithName: RKDOCXTextEffectsCharacterSpacingElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:spacingValue]]];
}

+ (NSXMLElement *)strikethroughPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSNumber *strikethroughAttribute = attributes[RKStrikethroughStyleAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKStrikethroughStyleAttributeName fromAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle])
		return nil;
	
	NSXMLElement *strikethroughProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsSingleStrikethroughElementName];
	
	if (!strikethroughAttribute || strikethroughAttribute.unsignedIntegerValue == RKUnderlineStyleNone)
		[strikethroughProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return strikethroughProperty;
}

+ (NSXMLElement *)underlinePropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSNumber *underlineAttribute = attributes[RKUnderlineStyleAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKUnderlineStyleAttributeName fromAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle])
		return nil;
	
	NSXMLElement *underlineProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsUnderlineElementName];
	
	if (!underlineAttribute || underlineAttribute.unsignedIntegerValue == RKUnderlineStyleNone) {
		[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsNoUnderlineAttributeValue]];
		return underlineProperty;
	}

	[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsSingleUnderlineAttributeValue]];
	
	RKColor *underlineColorAttribute = attributes[RKUnderlineColorAttributeName];
	if (underlineColorAttribute) {
		[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsUnderlineColorElementName stringValue:[attributes[RKUnderlineColorAttributeName] rk_hexRepresentation]]];
	}
	
	return underlineProperty;
}

+ (NSXMLElement *)superscriptPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSInteger superscriptAttribute = [attributes[RKSuperscriptAttributeName] unsignedIntegerValue];
	
	// String and style attribute are the same
	if (![self shouldTranslateAttributeWithName:RKSuperscriptAttributeName fromAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle])
		return nil;
	
	NSXMLElement *superscriptProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsSuperscriptElementName];
	
	// Superscript is set to baseline
	if (superscriptAttribute == 0) {
		[superscriptProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsBaselineAttributeValue]];
		return superscriptProperty;
	}
	
	// Subscript or superscript
	[superscriptProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:(superscriptAttribute < 0) ? RKDOCXTextEffectsSubscriptAttributeValue : RKDOCXTextEffectsSuperscriptAttributeValue]];
	
	return superscriptProperty;
}

+ (NSXMLElement *)ligaturePropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSDictionary *characterStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:attributes[RKCharacterStyleNameAttributeName] processingDefaultStyle:isDefaultStyle];
	id attributeValue = attributes[RKLigatureAttributeName] ?: @1;
	id styleValue = characterStyle[RKLigatureAttributeName] ?: @1;
	
	// Ignore ligature setting if matching with template style. Always set when processing default style, since ligatures are not activate by default in DOCX.
	if (!isDefaultStyle && [attributeValue isEqual: styleValue])
		return nil;
	
	NSXMLElement *ligatureProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsLigatureElementName];
	NSUInteger ligatureValue = [attributeValue unsignedIntegerValue];
	
	if (attributeValue && ligatureValue == 0)
		[ligatureProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsLigatureAttributeName stringValue:RKDOCXTextEffectsLigatureNoneAttributeValue]];

	else if (ligatureValue == 2)
		[ligatureProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsLigatureAttributeName stringValue:RKDOCXTextEffectsLigatureAllAttributeValue]];
	
	else
		[ligatureProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsLigatureAttributeName stringValue:RKDOCXTextEffectsLigatureDefaultAttributeValue]];
	
	return ligatureProperty;
}

+ (BOOL)shouldTranslateAttributeWithName:(NSString *)attributeName fromAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSDictionary *characterStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:attributes[RKCharacterStyleNameAttributeName] processingDefaultStyle:isDefaultStyle];
	id attributeValue = attributes[attributeName];
	id styleValue = characterStyle[attributeName];
	
	// No translation is performed if string attributes and style attributes are the same. (I.e. have the same value or are both set to nil.)
	return !((attributeValue == styleValue) || [attributeValue isEqual: styleValue]);
}

@end
