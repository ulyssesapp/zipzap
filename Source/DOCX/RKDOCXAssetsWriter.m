//
//  RKDOCXAssetsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAssetsWriter.h"
#import "RKDOCXConversionContext.h"

// Filenames
NSString *RKDOCXPackageRelationshipsFilename = @"_rels/.rels";
NSString *RKDOCXContentTypesFilename = @"[Content_Types].xml";
NSString *RKDOCXCorePropertiesFilename = @"docProps/core.xml";
NSString *RKDOCXExtendedPropertiesFilename = @"docProps/app.xml";
NSString *RKDOCXDocumentRelationshipsFilename = @"word/_rels/document.xml.rels";
NSString *RKDOCXDocumentFilename = @"word/document.xml";
NSString *RKDOCXSettingsFilename = @"word/settings.xml";

// Root element names
NSString *RKDOCXRelationshipsRootElementName = @"Relationships";
NSString *RKDOCXContentTypesRootElementName = @"Types";
NSString *RKDOCXCorePropertiesRootElementName = @"cp:coreProperties";
NSString *RKDOCXExtendedPropertiesRootElementName = @"Properties";
NSString *RKDOCXSettingsRootElementName = @"w:settings";
NSString *RKDOCXDocumentRootElementName = @"w:document";

// Element names
NSString *RKDOCXRelationshipElementName = @"Relationship";
NSString *RKDOCXDefaultContentTypeElementName = @"Default";
NSString *RKDOCXOverrideContentTypeElementName = @"Override";
NSString *RKDOCXDocumentBodyElementName = @"w:body";
NSString *RKDOCXDocumentParagraphElementName = @"w:p";
NSString *RKDOCXDocumentRunElementName = @"w:r";
NSString *RKDOCXDocumentTextElementName = @"w:t";

// Relationship types and targets
NSString *RKDOCXRelationshipDocumentType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
NSString *RKDOCXRelationshipDocumentTarget = @"word/document.xml";
NSString *RKDOCXRelationshipCorePropertiesType = @"http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties";
NSString *RKDOCXRelationshipCorePropertiesTarget = @"docProps/core.xml";
NSString *RKDOCXRelationshipExtendedPropertiesType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties";
NSString *RKDOCXRelationshipExtendedPropertiesTarget = @"docProps/app.xml";
NSString *RKDOCXRelationshipSettingsType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings";
NSString *RKDOCXRelationshipSettingsTarget = @"settings.xml";

// Content Types
NSString *RKDOCXDefaultXMLExtension = @"xml";
NSString *RKDOCXDefaultXMLContentType = @"application/xml";
NSString *RKDOCXDefaultRelationshipExtension = @"rels";
NSString *RKDOCXDefaultRelationshipContentType = @"application/vnd.openxmlformats-package.relationships+xml";
NSString *RKDOCXDocumentContentType = @"application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml";
NSString *RKDOCXSettingsContentType = @"application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml";
NSString *RKDOCXCorePropertiesContentType = @"application/vnd.openxmlformats-package.core-properties+xml";
NSString *RKDOCXExtendedPropertiesContentType = @"application/vnd.openxmlformats-officedocument.extended-properties+xml";

@implementation RKDOCXAssetsWriter

+ (void)buildPackageRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSUInteger relationshipCounter = 0;
	NSXMLElement *rootElement = [NSXMLElement elementWithName: RKDOCXRelationshipsRootElementName];
	NSXMLDocument *document = [NSXMLDocument documentWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;

	// Namespace attribute
	[rootElement addAttribute: [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://schemas.openxmlformats.org/package/2006/relationships"]];
	
	// Relationships
	NSDictionary *relationships = @{
									RKDOCXRelationshipDocumentType: RKDOCXRelationshipDocumentTarget,
									RKDOCXRelationshipCorePropertiesType: RKDOCXRelationshipCorePropertiesTarget,
									RKDOCXRelationshipExtendedPropertiesType: RKDOCXRelationshipExtendedPropertiesTarget
									};
	
	for (NSString *type in relationships) {
		NSXMLElement *relationshipElement = [NSXMLElement elementWithName: RKDOCXRelationshipElementName];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Id" stringValue:[NSString stringWithFormat:@"rId%ld", ++relationshipCounter]]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Type" stringValue:type]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Target" stringValue:relationships[type]]];
		[rootElement addChild: relationshipElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXPackageRelationshipsFilename];
}

+ (void)buildContentTypesUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *rootElement = [NSXMLElement elementWithName: RKDOCXContentTypesRootElementName];
	NSXMLDocument *document = [NSXMLDocument documentWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
	
	// Namespace attribute
	[rootElement addAttribute: [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://schemas.openxmlformats.org/package/2006/content-types"]];
	
	// Default Content Types
	NSDictionary *defaultContentTypes = @{
										  RKDOCXDefaultXMLExtension: RKDOCXDefaultXMLContentType,
										  RKDOCXDefaultRelationshipExtension: RKDOCXDefaultRelationshipContentType
										  };
	for (NSString *extension in defaultContentTypes) {
		NSXMLElement *defaultElement = [NSXMLElement elementWithName: RKDOCXDefaultContentTypeElementName];
		[defaultElement addAttribute: [NSXMLElement attributeWithName:@"Extension" stringValue:extension]];
		[defaultElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:defaultContentTypes[extension]]];
		[rootElement addChild: defaultElement];
	}
	
	// Override Content Types
	NSDictionary *overrideContentTypes = @{
										   [@"/" stringByAppendingString: RKDOCXDocumentFilename]: RKDOCXDocumentContentType,
										   [@"/" stringByAppendingString: RKDOCXSettingsFilename]: RKDOCXSettingsContentType,
										   [@"/" stringByAppendingString: RKDOCXCorePropertiesFilename]: RKDOCXCorePropertiesContentType,
										   [@"/" stringByAppendingString: RKDOCXExtendedPropertiesFilename]: RKDOCXExtendedPropertiesContentType
										   };
	for (NSString *partName in overrideContentTypes) {
		NSXMLElement *overrideElement = [NSXMLElement elementWithName: RKDOCXOverrideContentTypeElementName];
		[overrideElement addAttribute: [NSXMLElement attributeWithName:@"PartName" stringValue:partName]];
		[overrideElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:overrideContentTypes[partName]]];
		[rootElement addChild: overrideElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXContentTypesFilename];
}

+ (void)buildCorePropertiesUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *rootElement = [NSXMLElement elementWithName: RKDOCXCorePropertiesRootElementName];
	NSXMLDocument *document = [NSXMLDocument documentWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
	
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns:cp": @"http://schemas.openxmlformats.org/package/2006/metadata/core-properties",
								 @"xmlns:dc": @"http://purl.org/dc/elements/1.1/",
								 @"xmlns:dcterms": @"http://purl.org/dc/terms/",
								 @"xmlns:dcmitype": @"http://purl.org/dc/dcmitype/",
								 @"xmlns:xsi": @"http://www.w3.org/2001/XMLSchema-instance"
								 };
	for (NSString *namespace in namespaces)
		[rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:namespaces[namespace]]];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXCorePropertiesFilename];
}

+ (void)buildExtendedPropertiesUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *rootElement = [NSXMLElement elementWithName: RKDOCXExtendedPropertiesRootElementName];
	NSXMLDocument *document = [NSXMLDocument documentWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
	
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns": @"http://schemas.openxmlformats.org/officeDocument/2006/extended-properties",
								 @"xmlns:vt": @"http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
								 };
	for (NSString *namespace in namespaces)
		[rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:namespaces[namespace]]];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXExtendedPropertiesFilename];
}

+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSUInteger relationshipCounter = 0;
	NSXMLElement *rootElement = [NSXMLElement elementWithName: RKDOCXRelationshipsRootElementName];
	NSXMLDocument *document = [NSXMLDocument documentWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
	
	// Namespace attribute
	[rootElement addAttribute: [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://schemas.openxmlformats.org/package/2006/relationships"]];
	
	// Relationships
	NSDictionary *relationships = @{
									RKDOCXRelationshipSettingsType: RKDOCXRelationshipSettingsTarget
									};
	
	for (NSString *type in relationships) {
		NSXMLElement *relationshipElement = [NSXMLElement elementWithName: RKDOCXRelationshipElementName];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Id" stringValue:[NSString stringWithFormat: @"rId%ld", [context indexForRelationshipWithTarget: relationships[type]]]]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Type" stringValue:type]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Target" stringValue:relationships[type]]];
		[rootElement addChild: relationshipElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXDocumentRelationshipsFilename];
}

+ (void)buildSettingsUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *rootElement = [NSXMLElement elementWithName: RKDOCXSettingsRootElementName];
	NSXMLDocument *document = [NSXMLDocument documentWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
	
	// Namespace attributes
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
	for (NSString *namespace in namespaces)
		[rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:namespaces[namespace]]];
	
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
	
	[rootElement addChild: compat];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXSettingsFilename];
}

+ (void)buildDocumentUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *rootElement = [NSXMLElement elementWithName: RKDOCXDocumentRootElementName];
	NSXMLDocument *document = [NSXMLDocument documentWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
	
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns:wpc": @"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas",
								 @"xmlns:mo": @"http://schemas.microsoft.com/office/mac/office/2008/main",
								 @"xmlns:mc": @"http://schemas.openxmlformats.org/markup-compatibility/2006",
								 @"xmlns:mv": @"urn:schemas-microsoft-com:mac:vml",
								 @"xmlns:o": @"urn:schemas-microsoft-com:office:office",
								 @"xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
								 @"xmlns:m": @"http://schemas.openxmlformats.org/officeDocument/2006/math",
								 @"xmlns:v": @"urn:schemas-microsoft-com:vml",
								 @"xmlns:wp14": @"http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing",
								 @"xmlns:wp": @"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
								 @"xmlns:w10": @"urn:schemas-microsoft-com:office:word",
								 @"xmlns:w": @"http://schemas.openxmlformats.org/wordprocessingml/2006/main",
								 @"xmlns:w14": @"http://schemas.microsoft.com/office/word/2010/wordml",
								 @"xmlns:w15": @"http://schemas.microsoft.com/office/word/2012/wordml",
								 @"xmlns:wpg": @"http://schemas.microsoft.com/office/word/2010/wordprocessingGroup",
								 @"xmlns:wpi": @"http://schemas.microsoft.com/office/word/2010/wordprocessingInk",
								 @"xmlns:wne": @"http://schemas.microsoft.com/office/word/2006/wordml",
								 @"xmlns:wps": @"http://schemas.microsoft.com/office/word/2010/wordprocessingShape",
								 @"mc:Ignorable": @"w14 w15 wp14"
								 };
	for (NSString *key in namespaces)
		[rootElement addAttribute: [NSXMLElement attributeWithName:key stringValue:namespaces[key]]];
	
	// Document content
	NSXMLElement *body = [NSXMLElement elementWithName: RKDOCXDocumentBodyElementName];
	[rootElement addChild: body];
	
	NSXMLElement *paragraph = [NSXMLElement elementWithName: RKDOCXDocumentParagraphElementName];
	[body addChild: paragraph];
	
	NSXMLElement *run = [NSXMLElement elementWithName: RKDOCXDocumentRunElementName];
	[paragraph addChild: run];
	
	NSString *textContent = [[[[[context document] sections] firstObject] content] string];
	
	NSXMLElement *text = [NSXMLElement elementWithName:RKDOCXDocumentTextElementName stringValue:textContent];
	[text addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[run addChild: text];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXDocumentFilename];
}

@end
