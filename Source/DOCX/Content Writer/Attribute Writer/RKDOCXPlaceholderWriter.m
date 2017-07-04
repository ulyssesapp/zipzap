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
NSString *RKDOCXPlaceholderPageNumberAttributeValue		= @"PAGE \\* MERGEFORMAT";
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
	
	NSXMLElement *runElement = [RKDOCXRunWriter runElementForAttributes:attributes contentElement:[RKDOCXRunWriter textElementOfType:RKDOCXRunStandardType withStringValue:@"1"] usingContext:context];
	return [NSXMLElement elementWithName:RKDOCXPlaceholderSimpleFieldElementName children:@[runElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXPlaceholderInstructionAttributeName stringValue:RKDOCXPlaceholderPageNumberAttributeValue]]];
}

+ (NSXMLElement *)runElementWithSymbolicCharacter:(RKDOCXSymbolicCharacterType)type attributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;
{
	NSString *attributeValue;
	switch (type) {
		case RKDOCXPageBreakCharacter:
			attributeValue = RKDOCXPlaceholderPageBreakAttributeValue;
			break;
			
		case RKDOCXLineBreakCharacter:
			attributeValue = RKDOCXPlaceholderLineBreakAttributeValue;
			break;
			
		case RKDOCXTabStopCharacter:
			return [RKDOCXRunWriter runElementForAttributes:attributes contentElement:[NSXMLElement elementWithName: RKDOCXPlaceholderTabStopElementName] usingContext:context];
	}
	
	NSXMLElement *breakElement = [NSXMLElement elementWithName:RKDOCXPlaceholderBreakElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXPlaceholderBreakAttributeName stringValue:attributeValue]]];
	return [RKDOCXRunWriter runElementForAttributes:attributes contentElement:breakElement usingContext:context];
}

@end
