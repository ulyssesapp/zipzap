//
//  RKDOCXListWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 24.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXListItemWriter.h"

NSString *RKDOCXListItemNumberingIdentifierElementName	= @"w:numId";
NSString *RKDOCXListItemNumberingPropertyElementName	= @"w:numPr";
NSString *RKDOCXListItemLevelElementName				= @"w:ilvl";

@implementation RKDOCXListItemWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	RKListItem *listItem = attributes[RKListItemAttributeName];
	
	if (!listItem)
		return nil;
	
	// List level
	NSXMLElement *levelAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@(listItem.indentationLevel).stringValue];
	NSXMLElement *levelElement = [NSXMLElement elementWithName:RKDOCXListItemLevelElementName children:nil attributes:@[levelAttribute]];
	
	// List style
	NSXMLElement *numberingIdAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@([context indexForListStyle: listItem.listStyle]).stringValue];
	NSXMLElement *numberingIdElement = [NSXMLElement elementWithName:RKDOCXListItemNumberingIdentifierElementName children:nil attributes:@[numberingIdAttribute]];
	
	return @[[NSXMLElement elementWithName:RKDOCXListItemNumberingPropertyElementName children:@[levelElement, numberingIdElement] attributes:nil]];
}

@end
