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
NSString *RKDOCXTextEffectsSupersctiptName					= @"superscript";
NSString *RKDOCXTextEffectsSuperscriptPropertyName			= @"w:vertAlign";
NSString *RKDOCXTextEffectsUnderlineColorName				= @"w:color";
NSString *RKDOCXTextEffectsUnderlinePropertyName			= @"w:u";

NSInteger RKUnderlineStyleMask		= 0x0F;
NSInteger RKUnderlinePatternMask	= 0x0F00;


@implementation RKDOCXTextEffectsWriter

+ (NSArray *)runPropertiesForAttributes:(NSDictionary *)attributes
{
	NSMutableArray *properties = [NSMutableArray new];
	
	// Font color
	NSColor *fontColorAttribute = attributes[RKForegroundColorAttributeName];
	if (fontColorAttribute) {
		NSString *fontColor = [self.class hexValueOfNSColor: fontColorAttribute];
		
		NSXMLElement *fontColorElement = [NSXMLElement elementWithName:RKDOCXTextEffectsColorPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue:fontColor]]];
		
		[properties addObject: fontColorElement];
	}
	
	// Outline
	if ([attributes[RKStrokeWidthAttributeName] integerValue] > 0) {
		NSXMLElement *outlineElement = [NSXMLElement elementWithName: RKDOCXTextEffectsOutlinePropertyName];
		
		[properties addObject: outlineElement];
	}
	
	// Shadow
	if (attributes[RKShadowAttributeName]) {
		NSXMLElement *shadowElement = [NSXMLElement elementWithName: RKDOCXTextEffectsShadowPropertyName];
		
		[properties addObject: shadowElement];
	}
	
	// Strikethrough
	NSInteger strikethroughAttribute = [attributes[RKStrikethroughStyleAttributeName] integerValue];
	if ((strikethroughAttribute == RKUnderlineStyleSingle) || (strikethroughAttribute == RKUnderlineStyleThick)) {
		NSXMLElement *strikethroughElement = [NSXMLElement elementWithName: RKDOCXTextEffectsSingleStrikethroughPropertyName];
		[properties addObject: strikethroughElement];
	} else if (strikethroughAttribute == RKUnderlineStyleDouble) {
		NSXMLElement *strikethroughElement = [NSXMLElement elementWithName: RKDOCXTextEffectsDoubleStrikethroughPropertyName];
		[properties addObject: strikethroughElement];
	}
	
	// Underline
	NSNumber *underlineAttribute = attributes[RKUnderlineStyleAttributeName];
	if (underlineAttribute) {
		NSString *underlineColor = [self.class hexValueOfNSColor: attributes[RKUnderlineColorAttributeName]];
		
		NSXMLElement *underlineElement = [NSXMLElement elementWithName:RKDOCXTextEffectsUnderlinePropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue:RKDOCXTextEffectsSingleUnderlineName], [NSXMLElement attributeWithName:RKDOCXTextEffectsUnderlineColorName stringValue:underlineColor]]];
		
		[properties addObject: underlineElement];
	}
	
	// Subscript/Superscript
	NSInteger superscriptAttribute = [attributes[RKSuperscriptAttributeName] integerValue];
	if (superscriptAttribute < 0) {
		NSXMLElement *subscriptElement = [NSXMLElement elementWithName:RKDOCXTextEffectsSuperscriptPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue:RKDOCXTextEffectsSubscriptName]]];
		[properties addObject: subscriptElement];
	} else if (superscriptAttribute > 0) {
		NSXMLElement *superscriptElement = [NSXMLElement elementWithName:RKDOCXTextEffectsSuperscriptPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXRunAttributePropertyValueName stringValue:RKDOCXTextEffectsSupersctiptName]]];
		[properties addObject: superscriptElement];
	}
	
	return properties;
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
