//
//  RKDOCXTabStopWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 09.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXTabStopWriter.h"

NSString *RKDOCXTabStopCenterAlignmentName		= @"center";
NSString *RKDOCXTabStopLeftAlignmentName		= @"start";
NSString *RKDOCXTabStopRightAlignmentName		= @"end";
NSString *RKDOCXTabStopTabSetPropertyName		= @"w:tabs";
NSString *RKDOCXTabStopTabPropertyName			= @"w:tab";
NSString *RKDOCXTabStopTabPositionAttributeName	= @"w:pos";


@implementation RKDOCXTabStopWriter

+ (NSArray *)paragraphPropertiesForAttributes:(NSDictionary *)attributes
{
	NSArray *tabStops = [attributes[RKParagraphStyleAttributeName] tabStops];
	
	if (!tabStops || tabStops.count == 0 || [tabStops isEqual: [[NSParagraphStyle defaultParagraphStyle] tabStops]])
		return nil;
	
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
	
	return @[tabSetProperty];
}

@end
