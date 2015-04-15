//
//  RKDOCXSectionWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXSectionWriter.h"

// Elements
NSString *RKDOCXSectionColumnElementName							= @"w:cols";
NSString *RKDOCXSectionPageMarginElementName						= @"w:pgMar";
NSString *RKDOCXSectionPageNumberTypeElementName					= @"w:pgNumType";
NSString *RKDOCXSectionPageSizeElementName							= @"w:pgSz";
NSString *RKDOCXSectionPropertiesElementName						= @"w:sectPr";

// Attributes
NSString *RKDOCXSectionColumnCountAttributeName						= @"w:num";
NSString *RKDOCXSectionColumeEqualWidthAttributeName				= @"w:equalWidth";
NSString *RKDOCXSectionColumnSpacingAttributeName					= @"w:space";
NSString *RKDOCXSectionPageMarginBottomAttributeName				= @"w:bottom";
NSString *RKDOCXSectionPageMarginFooterAttributeName				= @"w:footer";
NSString *RKDOCXSectionPageMarginHeaderAttributeName				= @"w:header";
NSString *RKDOCXSectionPageMarginLeftAttributeName					= @"w:left";
NSString *RKDOCXSectionPageMarginRightAttributeName					= @"w:right";
NSString *RKDOCXSectionPageMarginTopAttributeName					= @"w:top";
NSString *RKDOCXSectionPageNumberFormatAttributeName				= @"w:fmt";
NSString *RKDOCXSectionPageSizeHeightAttributeName					= @"w:h";
NSString *RKDOCXSectionPageSizeOrientationAttributeName				= @"w:orient";
NSString *RKDOCXSectionPageSizeWidthAttributeName					= @"w:w";
NSString *RKDOCXSectionStartPageAttributeName						= @"w:start";

// Attribute Values
NSString *RKDOCXSectionPageNumberLowerLetterAttributeValue			= @"lowerLetter";
NSString *RKDOCXSectionPageNumberLowerRomanAttributeValue			= @"lowerRoman";
NSString *RKDOCXSectionPageNumberUpperLetterAttributeValue			= @"upperLetter";
NSString *RKDOCXSectionPageNumberUpperRomanAttributeValue			= @"upperRoman";
NSString *RKDOCXSectionPageSizeOrientationLandscapeAttributeValue	= @"landscape";
NSString *RKDOCXSectionPageSizeOrientationPortraitAttributeValue	= @"portrait";

@implementation RKDOCXSectionWriter

+ (NSArray *)sectionElementsUsingContext:(RKDOCXConversionContext *)context
{
	RKSection *lastSection = context.document.sections.lastObject;
	NSArray *lastSectionParagraphs = [RKDOCXAttributedStringWriter processAttributedString:lastSection.content usingContext:context];
	NSXMLElement *sectionProperties = [NSXMLElement elementWithName: RKDOCXSectionPropertiesElementName];
	
	// Columns (§17.6.4)
	NSXMLElement *columnProperty = [self columnPropertyForSection: lastSection];
	if (columnProperty)
		[sectionProperties addChild: columnProperty];
	
	// Page Number and Index Of First Page (§17.6.12)
	NSXMLElement *pageNumberTypeProperty = [self pageNumberTypePropertyForSection: lastSection];
	if (pageNumberTypeProperty)
		[sectionProperties addChild: pageNumberTypeProperty];
	
	// Document settings repeated in each section
	// Page Size and Page Orientation (§17.6.13)
	NSXMLElement *pageSizeProperty = [self pageSizePropertyForDocument: context.document];
	if (pageSizeProperty)
		[sectionProperties addChild: pageSizeProperty];
	
	// Page Margin (§17.6.11)
	NSXMLElement *pageMarginProperty = [self pageMarginPropertyForDocument: context.document];
	if (pageMarginProperty)
		[sectionProperties addChild: pageMarginProperty];
	
	if (sectionProperties.childCount == 0)
		return lastSectionParagraphs;
	
	return [lastSectionParagraphs arrayByAddingObject: sectionProperties];
}

+ (NSXMLElement *)columnPropertyForSection:(RKSection *)section
{
	if (section.numberOfColumns < 2)
		return nil;
	
	NSXMLElement *numberOfColumnsAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumnCountAttributeName stringValue:@(section.numberOfColumns).stringValue];
	NSXMLElement *equalWidthAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumeEqualWidthAttributeName stringValue:@"1"];
	NSXMLElement *spacingAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumnSpacingAttributeName stringValue:@(RKPointsToTwips(section.columnSpacing)).stringValue];
	
	return [NSXMLElement elementWithName:RKDOCXSectionColumnElementName children:nil attributes:@[numberOfColumnsAttribute, equalWidthAttribute, spacingAttribute]];
}

+ (NSXMLElement *)pageNumberTypePropertyForSection:(RKSection *)section
{
	if ((!section.indexOfFirstPage || section.indexOfFirstPage == NSNotFound) && (!section.pageNumberingStyle || section.pageNumberingStyle == RKPageNumberingDecimal))
		return nil;
	
	NSXMLElement *pageNumberTypeProperty = [NSXMLElement elementWithName:RKDOCXSectionPageNumberTypeElementName];
	
	if (section.indexOfFirstPage != NSNotFound) {
		NSXMLElement *startPageAttribute = [NSXMLElement attributeWithName:RKDOCXSectionStartPageAttributeName stringValue:@(section.indexOfFirstPage).stringValue];
		[pageNumberTypeProperty addAttribute: startPageAttribute];
	}
	
	NSString *pageNumberFormatAttributeValue;
	switch (section.pageNumberingStyle) {
		case RKPageNumberingRomanLowerCase:
			pageNumberFormatAttributeValue = RKDOCXSectionPageNumberLowerRomanAttributeValue;
			break;
			
		case RKPageNumberingRomanUpperCase:
			pageNumberFormatAttributeValue = RKDOCXSectionPageNumberUpperRomanAttributeValue;
			break;
			
		case RKPageNumberingAlphabeticLowerCase:
			pageNumberFormatAttributeValue = RKDOCXSectionPageNumberLowerLetterAttributeValue;
			break;
			
		case RKPageNumberingAlphabeticUpperCase:
			pageNumberFormatAttributeValue = RKDOCXSectionPageNumberUpperLetterAttributeValue;
			break;
			
		default:
			break;
	}
	if (pageNumberFormatAttributeValue)
		[pageNumberTypeProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXSectionPageNumberFormatAttributeName stringValue:pageNumberFormatAttributeValue]];
	
	return pageNumberTypeProperty;
}

+ (NSXMLElement *)pageSizePropertyForDocument:(RKDocument *)document
{
	NSXMLElement *widthAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeWidthAttributeName stringValue:@(RKPointsToTwips(document.pageSize.width)).stringValue];
	NSXMLElement *heightAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeHeightAttributeName stringValue:@(RKPointsToTwips(document.pageSize.height)).stringValue];
	NSXMLElement *orientationAttribute;
	if (document.pageOrientation == RKPageOrientationLandscape) {
		orientationAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeOrientationAttributeName stringValue:RKDOCXSectionPageSizeOrientationLandscapeAttributeValue];
	} else {
		orientationAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeOrientationAttributeName stringValue:RKDOCXSectionPageSizeOrientationPortraitAttributeValue];
	}
	
	return [NSXMLElement elementWithName: RKDOCXSectionPageSizeElementName children:nil attributes:@[widthAttribute, heightAttribute, orientationAttribute]];
}

+ (NSXMLElement *)pageMarginPropertyForDocument:(RKDocument *)document
{
	NSXMLElement *headerAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginHeaderAttributeName stringValue:@(RKPointsToTwips(document.headerSpacingBefore)).stringValue];
	NSXMLElement *footerAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginFooterAttributeName stringValue:@(RKPointsToTwips(document.footerSpacingAfter)).stringValue];
	// There is no headerAfter or footerBefore margin in DOCX.
	
	NSXMLElement *topAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginTopAttributeName stringValue:@(RKPointsToTwips(document.pageInsets.top)).stringValue];
	NSXMLElement *bottomAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginBottomAttributeName stringValue:@(RKPointsToTwips(document.pageInsets.bottom)).stringValue];
	
	NSString *innerMargin = @(RKPointsToTwips(document.pageInsets.inner)).stringValue;
	NSString *outerMargin = @(RKPointsToTwips(document.pageInsets.outer)).stringValue;

	NSXMLElement *leftAttribute;
	NSXMLElement *rightAttribute;
	
	if (document.pageBinding == RKPageBindingRight) {
		leftAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginLeftAttributeName stringValue:outerMargin];
		rightAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginRightAttributeName stringValue:innerMargin];
	} else {
		leftAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginLeftAttributeName stringValue:innerMargin];
		rightAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginRightAttributeName stringValue:outerMargin];
	}
	
	return [NSXMLElement elementWithName:RKDOCXSectionPageMarginElementName children:nil attributes:@[headerAttribute, footerAttribute, topAttribute, leftAttribute, rightAttribute, bottomAttribute]];
}

@end
