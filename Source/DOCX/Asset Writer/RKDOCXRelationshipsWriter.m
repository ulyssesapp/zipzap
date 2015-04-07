//
//  RKDOCXRelationshipsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRelationshipsWriter.h"


// Root element name
NSString *RKDOCXRelationshipsRootElementName			= @"Relationships";

// Element name
NSString *RKDOCXRelationshipElementName					= @"Relationship";

// Package relationship types and targets
NSString *RKDOCXCorePropertiesRelationshipType			= @"http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties";
NSString *RKDOCXCorePropertiesRelationshipTarget		= @"docProps/core.xml";
NSString *RKDOCXDocumentRelationshipType				= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
NSString *RKDOCXDocumentRelationshipTarget				= @"word/document.xml";
NSString *RKDOCXExtendedPropertiesRelationshipType		= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties";
NSString *RKDOCXExtendedPropertiesRelationshipTarget	= @"docProps/app.xml";

@implementation RKDOCXRelationshipsWriter

+ (void)buildPackageRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXRelationshipsRootElementName namespaces:@{@"xmlns": @"http://schemas.openxmlformats.org/package/2006/relationships"}];
	
	// Relationships
	NSUInteger relationshipCounter = 0;
	
	// document.xml
	[self addRelationshipWithTarget:RKDOCXDocumentRelationshipTarget type:RKDOCXDocumentRelationshipType id:[NSString stringWithFormat:@"rId%ld", ++relationshipCounter] toXMLElement:document.rootElement];
	// app.xml
	[self addRelationshipWithTarget:RKDOCXExtendedPropertiesRelationshipTarget type:RKDOCXExtendedPropertiesRelationshipType id:[NSString stringWithFormat:@"rId%ld", ++relationshipCounter] toXMLElement:document.rootElement];
	// core.xml
	[self addRelationshipWithTarget:RKDOCXCorePropertiesRelationshipTarget type:RKDOCXCorePropertiesRelationshipType id:[NSString stringWithFormat:@"rId%ld", ++relationshipCounter] toXMLElement:document.rootElement];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXPackageRelationshipsFilename];
}

+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXRelationshipsRootElementName namespaces:@{@"xmlns": @"http://schemas.openxmlformats.org/package/2006/relationships"}];
	
	// Relationships
	for (NSString *target in context.documentRelationships) {
		[self addRelationshipWithTarget:target type:context.documentRelationships[target][RKDOCXConversionContextRelationshipTypeName] id:[NSString stringWithFormat:@"rId%@", context.documentRelationships[target][RKDOCXConversionContextRelationshipIdentifierName]] toXMLElement:document.rootElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXDocumentRelationshipsFilename];
}

+ (void)addRelationshipWithTarget:(NSString *)target type:(NSString *)type id:(NSString *)identifier toXMLElement:(NSXMLElement *)rootElement
{
	NSXMLElement *relationshipElement = [NSXMLElement elementWithName: RKDOCXRelationshipElementName];
	[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Id" stringValue:identifier]];
	[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Type" stringValue:type]];
	[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Target" stringValue:target]];
	[rootElement addChild: relationshipElement];
}

@end
