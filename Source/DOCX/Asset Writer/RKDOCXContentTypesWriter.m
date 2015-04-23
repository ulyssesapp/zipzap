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

// Override Content Types
NSString *RKDOCXCorePropertiesContentType		= @"application/vnd.openxmlformats-package.core-properties+xml";
NSString *RKDOCXDocumentContentType				= @"application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml";
NSString *RKDOCXEndnotesContentType				= @"application/vnd.openxmlformats-officedocument.wordprocessingml.endnotes+xml";
NSString *RKDOCXExtendedPropertiesContentType	= @"application/vnd.openxmlformats-officedocument.extended-properties+xml";
NSString *RKDOCXFooterContentType				= @"application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml";
NSString *RKDOCXFootnotesContentType			= @"application/vnd.openxmlformats-officedocument.wordprocessingml.footnotes+xml";
NSString *RKDOCXHeaderContentType				= @"application/vnd.openxmlformats-officedocument.wordprocessingml.header+xml";
NSString *RKDOCXSettingsContentType				= @"application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml";

@implementation RKDOCXContentTypesWriter

+ (void)buildContentTypesUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXContentTypesRootElementName namespaces:@{@"xmlns": @"http://schemas.openxmlformats.org/package/2006/content-types"}];
	
	// Default Content Types
	for (NSString *extension in context.usedContentTypes) {
		[self addContentType:context.usedContentTypes[extension] forExtension:extension toXMLElement:document.rootElement];
	}
	[self addContentType:RKDOCXDefaultXMLContentType forExtension:RKDOCXDefaultXMLExtension toXMLElement:document.rootElement];
	[self addContentType:RKDOCXDefaultRelationshipContentType forExtension:RKDOCXDefaultRelationshipExtension toXMLElement:document.rootElement];
	
	// Override Content Types
	[self addContentType:RKDOCXDocumentContentType forFilename:RKDOCXDocumentFilename toXMLElement:document.rootElement];
	if (context.footnotes.count)
		[self addContentType:RKDOCXFootnotesContentType forFilename:RKDOCXFootnotesFilename toXMLElement:document.rootElement];
	if (context.endnotes.count)
		[self addContentType:RKDOCXEndnotesContentType forFilename:RKDOCXEndnotesFilename toXMLElement:document.rootElement];
	for (NSUInteger index = 1; index <= context.headerCount; index++)
		[self addContentType:RKDOCXHeaderContentType forFilename:[@"word/" stringByAppendingString: [RKDOCXHeaderFooterWriter filenameForNumber:@(index) isHeaderFile:YES]] toXMLElement:document.rootElement];
	for (NSUInteger index = 1; index <= context.footerCount; index++)
		[self addContentType:RKDOCXFooterContentType forFilename:[@"word/" stringByAppendingString: [RKDOCXHeaderFooterWriter filenameForNumber:@(index) isHeaderFile:NO]] toXMLElement:document.rootElement];
	[self addContentType:RKDOCXSettingsContentType forFilename:RKDOCXSettingsFilename toXMLElement:document.rootElement];
	[self addContentType:RKDOCXCorePropertiesContentType forFilename:RKDOCXCorePropertiesFilename toXMLElement:document.rootElement];
	[self addContentType:RKDOCXExtendedPropertiesContentType forFilename:RKDOCXExtendedPropertiesFilename toXMLElement:document.rootElement];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXContentTypesFilename];
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
