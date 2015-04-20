//
//  RKDOCXRunAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunWriter.h"

#import "RKDOCXFontAttributesWriter.h"
#import "RKDOCXFootnotesWriter.h"
#import "RKDOCXPlaceholderWriter.h"
#import "RKDOCXTextEffectAttributesWriter.h"
#import "RKDOCXImageWriter.h"

// Element names
NSString *RKDOCXRunElementName				= @"w:r";
NSString *RKDOCXRunPropertiesElementName	= @"w:rPr";
NSString *RKDOCXRunTextElementName			= @"w:t";

@implementation RKDOCXRunWriter

+ (NSXMLElement *)runElementForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range usingContext:(RKDOCXConversionContext *)context
{
	// Check for empty range
	if (!range.length)
		return nil;
	
	// Check for placeholder
	NSXMLElement *placeholderElement = [RKDOCXPlaceholderWriter	runElementForAttributes:attributes];
	if (placeholderElement)
		return placeholderElement;
	
	// Check for footnote/endnote reference mark (located in the footnote’s/endnote’s content)
	NSXMLElement *referenceMarkElement = [RKDOCXFootnotesWriter referenceMarkForAttributes:attributes];
	if (referenceMarkElement)
		return referenceMarkElement;
	
	// Check for image attribute
	NSXMLElement *imageRunElement = [RKDOCXImageWriter runElementForAttributes:attributes usingContext:context];
	if (imageRunElement)
		return imageRunElement;
	
	// Check for footnote reference
	NSXMLElement *referenceRunElement = [RKDOCXFootnotesWriter referenceElementForAttributes:attributes usingContext:context];
	if (referenceRunElement)
		return referenceRunElement;
	
	// Handling of usual runs
	NSXMLElement *textElement = [NSXMLElement elementWithName:RKDOCXRunTextElementName stringValue:[attributedString.string substringWithRange:range]];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	
	return [self runElementForAttributes:attributes contentElement:textElement usingContext:context];
}

+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes contentElement:(NSXMLElement *)contentElement usingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: RKDOCXRunElementName];
	NSArray *properties = [self propertyElementsForAttributes:attributes usingContext:context];
	
	if (properties.count) {
		NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName:RKDOCXRunPropertiesElementName children:properties attributes:nil];
		[runElement addChild: runPropertiesElement];
	}
	NSParameterAssert(contentElement);
	[runElement addChild: contentElement];
	
	return runElement;
}

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *properties = [NSMutableArray new];
	
	NSArray *propertyElements = [RKDOCXFontAttributesWriter propertyElementsForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	propertyElements = [RKDOCXTextEffectAttributesWriter propertyElementsForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	return properties;
}

@end
