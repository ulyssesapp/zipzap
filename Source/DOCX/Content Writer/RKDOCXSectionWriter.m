//
//  RKDOCXSectionWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXSectionWriter.h"

#import "RKDOCXAttributedStringWriter.h"
#import "RKDOCXHeaderFooterWriter.h"
#import "RKDOCXParagraphWriter.h"
#import "RKDOCXSettingsWriter.h"

#import "NSXMLElement+IntegerValueConvenience.h"


// Elements
NSString *RKDOCXSectionColumnElementName							= @"w:cols";
NSString *RKDOCXSectionFooterReferenceElementName					= @"w:footerReference";
NSString *RKDOCXSectionHeaderReferenceElementName					= @"w:headerReference";
NSString *RKDOCXSectionPageMarginElementName						= @"w:pgMar";
NSString *RKDOCXSectionPageNumberTypeElementName					= @"w:pgNumType";
NSString *RKDOCXSectionPageSizeElementName							= @"w:pgSz";
NSString *RKDOCXSectionPropertiesElementName						= @"w:sectPr";
NSString *RKDOCXSectionTitlePageElementName							= @"w:titlePg";

// Attributes
NSString *RKDOCXSectionColumnCountAttributeName						= @"w:num";
NSString *RKDOCXSectionColumeEqualWidthAttributeName				= @"w:equalWidth";
NSString *RKDOCXSectionColumnSpacingAttributeName					= @"w:space";
NSString *RKDOCXSectionIdentifierAttributeName						= @"r:id";
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
NSString *RKDOCXSectionTypeAttributeName							= @"w:type";

// Attribute Values
NSString *RKDOCXSectionPageNumberLowerLetterAttributeValue			= @"lowerLetter";
NSString *RKDOCXSectionPageNumberLowerRomanAttributeValue			= @"lowerRoman";
NSString *RKDOCXSectionPageNumberUpperLetterAttributeValue			= @"upperLetter";
NSString *RKDOCXSectionPageNumberUpperRomanAttributeValue			= @"upperRoman";
NSString *RKDOCXSectionPageSizeOrientationLandscapeAttributeValue	= @"landscape";
NSString *RKDOCXSectionPageSizeOrientationPortraitAttributeValue	= @"portrait";
NSString *RKDOCXSectionTypeDefaultAttriuteValue						= @"default";
NSString *RKDOCXSectionTypeEvenAttributeValue						= @"even";
NSString *RKDOCXSectionTypeFirstAttributeValue						= @"first";

@implementation RKDOCXSectionWriter

+ (NSArray *)sectionElementsUsingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *paragraphs = [NSMutableArray new];
	
	for (RKSection *section in context.document.sections) {
		NSXMLElement *sectionProperties = [NSXMLElement elementWithName: RKDOCXSectionPropertiesElementName];
		
		// Columns (§17.6.4)
		NSXMLElement *columnProperty = [self columnPropertyForSection: section];
		if (columnProperty)
			[sectionProperties addChild: columnProperty];
		
		// Page Number and Index Of First Page (§17.6.12)
		NSXMLElement *pageNumberTypeProperty = [self pageNumberTypePropertyForSection: section];
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
		
		// Footnote Properties
		NSXMLElement *footnoteProperties = [RKDOCXSettingsWriter footnotePropertiesFromDocument:context.document isEndnote:NO];
		if (footnoteProperties)
			[sectionProperties addChild: footnoteProperties];
		
		// Endnote Properties
		NSXMLElement *endnoteProperties = [RKDOCXSettingsWriter footnotePropertiesFromDocument:context.document isEndnote:YES];
		if (endnoteProperties)
			[sectionProperties addChild: endnoteProperties];
		
		// Headers and Footers
		// DOCX requires a "titlePg" element when using a different header or footer for first pages. See ISO 29500-1:2012: §17.10.6.
		if (!(section.hasSingleHeaderForAllPages && section.hasSingleFooterForAllPages) && ([section headerForPage: RKPageSelectionFirst] || [section footerForPage: RKPageSelectionFirst]))
			[sectionProperties addChild: [NSXMLElement elementWithName: RKDOCXSectionTitlePageElementName]];
		
		// Create a reference for each separate Header
		[section enumerateHeadersUsingBlock: ^(RKPageSelectionMask pageSelector, NSAttributedString *header) {
			[RKDOCXHeaderFooterWriter buildPageElement:RKDOCXHeader withIndex:++context.headerCount forAttributedString:header usingContext:context];
			[sectionProperties addChild: [self sectionPropertyElementForPageElement:RKDOCXHeader withAttributedString:header forPageSelector:pageSelector usingContext:context]];
		}];
		
		// Create a reference for each separate Footer
		[section enumerateFootersUsingBlock: ^(RKPageSelectionMask pageSelector, NSAttributedString *footer) {
			[RKDOCXHeaderFooterWriter buildPageElement:RKDOCXFooter withIndex:++context.footerCount forAttributedString:footer usingContext:context];
			[sectionProperties addChild: [self sectionPropertyElementForPageElement:RKDOCXFooter withAttributedString:footer forPageSelector:pageSelector usingContext:context]];
		}];
		
		NSArray *sectionParagraphs = [RKDOCXAttributedStringWriter processAttributedString:section.content usingContext:context];
		
		// If this is the last section, put it after the last paragraph. In any other case, add it to the last paragraph’s properties. See ISO 29500-1:2012: §17.6.18 and §17.6.17 (Section Properties and Final Section Properties).
		if (![section isEqual: context.document.sections.lastObject])
			sectionParagraphs = [sectionParagraphs arrayByAddingObject: [RKDOCXParagraphWriter paragraphElementWithProperties:@[sectionProperties] runElements:nil]];
		else
			sectionParagraphs = [sectionParagraphs arrayByAddingObject: sectionProperties];
		
		[paragraphs addObjectsFromArray: sectionParagraphs];
	}
	
	return paragraphs;
}

+ (NSXMLElement *)columnPropertyForSection:(RKSection *)section
{
	if (section.numberOfColumns < 2)
		return nil;
	
	NSXMLElement *numberOfColumnsAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumnCountAttributeName integerValue:section.numberOfColumns];
	NSXMLElement *equalWidthAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumeEqualWidthAttributeName stringValue:@"1"];
	NSXMLElement *spacingAttribute = [NSXMLElement attributeWithName:RKDOCXSectionColumnSpacingAttributeName integerValue:RKPointsToTwips(section.columnSpacing)];
	
	return [NSXMLElement elementWithName:RKDOCXSectionColumnElementName children:nil attributes:@[numberOfColumnsAttribute, equalWidthAttribute, spacingAttribute]];
}

+ (NSXMLElement *)pageNumberTypePropertyForSection:(RKSection *)section
{
	if ((!section.indexOfFirstPage || section.indexOfFirstPage == NSNotFound) && (!section.pageNumberingStyle || section.pageNumberingStyle == RKPageNumberingDecimal))
		return nil;
	
	NSXMLElement *pageNumberTypeProperty = [NSXMLElement elementWithName:RKDOCXSectionPageNumberTypeElementName];
	
	if (section.indexOfFirstPage != NSNotFound) {
		NSXMLElement *startPageAttribute = [NSXMLElement attributeWithName:RKDOCXSectionStartPageAttributeName integerValue:section.indexOfFirstPage];
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
	NSXMLElement *widthAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeWidthAttributeName integerValue:RKPointsToTwips(document.pageSize.width)];
	NSXMLElement *heightAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageSizeHeightAttributeName integerValue:RKPointsToTwips(document.pageSize.height)];
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
	NSXMLElement *headerAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginHeaderAttributeName integerValue:RKPointsToTwips(document.headerSpacingBefore)];
	NSXMLElement *footerAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginFooterAttributeName integerValue:RKPointsToTwips(document.footerSpacingAfter)];
	// There is no headerAfter or footerBefore margin in DOCX.
	
	NSXMLElement *topAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginTopAttributeName integerValue:RKPointsToTwips(document.pageInsets.top)];
	NSXMLElement *bottomAttribute = [NSXMLElement attributeWithName:RKDOCXSectionPageMarginBottomAttributeName integerValue:RKPointsToTwips(document.pageInsets.bottom)];
	
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

+ (NSXMLElement *)sectionPropertyElementForPageElement:(RKDOCXPageElementType)pageElement withAttributedString:(NSAttributedString *)string forPageSelector:(RKPageSelectionMask)pageSelector usingContext:(RKDOCXConversionContext *)context
{
	NSString *referenceElementName;
	NSUInteger index;
	switch (pageElement) {
		case RKDOCXHeader:
			referenceElementName = RKDOCXSectionHeaderReferenceElementName;
			index = context.headerCount;
			break;
			
		case RKDOCXFooter:
			referenceElementName = RKDOCXSectionFooterReferenceElementName;
			index = context.footerCount;
			break;
	}
	
	NSString *typeAttribute;
	switch (pageSelector) {
		case RKPageSelectionFirst:
			typeAttribute = RKDOCXSectionTypeFirstAttributeValue;
			break;
			
		case RKPageSelectionLeft:
			typeAttribute = RKDOCXSectionTypeEvenAttributeValue;
			context.evenAndOddHeaders = YES;
			break;
			
		case RKPageSelectionRight:
		case RKPageSelectorAll:
			typeAttribute = RKDOCXSectionTypeDefaultAttriuteValue;
			break;
	}
	
	NSXMLElement *referenceElement = [NSXMLElement elementWithName: referenceElementName];
	NSString *rId = [NSString stringWithFormat: @"rId%lu", [context indexForRelationshipWithTarget:[RKDOCXHeaderFooterWriter filenameForPageElement:pageElement withIndex:index] andType:nil]];
	[referenceElement addAttribute: [NSXMLElement attributeWithName:RKDOCXSectionIdentifierAttributeName stringValue:rId]];
	[referenceElement addAttribute: [NSXMLElement attributeWithName:RKDOCXSectionTypeAttributeName stringValue:typeAttribute]];
	
	return referenceElement;
}

@end
