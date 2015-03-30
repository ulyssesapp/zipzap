//
//  RKDOCXDocumentPropertiesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXDocumentPropertiesWriter.h"

// Root element names
NSString *RKDOCXCorePropertiesRootElementName = @"cp:coreProperties";
NSString *RKDOCXExtendedPropertiesRootElementName = @"Properties";

@implementation RKDOCXDocumentPropertiesWriter

+ (void)buildCorePropertiesUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName: RKDOCXCorePropertiesRootElementName];
	
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns:cp": @"http://schemas.openxmlformats.org/package/2006/metadata/core-properties",
								 @"xmlns:dc": @"http://purl.org/dc/elements/1.1/",
								 @"xmlns:dcterms": @"http://purl.org/dc/terms/",
								 @"xmlns:dcmitype": @"http://purl.org/dc/dcmitype/",
								 @"xmlns:xsi": @"http://www.w3.org/2001/XMLSchema-instance"
								 };
	for (NSString *namespace in namespaces)
		[document.rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:namespaces[namespace]]];
	
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
		[document.rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:namespaces[namespace]]];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXExtendedPropertiesFilename];
}

@end
