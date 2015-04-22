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

+ (NSArray *)runElementsForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range usingContext:(RKDOCXConversionContext *)context
{
	// Check for empty range
	if (!range.length)
		return nil;
	
	// Check for placeholder
	NSXMLElement *placeholderElement = [RKDOCXPlaceholderWriter	placeholderElementForAttributes:attributes usingContext:context];
	if (placeholderElement)
		return @[placeholderElement];
	
	// Check for footnote/endnote reference mark (located in the footnote’s/endnote’s content)
	NSXMLElement *referenceMarkElement = [RKDOCXFootnotesWriter referenceMarkForAttributes:attributes usingContext:context];
	if (referenceMarkElement)
		return @[referenceMarkElement];
	
	// Check for image attribute
	NSXMLElement *imageRunElement = [RKDOCXImageWriter runElementForAttributes:attributes usingContext:context];
	if (imageRunElement)
		return @[imageRunElement];
	
	// Check for footnote reference
	NSXMLElement *referenceRunElement = [RKDOCXFootnotesWriter referenceElementForAttributes:attributes usingContext:context];
	if (referenceRunElement)
		return @[referenceRunElement];
	
	// Handling of usual runs with line breaks and tab stops
	return [self runElementsWithBreaksFromAttributedString:attributedString attributes:attributes inRange:range usingContext:context];
}

+ (NSArray *)runElementsWithBreaksFromAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes inRange:(NSRange)range usingContext:(RKDOCXConversionContext *)context
{
	static NSCharacterSet *characterSet;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		characterSet = [NSCharacterSet characterSetWithCharactersInString: [NSString stringWithFormat: @"\t%C", RKLineSeparatorCharacter]];
	});
	
	NSMutableArray *runElements = [NSMutableArray new];
	NSUInteger scanLocation = range.location;
	
	do {
		NSRange nextCharacterRange = [attributedString.string rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(scanLocation, NSMaxRange(range) - scanLocation)];
		
		if (nextCharacterRange.location == NSNotFound) {
			[runElements addObject: [self runElementForAttributes:attributes contentElement:[self textElementWithStringValue: [attributedString.string substringWithRange: NSMakeRange(scanLocation, NSMaxRange(range) - scanLocation)]] usingContext:context]];
			break;
		}
		
		if (nextCharacterRange.location > scanLocation)
			[runElements addObject: [self runElementForAttributes:attributes contentElement:[self textElementWithStringValue: [attributedString.string substringWithRange: NSMakeRange(scanLocation, nextCharacterRange.location - scanLocation)]] usingContext:context]];
		
		if ([attributedString.string characterAtIndex: nextCharacterRange.location] == '\t') {
			[runElements addObject: [RKDOCXPlaceholderWriter runElementWithBreak: RKDOCXTabStop]];
		}
		else {
			[runElements addObject: [RKDOCXPlaceholderWriter runElementWithBreak: RKDOCXLineBreak]];
		}
		
		scanLocation = nextCharacterRange.location + 1;
	} while (scanLocation < NSMaxRange(range));
	
	return runElements;
}

+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes contentElement:(NSXMLElement *)contentElement usingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: RKDOCXRunElementName];
	NSArray *properties;
	if (attributes && context)
		properties = [self propertyElementsForAttributes:attributes usingContext:context];
	
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

+ (NSXMLElement *)textElementWithStringValue:(NSString *)stringValue
{
	NSXMLElement *textElement = [NSXMLElement elementWithName:RKDOCXRunTextElementName stringValue:stringValue];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	
	return textElement;
}

@end
