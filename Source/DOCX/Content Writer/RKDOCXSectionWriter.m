//
//  RKDOCXSectionWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXSectionWriter.h"

NSString *RKDOCXSectionColumnCountAttributeName			= @"w:num";
NSString *RKDOCXSectionColumeEqualWidthAttributeName	= @"w:equalWidth";
NSString *RKDOCXSectionColumnPropertyName				= @"w:cols";
NSString *RKDOCXSectionColumnSpacingAttributeName		= @"w:space";
NSString *RKDOCXSectionPageNumberFormatAttributeName	= @"w:fmt";
NSString *RKDOCXSectionPageNumberLowerLetterName		= @"lowerLetter";
NSString *RKDOCXSectionPageNumberLowerRomanName			= @"lowerRoman";
NSString *RKDOCXSectionPageNumberTypePropertyName		= @"w:pgNumType";
NSString *RKDOCXSectionPageNumberUpperLetterName		= @"upperLetter";
NSString *RKDOCXSectionPageNumberUpperRomanName			= @"upperRoman";
NSString *RKDOCXSectionPropertiesElementName			= @"w:sectPr";
NSString *RKDOCXSectionStartPageAttributeName			= @"w:start";

@implementation RKDOCXSectionWriter

+ (NSArray *)sectionsUsingContext:(RKDOCXConversionContext *)context
{
	RKSection *lastSection = context.document.sections.lastObject;
	NSArray *lastSectionParagraphs = [RKDOCXAttributedStringWriter processAttributedString:lastSection.content usingContext:context];
	NSXMLElement *sectionProperties = [NSXMLElement elementWithName: RKDOCXSectionPropertiesElementName];
	
	// Columns
	NSXMLElement *columnProperty = [self columnPropertyForSection: lastSection];
	if (columnProperty)
		[sectionProperties addChild: columnProperty];
	
	// Page Number and Index Of First Page
	NSXMLElement *pageNumberTypeProperty = [self pageNumberTypePropertyForSection: lastSection];
	if (pageNumberTypeProperty)
		[sectionProperties addChild: pageNumberTypeProperty];
	
	if (sectionProperties.childCount == 0)
		return lastSectionParagraphs;
	
	return [lastSectionParagraphs arrayByAddingObject: sectionProperties];
}

+ (NSXMLElement *)columnPropertyForSection:(RKSection *)section
{
	if (section.numberOfColumns < 2)
		return nil;
	
	NSXMLElement *numberOfColumnsAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumnCountAttributeName stringValue:[NSString stringWithFormat: @"%lu", section.numberOfColumns]];
	NSXMLElement *equalWidthAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumeEqualWidthAttributeName stringValue:@"1"];
	NSXMLElement *spacingAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumnSpacingAttributeName stringValue:@(RKPointsToTwips(section.columnSpacing)).stringValue];
	NSXMLElement *columnProperty = [NSXMLElement elementWithName:RKDOCXSectionColumnPropertyName children:nil attributes:@[numberOfColumnsAttribute, equalWidthAttribute, spacingAttribute]];
	
	return columnProperty;
}

+ (NSXMLElement *)pageNumberTypePropertyForSection:(RKSection *)section
{
	if ((!section.indexOfFirstPage || section.indexOfFirstPage == NSNotFound) && (!section.pageNumberingStyle || section.pageNumberingStyle == RKPageNumberingDecimal))
		return nil;
	
	NSXMLElement *pageNumberTypeProperty = [NSXMLElement elementWithName:RKDOCXSectionPageNumberTypePropertyName];
	
	if (section.indexOfFirstPage != NSNotFound) {
		NSXMLElement *startPageAttribute = [NSXMLElement attributeWithName:RKDOCXSectionStartPageAttributeName stringValue:[NSString stringWithFormat: @"%lu", section.indexOfFirstPage]];
		[pageNumberTypeProperty addAttribute: startPageAttribute];
	}
	
	NSXMLElement *pageNumberFormatAttribute;
	switch (section.pageNumberingStyle) {
		case RKPageNumberingRomanLowerCase:
			pageNumberFormatAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageNumberFormatAttributeName stringValue:RKDOCXSectionPageNumberLowerRomanName];
			break;
			
		case RKPageNumberingRomanUpperCase:
			pageNumberFormatAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageNumberFormatAttributeName stringValue:RKDOCXSectionPageNumberUpperRomanName];
			break;
			
		case RKPageNumberingAlphabeticLowerCase:
			pageNumberFormatAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageNumberFormatAttributeName stringValue:RKDOCXSectionPageNumberLowerLetterName];
			break;
			
		case RKPageNumberingAlphabeticUpperCase:
			pageNumberFormatAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageNumberFormatAttributeName stringValue:RKDOCXSectionPageNumberUpperLetterName];
			break;
			
		default:
			break;
	}
	if (pageNumberFormatAttribute)
		[pageNumberTypeProperty addAttribute: pageNumberFormatAttribute];
	
	return pageNumberTypeProperty;
}

@end
