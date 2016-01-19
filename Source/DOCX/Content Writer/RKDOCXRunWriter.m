//
//  RKDOCXRunWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunWriter.h"

#import "RKDOCXFontAttributesWriter.h"
#import "RKDOCXFootnotesWriter.h"
#import "RKDOCXImageWriter.h"
#import "RKDOCXPlaceholderWriter.h"
#import "RKDOCXStyleTemplateWriter.h"
#import "RKDOCXTextEffectAttributesWriter.h"

#import "NSString+ParsingConvenience.h"

// Element names
NSString *RKDOCXRunElementName				= @"w:r";
NSString *RKDOCXRunPropertiesElementName	= @"w:rPr";
NSString *RKDOCXRunTextElementName			= @"w:t";
NSString *RKDOCXRunDeletedTextElementName	= @"w:delText";

@implementation RKDOCXRunWriter

+ (NSArray *)runElementsForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range runType:(RKDOCXRunType)runType usingContext:(RKDOCXConversionContext *)context
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
	static NSCharacterSet *characterSet;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		characterSet = [NSCharacterSet characterSetWithCharactersInString: [NSString stringWithFormat: @"\t%C", RKLineSeparatorCharacter]];
	});
	
	NSMutableArray *runElements = [NSMutableArray new];
	[attributedString.string rk_enumerateTokensWithDelimiters:characterSet	inRange:range usingBlock:^(NSRange tokenRange, unichar delimiter) {
		// Add text run, if any
		if (tokenRange.length > 0)
			[runElements addObject: [self runElementForAttributes:attributes contentElement:[self textElementOfType:runType withStringValue: [attributedString.string substringWithRange: tokenRange]] usingContext:context]];
		
		if (delimiter == '\t')
			[runElements addObject: [RKDOCXPlaceholderWriter runElementWithSymbolicCharacter: RKDOCXTabStopCharacter]];
		else if (delimiter == RKLineSeparatorCharacter)
			[runElements addObject: [RKDOCXPlaceholderWriter runElementWithSymbolicCharacter: RKDOCXLineBreakCharacter]];
	}];
	
	return runElements;
}

+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes contentElement:(NSXMLElement *)contentElement usingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: RKDOCXRunElementName];
	NSArray *properties;

	if (attributes)
		properties = [self propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:NO];
	
	if (properties.count) {
		NSXMLElement *runPropertiesElement = [self runPropertiesElementWithProperties: properties];
		[runElement addChild: runPropertiesElement];
	}
	
	NSParameterAssert(contentElement);
	[runElement addChild: contentElement];
	
	return runElement;
}

+ (NSXMLElement *)runPropertiesElementWithProperties:(NSArray *)properties
{
	if (!properties.count)
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXRunPropertiesElementName children:properties attributes:nil];
}

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSMutableArray *properties = [NSMutableArray new];
	
	NSXMLElement *styleReferenceElement = [RKDOCXStyleTemplateWriter characterStyleReferenceElementForAttributes:attributes usingContext:context];
	if (styleReferenceElement)
		[properties addObject: styleReferenceElement];
	
	NSArray *propertyElements = [RKDOCXFontAttributesWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	propertyElements = [RKDOCXTextEffectAttributesWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	return properties;
}

+ (NSXMLElement *)textElementOfType:(RKDOCXRunType)runType withStringValue:(NSString *)stringValue
{
	NSString *textElementName;
	
	switch (runType) {
		case RKDOCXRunDeletedType:
			textElementName = RKDOCXRunDeletedTextElementName;
			break;
			
		// Inserted runs are the same as standard runs
		case RKDOCXRunInsertedType:
		case RKDOCXRunStandardType:
			textElementName = RKDOCXRunTextElementName;
			break;
	}
	
	NSXMLElement *textElement = [NSXMLElement elementWithName:textElementName stringValue:stringValue];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	
	return textElement;
}

@end
