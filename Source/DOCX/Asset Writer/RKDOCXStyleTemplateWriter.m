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

// Relationship type
NSString *RKDOCXStyleTemplateRelationshipType				= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles";

// Filename
NSString *RKDOCXStyleTemplateFilename						= @"styles.xml";

// Elements
NSString *RKDOCXStyleTemplateDocumentDefaultsElementName	= @"w:docDefaults";
NSString *RKDOCXStyleTemplateStyleNameElementName			= @"w:name";
NSString *RKDOCXStyleTemplateParagraphDefaultElementName	= @"w:pPrDefault";
NSString *RKDOCXStyleTemplateParagraphReferenceElementName	= @"w:pStyle";
NSString *RKDOCXStyleTemplateRunDefaultElementName			= @"w:rPrDefault";
NSString *RKDOCXStyleTemplateRunReferenceElementName		= @"w:rStyle";
NSString *RKDOCXStyleTemplateStyleElementName				= @"w:style";

// Attributes
NSString *RKDOCXStyleTemplateDefaultAttributeName			= @"w:default";
NSString *RKDOCXStyleTemplateStyleIDAttributeName			= @"w:styleId";
NSString *RKDOCXStyleTemplateTypeAttributeName				= @"w:type";

// Attribute Values
NSString *RKDOCXStyleTemplateCharacterStyleAttributeValue	= @"character";
NSString *RKDOCXStyleTemplateDefaultAttributeValue			= @"1";
NSString *RKDOCXStyleTemplateDefaultStyleNameAttributeValue	= @"Normal";
NSString *RKDOCXStyleTemplateParagraphStyleAttributeValue	= @"paragraph";

@implementation RKDOCXStyleTemplateWriter

+ (void)buildStyleTemplatesUsingContext:(RKDOCXConversionContext *)context
{
	NSDictionary *defaultStyle = context.document.defaultStyle;
	
	if (!context.document.characterStyles.count && !context.document.paragraphStyles.count && !defaultStyle)
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
	
	// Document defaults (§17.7.5)
	NSXMLElement *documentDefaultsElement = [NSXMLElement elementWithName: RKDOCXStyleTemplateDocumentDefaultsElementName];
	
	// Paragraph defaults
	NSXMLElement *defaultParagraphPropertiesElement = [self newDefaultParagraphPropertiesElementForStyleAttributes: defaultStyle];
	if (defaultParagraphPropertiesElement)
		[documentDefaultsElement addChild: [NSXMLElement elementWithName:RKDOCXStyleTemplateParagraphDefaultElementName children:@[defaultParagraphPropertiesElement] attributes:nil]];
	
	// Character defaults
	NSXMLElement *defaultRunPropertiesElement = [self newDefaultRunPropertiesElementForStyleAttributes: defaultStyle];
	if (defaultRunPropertiesElement)
		[documentDefaultsElement addChild: [NSXMLElement elementWithName:RKDOCXStyleTemplateRunDefaultElementName children:@[defaultRunPropertiesElement] attributes:nil]];
	
	if (documentDefaultsElement.childCount > 0)
		[document.rootElement addChild: documentDefaultsElement];
	
	// Repeat the document defaults as "Normal" style to make Pages happy
	if (defaultStyle.count > 0) {
		NSXMLElement *styleNameElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleNameElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXStyleTemplateDefaultStyleNameAttributeValue]]];
		[document.rootElement addChild: [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleElementName
															 children:@[styleNameElement,
																		[self newDefaultParagraphPropertiesElementForStyleAttributes: defaultStyle],
																		[self newDefaultRunPropertiesElementForStyleAttributes: defaultStyle]]
														   attributes:@[[NSXMLElement attributeWithName:RKDOCXStyleTemplateTypeAttributeName stringValue:RKDOCXStyleTemplateParagraphStyleAttributeValue],
																		[NSXMLElement attributeWithName:RKDOCXStyleTemplateDefaultAttributeName stringValue:RKDOCXStyleTemplateDefaultAttributeValue],
																		[NSXMLElement attributeWithName:RKDOCXStyleTemplateStyleIDAttributeName stringValue:RKDOCXStyleTemplateDefaultStyleNameAttributeValue]]]];
	}
	
	// Paragraph Styles
	for (NSString *styleName in context.document.paragraphStyles) {
		[document.rootElement addChild: [self styleElementForStyleName:styleName usingContext:context isCharacterStyle:NO]];
	}
	
	// Character Styles
	for (NSString *styleName in context.document.characterStyles) {
		[document.rootElement addChild: [self styleElementForStyleName:styleName usingContext:context isCharacterStyle:YES]];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXStyleTemplateFilename andType:RKDOCXStyleTemplateRelationshipType];
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:RKDOCXStyleTemplateFilename folder:RKDOCXWordFolder] contentType:RKDOCXStyleTemplateContentType];
}

+ (NSXMLElement *)newDefaultParagraphPropertiesElementForStyleAttributes:(NSDictionary *)styleAttributes
{
	NSArray *defaultParagraphProperties = [RKDOCXParagraphWriter propertyElementsForAttributes:styleAttributes usingContext:nil];
	return (defaultParagraphProperties.count > 0) ? [NSXMLElement elementWithName:RKDOCXParagraphPropertiesElementName children:defaultParagraphProperties attributes:nil] : nil;
}

+ (NSXMLElement *)newDefaultRunPropertiesElementForStyleAttributes:(NSDictionary *)styleAttributes
{
	NSArray *defaultRunProperties = [RKDOCXRunWriter propertyElementsForAttributes:styleAttributes usingContext:nil];
	return (defaultRunProperties.count > 0) ? [NSXMLElement elementWithName:RKDOCXRunPropertiesElementName children:defaultRunProperties attributes:nil] : nil;
}

+ (NSXMLElement *)styleElementForStyleName:(NSString *)styleName usingContext:(RKDOCXConversionContext *)context isCharacterStyle:(BOOL)isCharacterStyle
{
	NSMutableDictionary *attributes = isCharacterStyle ? [context.document.characterStyles[styleName] mutableCopy] : [context.document.paragraphStyles[styleName] mutableCopy];
	
	// Remove character and paragraph style names to prevent recursive style templates
	[attributes removeObjectForKey: RKCharacterStyleNameAttributeName];
	[attributes removeObjectForKey: RKParagraphStyleNameAttributeName];
	
	NSString *templateTypeAttributeValue = isCharacterStyle ? RKDOCXStyleTemplateCharacterStyleAttributeValue : RKDOCXStyleTemplateParagraphStyleAttributeValue;
	
	NSXMLElement *styleNameElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleNameElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:styleName]]];
	NSXMLElement *styleElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleElementName children:@[styleNameElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXStyleTemplateTypeAttributeName stringValue:templateTypeAttributeValue], [NSXMLElement attributeWithName:RKDOCXStyleTemplateStyleIDAttributeName stringValue:styleName]]];
	
	// In case of paragraph style
	NSArray *paragraphAttributes = [RKDOCXParagraphWriter propertyElementsForAttributes:attributes usingContext:context];
	if (!isCharacterStyle && paragraphAttributes.count > 0)
		[styleElement addChild: [NSXMLElement elementWithName:RKDOCXParagraphPropertiesElementName children:paragraphAttributes attributes:nil]];
	
	NSArray *characterAttributes = [RKDOCXRunWriter propertyElementsForAttributes:attributes usingContext:context];
	if (characterAttributes.count > 0)
		[styleElement addChild: [NSXMLElement elementWithName:RKDOCXRunPropertiesElementName children:characterAttributes attributes:nil]];
	
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
