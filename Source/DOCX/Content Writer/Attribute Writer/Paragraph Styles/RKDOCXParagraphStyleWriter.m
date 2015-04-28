//
//  RKDOCXParagraphStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphStyleWriter.h"

// Elements
NSString *RKDOCXParagraphStyleAlignmentElementName					= @"w:jc";
NSString *RKDOCXParagraphStyleBaseWritingDirectionElementName		= @"w:bidi";
NSString *RKDOCXParagraphStyleDefaultTabStopElementName				= @"w:defaultTabStop";
NSString *RKDOCXParagraphStyleIndentationElementName				= @"w:ind";
NSString *RKDOCXParagraphStyleSpacingElementName					= @"w:spacing";
NSString *RKDOCXParagraphStyleTabSetElementName						= @"w:tabs";
NSString *RKDOCXParagraphStyleTabElementName						= @"w:tab";

// Attributes
NSString *RKDOCXParagraphStyleFirstLineIndentationAttributeName		= @"w:firstLine";
NSString *RKDOCXParagraphStyleHangingIndentationAttributeName		= @"w:hanging";
NSString *RKDOCXParagraphStyleHeadIndentationAttributeName			= @"w:start";
NSString *RKDOCXParagraphStyleLineSpacingAttributeName				= @"w:line";
NSString *RKDOCXParagraphStyleLineSpacingRuleAttributeName			= @"w:lineRule";
NSString *RKDOCXParagraphStyleParagraphSpacingAfterAttributeName	= @"w:after";
NSString *RKDOCXParagraphStyleParagraphSpacingBeforeAttributeName	= @"w:before";
NSString *RKDOCXParagraphStyleTabPositionAttributeName				= @"w:pos";
NSString *RKDOCXParagraphStyleTailIndentationAttributeName			= @"w:end";

// Attribute Values
NSString *RKDOCXParagraphStyleCenterAlignmentAttributeValue			= @"center";
NSString *RKDOCXParagraphStyleJustifiedAlignmentAttributeValue		= @"both";
NSString *RKDOCXParagraphStyleLeftAlignmentAttributeValue			= @"start";
NSString *RKDOCXParagraphStyleLineSpacingRuleAttributeValue			= @"exactly";	// Alternatively: @"atLeast"
NSString *RKDOCXParagraphStyleRightAlignmentAttributeValue			= @"end";

@implementation RKDOCXParagraphStyleWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSParagraphStyle *paragraphStyleAttribute = attributes[RKParagraphStyleAttributeName];
	
	if (!paragraphStyleAttribute)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Base Writing Direction (§17.3.1.6)
	if (paragraphStyleAttribute.baseWritingDirection == NSWritingDirectionRightToLeft) {
		NSXMLElement *baseWritingDirectionProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleBaseWritingDirectionElementName];
		[properties addObject: baseWritingDirectionProperty];
	}
	
	// Indentation (§17.3.1.12)
	NSXMLElement *indentationProperty = [self indentationPropertyForParagraphStyle: paragraphStyleAttribute];
	if (indentationProperty)
		[properties addObject: indentationProperty];
	
	// Alignment (§17.3.1.13)
	NSXMLElement *alignmentProperty = [self alignmentPropertyForParagraphStyle: paragraphStyleAttribute];
	if (alignmentProperty)
		[properties addObject: alignmentProperty];
	
	// Spacing (§17.3.1.33)
	NSXMLElement *spacingProperty = [self spacingPropertyForParagraphStyle: paragraphStyleAttribute];
	if (spacingProperty)
		[properties addObject: spacingProperty];
	
	// Tab Stop Settings (§17.3.1.37/§17.3.1.38)
	NSArray *tabStopProperties = [self tabStopPropertiesForParagraphStyle:paragraphStyleAttribute usingContext:context];
	if (tabStopProperties)
		[properties addObjectsFromArray: tabStopProperties];
	
	return properties;
}

+ (NSXMLElement *)tabSettingsForMarkerLocationKey:(NSUInteger)markerLocationKey markerWidthKey:(NSUInteger)markerWidthKey
{
	NSXMLElement *tabsElement = [NSXMLElement elementWithName: RKDOCXParagraphStyleTabSetElementName];
	[tabsElement addChild: [NSXMLElement elementWithName:RKDOCXParagraphStyleTabElementName
												children:nil
											  attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@"num"],
														   [NSXMLElement attributeWithName:RKDOCXParagraphStyleTabPositionAttributeName stringValue:@(RKPointsToTwips(markerLocationKey + markerWidthKey)).stringValue]]]];
	return tabsElement;
}

+ (NSXMLElement *)indentationSettingsForMarkerLocationKey:(NSUInteger)markerLocationKey markerWidthKey:(NSUInteger)markerWidthKey
{
	NSXMLElement *indentationElement = [NSXMLElement elementWithName:RKDOCXParagraphStyleIndentationElementName
															children:nil
														  attributes:@[[NSXMLElement attributeWithName:RKDOCXParagraphStyleHeadIndentationAttributeName stringValue:@(RKPointsToTwips(markerLocationKey + markerWidthKey)).stringValue],
																	   [NSXMLElement attributeWithName:RKDOCXParagraphStyleHangingIndentationAttributeName stringValue:@(RKPointsToTwips(markerWidthKey)).stringValue]]];
	return indentationElement;
}

+ (NSXMLElement *)indentationPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
	if (paragraphStyle.headIndent == 0 && paragraphStyle.tailIndent == 0 && paragraphStyle.firstLineHeadIndent == 0)
		return nil;
	
	NSXMLElement *indentationProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleIndentationElementName];
	
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
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleLeftAlignmentAttributeValue]]];
			return alignmentProperty;
			
		case RKTextAlignmentCenter:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleCenterAlignmentAttributeValue]]];
			return alignmentProperty;
			
		case RKTextAlignmentRight:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleRightAlignmentAttributeValue]]];
			return alignmentProperty;
			
		case RKTextAlignmentJustified:
			alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleJustifiedAlignmentAttributeValue]]];
			return alignmentProperty;
			
		default:
			return nil;
	}
}

+ (NSXMLElement *)spacingPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
	if (paragraphStyle.lineSpacing == 0 && paragraphStyle.paragraphSpacingBefore == 0 && paragraphStyle.paragraphSpacing == 0)
		return nil;
	
	NSXMLElement *spacingProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleSpacingElementName];
	
	if (paragraphStyle.lineSpacing != 0) {
		NSXMLElement *lineAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleLineSpacingAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.lineSpacing)).stringValue];
		NSXMLElement *lineRuleAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleLineSpacingRuleAttributeName stringValue:RKDOCXParagraphStyleLineSpacingRuleAttributeValue];
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
		properties = [[NSMutableArray alloc] initWithArray:@[[NSXMLElement elementWithName:RKDOCXParagraphStyleDefaultTabStopElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@(RKPointsToTwips(paragraphStyle.defaultTabInterval)).stringValue]]]]];
	
	// Custom tab stops set? If not, either return defaultTabInterval or nil in case no interval has been set.
	if (!paragraphStyle.tabStops || paragraphStyle.tabStops.count == 0 || [paragraphStyle.tabStops isEqual: defaultStyle.tabStops])
		return properties;
	
	// Initialize array if no default tap stop interval has been set.
	if (!properties)
		properties = [NSMutableArray new];
	
	NSXMLElement *tabSetProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleTabSetElementName];
	
	for (NSTextTab *tabStop in paragraphStyle.tabStops) {
		NSXMLElement *tabProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleTabElementName];
		
		NSXMLElement *alignmentAttribute;
		switch (tabStop.alignment) {
			case RKTextAlignmentRight:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleRightAlignmentAttributeValue];
				break;
				
			case RKTextAlignmentCenter:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleCenterAlignmentAttributeValue];
				break;
				
			default:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleLeftAlignmentAttributeValue];
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
