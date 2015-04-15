//
//  RKDOCXRunAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunWriter.h"

#import "RKDOCXFontAttributesWriter.h"
#import "RKDOCXTextEffectAttributesWriter.h"
#import "RKDOCXImageWriter.h"

// Element names
NSString *RKDOCXRunElementName				= @"w:r";
NSString *RKDOCXRunInstructionAttributeName	= @"w:instr";
NSString *RKDOCXRunPageNumberAttributeValue	= @"PAGE";
NSString *RKDOCXRunPropertiesElementName	= @"w:rPr";
NSString *RKDOCXRunSimpleFieldElementName	= @"w:fldSimple";
NSString *RKDOCXRunTextElementName			= @"w:t";

@implementation RKDOCXRunWriter

+ (NSXMLElement *)runElementForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range usingContext:(RKDOCXConversionContext *)context
{
	// Check for empty range
	if (!range.length)
		return nil;
	
	// Check for page number placeholder
	if ([attributes[RKPlaceholderAttributeName] isEqual: @(RKPlaceholderPageNumber)])
		return [self pageNumberPlaceHolder];
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Collect all matching attributes
	NSArray *propertyElements = [RKDOCXFontAttributesWriter propertyElementsForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	propertyElements = [RKDOCXTextEffectAttributesWriter propertyElementsForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	NSXMLElement *runElement = [NSXMLElement elementWithName:RKDOCXRunElementName];
	
	if (properties.count) {
		NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName:RKDOCXRunPropertiesElementName children:properties attributes:nil];
		[runElement addChild: runPropertiesElement];
	}
	
	if (attributes[RKImageAttachmentAttributeName])
		return [RKDOCXImageWriter runElementWithImageAttachment:attributes[RKImageAttachmentAttributeName] inRunElement:runElement usingContext:context];
	
	NSXMLElement *textElement = [NSXMLElement elementWithName:RKDOCXRunTextElementName stringValue:[attributedString.string substringWithRange:range]];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)pageNumberPlaceHolder
{
	NSXMLElement *textElement = [NSXMLElement elementWithName:RKDOCXRunTextElementName stringValue:@"1"];
	NSXMLElement *runElement = [NSXMLElement elementWithName:RKDOCXRunElementName children:@[textElement] attributes:nil];
	return [NSXMLElement elementWithName:RKDOCXRunSimpleFieldElementName children:@[runElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXRunInstructionAttributeName stringValue:RKDOCXRunPageNumberAttributeValue]]];
}

@end
