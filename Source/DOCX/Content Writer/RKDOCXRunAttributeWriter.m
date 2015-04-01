//
//  RKDOCXRunAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"

#import "RKDOCXFontAttributeWriter.h"


// Element names
NSString *RKDOCXRunAttributeRunElementName				= @"w:r";
NSString *RKDOCXRunAttributeRunPropertiesElementName	= @"w:rPr";
NSString *RKDOCXRunAttributeTextElementName				= @"w:t";

@implementation RKDOCXRunAttributeWriter

+ (NSXMLElement *)runElementForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range
{
	// Check for empty range
	if (!range.length)
		return nil;
	
	// Check for invalid range
	NSParameterAssert(NSMaxRange(range) <= attributedString.length);
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Collect all matching attributes
	NSArray *propertyElements = [RKDOCXFontAttributeWriter runPropertiesForAttributes: attributes];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	// ...
	
	NSXMLElement *runElement = [NSXMLElement elementWithName:RKDOCXRunAttributeRunElementName];
	
	if (properties.count) {
		NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName:RKDOCXRunAttributeRunPropertiesElementName children:properties attributes:nil];
		[runElement addChild: runPropertiesElement];
	}
	
	NSXMLElement *textElement = [NSXMLElement elementWithName:RKDOCXRunAttributeTextElementName stringValue:[attributedString.string substringWithRange:range]];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: textElement];
	
	return runElement;
}

@end
