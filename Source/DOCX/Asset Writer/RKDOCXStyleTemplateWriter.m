//
//  RKDOCXStyleTemplateWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 29.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXStyleTemplateWriter.h"

#import "RKDOCXAttributeWriter.h"
#import "RKDOCXRunWriter.h"

// Root element name
NSString *RKDOCXStyleTemplateRootElementName				= @"w:styles";

// Content type
NSString *RKDOCXStyleTemplateContentType					= @"application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml";

// Relationship type and target
NSString *RKDOCXStyleTemplateRelationshipType				= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles";
NSString *RKDOCXStyleTemplateRelationshipTarget				= @"styles.xml";

// Elements
NSString *RKDOCXStyleTemplateStyleNameElementName			= @"w:name";
NSString *RKDOCXStyleTemplateParagraphPropertiesElementName	= @"w:pPr";
NSString *RKDOCXStyleTemplateParagraphReferenceElementName	= @"w:pStyle";
NSString *RKDOCXStyleTemplateRunPropertiesElementName		= @"w:rPr";
NSString *RKDOCXStyleTemplateRunReferenceElementName		= @"w:rStyle";
NSString *RKDOCXStyleTemplateStyleElementName				= @"w:style";

// Attributes
NSString *RKDOCXStyleTemplateStyleIDAttributeName			= @"w:styleId";
NSString *RKDOCXStyleTemplateTypeAttributeName				= @"w:type";

// Attribute Values
NSString *RKDOCXStyleTemplateCharacterStyleAttributeValue	= @"character";
NSString *RKDOCXStyleTemplateParagraphStyleAttributeValue	= @"paragraph";

@implementation RKDOCXStyleTemplateWriter

+ (void)buildStyleTemplatesUsingContext:(RKDOCXConversionContext *)context
{
	if (!context.document.characterStyles && !context.document.paragraphStyles)
		return;
	
	// Namespaces
	NSDictionary *namespaces = @{
								 @"xmlns:mc": @"http://schemas.openxmlformats.org/markup-compatibility/2006",
								 @"xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
								 @"xmlns:w": @"http://schemas.openxmlformats.org/wordprocessingml/2006/main",
								 @"xmlns:w14": @"http://schemas.microsoft.com/office/word/2010/wordml",
								 @"xmlns:w15": @"http://schemas.microsoft.com/office/word/2012/wordml",
								 @"mc:Ignorable": @"w14 w15"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXStyleTemplateRootElementName namespaces:namespaces];
	
	for (NSString *styleName in context.document.characterStyles) {
		NSDictionary *attributes = context.document.characterStyles[styleName];
		
		NSXMLElement *styleNameElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleNameElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:styleName]]];
		NSXMLElement *runProperties = [NSXMLElement elementWithName:RKDOCXStyleTemplateRunPropertiesElementName children:[RKDOCXRunWriter propertyElementsForAttributes:attributes usingContext:context] attributes:nil];
		NSXMLElement *styleElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleElementName
														  children:@[styleNameElement, runProperties]
														attributes:@[[NSXMLElement attributeWithName:RKDOCXStyleTemplateTypeAttributeName stringValue:RKDOCXStyleTemplateCharacterStyleAttributeValue],
																	 [NSXMLElement attributeWithName:RKDOCXStyleTemplateStyleIDAttributeName stringValue:styleName]]];
		[document.rootElement addChild: styleElement];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXStyleTemplateRelationshipTarget andType:RKDOCXStyleTemplateRelationshipType];
	[context addXMLDocumentPart:document withFilename:RKDOCXStyleTemplateFilename contentType:RKDOCXStyleTemplateContentType];
}

+ (NSXMLElement *)characterStyleReferenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (!attributes[RKCharacterStyleNameAttributeName])
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXStyleTemplateRunReferenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:attributes[RKCharacterStyleNameAttributeName]]]];
}

@end
