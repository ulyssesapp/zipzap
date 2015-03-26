//
//  RKDOCXAssetsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAssetsWriter.h"
#import "RKDOCXContextObject.h"

// Filenames
NSString *RKDOCXPackageRelationshipsFilename = @"_rels/.rels";
NSString *RKDOCXContentTypesFilename = @"[Content_Types].xml";
NSString *RKDOCXCorePropertiesFilename = @"docProps/core.xml";
NSString *RKDOCXExtendedPropertiesFilename = @"docProps/app.xml";
NSString *RKDOCXDocumentFilename = @"word/document.xml";
NSString *RKDOCXSettingsFilename = @"word/settings.xml";

// Root element names
NSString *RKDOCXRelationshipsRootElementName = @"Relationships";
NSString *RKDOCXContentTypesRootElementName = @"Types";
NSString *RKDOCXCorePropertiesElementName = @"cp:coreProperties";
NSString *RKDOCXExtendedPropertiesElementName = @"Properties";

// Element names
NSString *RKDOCXRelationshipElementName = @"Relationship";
NSString *RKDOCXDefaultContentTypeElementName = @"Default";
NSString *RKDOCXOverrideContentTypeElementName = @"Override";

// Relationship types and targets
NSString *RKDOCXRelationshipDocumentType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
NSString *RKDOCXRelationshipDocumentTarget = @"word/document.xml";
NSString *RKDOCXRelationshipCorePropertiesType = @"http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties";
NSString *RKDOCXRelationshipCorePropertiesTarget = @"docProps/core.xml";
NSString *RKDOCXRelationshipExtendedPropertiesType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties";
NSString *RKDOCXRelationshipExtendedPropertiesTarget = @"docProps/app.xml";

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

/*!
 @abstract Builds the relationship NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildPackageRelationshipsUsingContext:(RKDOCXContextObject *)context
{
	NSUInteger relationshipCounter = 0;
	NSXMLElement *rootElement = [[NSXMLElement alloc] initWithName: RKDOCXRelationshipsRootElementName];
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement: rootElement];
	
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
		NSXMLElement *relationshipElement = [[NSXMLElement alloc] initWithName: RKDOCXRelationshipElementName];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Id" stringValue:[NSString stringWithFormat:@"%ld", relationshipCounter++]]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Type" stringValue:type]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Target" stringValue:[relationships objectForKey: type]]];
		[rootElement addChild: relationshipElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint] withFilename:RKDOCXPackageRelationshipsFilename];
}

/*!
 @abstract Builds the content types NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildContentTypesUsingContext:(RKDOCXContextObject *)context
{
	NSXMLElement *rootElement = [[NSXMLElement alloc] initWithName: RKDOCXContentTypesRootElementName];
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement: rootElement];
	
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
		NSXMLElement *defaultElement = [[NSXMLElement alloc] initWithName: RKDOCXDefaultContentTypeElementName];
		[defaultElement addAttribute: [NSXMLElement attributeWithName:@"Extension" stringValue:extension]];
		[defaultElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:[defaultContentTypes objectForKey: extension]]];
		[rootElement addChild: defaultElement];
	}
	
	// Override Content Types
	NSDictionary *overrideContentTypes = @{
										   [NSString stringWithFormat: @"/%@", RKDOCXDocumentFilename]: RKDOCXDocumentContentType,
										   [NSString stringWithFormat: @"/%@", RKDOCXSettingsFilename]: RKDOCXSettingsContentType,
										   [NSString stringWithFormat: @"/%@", RKDOCXCorePropertiesFilename]: RKDOCXCorePropertiesContentType,
										   [NSString stringWithFormat: @"/%@", RKDOCXExtendedPropertiesFilename]: RKDOCXExtendedPropertiesContentType
										   };
	for (NSString *partName in overrideContentTypes) {
		NSXMLElement *overrideElement = [[NSXMLElement alloc] initWithName: RKDOCXOverrideContentTypeElementName];
		[overrideElement addAttribute: [NSXMLElement attributeWithName:@"PartName" stringValue:partName]];
		[overrideElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:[overrideContentTypes objectForKey: partName]]];
		[rootElement addChild: overrideElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint] withFilename:RKDOCXContentTypesFilename];
}

/*!
 @abstract Builds the core properties NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildCorePropertiesUsingContext:(RKDOCXContextObject *)context
{
	NSXMLElement *rootElement = [[NSXMLElement alloc] initWithName: RKDOCXCorePropertiesElementName];
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement: rootElement];
	
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
		[rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:[namespaces objectForKey: namespace]]];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint] withFilename:RKDOCXCorePropertiesFilename];
}

/*!
 @abstract Builds the extended properties NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildExtendedPropertiesUsingContext:(RKDOCXContextObject *)context
{
	NSXMLElement *rootElement = [[NSXMLElement alloc] initWithName: RKDOCXExtendedPropertiesElementName];
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement: rootElement];
	
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
	
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns": @"http://schemas.openxmlformats.org/officeDocument/2006/extended-properties",
								 @"xmlns:vt": @"http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
								 };
	for (NSString *namespace in namespaces)
		[rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:[namespaces objectForKey: namespace]]];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint] withFilename:RKDOCXExtendedPropertiesFilename];
}

+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXContextObject *)context
{
	// document.xml.rels
}

@end
