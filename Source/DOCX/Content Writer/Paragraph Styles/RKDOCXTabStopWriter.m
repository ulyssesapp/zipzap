//
//  RKDOCXTabStopWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 09.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXTabStopWriter.h"

NSString *RKDOCXTabStopCenterAlignmentName			= @"center";
NSString *RKDOCXTabStopDefaultTabStopPropertyName	= @"w:defaultTabStop";
NSString *RKDOCXTabStopLeftAlignmentName			= @"start";
NSString *RKDOCXTabStopRightAlignmentName			= @"end";
NSString *RKDOCXTabStopTabSetPropertyName			= @"w:tabs";
NSString *RKDOCXTabStopTabPropertyName				= @"w:tab";
NSString *RKDOCXTabStopTabPositionAttributeName		= @"w:pos";


@implementation RKDOCXTabStopWriter

+ (NSArray *)paragraphPropertiesForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSArray *tabStops = [attributes[RKParagraphStyleAttributeName] tabStops];
	CGFloat defaultTabInterval = [attributes[RKParagraphStyleAttributeName] defaultTabInterval];
	NSParagraphStyle *defaultStyle = [NSParagraphStyle defaultParagraphStyle];
	
	NSMutableArray *properties;
	
	// Default tab stop interval set?
	if (defaultTabInterval && defaultTabInterval != defaultStyle.defaultTabInterval)
		properties = [[NSMutableArray alloc] initWithArray:@[[NSXMLElement elementWithName:RKDOCXTabStopDefaultTabStopPropertyName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@(RKPointsToTwips(defaultTabInterval)).stringValue]]]]];
	
	// Custom tab stops set? If not, either return defaultTabInterval or nil in case no interval has been set.
	if (!tabStops || tabStops.count == 0 || [tabStops isEqual: defaultStyle.tabStops])
		return properties;
	
	// Initialize array if no default tap stop interval has been set.
	if (!properties)
		properties = [NSMutableArray new];
	
	NSXMLElement *tabSetProperty = [NSXMLElement elementWithName:RKDOCXTabStopTabSetPropertyName];
	
	for (NSTextTab *tabStop in tabStops) {
		NSXMLElement *tabProperty = [NSXMLElement elementWithName: RKDOCXTabStopTabPropertyName];
		
		NSXMLElement *alignmentAttribute;
		switch (tabStop.alignment) {
			case RKTextAlignmentRight:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTabStopRightAlignmentName];
				break;
				
			case RKTextAlignmentCenter:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTabStopCenterAlignmentName];
				break;
				
			default:
				alignmentAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTabStopLeftAlignmentName];
				break;
		}
		[tabProperty addAttribute: alignmentAttribute];
		
		NSXMLElement *positionAttribute = [NSXMLElement attributeWithName:RKDOCXTabStopTabPositionAttributeName stringValue:@(RKPointsToTwips(tabStop.location)).stringValue];
		[tabProperty addAttribute: positionAttribute];
		
		[tabSetProperty addChild: tabProperty];
	}
	
	[properties addObject: tabSetProperty];
	
	return properties;
}

@end
