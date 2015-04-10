//
//  RKDOCXDocumentPropertiesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXDocumentPropertiesWriter.h"

// Root element names
NSString *RKDOCXCorePropertiesRootElementName		= @"cp:coreProperties";
NSString *RKDOCXExtendedPropertiesRootElementName	= @"Properties";


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

@end
