//
//  RKDOCXParagraphStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphStyleWriter.h"

#import "NSXMLElement+IntegerValueConvenience.h"

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
NSString *RKDOCXParagraphStyleLineSpacingRuleAttributeValue			= @"atLeast";	// Alternatively: @"exactly"
NSString *RKDOCXParagraphStyleRightAlignmentAttributeValue			= @"end";

@implementation RKDOCXParagraphStyleWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSParagraphStyle *paragraphStyleAttribute = attributes[RKParagraphStyleAttributeName] ?: NSParagraphStyle.defaultParagraphStyle;
	NSParagraphStyle *templateParagraphStyleAttribute = context.document.paragraphStyles[attributes[RKParagraphStyleNameAttributeName]][RKParagraphStyleAttributeName] ?: NSParagraphStyle.defaultParagraphStyle;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Base Writing Direction (§17.3.1.6)
	if (paragraphStyleAttribute.baseWritingDirection != templateParagraphStyleAttribute.baseWritingDirection) {
		NSXMLElement *baseWritingDirectionProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleBaseWritingDirectionElementName];
		if (paragraphStyleAttribute.baseWritingDirection != NSWritingDirectionRightToLeft)
			[baseWritingDirectionProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
		
		[properties addObject: baseWritingDirectionProperty];
	}
	
	// Indentation (§17.3.1.12)
	NSXMLElement *indentationProperty = [self indentationPropertyForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute];
	if (indentationProperty)
		[properties addObject: indentationProperty];
	
	// Alignment (§17.3.1.13)
	NSXMLElement *alignmentProperty = [self alignmentPropertyForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute];
	if (alignmentProperty)
		[properties addObject: alignmentProperty];
	
	// Spacing (§17.3.1.33)
	NSXMLElement *spacingProperty = [self spacingPropertyForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute];
	if (spacingProperty)
		[properties addObject: spacingProperty];
	
	// Tab Stop Settings (§17.3.1.37/§17.3.1.38)
	NSArray *tabStopProperties = [self tabStopPropertiesForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute usingContext:context];
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
														   [NSXMLElement attributeWithName:RKDOCXParagraphStyleTabPositionAttributeName integerValue:RKPointsToTwips(markerLocationKey + markerWidthKey)]]]];
	return tabsElement;
}

+ (NSXMLElement *)indentationSettingsForMarkerLocationKey:(NSUInteger)markerLocationKey markerWidthKey:(NSUInteger)markerWidthKey
{
	NSXMLElement *indentationElement = [NSXMLElement elementWithName:RKDOCXParagraphStyleIndentationElementName
															children:nil
														  attributes:@[[NSXMLElement attributeWithName:RKDOCXParagraphStyleHeadIndentationAttributeName integerValue:RKPointsToTwips(markerLocationKey + markerWidthKey)],
																	   [NSXMLElement attributeWithName:RKDOCXParagraphStyleHangingIndentationAttributeName integerValue:RKPointsToTwips(markerWidthKey)]]];
	return indentationElement;
}

+ (NSXMLElement *)indentationPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle templateParagraphStyle:(NSParagraphStyle *)templateParagraphStyle
{
	if (paragraphStyle.headIndent == templateParagraphStyle.headIndent && paragraphStyle.tailIndent == templateParagraphStyle.tailIndent && paragraphStyle.firstLineHeadIndent == templateParagraphStyle.firstLineHeadIndent)
		return nil;
	
	NSXMLElement *indentationProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleIndentationElementName];
	
	if (paragraphStyle.headIndent != templateParagraphStyle.headIndent)
		[indentationProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleHeadIndentationAttributeName integerValue:RKPointsToTwips(paragraphStyle.headIndent)]];
	
	if (paragraphStyle.tailIndent != templateParagraphStyle.tailIndent)
		[indentationProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleTailIndentationAttributeName integerValue:RKPointsToTwips(paragraphStyle.tailIndent)]];
	
	if (paragraphStyle.firstLineHeadIndent != templateParagraphStyle.firstLineHeadIndent)
		[indentationProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleFirstLineIndentationAttributeName integerValue:RKPointsToTwips(paragraphStyle.firstLineHeadIndent)]];
	
	return (indentationProperty.attributes.count > 0) ? indentationProperty : nil;
}

+ (NSXMLElement *)alignmentPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle templateParagraphStyle:(NSParagraphStyle *)templateParagraphStyle
{
	if (paragraphStyle.alignment == templateParagraphStyle.alignment)
		return nil;
	
	NSString *alignmentValue;
	
	switch (paragraphStyle.alignment) {
		case RKTextAlignmentLeft:
			alignmentValue = RKDOCXParagraphStyleLeftAlignmentAttributeValue;
			break;
			
		case RKTextAlignmentCenter:
			alignmentValue = RKDOCXParagraphStyleCenterAlignmentAttributeValue;
			break;
			
		case RKTextAlignmentRight:
			alignmentValue = RKDOCXParagraphStyleRightAlignmentAttributeValue;
			break;
			
		case RKTextAlignmentJustified:
			alignmentValue = RKDOCXParagraphStyleJustifiedAlignmentAttributeValue;
			break;
			
		default:
			return nil;
	}
	
	return [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:alignmentValue]]];
}

+ (NSXMLElement *)spacingPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle templateParagraphStyle:(NSParagraphStyle *)templateParagraphStyle
{
	if (paragraphStyle.lineSpacing == templateParagraphStyle.lineSpacing && paragraphStyle.paragraphSpacingBefore == templateParagraphStyle.paragraphSpacingBefore && paragraphStyle.paragraphSpacing == templateParagraphStyle.paragraphSpacing)
		return nil;
	
	NSXMLElement *spacingProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleSpacingElementName];
	
	if (paragraphStyle.lineSpacing != templateParagraphStyle.lineSpacing) {
		[spacingProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleLineSpacingAttributeName integerValue:RKPointsToTwips(paragraphStyle.lineSpacing)]];
		[spacingProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleLineSpacingRuleAttributeName stringValue:RKDOCXParagraphStyleLineSpacingRuleAttributeValue]];
	}
	
	if (paragraphStyle.paragraphSpacingBefore != templateParagraphStyle.paragraphSpacingBefore)
		[spacingProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleParagraphSpacingBeforeAttributeName integerValue:RKPointsToTwips(paragraphStyle.paragraphSpacingBefore)]];
	
	if (paragraphStyle.paragraphSpacing != templateParagraphStyle.paragraphSpacing)
		[spacingProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleParagraphSpacingAfterAttributeName integerValue:RKPointsToTwips(paragraphStyle.paragraphSpacing)]];
	
	return (spacingProperty.attributes.count > 0) ? spacingProperty : nil;
}

+ (NSArray *)tabStopPropertiesForParagraphStyle:(NSParagraphStyle *)paragraphStyle templateParagraphStyle:(NSParagraphStyle *)templateParagraphStyle usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *properties;
	
	// Default tab stop interval set?
	if (paragraphStyle.defaultTabInterval != templateParagraphStyle.defaultTabInterval) {
		properties = [NSMutableArray arrayWithArray:@[[NSXMLElement elementWithName:RKDOCXParagraphStyleDefaultTabStopElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName integerValue:RKPointsToTwips(paragraphStyle.defaultTabInterval)]]]]];
	}
	
	// Custom tab stops set? If not, either return defaultTabInterval or nil in case no interval has been set.
	if (!paragraphStyle.tabStops || paragraphStyle.tabStops.count == 0 || [paragraphStyle.tabStops isEqual: templateParagraphStyle.tabStops])
		return properties;
	
	// Initialize array if no default tap stop interval has been set.
	if (!properties)
		properties = [NSMutableArray new];
	
	NSXMLElement *tabSetProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleTabSetElementName];
	
	for (NSTextTab *tabStop in paragraphStyle.tabStops) {
		NSXMLElement *tabProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleTabElementName];
		
		NSString *alignmentValue;
		
		switch (tabStop.alignment) {
			case RKTextAlignmentRight:
				alignmentValue = RKDOCXParagraphStyleRightAlignmentAttributeValue;
				break;
				
			case RKTextAlignmentCenter:
				alignmentValue = RKDOCXParagraphStyleCenterAlignmentAttributeValue;
				break;
				
			case RKTextAlignmentJustified: // will never happen
			case RKTextAlignmentNatural:
			case RKTextAlignmentLeft:
				alignmentValue = RKDOCXParagraphStyleLeftAlignmentAttributeValue;
				break;
		}
		
		[tabProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:alignmentValue]];
		
		NSXMLElement *positionAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleTabPositionAttributeName integerValue:RKPointsToTwips(tabStop.location)];
		[tabProperty addAttribute: positionAttribute];
		
		[tabSetProperty addChild: tabProperty];
	}
	
	[properties addObject: tabSetProperty];
	
	return properties;
}

@end
