//
//  RKDOCXTextEffectsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 07.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXTextEffectsWriter.h"

#import "RKColor.h"

NSString *RKDOCXTextEffectsColorPropertyName				= @"w:color";
NSString *RKDOCXTextEffectsDoubleStrikethroughPropertyName	= @"w:dstrike";
NSString *RKDOCXTextEffectsOutlinePropertyName				= @"w:outline";
NSString *RKDOCXTextEffectsShadowPropertyName				= @"w:shadow";
NSString *RKDOCXTextEffectsSingleStrikethroughPropertyName	= @"w:strike";
NSString *RKDOCXTextEffectsSingleUnderlineName				= @"single";
NSString *RKDOCXTextEffectsSubscriptName					= @"subscript";
NSString *RKDOCXTextEffectsSuperscriptName					= @"superscript";
NSString *RKDOCXTextEffectsSuperscriptPropertyName			= @"w:vertAlign";
NSString *RKDOCXTextEffectsUnderlineColorName				= @"w:color";
NSString *RKDOCXTextEffectsUnderlinePropertyName			= @"w:u";


@implementation RKDOCXTextEffectsWriter

+ (NSArray *)runPropertiesForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *properties = [NSMutableArray new];
	
	// Font color
	NSXMLElement *foregroundColorProperty = [self foregroundColorPropertyForAttributes: attributes];
	if (foregroundColorProperty)
		[properties addObject: foregroundColorProperty];
	
	// Outline
	NSXMLElement *strokeWidthProperty = [self strokeWidthPropertyForAttributes: attributes];
	if (strokeWidthProperty)
		[properties addObject: strokeWidthProperty];
	
	// Shadow
	NSXMLElement *shadowProperty = [self shadowPropertyForAttributes: attributes];
	if (shadowProperty)
		[properties addObject: shadowProperty];
	
	// Strikethrough
	NSXMLElement *strikethroughProperty = [self strikethroughPropertyForAttributes: attributes];
	if (strikethroughProperty)
		[properties addObject: strikethroughProperty];
	
	// Underline
	NSXMLElement *underlineProperty = [self underlinePropertyForAttributes: attributes];
	if (underlineProperty)
		[properties addObject: underlineProperty];
	
	// Subscript/Superscript
	NSXMLElement *superscriptProperty = [self superscriptPropertyForAttributes: attributes];
	if (superscriptProperty)
		[properties addObject: superscriptProperty];
	
	return properties;
}

+ (NSXMLElement *)foregroundColorPropertyForAttributes:(NSDictionary *)attributes
{
	RKColor *fontColorAttribute = attributes[RKForegroundColorAttributeName];
	if (!fontColorAttribute)
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXTextEffectsColorPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:fontColorAttribute.hexRepresentation]]];
}

+ (NSXMLElement *)strokeWidthPropertyForAttributes:(NSDictionary *)attributes
{
	if ([attributes[RKStrokeWidthAttributeName] integerValue] <= 0)
		return nil;
	
	return [NSXMLElement elementWithName: RKDOCXTextEffectsOutlinePropertyName];
}

+ (NSXMLElement *)shadowPropertyForAttributes:(NSDictionary *)attributes
{
	if (!attributes[RKShadowAttributeName])
		return nil;
	
	return [NSXMLElement elementWithName: RKDOCXTextEffectsShadowPropertyName];
}

+ (NSXMLElement *)strikethroughPropertyForAttributes:(NSDictionary *)attributes
{
	NSNumber *strikethroughAttribute = attributes[RKStrikethroughStyleAttributeName];
	if (!strikethroughAttribute || (strikethroughAttribute.integerValue == NSUnderlineStyleNone))
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXTextEffectsSingleStrikethroughPropertyName];
}

+ (NSXMLElement *)underlinePropertyForAttributes:(NSDictionary *)attributes
{
	NSNumber *underlineAttribute = attributes[RKUnderlineStyleAttributeName];
	if (!underlineAttribute || (underlineAttribute.integerValue == RKUnderlineStyleNone))
		return nil;
	
	NSXMLElement *underlineElement = [NSXMLElement elementWithName:RKDOCXTextEffectsUnderlinePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsSingleUnderlineName]]];
	RKColor *underlineColorAttribute = attributes[RKUnderlineColorAttributeName];
	if (underlineColorAttribute) {
		[underlineElement addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsUnderlineColorName stringValue:[attributes[RKUnderlineColorAttributeName] hexRepresentation]]];
	}
	
	return underlineElement;
}

+ (NSXMLElement *)superscriptPropertyForAttributes:(NSDictionary *)attributes
{
	NSInteger superscriptAttribute = [attributes[RKSuperscriptAttributeName] integerValue];
	if (superscriptAttribute == 0)
		return nil;
	
	NSString *superscriptValue = (superscriptAttribute < 0) ? RKDOCXTextEffectsSubscriptName : RKDOCXTextEffectsSuperscriptName;
	return [NSXMLElement elementWithName:RKDOCXTextEffectsSuperscriptPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:superscriptValue]]];
}

@end
