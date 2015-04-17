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

@implementation RKDOCXPlaceholderWriter

+ (NSXMLElement *)placeholder:(NSNumber *)placeholder withRunElementName:(NSString *)runElementName textElementName:(NSString *)textElementName
{
	if (![placeholder isEqual: @(RKPlaceholderPageNumber)])
		return nil;
	
	NSXMLElement *textElement = [NSXMLElement elementWithName:textElementName stringValue:@"1"];
	NSXMLElement *runElement = [NSXMLElement elementWithName:runElementName children:@[textElement] attributes:nil];
	return [NSXMLElement elementWithName:RKDOCXPlaceholderSimpleFieldElementName children:@[runElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXPlaceholderInstructionAttributeName stringValue:RKDOCXPlaceholderPageNumberAttributeValue]]];
}

@end
