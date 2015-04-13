//
//  RKDOCXSectionWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXSectionWriter.h"

NSString *RKDOCXSectionColumnPropertyName				= @"w:cols";
NSString *RKDOCXSectionColumnCountAttributeName			= @"w:num";
NSString *RKDOCXSectionColumeEqualWidthAttributeName	= @"w:equalWidth";
NSString *RKDOCXSectionPropertiesElementName			= @"w:sectPr";

@implementation RKDOCXSectionWriter

+ (NSArray *)sectionsUsingContext:(RKDOCXConversionContext *)context
{
	RKSection *lastSection = context.document.sections.lastObject;
	NSMutableArray *lastSectionParagraphs = [[RKDOCXAttributedStringWriter processAttributedString:lastSection.content usingContext:context] mutableCopy];
	NSXMLElement *sectionProperties = [NSXMLElement elementWithName: RKDOCXSectionPropertiesElementName];
	
	// Columns
	NSXMLElement *columnProperty = [self columnPropertyForSection: lastSection];
	if (columnProperty)
		[sectionProperties addChild: columnProperty];
	
	if (sectionProperties.children.count)
		[lastSectionParagraphs addObject: sectionProperties];
	
	return lastSectionParagraphs;
}

+ (NSXMLElement *)columnPropertyForSection:(RKSection *)section
{
	if (section.numberOfColumns < 2)
		return nil;
	
	NSXMLElement *numberOfColumnsAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumnCountAttributeName stringValue:[NSString stringWithFormat: @"%lu", section.numberOfColumns]];
	NSXMLElement *equalWidthAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumeEqualWidthAttributeName stringValue:@"1"];
	NSXMLElement *columnProperty = [NSXMLElement elementWithName:RKDOCXSectionColumnPropertyName children:nil attributes:@[numberOfColumnsAttribute, equalWidthAttribute]];
	
	return columnProperty;
}

@end
