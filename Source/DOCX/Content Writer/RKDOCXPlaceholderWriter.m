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

+ (NSXMLElement *)placeholderElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![attributes[RKPlaceholderAttributeName] isEqual: @(RKPlaceholderPageNumber)])
		return nil;
	
	NSXMLElement *runElement = [RKDOCXRunWriter runElementForAttributes:nil contentElement:[RKDOCXRunWriter textElementWithStringValue:@"1"] usingContext:context];
	return [NSXMLElement elementWithName:RKDOCXPlaceholderSimpleFieldElementName children:@[runElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXPlaceholderInstructionAttributeName stringValue:RKDOCXPlaceholderPageNumberAttributeValue]]];
}

@end
