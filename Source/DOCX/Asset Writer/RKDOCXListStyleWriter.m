//
//  RKDOCXListStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 24.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXListStyleWriter.h"

#import "RKDOCXAttributeWriter.h"
#import "RKDOCXParagraphWriter.h"
#import "RKDOCXParagraphStyleWriter.h"
#import "RKDOCXRunWriter.h"
#import "RKListStyle+FormatStringParserAdditions.h"

// Root element name
NSString *RKDOCXListStyleRootElementName								= @"w:numbering";

// Content type
NSString *RKDOCXNumberingContentType									= @"application/vnd.openxmlformats-officedocument.wordprocessingml.numbering+xml";

// Relationship type
NSString *RKDOCXListStyleRelationshipType								= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering";

// Filename
NSString *RKDOCXNumberingFilename										= @"numbering.xml";

// Elements
NSString *RKDOCXListStyleAbstractNumberingElementName					= @"w:abstractNum";
NSString *RKDOCXListStyleLevelAlignmentElementName						= @"w:lvlJc";
NSString *RKDOCXListStyleLevelElementName								= @"w:lvl";
NSString *RKDOCXListStyleLevelTextElementName							= @"w:lvlText";
NSString *RKDOCXListStyleMultiLevelTypeElementName						= @"w:multiLevelType";
NSString *RKDOCXListStyleNumberingElementName							= @"w:num";
NSString *RKDOCXListStyleEnumerationFormatElementName					= @"w:numFmt";
NSString *RKDOCXListStyleStartElementName								= @"w:start";
NSString *RKDOCXListStyleLevelOverrideElementName						= @"w:lvlOverride";
NSString *RKDOCXListStyleStartIndexOverrideElementName					= @"w:startOverride";

// Attributes
NSString *RKDOCXListStyleAbstractNumberingAttributeName					= @"w:abstractNumId";
NSString *RKDOCXListStyleLevelAttributeName								= @"w:ilvl";
NSString *RKDOCXListStyleNumberingAttributeName							= @"w:numId";

// Attribute Values
NSString *RKDOCXListStyleAlignmentAttributeValue						= @"left";
NSString *RKDOCXListStyleMultiLevelTypeHybridMultilevelAttributeValue	= @"hybridMultilevel";
NSString *RKDOCXListStyleMultiLevelTypeMultilevelAttributeValue			= @"multilevel";
NSString *RKDOCXListStyleMultiLevelTypeSingleLevelAttributeValue		= @"singleLevel";
NSString *RKDOCXListStyleEnumerationFormatBulletAttributeValue			= @"bullet";
NSString *RKDOCXListStyleEnumerationFormatChicagoAttributeValue			= @"chicago";
NSString *RKDOCXListStyleEnumerationFormatDecimalAttributeValue			= @"decimal";
NSString *RKDOCXListStyleEnumerationFormatLowerLetterAttributeValue		= @"lowerLetter";
NSString *RKDOCXListStyleEnumerationFormatLowerRomanAttributeValue		= @"lowerRoman";
NSString *RKDOCXListStyleEnumerationFormatNoneAttributeValue			= @"none";
NSString *RKDOCXListStyleEnumerationFormatUpperLetterAttributeValue		= @"upperLetter";
NSString *RKDOCXListStyleEnumerationFormatUpperRomanAttributeValue		= @"upperRoman";

@implementation RKDOCXListStyleWriter

+ (void)buildNumberingDefinitionsUsingContext:(RKDOCXConversionContext *)context
{
	if (!context.numberingDefinitions.count)
		return;
	
	NSXMLDocument *document = [self basicXMLDocumentWithStandardNamespacesAndRootElementName: RKDOCXListStyleRootElementName];

	// Collect numbering definitions
	NSMutableArray *numberingDefinitionElements = [NSMutableArray new];
	for (NSNumber *index in [context.numberingDefinitions.allKeys sortedArrayUsingSelector: @selector(compare:)]) {
		[numberingDefinitionElements addObject: [self numberingDefinitionWithIndex:index listItem:context.numberingDefinitions[index] context:context]];
	}
	
	// Abstract numberings
	for (NSNumber *index in [context.listStyles.allKeys sortedArrayUsingSelector: @selector(compare:)]) {
		[document.rootElement addChild: [self abstractNumberingElementFromListStyle:context.listStyles[index] usingContext:context]];
	}
	
	// Numbering instances
	for (NSXMLElement *numberingDefinitionElement in numberingDefinitionElements) {
		[document.rootElement addChild: numberingDefinitionElement];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXNumberingFilename andType:RKDOCXListStyleRelationshipType];
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:RKDOCXNumberingFilename folder:RKDOCXWordFolder] contentType:RKDOCXNumberingContentType];
}

+ (NSXMLElement *)abstractNumberingElementFromListStyle:(RKListStyle *)listStyle usingContext:(RKDOCXConversionContext *)context
{
	// Numbering Identifier (§17.9.2)
	NSXMLElement *abstractNumberingElement = [NSXMLElement elementWithName: RKDOCXListStyleAbstractNumberingElementName];
	[abstractNumberingElement addAttribute: [NSXMLElement attributeWithName:RKDOCXListStyleAbstractNumberingAttributeName stringValue:@([context indexForListStyle: listStyle]).stringValue]];
	
	// Multi level type (§17.9.12)
	NSXMLElement *multiLevelTypeElement = [NSXMLElement elementWithName: RKDOCXListStyleMultiLevelTypeElementName];
	NSXMLElement *multiLevelTypeAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:(listStyle.numberOfLevels == 1) ? RKDOCXListStyleMultiLevelTypeSingleLevelAttributeValue : RKDOCXListStyleMultiLevelTypeMultilevelAttributeValue];
	[multiLevelTypeElement addAttribute: multiLevelTypeAttribute];
	[abstractNumberingElement addChild: multiLevelTypeElement];
	
	// Numbering level definitions (§17.9.6)
	for (NSUInteger index = 0; index < listStyle.numberOfLevels; index++) {
		NSXMLElement *levelElement = [NSXMLElement elementWithName: RKDOCXListStyleLevelElementName];
		[levelElement addAttribute: [NSXMLElement attributeWithName:RKDOCXListStyleLevelAttributeName stringValue:@(index).stringValue]];
		
		// Start Number (§17.9.25)
		NSXMLElement *startElement = [NSXMLElement elementWithName: RKDOCXListStyleStartElementName];
		[startElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:[listStyle.startNumbers[index] stringValue] ?: @"1"]];
		[levelElement addChild: startElement];
		
		// Enumeration Format (§17.9.17)
		__block NSString *formatString;
		NSMutableString *levelTextString = [[NSMutableString alloc] initWithString: @""];
		
		[listStyle scanFullFormatStringOfLevel:index usingBlock:^(id token, NSUInteger tokenLevel) {
			if ([token isKindOfClass: NSNumber.class]) {
				switch ([token unsignedIntegerValue]) {
					case RKListFormatCodeBullet:
						formatString = RKDOCXListStyleEnumerationFormatBulletAttributeValue;
						break;
						
					case RKListFormatCodeDecimal:
						formatString = RKDOCXListStyleEnumerationFormatDecimalAttributeValue;
						break;
						
					case RKListFormatCodeLowerCaseLetter:
						formatString = RKDOCXListStyleEnumerationFormatLowerLetterAttributeValue;
						break;
						
					case RKListFormatCodeLowerCaseRoman:
						formatString = RKDOCXListStyleEnumerationFormatLowerRomanAttributeValue;
						break;
						
					case RKListFormatCodeUpperCaseLetter:
						formatString = RKDOCXListStyleEnumerationFormatUpperLetterAttributeValue;
						break;
						
					case RKListFormatCodeUpperCaseRoman:
						formatString = RKDOCXListStyleEnumerationFormatUpperRomanAttributeValue;
						break;
				}
				
				[levelTextString appendString:[@"%" stringByAppendingString: @(tokenLevel + 1).stringValue]];
			}
			else if ([token isKindOfClass: NSString.class])
				[levelTextString appendString: token];
		}];
		
		// Set enumeration format to bullet, if list is unordered
		if (!formatString)
			formatString = RKDOCXListStyleEnumerationFormatBulletAttributeValue;
		
		NSXMLElement *enumerationFormatElement = [NSXMLElement elementWithName: RKDOCXListStyleEnumerationFormatElementName];
		[enumerationFormatElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:formatString]];
		[levelElement addChild: enumerationFormatElement];
		
		// Level Text (§17.9.11)
		NSXMLElement *levelTextElement = [NSXMLElement elementWithName: RKDOCXListStyleLevelTextElementName];
		[levelTextElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:levelTextString]];
		[levelElement addChild: levelTextElement];
		
		// Level Alignment (§17.9.7)
		NSXMLElement *levelAlignmentElement = [NSXMLElement elementWithName: RKDOCXListStyleLevelAlignmentElementName];
		[levelAlignmentElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXListStyleAlignmentAttributeValue]];
		[levelElement addChild: levelAlignmentElement];
		
		// Enumerator Styling
		NSDictionary *attributes = listStyle.levelStyles[index];
		NSXMLElement *paragraphPropertiesElement = [RKDOCXParagraphWriter paragraphPropertiesElementForMarkerLocation:[attributes[RKListStyleMarkerLocationKey] unsignedIntegerValue] markerWidth:[attributes[RKListStyleMarkerWidthKey] unsignedIntegerValue]];
		[levelElement addChild: paragraphPropertiesElement];
		
		NSXMLElement *runPropertiesElement = [RKDOCXRunWriter runPropertiesElementWithProperties: [RKDOCXRunWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:NO]];
		if (runPropertiesElement.childCount > 0)
			[levelElement addChild: runPropertiesElement];
		
		[abstractNumberingElement addChild: levelElement];
	}
	
	return abstractNumberingElement;
}

+ (NSXMLElement *)numberingDefinitionWithIndex:(NSNumber *)definitionIndex listItem:(RKListItem *)listItem context:(RKDOCXConversionContext *)context
{
	NSUInteger listStyleIndex = [context indexForListStyle: listItem.listStyle];
	NSXMLElement *abstractNumberingElement = [NSXMLElement elementWithName: RKDOCXListStyleAbstractNumberingAttributeName];
	[abstractNumberingElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@(listStyleIndex).stringValue]];

	NSXMLElement *numberingDefinitionElement = [NSXMLElement elementWithName:RKDOCXListStyleNumberingElementName children:@[abstractNumberingElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXListStyleNumberingAttributeName stringValue:definitionIndex.stringValue]]];
	if (listItem.resetIndex != NSUIntegerMax) {
		NSXMLElement *startOverrideElement = [NSXMLElement elementWithName:RKDOCXListStyleStartIndexOverrideElementName];
		[startOverrideElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@(listItem.resetIndex).stringValue]];
		
		NSXMLElement *indentationLevelAttribute = [NSXMLElement attributeWithName:RKDOCXListStyleLevelAttributeName stringValue:@(listItem.indentationLevel).stringValue];
		NSXMLElement *levelOverrideElement = [NSXMLElement elementWithName:RKDOCXListStyleLevelOverrideElementName children:@[startOverrideElement] attributes:@[indentationLevelAttribute]];
		
		[numberingDefinitionElement addChild: levelOverrideElement];
	}
	
	return numberingDefinitionElement;
}

@end
