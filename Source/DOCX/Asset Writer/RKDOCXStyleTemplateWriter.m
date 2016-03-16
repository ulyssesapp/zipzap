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

#import "NSXMLElement+IntegerValueConvenience.h"

// Root element name
NSString *RKDOCXStyleTemplateRootElementName				= @"w:styles";

// Content type
NSString *RKDOCXStyleTemplateContentType					= @"application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml";

// Relationship type
NSString *RKDOCXStyleTemplateRelationshipType				= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles";

// Filename
NSString *RKDOCXStyleTemplateFilename						= @"styles.xml";

// Elements
NSString *RKDOCXStyleTemplateBasedOnElementName				= @"w:basedOn";
NSString *RKDOCXStyleTemplateDocumentDefaultsElementName	= @"w:docDefaults";
NSString *RKDOCXStyleTemplateStyleNameElementName			= @"w:name";
NSString *RKDOCXStyleTemplatePrimaryStyleElementName		= @"w:qFormat";
NSString *RKDOCXStyleTemplateUIPriorityElementName			= @"w:uiPriority";
NSString *RKDOCXStyleTemplateParagraphDefaultElementName	= @"w:pPrDefault";
NSString *RKDOCXStyleTemplateParagraphReferenceElementName	= @"w:pStyle";
NSString *RKDOCXStyleTemplateRunDefaultElementName			= @"w:rPrDefault";
NSString *RKDOCXStyleTemplateRunReferenceElementName		= @"w:rStyle";
NSString *RKDOCXStyleTemplateSemiHiddenElementName			= @"w:semiHidden";
NSString *RKDOCXStyleTemplateStyleElementName				= @"w:style";
NSString *RKDOCXStyleTemplateUnhideWhenUsedElementName		= @"w:unhideWhenUsed";

// Attributes
NSString *RKDOCXStyleTemplateDefaultAttributeName			= @"w:default";
NSString *RKDOCXStyleTemplateStyleIDAttributeName			= @"w:styleId";
NSString *RKDOCXStyleTemplateTypeAttributeName				= @"w:type";

// Attribute Values
NSString *RKDOCXStyleTemplateCharacterStyleAttributeValue	= @"character";
NSString *RKDOCXStyleTemplateDefaultAttributeValue			= @"1";
NSString *RKDOCXStyleTemplateDefaultStyleNameAttributeValue	= @"Normal";
NSString *RKDOCXStyleTemplateParagraphStyleAttributeValue	= @"paragraph";
NSString *RKDOCXStyleTemplateDefaultStyleName				= @"Normal";

NSUInteger RKDOCXUIPriorityParagraphStyle					= 1;
NSUInteger RKDOCXUIPriorityCharacterStyle					= 2;


@implementation RKDOCXStyleTemplateWriter

+ (void)buildStyleTemplatesUsingContext:(RKDOCXConversionContext *)context
{
	NSDictionary *defaultStyle = context.document.defaultStyle;
	
	if (!context.characterStyles.count && !context.paragraphStyles.count && !defaultStyle)
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
	NSXMLElement *defaultParagraphPropertiesElement = [self defaultParagraphPropertiesElementForStyleAttributes:defaultStyle usingContext:context];
	if (defaultParagraphPropertiesElement)
		[documentDefaultsElement addChild: [NSXMLElement elementWithName:RKDOCXStyleTemplateParagraphDefaultElementName children:@[defaultParagraphPropertiesElement] attributes:nil]];
	
	// Character defaults
	NSXMLElement *defaultRunPropertiesElement = [self defaultRunPropertiesElementForStyleAttributes:defaultStyle usingContext:context];
	if (defaultRunPropertiesElement)
		[documentDefaultsElement addChild: [NSXMLElement elementWithName:RKDOCXStyleTemplateRunDefaultElementName children:@[defaultRunPropertiesElement] attributes:nil]];
	
	if (documentDefaultsElement.childCount > 0)
		[document.rootElement addChild: documentDefaultsElement];
	
	// Repeat the document defaults as "Normal", otherwise Pages ignores the default settings.
	// Additionally, Pages requires every paragraph to use a style, or else it will use the previous paragraph’s formatting.
	if (defaultStyle.count > 0) {
		NSXMLElement *styleNameElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleNameElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXStyleTemplateDefaultStyleNameAttributeValue]]];
		NSXMLElement *styleElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleElementName
															  children:@[styleNameElement, [NSXMLElement elementWithName:RKDOCXStyleTemplatePrimaryStyleElementName children:nil attributes:nil]]
															attributes:@[[NSXMLElement attributeWithName:RKDOCXStyleTemplateTypeAttributeName stringValue:RKDOCXStyleTemplateParagraphStyleAttributeValue],
																		 [NSXMLElement attributeWithName:RKDOCXStyleTemplateDefaultAttributeName stringValue:RKDOCXStyleTemplateDefaultAttributeValue],
																		 [NSXMLElement attributeWithName:RKDOCXStyleTemplateStyleIDAttributeName stringValue:RKDOCXStyleTemplateDefaultStyleNameAttributeValue]]];
		NSXMLElement *paragraphDefaultsElement = [self defaultParagraphPropertiesElementForStyleAttributes:defaultStyle usingContext:context];
		if (paragraphDefaultsElement)
			[styleElement addChild: paragraphDefaultsElement];
		
		NSXMLElement *runDefaultsElement = [self defaultRunPropertiesElementForStyleAttributes:defaultStyle usingContext:context];
		if (runDefaultsElement)
			[styleElement addChild: runDefaultsElement];
		
		[document.rootElement addChild: styleElement];
	}
	
	// Paragraph Styles
	for (NSString *styleName in context.paragraphStyles) {
		[document.rootElement addChild: [self styleElementForStyleName:styleName usingContext:context isCharacterStyle:NO]];
	}
	
	// Character Styles
	for (NSString *styleName in context.characterStyles) {
		[document.rootElement addChild: [self styleElementForStyleName:styleName usingContext:context isCharacterStyle:YES]];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXStyleTemplateFilename andType:RKDOCXStyleTemplateRelationshipType];
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:RKDOCXStyleTemplateFilename folder:RKDOCXWordFolder] contentType:RKDOCXStyleTemplateContentType];
}

+ (NSXMLElement *)defaultParagraphPropertiesElementForStyleAttributes:(NSDictionary *)styleAttributes usingContext:(RKDOCXConversionContext *)context
{
	// Ignore style templates, to prevent that default style will be based upon its own.
	return [RKDOCXParagraphWriter paragraphPropertiesElementWithProperties: [RKDOCXParagraphWriter propertyElementsForAttributes:styleAttributes usingContext:context isDefaultStyle:YES]];
}

+ (NSXMLElement *)defaultRunPropertiesElementForStyleAttributes:(NSDictionary *)styleAttributes usingContext:(RKDOCXConversionContext *)context
{
	// Ignore style templates, to prevent that default style will be based upon its own.
	return [RKDOCXRunWriter runPropertiesElementWithProperties: [RKDOCXRunWriter propertyElementsForAttributes:styleAttributes usingContext:context isDefaultStyle:YES]];
}

+ (NSXMLElement *)styleElementForStyleName:(NSString *)styleName usingContext:(RKDOCXConversionContext *)context isCharacterStyle:(BOOL)isCharacterStyle
{
	NSMutableDictionary *attributes = isCharacterStyle ? [context.characterStyles[styleName] mutableCopy] : [context.paragraphStyles[styleName] mutableCopy];
	NSUInteger uiPriority = isCharacterStyle ? RKDOCXUIPriorityCharacterStyle : RKDOCXUIPriorityParagraphStyle;
	NSString *docxStyleName = [styleName isEqual: RKDefaultStyleName] ? RKDOCXStyleTemplateDefaultAttributeName : styleName;
	
	// Remove character and paragraph style names to prevent recursive style templates
	[attributes removeObjectForKey: RKCharacterStyleNameAttributeName];
	[attributes removeObjectForKey: RKParagraphStyleNameAttributeName];
	
	// Remove background color (not supported in styles)
	[attributes removeObjectForKey: RKBackgroundColorAttributeName];
	
	NSString *templateTypeAttributeValue = isCharacterStyle ? RKDOCXStyleTemplateCharacterStyleAttributeValue : RKDOCXStyleTemplateParagraphStyleAttributeValue;
	
	NSXMLElement *styleNameElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleNameElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:docxStyleName]]];
	NSXMLElement *basedOnElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateBasedOnElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXStyleTemplateDefaultStyleNameAttributeValue]]];
	NSXMLElement *priorityElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateUIPriorityElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName integerValue:uiPriority]]];
	NSXMLElement *qFormatElement = [NSXMLElement elementWithName:RKDOCXStyleTemplatePrimaryStyleElementName children:nil attributes:nil];
	
	NSXMLElement *styleElement = [NSXMLElement elementWithName:RKDOCXStyleTemplateStyleElementName children:@[styleNameElement, basedOnElement, priorityElement, qFormatElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXStyleTemplateTypeAttributeName stringValue:templateTypeAttributeValue], [NSXMLElement attributeWithName:RKDOCXStyleTemplateStyleIDAttributeName stringValue:docxStyleName]]];
	
	// Show or hide template in Word
	if (attributes[RKStyleTemplateVisibilityAttributeName])
		switch ((RKStyleTemplateVisibility)[attributes[RKStyleTemplateVisibilityAttributeName] unsignedIntegerValue]) {
			case RKStyleTemplateVisibilityAlways:
				break;
				
			case RKStyleTemplateVisibilityWhenUsed:
				if (![context.usedStyles containsObject: styleName]) {
					[styleElement addChild: [NSXMLElement elementWithName: RKDOCXStyleTemplateSemiHiddenElementName]];
					[styleElement addChild: [NSXMLElement elementWithName: RKDOCXStyleTemplateUnhideWhenUsedElementName]];
				}
				break;
				
			case RKStyleTemplateVisibilityNever:
				[styleElement addChild: [NSXMLElement elementWithName: RKDOCXStyleTemplateSemiHiddenElementName]];
				break;
		}
	
	// Add style elements for paragraphs and character styles as needed
	NSArray *paragraphAttributes = [RKDOCXParagraphWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:NO];
	if (!isCharacterStyle && paragraphAttributes.count > 0)
		[styleElement addChild: [RKDOCXParagraphWriter paragraphPropertiesElementWithProperties: paragraphAttributes]];
	
	NSArray *characterAttributes = [RKDOCXRunWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:NO];
	if (characterAttributes.count > 0)
		[styleElement addChild: [RKDOCXRunWriter runPropertiesElementWithProperties: characterAttributes]];
	
	return styleElement;
}

+ (NSXMLElement *)paragraphStyleReferenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSString *styleName = attributes[RKParagraphStyleNameAttributeName];
	if (!styleName)
		return nil;
	
	if ([styleName isEqual: RKDefaultStyleName])
		styleName = RKDOCXStyleTemplateDefaultStyleName;
	
	return [NSXMLElement elementWithName:RKDOCXStyleTemplateParagraphReferenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:styleName]]];
}

+ (NSXMLElement *)characterStyleReferenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSString *styleName = attributes[RKCharacterStyleNameAttributeName];
	if (!styleName)
		return nil;
	
	if ([styleName isEqual: RKDefaultStyleName])
		styleName = RKDOCXStyleTemplateDefaultStyleName;
	
	return [NSXMLElement elementWithName:RKDOCXStyleTemplateRunReferenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:styleName]]];
}

@end
