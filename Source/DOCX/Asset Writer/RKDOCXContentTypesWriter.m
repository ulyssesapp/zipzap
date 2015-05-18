//
//  RKDOCXContentTypesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXContentTypesWriter.h"

#import "RKDOCXHeaderFooterWriter.h"

// Root element name
NSString *RKDOCXContentTypesRootElementName		= @"Types";

// Element names
NSString *RKDOCXDefaultContentTypeElementName	= @"Default";
NSString *RKDOCXOverrideContentTypeElementName	= @"Override";

// Default Content Types
NSString *RKDOCXDefaultRelationshipExtension	= @"rels";
NSString *RKDOCXDefaultRelationshipContentType	= @"application/vnd.openxmlformats-package.relationships+xml";
NSString *RKDOCXDefaultXMLExtension				= @"xml";
NSString *RKDOCXDefaultXMLContentType			= @"application/xml";

// Filename
NSString *RKDOCXContentTypesFilename			= @"[Content_Types].xml";

@implementation RKDOCXContentTypesWriter

+ (void)buildContentTypesUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXContentTypesRootElementName namespaces:@{@"xmlns": @"http://schemas.openxmlformats.org/package/2006/content-types"}];
	
	// Default Content Types
	for (NSString *extension in context.usedMIMETypes) {
		[self addContentType:context.usedMIMETypes[extension] forExtension:extension toXMLElement:document.rootElement];
	}
	[self addContentType:RKDOCXDefaultXMLContentType forExtension:RKDOCXDefaultXMLExtension toXMLElement:document.rootElement];
	[self addContentType:RKDOCXDefaultRelationshipContentType forExtension:RKDOCXDefaultRelationshipExtension toXMLElement:document.rootElement];
	
	// Override Content Types
	for (NSString *filename in context.usedXMLTypes) {
		[self addContentType:context.usedXMLTypes[filename] forFilename:filename toXMLElement:document.rootElement];
	}
	
	[context addXMLDocumentPart:document withFilename:[self fullPathForFilename:RKDOCXContentTypesFilename inLevel:RKDOCXRootLevel] contentType:nil];
}

+ (void)addContentType:(NSString *)contentType forExtension:(NSString *)extension toXMLElement:(NSXMLElement *)rootElement
{
	NSXMLElement *defaultElement = [NSXMLElement elementWithName: RKDOCXDefaultContentTypeElementName];
	[defaultElement addAttribute: [NSXMLElement attributeWithName:@"Extension" stringValue:extension]];
	[defaultElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:contentType]];
	[rootElement addChild: defaultElement];
}

+ (void)addContentType:(NSString *)contentType forFilename:(NSString *)filename toXMLElement:(NSXMLElement *)rootElement
{
	NSXMLElement *overrideElement = [NSXMLElement elementWithName: RKDOCXOverrideContentTypeElementName];
	[overrideElement addAttribute: [NSXMLElement attributeWithName:@"PartName" stringValue:[@"/" stringByAppendingString: filename]]];
	[overrideElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:contentType]];
	[rootElement addChild: overrideElement];
}

@end
