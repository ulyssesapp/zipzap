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
#import "RKListStyle+FormatStringParserAdditions.h"

// Root element name
NSString *RKDOCXListStyleRootElementName								= @"w:numbering";

// Relationship type and target
NSString *RKDOCXListStyleRelationshipType								= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering";
NSString *RKDOCXListStyleRelationshipTarget								= @"numbering.xml";

// Elements
NSString *RKDOCXListStyleAbstractNumberingElementName					= @"w:abstractNum";
NSString *RKDOCXListStyleLevelAlignmentElementName						= @"w:lvlJc";
NSString *RKDOCXListStyleLevelElementName								= @"w:lvl";
NSString *RKDOCXListStyleLevelTextElementName							= @"w:lvlText";
NSString *RKDOCXListStyleMultiLevelTypeElementName						= @"w:multiLevelType";
NSString *RKDOCXListStyleNumberingElementName							= @"w:num";
NSString *RKDOCXListStyleEnumerationFormatElementName					= @"w:numFmt";
NSString *RKDOCXListStyleStartElementName								= @"w:start";

// Attributes
NSString *RKDOCXListStyleAbstractNumberingAttributeName					= @"w:abstractNumId";
NSString *RKDOCXListStyleLevelAttributeName								= @"w:ilvl";
NSString *RKDOCXListStyleNumberingAttributeName							= @"w:numId";

// Attribute Values
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

+ (void)buildNumberingsUsingContxt:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithStandardNamespacesAndRootElementName: RKDOCXListStyleRootElementName];
	
	// Abstract numberings
	for (NSNumber *index in context.listStyles) {
		[document.rootElement addChild: [self abstractNumberingElementFromListStyle:context.listStyles[index] usingContext:context]];
	}
	
	// Numbering instances
	for (NSNumber *index in context.listStyles) {
		[document.rootElement addChild: [self numberingElementFromListStyleIndentifier: index.integerValue]];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXListStyleRelationshipTarget andType:RKDOCXListStyleRelationshipType];
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXNumberingFilename];
}

+ (NSXMLElement *)abstractNumberingElementFromListStyle:(RKListStyle *)listStyle usingContext:(RKDOCXConversionContext *)context
{
	// Numbering Identifier (§17.9.2)
	NSXMLElement *abstractNumberingElement = [NSXMLElement elementWithName: RKDOCXListStyleAbstractNumberingElementName];
	[abstractNumberingElement addAttribute: [NSXMLElement attributeWithName:RKDOCXListStyleAbstractNumberingAttributeName stringValue:@([context indexForListStyle: listStyle] - 1).stringValue]];
	
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
		__block NSString *levelTextString = @"";
		
		[listStyle scanFullFormatStringOfLevel:index usingBlock:^(id token, NSUInteger tokenLevel) {
			if ([token isKindOfClass: NSNumber.class]) {
				switch ([token integerValue]) {
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
				
				levelTextString = [levelTextString stringByAppendingString: [@"%" stringByAppendingString: @(tokenLevel + 1).stringValue]];
			}
			else if ([token isKindOfClass: NSString.class])
				levelTextString = [levelTextString stringByAppendingString: token];
		}];
		
		if (formatString) {
			NSXMLElement *enumerationFormatElement = [NSXMLElement elementWithName: RKDOCXListStyleEnumerationFormatElementName];
			[enumerationFormatElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:formatString]];
			[levelElement addChild: enumerationFormatElement];
		}
		
		// Level Text (§17.9.11)
		NSXMLElement *levelTextElement = [NSXMLElement elementWithName: RKDOCXListStyleLevelTextElementName];
		[levelTextElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:levelTextString]];
		[levelElement addChild: levelTextElement];
		
		// Level Alignment (§17.9.7)
		NSXMLElement *levelAlignmentElement = [NSXMLElement elementWithName: RKDOCXListStyleLevelAlignmentElementName];
		[levelAlignmentElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXParagraphStyleLeftAlignmentAttributeValue]];
		[levelElement addChild: levelAlignmentElement];
		
		// Enumerator Styling
		NSDictionary *attributes = listStyle.levelStyles[index];
		NSXMLElement *paragraphPropertiesElement = [NSXMLElement elementWithName: RKDOCXParagraphPropertiesElementName];
		NSXMLElement *tabsElement = [NSXMLElement elementWithName: RKDOCXParagraphStyleTabSetElementName];
		[tabsElement addChild: [NSXMLElement elementWithName:RKDOCXParagraphStyleTabElementName children:nil attributes:@[
																								[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@"num"],
																								[NSXMLElement attributeWithName:RKDOCXParagraphStyleTabPositionAttributeName stringValue:@(RKPointsToTwips([attributes[RKListStyleMarkerLocationKey] integerValue] + [attributes[RKListStyleMarkerWidthKey] integerValue])).stringValue]]]];
		[paragraphPropertiesElement addChild: tabsElement];
		NSXMLElement *indentationElement = [NSXMLElement elementWithName:RKDOCXParagraphStyleIndentationElementName children:nil attributes:@[
																											[NSXMLElement attributeWithName:RKDOCXParagraphStyleHeadIndentationAttributeName stringValue:@(RKPointsToTwips([attributes[RKListStyleMarkerLocationKey] integerValue] + [attributes[RKListStyleMarkerWidthKey] integerValue])).stringValue],
																											[NSXMLElement attributeWithName:RKDOCXParagraphStyleHangingIndentationAttributeName stringValue:@(RKPointsToTwips([attributes[RKListStyleMarkerWidthKey] integerValue])).stringValue]
																											]];
		[paragraphPropertiesElement addChild: indentationElement];
		[levelElement addChild: paragraphPropertiesElement];
		
		[abstractNumberingElement addChild: levelElement];
	}
	
	return abstractNumberingElement;
}

+ (NSXMLElement *)numberingElementFromListStyleIndentifier:(NSUInteger)identifier
{
	NSXMLElement *abstractNumberingElement = [NSXMLElement elementWithName: RKDOCXListStyleAbstractNumberingAttributeName];
	[abstractNumberingElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:@(identifier - 1).stringValue]];
	return [NSXMLElement elementWithName:RKDOCXListStyleNumberingElementName children:@[abstractNumberingElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXListStyleNumberingAttributeName stringValue:@(identifier).stringValue]]];
}

@end
