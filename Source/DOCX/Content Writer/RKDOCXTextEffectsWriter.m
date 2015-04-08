//
//  RKDOCXTextEffectsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 07.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXTextEffectsWriter.h"

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

+ (NSArray *)runPropertiesForAttributes:(NSDictionary *)attributes
{
	NSMutableArray *properties = [NSMutableArray new];
	
	// Font color
	[self checkForFontColorInAttributes:attributes addToProperties:properties];
	
	// Outline
	[self checkForOutlineInAttributes:attributes addToProperties:properties];
	
	// Shadow
	[self checkForShadowInAttributes:attributes addToProperties:properties];
	
	// Strikethrough
	[self checkForStrikethroughInAttributes:attributes addToProperties:properties];
	
	// Underline
	[self checkForUnderlineInAttributes:attributes addToProperties:properties];
	
	// Subscript/Superscript
	[self checkForSuperscriptInAttributes:attributes addToProperties:properties];
	
	return properties;
}

+ (void)checkForFontColorInAttributes:(NSDictionary *)attributes addToProperties:(NSMutableArray *)properties
{
	NSColor *fontColorAttribute = attributes[RKForegroundColorAttributeName];
	if (fontColorAttribute) {
		NSString *fontColor = [self.class hexValueOfNSColor: fontColorAttribute];
		NSXMLElement *fontColorElement = [NSXMLElement elementWithName:RKDOCXTextEffectsColorPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue:fontColor]]];
		[properties addObject: fontColorElement];
	}
}

+ (void)checkForOutlineInAttributes:(NSDictionary *)attributes addToProperties:(NSMutableArray *)properties
{
	if ([attributes[RKStrokeWidthAttributeName] integerValue] > 0) {
		NSXMLElement *outlineElement = [NSXMLElement elementWithName: RKDOCXTextEffectsOutlinePropertyName];
		[properties addObject: outlineElement];
	}
}

+ (void)checkForShadowInAttributes:(NSDictionary *)attributes addToProperties:(NSMutableArray *)properties
{
	if (attributes[RKShadowAttributeName]) {
		NSXMLElement *shadowElement = [NSXMLElement elementWithName: RKDOCXTextEffectsShadowPropertyName];
		[properties addObject: shadowElement];
	}
}

+ (void)checkForStrikethroughInAttributes:(NSDictionary *)attributes addToProperties:(NSMutableArray *)properties
{
	NSNumber *strikethroughAttribute = attributes[RKStrikethroughStyleAttributeName];
	if (strikethroughAttribute) {
		NSXMLElement *strikethroughElement = [NSXMLElement elementWithName:RKDOCXTextEffectsSingleStrikethroughPropertyName];
		[properties addObject: strikethroughElement];
	}
}

+ (void)checkForUnderlineInAttributes:(NSDictionary *)attributes addToProperties:(NSMutableArray *)properties
{
	NSNumber *underlineAttribute = attributes[RKUnderlineStyleAttributeName];
	if (underlineAttribute) {
		NSXMLElement *underlineElement = [NSXMLElement elementWithName:RKDOCXTextEffectsUnderlinePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue:RKDOCXTextEffectsSingleUnderlineName]]];
		NSColor *underlineColorAttribute = attributes[RKUnderlineColorAttributeName];
		if (underlineColorAttribute) {
			NSString *underlineColor = [self.class hexValueOfNSColor: attributes[RKUnderlineColorAttributeName]];
			[underlineElement addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsUnderlineColorName stringValue:underlineColor]];
		}
		[properties addObject: underlineElement];
	}
}

+ (void)checkForSuperscriptInAttributes:(NSDictionary *)attributes addToProperties:(NSMutableArray *)properties
{
	NSInteger superscriptAttribute = [attributes[RKSuperscriptAttributeName] integerValue];
	if ([attributes[RKSuperscriptAttributeName] integerValue] != 0) {
		NSString *superscriptValue = (superscriptAttribute < 0) ? RKDOCXTextEffectsSubscriptName : RKDOCXTextEffectsSuperscriptName;
		NSXMLElement *superscriptElement = [NSXMLElement elementWithName:RKDOCXTextEffectsSuperscriptPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue:superscriptValue]]];
		[properties addObject: superscriptElement];
	}
}

+ (NSString *)hexValueOfNSColor:(NSColor *)color
{
	CGFloat redComponent, greenComponent, blueComponent;
	
	[color getRed:&redComponent green:&greenComponent blue:&blueComponent alpha:NULL];
	
	uint32_t hexValue = (  (((int)round(redComponent   * 255)) << 16)
						 + (((int)round(greenComponent * 255)) << 8)
						 + (((int)round(blueComponent  * 255)) << 0));
	
	return [NSString stringWithFormat: @"%06x", hexValue];
}

@end
