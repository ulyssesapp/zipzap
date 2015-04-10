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

// Property element names
NSString *RKDOCXDocumentPropertiesAuthorPropertyName		= @"dc:creator";
NSString *RKDOCXDocumentPropertiesCategoryPropertyName		= @"cp:category";
NSString *RKDOCXDocumentPropertiesCreationTimePropertyName	= @"dcterms:created";
NSString *RKDOCXDocumentPropertiesEditorPropertyName		= @"cp:lastModifiedBy";
NSString *RKDOCXDocumentPropertiesKeywordsPropertyName		= @"cp:keywords";
NSString *RKDOCXDocumentPropertiesModificationPropertyName	= @"dcterms:modified";
NSString *RKDOCXDocumentPropertiesSubjectPropertyName		= @"dc:subject";
NSString *RKDOCXDocumentPropertiesTimeAttributeName			= @"xsi:type";
NSString *RKDOCXDocumentPropertiesTimeTypeName				= @"dcterms:W3CDTF";
NSString *RKDOCXDocumentPropertiesTitlePropertyName			= @"dc:title";

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
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXCorePropertiesFilename];
}

+ (void)buildExtendedPropertiesUsingContext:(RKDOCXConversionContext *)context
{
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns": @"http://schemas.openxmlformats.org/officeDocument/2006/extended-properties",
								 @"xmlns:vt": @"http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXExtendedPropertiesRootElementName namespaces:namespaces];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXExtendedPropertiesFilename];
}

+ (NSArray *)corePropertyElementsFromContext:(RKDOCXConversionContext *)context
{
	NSDictionary *metadata = context.document.metadata;
	if (!metadata)
		return nil;
	
	NSMutableArray *coreProperties = [NSMutableArray new];
	
	if (metadata[NSTitleDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesTitlePropertyName stringValue:metadata[NSTitleDocumentAttribute]]];
	
	if (metadata[NSSubjectDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesSubjectPropertyName stringValue:metadata[NSSubjectDocumentAttribute]]];
	
	if (metadata[NSAuthorDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesAuthorPropertyName stringValue:metadata[NSAuthorDocumentAttribute]]];
	
	if (metadata[NSKeywordsDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesKeywordsPropertyName stringValue:metadata[NSKeywordsDocumentAttribute]]];
	
	if (metadata[NSEditorDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesEditorPropertyName stringValue:metadata[NSEditorDocumentAttribute]]];
	
	NSXMLElement *timeAttribute = [NSXMLElement attributeWithName:RKDOCXDocumentPropertiesTimeAttributeName stringValue:RKDOCXDocumentPropertiesTimeTypeName];
	
	if (metadata[NSCreationTimeDocumentAttribute]) {
		NSXMLElement *creationTimeElement = [NSXMLElement elementWithName:RKDOCXDocumentPropertiesCreationTimePropertyName stringValue:[self stringFromDate: metadata[NSCreationTimeDocumentAttribute]]];
		[creationTimeElement addAttribute: [timeAttribute copy]];
		[coreProperties addObject: creationTimeElement];
	}
	
	if (metadata[NSModificationTimeDocumentAttribute]) {
		NSXMLElement *modificationTimeElement = [NSXMLElement elementWithName:RKDOCXDocumentPropertiesModificationPropertyName stringValue:[self stringFromDate: metadata[NSModificationTimeDocumentAttribute]]];
		[modificationTimeElement addAttribute: [timeAttribute copy]];
		[coreProperties addObject: modificationTimeElement];
	}
	
	if (metadata[NSCategoryDocumentAttribute])
		[coreProperties addObject: [NSXMLElement elementWithName:RKDOCXDocumentPropertiesCategoryPropertyName stringValue:metadata[NSCategoryDocumentAttribute]]];
	
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
