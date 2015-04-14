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
NSString *RKDOCXSettingsRootElementName					= @"w:settings";

// Relationship type and target
NSString *RKDOCXSettingsRelationshipType				= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings";
NSString *RKDOCXSettingsRelationshipTarget				= @"settings.xml";

// Setting names
NSString *RKDOCXSettingsAutoHyphenationPropertyName		= @"w:autoHyphenation";
NSString *RKDOCXSettingsEndnotePropertiesName			= @"w:endnotePr";
NSString *RKDOCXSettingsEnumerationContinuousName		= @"continuous";
NSString *RKDOCXSettingsEnumerationFormatChicago		= @"chicago";
NSString *RKDOCXSettingsEnumerationFormatDecimal		= @"decimal";
NSString *RKDOCXSettingsEnumerationFormatLowerLetter	= @"lowerLetter";
NSString *RKDOCXSettingsEnumerationFormatLowerRoman		= @"lowerRoman";
NSString *RKDOCXSettingsEnumerationFormatPropertyName	= @"w:numFmt";
NSString *RKDOCXSettingsEnumerationFormatUpperLetter	= @"upperLetter";
NSString *RKDOCXSettingsEnumerationFormatUpperRoman		= @"upperRoman";
NSString *RKDOCXSettingsEnumerationPerPageName			= @"eachPage";
NSString *RKDOCXSettingsEnumerationPerSectionName		= @"eachSect";
NSString *RKDOCXSettingsEnumerationRestartPropertyName	= @"w:numRestart";
NSString *RKDOCXSettingsFootnotePropertiesName			= @"w:footnotePr";
NSString *RKDOCXSettingsMirrorMarginsPropertyName		= @"w:mirrorMargins";
NSString *RKDOCXSettingsPositionPropertyName			= @"w:pos";
NSString *RKDOCXSettingsPositionSamePageName			= @"pageBottom";	// Alternatively "beneathText"
NSString *RKDOCXSettingsPositionSectionEndName			= @"sectEnd";
NSString *RKDOCXSettingsPositionDocumentEndName			= @"docEnd";


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
	
	// Hyphenation
	if (context.document.hyphenationEnabled)
		[document.rootElement addChild: [NSXMLElement elementWithName: RKDOCXSettingsAutoHyphenationPropertyName]];
	
#warning Needs further testing when footnotes are supported.
	// Footnote Properties
	NSXMLElement *footnoteProperties = [self footnotePropertiesFromDocument: context.document];
	if (footnoteProperties)
		[document.rootElement addChild: footnoteProperties];
	
	// Endnote Properties
	NSXMLElement *endnoteProperties = [self endnotePropertiesFromDocument: context.document];
	if (endnoteProperties)
		[document.rootElement addChild: endnoteProperties];
	
	// Twosided
	if (context.document.twoSided)
		[document.rootElement addChild: [NSXMLElement elementWithName: RKDOCXSettingsMirrorMarginsPropertyName]];
	
	[context indexForRelationshipWithTarget:RKDOCXSettingsRelationshipTarget andType:RKDOCXSettingsRelationshipType];
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXSettingsFilename];
}

+ (NSXMLElement *)footnotePropertiesFromDocument:(RKDocument *)document
{
	if (document.footnotePlacement == RKFootnotePlacementSamePage && document.footnoteEnumerationStyle == RKFootnoteEnumerationDecimal && document.footnoteEnumerationPolicy == RKFootnoteEnumerationPerPage)
		return nil;
	
	// Footnote Placement
	NSXMLElement *positionAttribute;
	switch (document.footnotePlacement) {
		case RKFootnotePlacementSectionEnd:
			positionAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsPositionSectionEndName];
			break;
			
		case RKFootnotePlacementDocumentEnd:
			positionAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsPositionDocumentEndName];
			break;
			
		default:
			positionAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsPositionSamePageName];
			break;
	}
	NSXMLElement *positionProperty = [NSXMLElement elementWithName: RKDOCXSettingsPositionPropertyName children:nil attributes:@[positionAttribute]];
	
	// Footnote Enumeration Style
	NSXMLElement *enumerationFormatAttribute;
	switch (document.footnoteEnumerationStyle) {
		case RKFootnoteEnumerationRomanLowerCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatLowerRoman];
			break;
			
		case RKFootnoteEnumerationRomanUpperCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatUpperRoman];
			break;
			
		case RKFootnoteEnumerationAlphabeticLowerCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatLowerLetter];
			break;
			
		case RKFootnoteEnumerationAlphabeticUpperCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatUpperLetter];
			break;
			
		case RKFootnoteEnumerationChicagoManual:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatChicago];
			break;
			
		default:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatDecimal];
			break;
	}
	NSXMLElement *enumerationFormatProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationFormatPropertyName children:nil attributes:@[enumerationFormatAttribute]];
	
	// Footnote Enumeration Policy
	NSXMLElement *enumerationRestartAttribute;
	switch (document.footnoteEnumerationPolicy) {
		case RKFootnoteEnumerationPerSection:
			enumerationRestartAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationPerSectionName];
			break;
			
		case RKFootnoteEnumerationPerPage:
			enumerationRestartAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationPerPageName];
			break;
			
		default:
			enumerationRestartAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationContinuousName];
			break;
	}
	NSXMLElement *enumerationRestartProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationRestartPropertyName children:nil attributes:@[enumerationRestartAttribute]];
	
	return [NSXMLElement elementWithName:RKDOCXSettingsFootnotePropertiesName children:@[positionProperty, enumerationFormatProperty, enumerationRestartProperty] attributes:nil];
}

+ (NSXMLElement *)endnotePropertiesFromDocument:(RKDocument *)document
{
	if (document.endnotePlacement == RKEndnotePlacementDocumentEnd && document.endnoteEnumerationStyle == RKFootnoteEnumerationDecimal && document.endnoteEnumerationPolicy == RKFootnoteContinuousEnumeration)
		return nil;
	
	// Endnote Placement
	NSXMLElement *positionAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsPositionSectionEndName];
	switch (document.endnotePlacement) {
		case RKEndnotePlacementSectionEnd:
			positionAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsPositionSectionEndName];
			break;
			
		default:
			positionAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsPositionDocumentEndName];
			break;
	}
	NSXMLElement *positionProperty = [NSXMLElement elementWithName: RKDOCXSettingsPositionPropertyName children:nil attributes:@[positionAttribute]];
	
	// Endnote Enumeration Style
	NSXMLElement *enumerationFormatAttribute;
	switch (document.endnoteEnumerationStyle) {
		case RKFootnoteEnumerationRomanLowerCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatLowerRoman];
			break;
			
		case RKFootnoteEnumerationRomanUpperCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatUpperRoman];
			break;
			
		case RKFootnoteEnumerationAlphabeticLowerCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatLowerLetter];
			break;
			
		case RKFootnoteEnumerationAlphabeticUpperCase:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatUpperLetter];
			break;
			
		case RKFootnoteEnumerationChicagoManual:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatChicago];
			break;
			
		default:
			enumerationFormatAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationFormatDecimal];
			break;
	}
	NSXMLElement *enumerationFormatProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationFormatPropertyName children:nil attributes:@[enumerationFormatAttribute]];
	
	// Endnote Enumeration Policy
	NSXMLElement *enumerationRestartAttribute;
	switch (document.footnoteEnumerationPolicy) {
		case RKFootnoteEnumerationPerSection:
			enumerationRestartAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationPerSectionName];
			break;
			
		case RKFootnoteEnumerationPerPage:
			enumerationRestartAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationPerPageName];
			break;
			
		default:
			enumerationRestartAttribute = [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXSettingsEnumerationContinuousName];
			break;
	}
	NSXMLElement *enumerationRestartProperty = [NSXMLElement elementWithName:RKDOCXSettingsEnumerationRestartPropertyName children:nil attributes:@[enumerationRestartAttribute]];
	
	return [NSXMLElement elementWithName:RKDOCXSettingsEndnotePropertiesName children:@[positionProperty, enumerationFormatProperty, enumerationRestartProperty] attributes:nil];
}

@end
