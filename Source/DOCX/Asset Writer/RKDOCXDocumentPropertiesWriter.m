//
//  RKDOCXDocumentPropertiesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXDocumentPropertiesWriter.h"

// Root element names
NSString *RKDOCXCorePropertiesRootElementName				= @"cp:coreProperties";
NSString *RKDOCXExtendedPropertiesRootElementName			= @"Properties";

// Content types
NSString *RKDOCXCorePropertiesContentType					= @"application/vnd.openxmlformats-package.core-properties+xml";
NSString *RKDOCXExtendedPropertiesContentType				= @"application/vnd.openxmlformats-officedocument.extended-properties+xml";

// Filenames
NSString *RKDOCXCorePropertiesFilename						= @"core.xml";
NSString *RKDOCXExtendedPropertiesFilename					= @"app.xml";

// Relationship types
NSString *RKDOCXCorePropertiesRelationshipType				= @"http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties";
NSString *RKDOCXExtendedPropertiesRelationshipType			= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties";

// Elements
NSString *RKDOCXDocumentPropertiesAuthorElementName			= @"dc:creator";
NSString *RKDOCXDocumentPropertiesCategoryElementName		= @"cp:category";
NSString *RKDOCXDocumentPropertiesCreationTimeElementName	= @"dcterms:created";
NSString *RKDOCXDocumentPropertiesEditorElementName			= @"cp:lastModifiedBy";
NSString *RKDOCXDocumentPropertiesKeywordsElementName		= @"cp:keywords";
NSString *RKDOCXDocumentPropertiesModificationElementName	= @"dcterms:modified";
NSString *RKDOCXDocumentPropertiesSubjectElementName		= @"dc:subject";
NSString *RKDOCXDocumentPropertiesTimeAttributeName			= @"xsi:type";
NSString *RKDOCXDocumentPropertiesTimeTypeAttributeValue	= @"dcterms:W3CDTF";
NSString *RKDOCXDocumentPropertiesTitleElementName			= @"dc:title";

@implementation RKDOCXDocumentPropertiesWriter

+ (void)buildCorePropertiesUsingContext:(RKDOCXConversionContext *)context
{
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns:cp": @"http://schemas.openxmlformats.org/package/2006/metadata/core-properties",
								 @"xmlns:dc": @"http://purl.org/dc/elements/1.1/",
								 @"xmlns:dcterms": @"http://purl.org/dc/terms/",
								 @"xmlns:dcmitype": @"http://purl.org/dc/dcmitype/",
								 @"xmlns:xsi": @"http://www.w3.org/2001/XMLSchema-instance"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXCorePropertiesRootElementName namespaces:namespaces];
	
	// Core Properties
	document.rootElement.children = [self corePropertyElementsFromContext: context];
	
	[context addPackageRelationshipWithTarget:[self packagePathForFilename:RKDOCXCorePropertiesFilename folder:RKDOCXDocPropsFolder] type:RKDOCXCorePropertiesRelationshipType];
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:RKDOCXCorePropertiesFilename folder:RKDOCXDocPropsFolder] contentType:RKDOCXCorePropertiesContentType];
}

+ (void)buildExtendedPropertiesUsingContext:(RKDOCXConversionContext *)context
{
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns": @"http://schemas.openxmlformats.org/officeDocument/2006/extended-properties",
								 @"xmlns:vt": @"http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXExtendedPropertiesRootElementName namespaces:namespaces];
	
	[context addPackageRelationshipWithTarget:[self packagePathForFilename:RKDOCXExtendedPropertiesFilename folder:RKDOCXDocPropsFolder] type:RKDOCXExtendedPropertiesRelationshipType];
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:RKDOCXExtendedPropertiesFilename folder:RKDOCXDocPropsFolder] contentType:RKDOCXExtendedPropertiesContentType];
}

+ (NSArray *)corePropertyElementsFromContext:(RKDOCXConversionContext *)context
{
	NSDictionary *metadata = context.document.metadata;
	if (!metadata)
		return nil;
	
	NSMutableArray *coreProperties = [NSMutableArray new];
	
	if (metadata[RKTitleDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesTitleElementName stringValue:metadata[RKTitleDocumentAttribute]]];
	
	if (metadata[RKSubjectDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesSubjectElementName stringValue:metadata[RKSubjectDocumentAttribute]]];
	
	if (metadata[RKAuthorDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesAuthorElementName stringValue:metadata[RKAuthorDocumentAttribute]]];
	
	// Not according to standard, because Word ignores the standard in this case.
	if (metadata[RKKeywordsDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesKeywordsElementName stringValue:[metadata[RKKeywordsDocumentAttribute] componentsJoinedByString: @", "]]];
	
	if (metadata[RKEditorDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesEditorElementName stringValue:metadata[RKEditorDocumentAttribute]]];
	
	NSXMLElement *timeAttribute = [NSXMLElement attributeWithName:RKDOCXDocumentPropertiesTimeAttributeName stringValue:RKDOCXDocumentPropertiesTimeTypeAttributeValue];
	
	if (metadata[RKCreationTimeDocumentAttribute]) {
		NSXMLElement *creationTimeElement = [NSXMLElement elementWithName:RKDOCXDocumentPropertiesCreationTimeElementName stringValue:[self stringFromDate: metadata[RKCreationTimeDocumentAttribute]]];
		[creationTimeElement addAttribute: [timeAttribute copy]];
		[coreProperties addObject: creationTimeElement];
	}
	
	if (metadata[RKModificationTimeDocumentAttribute]) {
		NSXMLElement *modificationTimeElement = [NSXMLElement elementWithName:RKDOCXDocumentPropertiesModificationElementName stringValue:[self stringFromDate: metadata[RKModificationTimeDocumentAttribute]]];
		[modificationTimeElement addAttribute: [timeAttribute copy]];
		[coreProperties addObject: modificationTimeElement];
	}
	
	if (metadata[RKCategoryDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesCategoryElementName stringValue:metadata[RKCategoryDocumentAttribute]]];
	
	return coreProperties;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ss'Z'";
	dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
	
	return [dateFormatter stringFromDate: date];
}

@end
