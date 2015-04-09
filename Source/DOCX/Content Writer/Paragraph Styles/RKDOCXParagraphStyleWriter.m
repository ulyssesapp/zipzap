//
//  RKDOCXParagraphStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphStyleWriter.h"

NSString *RKDOCXParagraphStyleAlignmentPropertyName					= @"w:jc";
NSString *RKDOCXParagraphStyleBaseWritingDirectionPropertyName		= @"w:bidi";
NSString *RKDOCXParagraphStyleCenterAlignmentName					= @"center";
NSString *RKDOCXParagraphStyleFirstLineIndentationAttributeName		= @"w:firstLine";
NSString *RKDOCXParagraphStyleHangingIndentationAttributeName		= @"w:hanging";
NSString *RKDOCXParagraphStyleHeadIndentationAttributeName			= @"w:start";
NSString *RKDOCXParagraphStyleIndentationPropertyName				= @"w:ind";
NSString *RKDOCXParagraphStyleJustifiedAlignmentName				= @"both";
NSString *RKDOCXParagraphStyleLeftAlignmentName						= @"start";
NSString *RKDOCXParagraphStyleLineSpacingAttributeName				= @"w:line";
NSString *RKDOCXParagraphStyleLineSpacingRuleAttributeName			= @"w:lineRule";
NSString *RKDOCXParagraphStyleLineSpacingRuleName					= @"exactly";	// Alternatively: @"atLeast"
NSString *RKDOCXParagraphStyleParagraphSpacingAfterAttributeName	= @"w:after";
NSString *RKDOCXParagraphStyleParagraphSpacingBeforeAttributeName	= @"w:before";
NSString *RKDOCXParagraphStyleRightAlignmentName					= @"end";
NSString *RKDOCXParagraphStyleSpacingPropertyName					= @"w:spacing";
NSString *RKDOCXParagraphStyleTailIndentationAttributeName			= @"w:end";


@implementation RKDOCXParagraphStyleWriter

+ (NSArray *)paragraphPropertiesForAttributes:(NSDictionary *)attributes
{
	NSParagraphStyle *paragraphStyleAttribute = attributes[RKParagraphStyleAttributeName];
	
	if (!paragraphStyleAttribute)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Base Writing Direction
	if (paragraphStyleAttribute.baseWritingDirection == NSWritingDirectionRightToLeft) {
		NSXMLElement *baseWritingDirectionProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleBaseWritingDirectionPropertyName];
		[properties addObject: baseWritingDirectionProperty];
	}
	
	// Indentation
	NSXMLElement *indentationProperty = [self indentationPropertyForParagraphStyle: paragraphStyleAttribute];
	if (indentationProperty)
		[properties addObject: indentationProperty];
	
	// Alignment
	NSXMLElement *alignmentProperty = [self alignmentPropertyForParagraphStyle: paragraphStyleAttribute];
	if (alignmentProperty)
		[properties addObject: alignmentProperty];
	
	// Spacing
	NSXMLElement *spacingProperty = [self spacingPropertyForParagraphStyle: paragraphStyleAttribute];
	if (spacingProperty)
		[properties addObject: spacingProperty];
	
	return properties;
}

+ (NSXMLElement *)indentationPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
	if (paragraphStyle.headIndent == 0 && paragraphStyle.tailIndent == 0 && paragraphStyle.firstLineHeadIndent == 0)
		return nil;
	
	NSXMLElement *indentationProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleIndentationPropertyName];
	
	if (paragraphStyle.headIndent != 0) {
		NSXMLElement *startAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleHeadIndentationAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.headIndent)).stringValue];
		[indentationProperty addAttribute: startAttribute];
	}
	
	if (paragraphStyle.tailIndent != 0) {
		NSXMLElement *endAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleTailIndentationAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.tailIndent)).stringValue];
		[indentationProperty addAttribute: endAttribute];
	}
	
	if (paragraphStyle.firstLineHeadIndent != 0) {
		NSXMLElement *firstLineAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleFirstLineIndentationAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.firstLineHeadIndent)).stringValue];
		[indentationProperty addAttribute: firstLineAttribute];
	}
	
	return indentationProperty;
}

+ (NSXMLElement *)alignmentPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
	NSXMLElement *alignmentProperty;
	
	switch (paragraphStyle.alignment) {
		case kCTLeftTextAlignment:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleLeftAlignmentName]]];
			return alignmentProperty;
			
		case kCTCenterTextAlignment:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleCenterAlignmentName]]];
			return alignmentProperty;
			
		case kCTRightTextAlignment:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleRightAlignmentName]]];
			return alignmentProperty;
			
		case kCTJustifiedTextAlignment:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleJustifiedAlignmentName]]];
			return alignmentProperty;
			
		default:
			return nil;
	}
}

+ (NSXMLElement *)spacingPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
	if (paragraphStyle.lineSpacing == 0 && paragraphStyle.paragraphSpacingBefore == 0 && paragraphStyle.paragraphSpacing == 0)
		return nil;
	
	NSXMLElement *spacingProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleSpacingPropertyName];
	
	if (paragraphStyle.lineSpacing != 0) {
		NSXMLElement *lineAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleLineSpacingAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.lineSpacing)).stringValue];
		NSXMLElement *lineRuleAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleLineSpacingRuleAttributeName stringValue:RKDOCXParagraphStyleLineSpacingRuleName];
		[spacingProperty addAttribute: lineAttribute];
		[spacingProperty addAttribute: lineRuleAttribute];
	}
	if (paragraphStyle.paragraphSpacingBefore) {
		NSXMLElement *beforeAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleParagraphSpacingBeforeAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.paragraphSpacingBefore)).stringValue];
		[spacingProperty addAttribute: beforeAttribute];
	}
	if (paragraphStyle.paragraphSpacing) {
		NSXMLElement *beforeAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleParagraphSpacingAfterAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.paragraphSpacing)).stringValue];
		[spacingProperty addAttribute: beforeAttribute];
	}
	
	return spacingProperty;
}

@end
