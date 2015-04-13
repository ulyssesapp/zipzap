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
NSString *RKDOCXSectionPageMarginBottomAttributeName	= @"w:bottom";
NSString *RKDOCXSectionPageMarginFooterAttributeName	= @"w:footer";
NSString *RKDOCXSectionPageMarginHeaderAttributeName	= @"w:header";
NSString *RKDOCXSectionPageMarginLeftAttribute			= @"w:left";
NSString *RKDOCXSectionPageMarginPropertyName			= @"w:pgMar";
NSString *RKDOCXSectionPageMarginRightAttributeName		= @"w:right";
NSString *RKDOCXSectionPageMarginTopAttributeName		= @"w:top";
NSString *RKDOCXSectionPageNumberFormatAttributeName	= @"w:fmt";
NSString *RKDOCXSectionPageNumberLowerLetterName		= @"lowerLetter";
NSString *RKDOCXSectionPageNumberLowerRomanName			= @"lowerRoman";
NSString *RKDOCXSectionPageNumberTypePropertyName		= @"w:pgNumType";
NSString *RKDOCXSectionPageNumberUpperLetterName		= @"upperLetter";
NSString *RKDOCXSectionPageNumberUpperRomanName			= @"upperRoman";
NSString *RKDOCXSectionPageSizeHeightAttributeName		= @"w:h";
NSString *RKDOCXSectionPageSizeOrientationAttributeName	= @"w:orient";
NSString *RKDOCXSectionPageSizeOrientationLandscapeName	= @"landscape";
NSString *RKDOCXSectionPageSizeOrientationPortraitName	= @"portrait";
NSString *RKDOCXSectionPageSizePropertyName				= @"w:pgSz";
NSString *RKDOCXSectionPageSizeWidthAttributeName		= @"w:w";
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
	
	// Document settings repeated in each section
	// Page Size and Page Orientation
	NSXMLElement *pageSizeProperty = [self pageSizePropertyForDocument: context.document];
	if (pageSizeProperty)
		[sectionProperties addChild: pageSizeProperty];
	
	// Page Margin
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
	
	return [NSXMLElement elementWithName:RKDOCXSectionColumnPropertyName children:nil attributes:@[numberOfColumnsAttribute, equalWidthAttribute, spacingAttribute]];
}

+ (NSXMLElement *)pageNumberTypePropertyForSection:(RKSection *)section
{
	if ((!section.indexOfFirstPage || section.indexOfFirstPage == NSNotFound) && (!section.pageNumberingStyle || section.pageNumberingStyle == RKPageNumberingDecimal))
		return nil;
	
	NSXMLElement *pageNumberTypeProperty = [NSXMLElement elementWithName:RKDOCXSectionPageNumberTypePropertyName];
	
	if (section.indexOfFirstPage != NSNotFound) {
		NSXMLElement *startPageAttribute = [NSXMLElement attributeWithName:RKDOCXSectionStartPageAttributeName stringValue:@(section.indexOfFirstPage).stringValue];
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

+ (NSXMLElement *)pageSizePropertyForDocument:(RKDocument *)document
{
	NSXMLElement *widthAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeWidthAttributeName stringValue:@(RKPointsToTwips(document.pageSize.width)).stringValue];
	NSXMLElement *heightAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeHeightAttributeName stringValue:@(RKPointsToTwips(document.pageSize.height)).stringValue];
	NSXMLElement *orientationAttribute;
	if (document.pageOrientation == RKPageOrientationLandscape) {
		orientationAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeOrientationAttributeName stringValue:RKDOCXSectionPageSizeOrientationLandscapeName];
	} else {
		orientationAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeOrientationAttributeName stringValue:RKDOCXSectionPageSizeOrientationPortraitName];
	}
	
	return [NSXMLElement elementWithName: RKDOCXSectionPageSizePropertyName children:nil attributes:@[widthAttribute, heightAttribute, orientationAttribute]];
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
		leftAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginLeftAttribute stringValue:outerMargin];
		rightAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginRightAttributeName stringValue:innerMargin];
	} else {
		leftAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginLeftAttribute stringValue:innerMargin];
		rightAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginRightAttributeName stringValue:outerMargin];
	}
	
	return [NSXMLElement elementWithName:RKDOCXSectionPageMarginPropertyName children:nil attributes:@[headerAttribute, footerAttribute, topAttribute, leftAttribute, rightAttribute, bottomAttribute]];
}

@end
