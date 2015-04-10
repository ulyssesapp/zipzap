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
NSString *RKDOCXParagraphStyleDefaultTabStopPropertyName			= @"w:defaultTabStop";
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
NSString *RKDOCXParagraphStyleTabSetPropertyName					= @"w:tabs";
NSString *RKDOCXParagraphStyleTabPropertyName						= @"w:tab";
NSString *RKDOCXParagraphStyleTabPositionAttributeName				= @"w:pos";
NSString *RKDOCXParagraphStyleTailIndentationAttributeName			= @"w:end";

@implementation RKDOCXParagraphStyleWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
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
	
	// Tab Stop Settings
	NSArray *tabStopProperties = [self tabStopPropertiesForParagraphStyle:paragraphStyleAttribute usingContext:context];
	if (tabStopProperties)
		[properties addObjectsFromArray: tabStopProperties];
	
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
		case RKTextAlignmentLeft:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleLeftAlignmentName]]];
			return alignmentProperty;
			
		case RKTextAlignmentCenter:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleCenterAlignmentName]]];
			return alignmentProperty;
			
		case RKTextAlignmentRight:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleRightAlignmentName]]];
			return alignmentProperty;
			
		case RKTextAlignmentJustified:
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

+ (NSArray *)tabStopPropertiesForParagraphStyle:(NSParagraphStyle *)paragraphStyle usingContext:(RKDOCXConversionContext *)context
{
	NSParagraphStyle *defaultStyle = [NSParagraphStyle defaultParagraphStyle];
	
	NSMutableArray *properties;
	
	// Default tab stop interval set?
	if (paragraphStyle.defaultTabInterval && paragraphStyle.defaultTabInterval != defaultStyle.defaultTabInterval)
		properties = [[NSMutableArray alloc] initWithArray:@[[NSXMLElement elementWithName:RKDOCXParagraphStyleDefaultTabStopPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.defaultTabInterval)).stringValue]]]]];
	
	// Custom tab stops set? If not, either return defaultTabInterval or nil in case no interval has been set.
	if (!paragraphStyle.tabStops || paragraphStyle.tabStops.count == 0 || [paragraphStyle.tabStops isEqual: defaultStyle.tabStops])
		return properties;
	
	// Initialize array if no default tap stop interval has been set.
	if (!properties)
		properties = [NSMutableArray new];
	
	NSXMLElement *tabSetProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleTabSetPropertyName];
	
	for (NSTextTab *tabStop in paragraphStyle.tabStops) {
		NSXMLElement *tabProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleTabPropertyName];
		
		NSXMLElement *alignmentAttribute;
		switch (tabStop.alignment) {
			case RKTextAlignmentRight:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleRightAlignmentName];
				break;
				
			case RKTextAlignmentCenter:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleCenterAlignmentName];
				break;
				
			default:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleLeftAlignmentName];
				break;
		}
		[tabProperty addAttribute: alignmentAttribute];
		
		NSXMLElement *positionAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleTabPositionAttributeName stringValue:@(RKPointsToTwips(tabStop.location)).stringValue];
		[tabProperty addAttribute: positionAttribute];
		
		[tabSetProperty addChild: tabProperty];
	}
	
	[properties addObject: tabSetProperty];
	
	return properties;
}

@end
