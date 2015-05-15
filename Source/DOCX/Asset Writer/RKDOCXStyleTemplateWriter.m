//
//  RKDOCXStyleTemplateWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 29.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXStyleTemplateWriter.h"

#import "RKDOCXAttributeWriter.h"
#import "RKDOCXParagraphWriter.h"
#import "RKDOCXRunWriter.h"

// Root element name
NSString *RKDOCXStyleTemplateRootElementName				= @"w:styles";

// Content type
NSString *RKDOCXStyleTemplateContentType					= @"application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml";

// Relationship type and target
NSString *RKDOCXStyleTemplateRelationshipType				= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles";

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
	
	// Paragraph Styles
	for (NSString *styleName in context.document.paragraphStyles) {
		[document.rootElement addChild: [self styleElementForStyleName:styleName usingContext:context isCharacterStyle:NO]];
	}
	
	// Character Styles
	for (NSString *styleName in context.document.characterStyles) {
		[document.rootElement addChild: [self styleElementForStyleName:styleName usingContext:context isCharacterStyle:YES]];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXStyleTemplateFilename andType:RKDOCXStyleTemplateRelationshipType];
	[context addXMLDocumentPart:document withFilename:[self fullPathForFilename:RKDOCXStyleTemplateFilename inLevel:RKDOCXWordLevel] contentType:RKDOCXStyleTemplateContentType];
}

+ (NSXMLElement *)styleElementForStyleName:(NSString *)styleName usingContext:(RKDOCXConversionContext *)context isCharacterStyle:(BOOL)isCharacterStyle
{
	NSDictionary *attributes = isCharacterStyle ? context.document.characterStyles[styleName] : context.document.paragraphStyles[styleName];
	NSString *templateTypeAttributeValue = isCharacterStyle ? RKDOCXStyleTemplateCharacterStyleAttributeValue : RKDOCXStyleTemplateParagraphStyleAttributeValue;
	
	NSXMLElement *styleNameElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleNameElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:styleName]]];
	NSXMLElement *styleElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleElementName children:@[styleNameElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXStyleTemplateTypeAttributeName stringValue:templateTypeAttributeValue], [NSXMLElement attributeWithName:RKDOCXStyleTemplateStyleIDAttributeName stringValue:styleName]]];
	
	// In case of paragraph style
	NSArray *paragraphAttributes = [RKDOCXParagraphWriter propertyElementsForAttributes:attributes usingContext:context];
	if (!isCharacterStyle && paragraphAttributes.count > 0)
		[styleElement addChild: [NSXMLElement elementWithName:RKDOCXStyleTemplateParagraphPropertiesElementName children:paragraphAttributes attributes:nil]];
	
	NSArray *characterAttributes = [RKDOCXRunWriter propertyElementsForAttributes:attributes usingContext:context];
	if (characterAttributes.count > 0)
		[styleElement addChild: [NSXMLElement elementWithName:RKDOCXStyleTemplateRunPropertiesElementName children:characterAttributes attributes:nil]];
	
	return styleElement;
}

+ (NSXMLElement *)paragraphStyleReferenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (!attributes[RKParagraphStyleNameAttributeName])
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXStyleTemplateParagraphReferenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:attributes[RKParagraphStyleNameAttributeName]]]];
}

+ (NSXMLElement *)characterStyleReferenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (!attributes[RKCharacterStyleNameAttributeName])
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXStyleTemplateRunReferenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:attributes[RKCharacterStyleNameAttributeName]]]];
}

@end
