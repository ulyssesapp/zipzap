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
	if (!fontColorAttribute || [fontColorAttribute isEqual: context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][RKForegroundColorAttributeName]])
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXTextEffectsColorElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:fontColorAttribute.hexRepresentation]]];
}

+ (NSXMLElement *)strokeWidthPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if ([attributes[RKStrokeWidthAttributeName] integerValue] <= 0 || [attributes[RKStrokeWidthAttributeName] isEqual: context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][RKStrokeWidthAttributeName]])
		return nil;
	
	NSXMLElement *strokeWidthProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsOutlineElementName];
	
	if ([attributes[RKStrokeWidthAttributeName] integerValue] <= 0)
		[strokeWidthProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return strokeWidthProperty;
}

+ (NSXMLElement *)shadowPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (!attributes[RKShadowAttributeName] && context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][RKShadowAttributeName])
		return [NSXMLElement elementWithName:RKDOCXTextEffectsShadowElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]];
	
	if (!attributes[RKShadowAttributeName])
		return nil;
	
	return [NSXMLElement elementWithName: RKDOCXTextEffectsShadowElementName];
}

+ (NSXMLElement *)strikethroughPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSNumber *strikethroughAttribute = attributes[RKStrikethroughStyleAttributeName];
	
	if ((!strikethroughAttribute || (strikethroughAttribute.integerValue == RKUnderlineStyleNone)) && context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][RKStrikethroughStyleAttributeName])
		return [NSXMLElement elementWithName:RKDOCXTextEffectsSingleStrikethroughElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]]];
	
	if (!strikethroughAttribute || (strikethroughAttribute.integerValue == RKUnderlineStyleNone))
		return nil;
	
	return [NSXMLElement elementWithName: RKDOCXTextEffectsSingleStrikethroughElementName];
}

+ (NSXMLElement *)underlinePropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSNumber *underlineAttribute = attributes[RKUnderlineStyleAttributeName];
	
	if ((!underlineAttribute || (underlineAttribute.integerValue == RKUnderlineStyleNone)) && context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][RKUnderlineStyleAttributeName])
		return [NSXMLElement elementWithName:RKDOCXTextEffectsUnderlineElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsNoUnderlineAttributeValue]]];
	
	if (!underlineAttribute || (underlineAttribute.integerValue == RKUnderlineStyleNone))
		return nil;
	
	NSXMLElement *underlineElement = [NSXMLElement elementWithName:RKDOCXTextEffectsUnderlineElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsSingleUnderlineAttributeValue]]];
	RKColor *underlineColorAttribute = attributes[RKUnderlineColorAttributeName];
	if (underlineColorAttribute) {
		[underlineElement addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsUnderlineColorElementName stringValue:[attributes[RKUnderlineColorAttributeName] hexRepresentation]]];
	}
	
	return underlineElement;
}

+ (NSXMLElement *)superscriptPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSInteger superscriptAttribute = [attributes[RKSuperscriptAttributeName] integerValue];
	
	if ((superscriptAttribute == 0) && ([context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][RKSuperscriptAttributeName] integerValue] != 0))
		return [NSXMLElement elementWithName:RKDOCXTextEffectsSuperscriptElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsBaselineAttributeValue]]];
	
	if (superscriptAttribute == 0)
		return nil;
	
	NSString *superscriptValue = (superscriptAttribute < 0) ? RKDOCXTextEffectsSubscriptAttributeValue : RKDOCXTextEffectsSuperscriptAttributeValue;
	return [NSXMLElement elementWithName:RKDOCXTextEffectsSuperscriptElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:superscriptValue]]];
}

@end
