//
//  RKDOCXRunAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"

#import "RKDOCXFontAttributeWriter.h"
#import "RKDOCXTextEffectsWriter.h"


// Element names
NSString *RKDOCXRunAttributeRunElementName				= @"w:r";
NSString *RKDOCXRunAttributeRunPropertiesElementName	= @"w:rPr";
NSString *RKDOCXRunAttributeTextElementName				= @"w:t";


@implementation RKDOCXRunAttributeWriter

+ (NSXMLElement *)runElementForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range usingContext:(RKDOCXConversionContext *)context
{
	// Check for empty range
	if (!range.length)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Collect all matching attributes
	NSArray *propertyElements = [RKDOCXFontAttributeWriter runPropertiesForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	propertyElements = [RKDOCXTextEffectsWriter runPropertiesForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
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
