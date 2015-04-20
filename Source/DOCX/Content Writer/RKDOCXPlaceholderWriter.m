//
//  RKDOCXPlaceholderWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

NSString *RKDOCXPlaceholderInstructionAttributeName			= @"w:instr";
NSString *RKDOCXPlaceholderPageNumberAttributeValue			= @"PAGE";
NSString *RKDOCXPlaceholderSimpleFieldElementName			= @"w:fldSimple";

#import "RKDOCXPlaceholderWriter.h"

#import "RKDOCXRunWriter.h"

@implementation RKDOCXPlaceholderWriter

+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes
{
	if (![attributes[RKPlaceholderAttributeName] isEqual: @(RKPlaceholderPageNumber)])
		return nil;
	
	NSXMLElement *textElement = [NSXMLElement elementWithName:RKDOCXRunTextElementName stringValue:@"1"];
	NSXMLElement *runElement = [NSXMLElement elementWithName:RKDOCXRunElementName children:@[textElement] attributes:nil];
	return [NSXMLElement elementWithName:RKDOCXPlaceholderSimpleFieldElementName children:@[runElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXPlaceholderInstructionAttributeName stringValue:RKDOCXPlaceholderPageNumberAttributeValue]]];
}

@end
