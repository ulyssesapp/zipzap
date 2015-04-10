//
//  RKDOCXPartWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"

#import "RKDOCXConversionContext.h"

// Filenames
NSString *RKDOCXContentTypesFilename			= @"[Content_Types].xml";
NSString *RKDOCXCorePropertiesFilename			= @"docProps/core.xml";
NSString *RKDOCXDocumentFilename				= @"word/document.xml";
NSString *RKDOCXDocumentRelationshipsFilename	= @"word/_rels/document.xml.rels";
NSString *RKDOCXExtendedPropertiesFilename		= @"docProps/app.xml";
NSString *RKDOCXPackageRelationshipsFilename	= @"_rels/.rels";
NSString *RKDOCXSettingsFilename				= @"word/settings.xml";


@implementation RKDOCXPartWriter

+ (NSXMLDocument *)basicXMLDocumentWithRootElementName:(NSString *)root namespaces:(NSDictionary *)namespaces
{
	NSXMLElement *rootElement = [NSXMLElement elementWithName: root];
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement: rootElement];
	
#if !TARGET_OS_IPHONE
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
#else
	// Adaption required for test stability. See ULYSSES-4867.
	xmlTreeIndentString = "    ";
#endif
	
	// Namespaces
	for (NSString *namespace in namespaces) {
		[rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:namespaces[namespace]]];
	}
	
	return document;
}

@end
