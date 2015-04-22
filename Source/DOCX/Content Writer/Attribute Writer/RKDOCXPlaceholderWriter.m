//
//  RKDOCXPlaceholderWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

NSString *RKDOCXPlaceholderBreakAttributeName			= @"w:type";
NSString *RKDOCXPlaceholderBreakElementName				= @"w:br";
NSString *RKDOCXPlaceholderInstructionAttributeName		= @"w:instr";
NSString *RKDOCXPlaceholderLineBreakAttributeValue		= @"textWrapping";
NSString *RKDOCXPlaceholderPageBreakAttributeValue		= @"page";
NSString *RKDOCXPlaceholderPageNumberAttributeValue		= @"PAGE";
NSString *RKDOCXPlaceholderSimpleFieldElementName		= @"w:fldSimple";
NSString *RKDOCXPlaceholderTabStopElementName			= @"w:tab";

NSString *RKDOCXBreakAttributeName						= @"RKDOCXBreak";

#import "RKDOCXPlaceholderWriter.h"

#import "RKDOCXRunWriter.h"

@implementation RKDOCXPlaceholderWriter

+ (NSXMLElement *)placeholderElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![attributes[RKPlaceholderAttributeName] isEqual: @(RKPlaceholderPageNumber)])
		return nil;
	
	NSXMLElement *runElement = [RKDOCXRunWriter runElementForAttributes:nil contentElement:[RKDOCXRunWriter textElementWithStringValue:@"1"] usingContext:context];
	return [NSXMLElement elementWithName:RKDOCXPlaceholderSimpleFieldElementName children:@[runElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXPlaceholderInstructionAttributeName stringValue:RKDOCXPlaceholderPageNumberAttributeValue]]];
}

+ (NSXMLElement *)runElementWithBreak:(RKDOCXBreakType)type
{
	NSString *attributeValue;
	switch (type) {
		case RKDOCXPageBreak:
			attributeValue = RKDOCXPlaceholderPageBreakAttributeValue;
			break;
			
		case RKDOCXLineBreak:
			attributeValue = RKDOCXPlaceholderLineBreakAttributeValue;
			break;
			
		case RKDOCXTabStop:
			return [RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName: RKDOCXPlaceholderTabStopElementName] usingContext:nil];
			
		default:
			return nil;
	}
	
	NSXMLElement *breakElement = [NSXMLElement elementWithName:RKDOCXPlaceholderBreakElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXPlaceholderBreakAttributeName stringValue:attributeValue]]];
	return [RKDOCXRunWriter runElementForAttributes:nil contentElement:breakElement usingContext:nil];
}

@end
