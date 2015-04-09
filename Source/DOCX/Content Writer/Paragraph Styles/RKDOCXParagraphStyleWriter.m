//
//  RKDOCXParagraphStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphStyleWriter.h"

NSString *RKDOCXParagraphStyleBaseWritingDirectionPropertyName	= @"w:bidi";
NSString *RKDOCXParagraphStyleFirstLineIndentationAttributeName	= @"w:firstLine";
NSString *RKDOCXParagraphStyleHangingIndentationAttributeName	= @"w:hanging";
NSString *RKDOCXParagraphStyleHeadIndentationAttributeName		= @"w:start";
NSString *RKDOCXParagraphStyleIndentationPropertyName			= @"w:ind";
NSString *RKDOCXParagraphStyleTailIndentationAttributeName		= @"w:end";


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

@end
