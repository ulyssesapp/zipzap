//
//  RKDOCXTextEffectsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 07.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXTextEffectAttributesWriter.h"

#import "RKColor.h"

NSString *RKDOCXTextEffectsBaselineAttributeValue			= @"baseline";
NSString *RKDOCXTextEffectsColorAutoAttributeValue			= @"auto";
NSString *RKDOCXTextEffectsColorElementName					= @"w:color";
NSString *RKDOCXTextEffectsDoubleStrikethroughElementName	= @"w:dstrike";
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

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *properties = [NSMutableArray new];
	
	// Font color (§17.3.2.6)
	NSXMLElement *foregroundColorProperty = [self foregroundColorPropertyForAttributes:attributes usingContext:context];
	if (foregroundColorProperty)
		[properties addObject: foregroundColorProperty];
	
	// Outline (§17.3.2.23)
	NSXMLElement *strokeWidthProperty = [self strokeWidthPropertyForAttributes:attributes usingContext:context];
	if (strokeWidthProperty)
		[properties addObject: strokeWidthProperty];
	
	// Shadow (§17.3.2.31)
	NSXMLElement *shadowProperty = [self shadowPropertyForAttributes:attributes usingContext:context];
	if (shadowProperty)
		[properties addObject: shadowProperty];
	
	// Strikethrough (§17.3.2.9/§17.3.2.37)
	NSXMLElement *strikethroughProperty = [self strikethroughPropertyForAttributes:attributes usingContext:context];
	if (strikethroughProperty)
		[properties addObject: strikethroughProperty];
	
	// Underline (§17.3.2.40)
	NSXMLElement *underlineProperty = [self underlinePropertyForAttributes:attributes usingContext:context];
	if (underlineProperty)
		[properties addObject: underlineProperty];
	
	// Subscript/Superscript (§17.3.2.42)
	NSXMLElement *superscriptProperty = [self superscriptPropertyForAttributes:attributes usingContext:context];
	if (superscriptProperty)
		[properties addObject: superscriptProperty];
	
	return properties;
}

+ (NSXMLElement *)foregroundColorPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	RKColor *fontColorAttribute = attributes[RKForegroundColorAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKForegroundColorAttributeName fromAttributes:attributes usingContext:context isCharacterStyle:YES])
		return nil;
	
	NSXMLElement *foregroundColorProperty = [NSXMLElement elementWithName:RKDOCXTextEffectsColorElementName];
	
	if (!fontColorAttribute)
		[foregroundColorProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsColorAutoAttributeValue]];
	else
		[foregroundColorProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:fontColorAttribute.hexRepresentation]];
	
	return foregroundColorProperty;
}

+ (NSXMLElement *)strokeWidthPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![self shouldTranslateAttributeWithName:RKStrokeWidthAttributeName fromAttributes:attributes usingContext:context isCharacterStyle:YES])
		return nil;
	
	NSXMLElement *strokeWidthProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsOutlineElementName];
	
	if (!attributes[RKStrokeWidthAttributeName] || [attributes[RKStrokeWidthAttributeName] isLessThanOrEqualTo: @0])
		[strokeWidthProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return strokeWidthProperty;
}

+ (NSXMLElement *)shadowPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![self shouldTranslateAttributeWithName:RKShadowAttributeName fromAttributes:attributes usingContext:context isCharacterStyle:YES])
		return nil;
	
	NSXMLElement *shadowProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsShadowElementName];
	
	if (!attributes[RKShadowAttributeName])
		[shadowProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return shadowProperty;
}

+ (NSXMLElement *)strikethroughPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSNumber *strikethroughAttribute = attributes[RKStrikethroughStyleAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKStrikethroughStyleAttributeName fromAttributes:attributes usingContext:context isCharacterStyle:YES])
		return nil;
	
	NSXMLElement *strikethroughProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsSingleStrikethroughElementName];
	
	if (!strikethroughAttribute || strikethroughAttribute.integerValue == RKUnderlineStyleNone)
		[strikethroughProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return strikethroughProperty;
}

+ (NSXMLElement *)underlinePropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSNumber *underlineAttribute = attributes[RKUnderlineStyleAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKUnderlineStyleAttributeName fromAttributes:attributes usingContext:context isCharacterStyle:YES])
		return nil;
	
	NSXMLElement *underlineProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsUnderlineElementName];
	
	if (!underlineAttribute || underlineAttribute.integerValue == RKUnderlineStyleNone) {
		[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsNoUnderlineAttributeValue]];
		return underlineProperty;
	}

	[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsSingleUnderlineAttributeValue]];
	
	RKColor *underlineColorAttribute = attributes[RKUnderlineColorAttributeName];
	if (underlineColorAttribute) {
		[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsUnderlineColorElementName stringValue:[attributes[RKUnderlineColorAttributeName] hexRepresentation]]];
	}
	
	return underlineProperty;
}

+ (NSXMLElement *)superscriptPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSInteger superscriptAttribute = [attributes[RKSuperscriptAttributeName] integerValue];
	
	// String and style attribute are the same
	if (![self shouldTranslateAttributeWithName:RKSuperscriptAttributeName fromAttributes:attributes usingContext:context isCharacterStyle:YES])
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

+ (BOOL)shouldTranslateAttributeWithName:(NSString *)attributeName fromAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isCharacterStyle:(BOOL)isCharacterStyle
{
	id attributeValue = attributes[attributeName];
	id styleValue = isCharacterStyle ? context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][attributeName] : context.document.paragraphStyles[attributes[RKParagraphStyleNameAttributeName]][attributeName];
	
	// No translation is performed if string attributes and style attributes are the same. (I.e. have the same value or are both set to nil.)
	return !((attributeValue == styleValue) || [attributeValue isEqual: styleValue]);
}

@end
