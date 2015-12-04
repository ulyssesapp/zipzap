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
NSString *RKDOCXParagraphStyleKeepNextElementName					= @"w:keepNext";
NSString *RKDOCXParagraphStyleSpacingElementName					= @"w:spacing";
NSString *RKDOCXParagraphStyleSuppressHyphenationElementName		= @"w:suppressAutoHyphens";
NSString *RKDOCXParagraphStyleTabSetElementName						= @"w:tabs";
NSString *RKDOCXParagraphStyleTabElementName						= @"w:tab";
NSString *RKDOCXParagraphStyleOrphanControlElementName				= @"w:widowControl";

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

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle;
{
	NSParagraphStyle *paragraphStyleAttribute = attributes[RKParagraphStyleAttributeName] ?: NSParagraphStyle.defaultParagraphStyle;
	RKAdditionalParagraphStyle *additionalParagraphStyleAttribute = attributes[RKAdditionalParagraphStyleAttributeName];
	
	NSDictionary *templateStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:nil processingDefaultStyle:isDefaultStyle];
	NSParagraphStyle *templateParagraphStyleAttribute = templateStyle[RKParagraphStyleAttributeName] ?: NSParagraphStyle.defaultParagraphStyle;
	RKAdditionalParagraphStyle *templateAdditionalParagraphStyleAttribute = templateStyle[RKAdditionalParagraphStyleAttributeName];
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Base Writing Direction (§17.3.1.6)
	if (paragraphStyleAttribute.baseWritingDirection != templateParagraphStyleAttribute.baseWritingDirection) {
		NSXMLElement *baseWritingDirectionProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleBaseWritingDirectionElementName];
		if (paragraphStyleAttribute.baseWritingDirection != NSWritingDirectionRightToLeft)
			[baseWritingDirectionProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
		
		[properties addObject: baseWritingDirectionProperty];
	}
	
	// Indentation (§17.3.1.12)
	// HACK: Only set indentation when paragraph is not inside an itemization
	if (!attributes[RKListItemAttributeName]) {
		NSXMLElement *indentationProperty = [self indentationPropertyForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute];
		if (indentationProperty)
			[properties addObject: indentationProperty];
	}
	
	// Alignment (§17.3.1.13)
	NSXMLElement *alignmentProperty = [self alignmentPropertyForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute];
	if (alignmentProperty)
		[properties addObject: alignmentProperty];
	
	// Spacing (§17.3.1.33)
	NSXMLElement *spacingProperty = [self spacingPropertyForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute additionalParagraphStyle:additionalParagraphStyleAttribute templateAdditionalParagraphStyle:templateAdditionalParagraphStyleAttribute];
	if (spacingProperty)
		[properties addObject: spacingProperty];
	
	// Tab Stop Settings (§17.3.1.37/§17.3.1.38)
	NSArray *tabStopProperties = [self tabStopPropertiesForParagraphStyle:paragraphStyleAttribute templateParagraphStyle:templateParagraphStyleAttribute usingContext:context];
	if (tabStopProperties)
		[properties addObjectsFromArray: tabStopProperties];
	
	// Keep With following (§17.3.1.15)
	if (additionalParagraphStyleAttribute.keepWithFollowingParagraph != templateAdditionalParagraphStyleAttribute.keepWithFollowingParagraph) {
		NSXMLElement *keepNextElement = [NSXMLElement elementWithName: RKDOCXParagraphStyleKeepNextElementName];
		if (!additionalParagraphStyleAttribute.keepWithFollowingParagraph)
			[keepNextElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
		
		[properties addObject: keepNextElement];
	}
	
	// Skip Orphan Control (§17.3.1.44)
	if (additionalParagraphStyleAttribute.skipOrphanControl != templateAdditionalParagraphStyleAttribute.skipOrphanControl) {
		NSXMLElement *widowControlElement = [NSXMLElement elementWithName: RKDOCXParagraphStyleOrphanControlElementName];
		if (additionalParagraphStyleAttribute.skipOrphanControl)
			[widowControlElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
		
		[properties addObject: widowControlElement];
	}
	
	// Hyphenation (§17.3.1.34)
	if (context.document.hyphenationEnabled) {
		// Do not set hyphenation if matching style template.
		if ((additionalParagraphStyleAttribute.hyphenationEnabled != templateAdditionalParagraphStyleAttribute.hyphenationEnabled) || (!templateAdditionalParagraphStyleAttribute && !additionalParagraphStyleAttribute.hyphenationEnabled)) {
			NSXMLElement *suppressAutoHyphensElement = [NSXMLElement elementWithName: RKDOCXParagraphStyleSuppressHyphenationElementName];

			// Re-activate hyphenation when overriding template setting
			if (additionalParagraphStyleAttribute.hyphenationEnabled && !templateAdditionalParagraphStyleAttribute.hyphenationEnabled)
				[suppressAutoHyphensElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
			
			[properties addObject: suppressAutoHyphensElement];
		}
	}
	
	return properties;
}


#pragma mark - Settings

+ (NSXMLElement *)indentationPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle templateParagraphStyle:(NSParagraphStyle *)templateParagraphStyle
{
	if (paragraphStyle.headIndent == templateParagraphStyle.headIndent && paragraphStyle.tailIndent == templateParagraphStyle.tailIndent && paragraphStyle.firstLineHeadIndent == templateParagraphStyle.firstLineHeadIndent)
		return nil;
	
	NSXMLElement *indentationProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleIndentationElementName];
	
	if (paragraphStyle.headIndent != templateParagraphStyle.headIndent)
		[indentationProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleHeadIndentationAttributeName integerValue:RKPointsToTwips(paragraphStyle.headIndent)]];
	
	if (paragraphStyle.tailIndent != templateParagraphStyle.tailIndent)
		[indentationProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleTailIndentationAttributeName integerValue:RKPointsToTwips(paragraphStyle.tailIndent * -1)]];
	
	if (paragraphStyle.firstLineHeadIndent - paragraphStyle.headIndent != templateParagraphStyle.firstLineHeadIndent - templateParagraphStyle.headIndent) {
		NSInteger firstLineIndent = RKPointsToTwips(paragraphStyle.firstLineHeadIndent - paragraphStyle.headIndent);
		if (firstLineIndent < 0)
			[indentationProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleHangingIndentationAttributeName integerValue:(firstLineIndent * -1)]];
		else
			[indentationProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleFirstLineIndentationAttributeName integerValue:firstLineIndent]];
	}
	
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

+ (NSXMLElement *)spacingPropertyForParagraphStyle:(NSParagraphStyle *)paragraphStyle templateParagraphStyle:(NSParagraphStyle *)templateParagraphStyle additionalParagraphStyle:(RKAdditionalParagraphStyle *)additionalParagraphStyle templateAdditionalParagraphStyle:(RKAdditionalParagraphStyle *)templateAdditionalParagraphStyle
{
	if (additionalParagraphStyle.baselineDistance == templateAdditionalParagraphStyle.baselineDistance && paragraphStyle.paragraphSpacingBefore == templateParagraphStyle.paragraphSpacingBefore && paragraphStyle.paragraphSpacing == templateParagraphStyle.paragraphSpacing)
		return nil;
	
	NSXMLElement *spacingProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleSpacingElementName];
	
	if (additionalParagraphStyle.baselineDistance != templateAdditionalParagraphStyle.baselineDistance) {
		[spacingProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXParagraphStyleLineSpacingAttributeName integerValue:RKPointsToTwips(additionalParagraphStyle.baselineDistance)]];
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


#pragma mark - Convenience constructors

+ (NSXMLElement *)tabSettingsForMarkerLocation:(NSUInteger)markerLocation markerWidth:(NSUInteger)markerWidth
{
	NSXMLElement *tabsElement = [NSXMLElement elementWithName: RKDOCXParagraphStyleTabSetElementName];
	[tabsElement addChild: [NSXMLElement elementWithName:RKDOCXParagraphStyleTabElementName
												children:nil
											  attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@"num"],
														   [NSXMLElement attributeWithName:RKDOCXParagraphStyleTabPositionAttributeName integerValue:RKPointsToTwips(markerLocation + markerWidth)]]]];
	return tabsElement;
}

+ (NSXMLElement *)indentationSettingsForMarkerLocation:(NSUInteger)markerLocation markerWidth:(NSUInteger)markerWidth
{
	NSXMLElement *indentationElement = [NSXMLElement elementWithName:RKDOCXParagraphStyleIndentationElementName
															children:nil
														  attributes:@[[NSXMLElement attributeWithName:RKDOCXParagraphStyleHeadIndentationAttributeName integerValue:RKPointsToTwips(markerLocation + markerWidth)],
																	   [NSXMLElement attributeWithName:RKDOCXParagraphStyleHangingIndentationAttributeName integerValue:RKPointsToTwips(markerWidth)]]];
	return indentationElement;
}

+ (NSArray *)paragraphPropertiesForSeparatorElementUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *beforeAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleParagraphSpacingBeforeAttributeName integerValue:RKPointsToTwips(context.document.footnoteAreaDividerSpacingBefore)];
	NSXMLElement *afterAttribute = [NSXMLElement attributeWithName:RKDOCXParagraphStyleParagraphSpacingAfterAttributeName integerValue:RKPointsToTwips(context.document.footnoteAreaDividerSpacingAfter)];
	NSXMLElement *spacingProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleSpacingElementName children:nil attributes:@[beforeAttribute, afterAttribute]];
	
	NSXMLElement *alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:(context.document.footnoteAreaDividerPosition == RKTextAlignmentRight) ? RKDOCXParagraphStyleRightAlignmentAttributeValue : RKDOCXParagraphStyleLeftAlignmentAttributeValue];
	NSXMLElement *alignmentProperty = [NSXMLElement elementWithName:RKDOCXParagraphStyleAlignmentElementName children:nil attributes:@[alignmentAttribute]];
	
	return @[spacingProperty, alignmentProperty];
}

@end
