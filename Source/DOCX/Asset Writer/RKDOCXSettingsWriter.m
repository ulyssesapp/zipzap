//
//  RKDOCXSettingsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXSettingsWriter.h"

#import "RKDOCXAttributeWriter.h"

// Root element name
NSString *RKDOCXSettingsRootElementName								= @"w:settings";

// Relationship type and target
NSString *RKDOCXSettingsRelationshipType							= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings";
NSString *RKDOCXSettingsRelationshipTarget							= @"settings.xml";

// Setting names
// Elements
NSString *RKDOCXSettingsAutoHyphenationElementName					= @"w:autoHyphenation";
NSString *RKDOCXSettingsEndnotePropertiesElementName				= @"w:endnotePr";
NSString *RKDOCXSettingsEnumerationFormatElementName				= @"w:numFmt";
NSString *RKDOCXSettingsEnumerationRestartElementName				= @"w:numRestart";
NSString *RKDOCXSettingsFootnotePropertiesElementName				= @"w:footnotePr";
NSString *RKDOCXSettingsMirrorMarginsElementName					= @"w:mirrorMargins";
NSString *RKDOCXSettingsPositionElementName							= @"w:pos";

// Attribute Values
NSString *RKDOCXSettingsEnumerationContinuousAttributeValue			= @"continuous";
NSString *RKDOCXSettingsEnumerationFormatChicagoAttributeValue		= @"chicago";
NSString *RKDOCXSettingsEnumerationFormatDecimalAttributeValue		= @"decimal";
NSString *RKDOCXSettingsEnumerationFormatLowerLetterAttributeValue	= @"lowerLetter";
NSString *RKDOCXSettingsEnumerationFormatLowerRomanAttributeValue	= @"lowerRoman";
NSString *RKDOCXSettingsEnumerationFormatUpperLetterAttributeValue	= @"upperLetter";
NSString *RKDOCXSettingsEnumerationFormatUpperRomanAttributeValue	= @"upperRoman";
NSString *RKDOCXSettingsEnumerationPerPageAttributeValue			= @"eachPage";
NSString *RKDOCXSettingsEnumerationPerSectionAttributeValue			= @"eachSect";
NSString *RKDOCXSettingsPositionSamePageAttributeValue				= @"pageBottom";	// Alternatively "beneathText"
NSString *RKDOCXSettingsPositionSectionEndAttributeValue			= @"sectEnd";
NSString *RKDOCXSettingsPositionDocumentEndAttributeValue			= @"docEnd";


@implementation RKDOCXSettingsWriter

+ (void)buildSettingsUsingContext:(RKDOCXConversionContext *)context
{
	// Namespaces
	NSDictionary *namespaces = @{
								 @"xmlns:mc": @"http://schemas.openxmlformats.org/markup-compatibility/2006",
								 @"xmlns:o": @"urn:schemas-microsoft-com:office:office",
								 @"xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
								 @"xmlns:m": @"http://schemas.openxmlformats.org/officeDocument/2006/math",
								 @"xmlns:v": @"urn:schemas-microsoft-com:vml",
								 @"xmlns:w10": @"urn:schemas-microsoft-com:office:word",
								 @"xmlns:w": @"http://schemas.openxmlformats.org/wordprocessingml/2006/main",
								 @"xmlns:w14": @"http://schemas.microsoft.com/office/word/2010/wordml",
								 @"xmlns:w15": @"http://schemas.microsoft.com/office/word/2012/wordml",
								 @"xmlns:sl": @"http://schemas.openxmlformats.org/schemaLibrary/2006/main",
								 @"mc:Ignorable": @"w14 w15"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXSettingsRootElementName namespaces:namespaces];
	
	// Settings
	// Complex type font compatibility settings
	NSXMLElement *compat = [NSXMLElement elementWithName: @"w:compat"];
	[compat addChild: [NSXMLElement elementWithName: @"w:useFELayout"]];
	
	// Avoid compatibility mode
	NSXMLElement *compatSetting = [NSXMLElement elementWithName: @"w:compatSetting"];
	[compatSetting addAttribute: [NSXMLElement attributeWithName:@"w:name" stringValue:@"compatibilityMode"]];
	[compatSetting addAttribute: [NSXMLElement attributeWithName:@"w:uri" stringValue:@"http://schemas.microsoft.com/office/word"]];
	[compatSetting addAttribute: [NSXMLElement attributeWithName:@"w:val" stringValue:@"15"]];
	[compat addChild: compatSetting];
	
	[document.rootElement addChild: compat];
	
	// Hyphenation (§17.15.1.10)
	if (context.document.hyphenationEnabled)
		[document.rootElement addChild: [NSXMLElement elementWithName: RKDOCXSettingsAutoHyphenationElementName]];
	
#warning Needs further testing when footnotes are supported.
	// Footnote Properties
	NSXMLElement *footnoteProperties = [self footnotePropertiesFromDocument: context.document];
	if (footnoteProperties)
		[document.rootElement addChild: footnoteProperties];
	
	// Endnote Properties
	NSXMLElement *endnoteProperties = [self endnotePropertiesFromDocument: context.document];
	if (endnoteProperties)
		[document.rootElement addChild: endnoteProperties];
	
	// Twosided (§17.15.1.57)
	if (context.document.twoSided)
		[document.rootElement addChild: [NSXMLElement elementWithName: RKDOCXSettingsMirrorMarginsElementName]];
	
	[context indexForRelationshipWithTarget:RKDOCXSettingsRelationshipTarget andType:RKDOCXSettingsRelationshipType];
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXSettingsFilename];
}

+ (NSXMLElement *)footnotePropertiesFromDocument:(RKDocument *)document
{
	if (document.footnotePlacement == RKFootnotePlacementSamePage && document.footnoteEnumerationStyle == RKFootnoteEnumerationDecimal && document.footnoteEnumerationPolicy == RKFootnoteEnumerationPerPage)
		return nil;
	
	// Footnote Placement (§17.11.21)
	NSString *xmlPositionAttributeValue;
	switch (document.footnotePlacement) {
		case RKFootnotePlacementSectionEnd:
			xmlPositionAttributeValue = RKDOCXSettingsPositionSectionEndAttributeValue;
			break;
			
		case RKFootnotePlacementDocumentEnd:
			xmlPositionAttributeValue = RKDOCXSettingsPositionDocumentEndAttributeValue;
			break;
			
		default:
			xmlPositionAttributeValue = RKDOCXSettingsPositionSamePageAttributeValue;
			break;
	}
	NSXMLElement *positionProperty = [NSXMLElement elementWithName: RKDOCXSettingsPositionElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:xmlPositionAttributeValue]]];
	
	// Footnote Enumeration Style (§17.11.18)
	NSString *enumerationFormatAttributeValue;
	switch (document.footnoteEnumerationStyle) {
		case RKFootnoteEnumerationRomanLowerCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatLowerRomanAttributeValue;
			break;
			
		case RKFootnoteEnumerationRomanUpperCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatUpperRomanAttributeValue;
			break;
			
		case RKFootnoteEnumerationAlphabeticLowerCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatLowerLetterAttributeValue;
			break;
			
		case RKFootnoteEnumerationAlphabeticUpperCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatUpperLetterAttributeValue;
			break;
			
		case RKFootnoteEnumerationChicagoManual:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatChicagoAttributeValue;
			break;
			
		default:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatDecimalAttributeValue;
			break;
	}
	NSXMLElement *enumerationFormatProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationFormatElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:enumerationFormatAttributeValue]]];
	
	// Footnote Enumeration Policy (§17.11.19)
	NSString *enumerationRestartAttributeValue;
	switch (document.footnoteEnumerationPolicy) {
		case RKFootnoteEnumerationPerSection:
			enumerationRestartAttributeValue = RKDOCXSettingsEnumerationPerSectionAttributeValue;
			break;
			
		case RKFootnoteEnumerationPerPage:
			enumerationRestartAttributeValue = RKDOCXSettingsEnumerationPerPageAttributeValue;
			break;
			
		default:
			enumerationRestartAttributeValue = RKDOCXSettingsEnumerationContinuousAttributeValue;
			break;
	}
	NSXMLElement *enumerationRestartProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationRestartElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:enumerationRestartAttributeValue]]];
	
	return [NSXMLElement elementWithName:RKDOCXSettingsFootnotePropertiesElementName children:@[positionProperty, enumerationFormatProperty, enumerationRestartProperty] attributes:nil];
}

+ (NSXMLElement *)endnotePropertiesFromDocument:(RKDocument *)document
{
	if (document.endnotePlacement == RKEndnotePlacementDocumentEnd && document.endnoteEnumerationStyle == RKFootnoteEnumerationDecimal && document.endnoteEnumerationPolicy == RKFootnoteContinuousEnumeration)
		return nil;
	
	// Endnote Placement (§17.11.22)
	NSString *xmlPositionAttributeValue;
	switch (document.endnotePlacement) {
		case RKEndnotePlacementSectionEnd:
			xmlPositionAttributeValue = RKDOCXSettingsPositionSectionEndAttributeValue;
			break;
			
		default:
			xmlPositionAttributeValue = RKDOCXSettingsPositionDocumentEndAttributeValue;
			break;
	}
	NSXMLElement *positionProperty = [NSXMLElement elementWithName: RKDOCXSettingsPositionElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:xmlPositionAttributeValue]]];
	
	// Endnote Enumeration Style (§17.11.17)
	NSString *enumerationFormatAttributeValue;
	switch (document.endnoteEnumerationStyle) {
		case RKFootnoteEnumerationRomanLowerCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatLowerRomanAttributeValue;
			break;
			
		case RKFootnoteEnumerationRomanUpperCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatUpperRomanAttributeValue;
			break;
			
		case RKFootnoteEnumerationAlphabeticLowerCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatLowerLetterAttributeValue;
			break;
			
		case RKFootnoteEnumerationAlphabeticUpperCase:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatUpperLetterAttributeValue;
			break;
			
		case RKFootnoteEnumerationChicagoManual:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatChicagoAttributeValue;
			break;
			
		default:
			enumerationFormatAttributeValue = RKDOCXSettingsEnumerationFormatDecimalAttributeValue;
			break;
	}
	NSXMLElement *enumerationFormatProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationFormatElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:enumerationFormatAttributeValue]]];
	
	// Endnote Enumeration Policy (§17.11.19)
	NSString *enumerationRestartAttributeValue;
	switch (document.footnoteEnumerationPolicy) {
		case RKFootnoteEnumerationPerSection:
			enumerationRestartAttributeValue = RKDOCXSettingsEnumerationPerSectionAttributeValue;
			break;
			
		case RKFootnoteEnumerationPerPage:
			enumerationRestartAttributeValue = RKDOCXSettingsEnumerationPerPageAttributeValue;
			break;
			
		default:
			enumerationRestartAttributeValue = RKDOCXSettingsEnumerationContinuousAttributeValue;
			break;
	}
	NSXMLElement *enumerationRestartProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationRestartElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:enumerationRestartAttributeValue]]];
	
	return [NSXMLElement elementWithName:RKDOCXSettingsEndnotePropertiesElementName children:@[positionProperty, enumerationFormatProperty, enumerationRestartProperty] attributes:nil];
}

@end
