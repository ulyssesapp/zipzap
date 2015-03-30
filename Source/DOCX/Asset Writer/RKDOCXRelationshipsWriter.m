//
//  RKDOCXRelationshipsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

// Root element name
NSString *RKDOCXRelationshipsRootElementName = @"Relationships";

// Element name
NSString *RKDOCXRelationshipElementName = @"Relationship";

// Relationship types and targets
NSString *RKDOCXDocumentRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
NSString *RKDOCXDocumentRelationshipTarget = @"word/document.xml";
NSString *RKDOCXCorePropertiesRelationshipType = @"http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties";
NSString *RKDOCXCorePropertiesRelationshipTarget = @"docProps/core.xml";
NSString *RKDOCXExtendedPropertiesRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties";
NSString *RKDOCXExtendedPropertiesRelationshipTarget = @"docProps/app.xml";
NSString *RKDOCXSettingsRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings";
NSString *RKDOCXSettingsRelationshipTarget = @"settings.xml";

#import "RKDOCXRelationshipsWriter.h"

@implementation RKDOCXRelationshipsWriter

+ (void)buildPackageRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocument];
	
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
	NSXMLDocument *document = [self basicXMLDocument];
	
	// Relationships
	
	// settings.xml
	[self addRelationshipWithTarget:RKDOCXSettingsRelationshipTarget type:RKDOCXSettingsRelationshipType id:[NSString stringWithFormat:@"rId%ld", [context indexForRelationshipWithTarget:RKDOCXSettingsRelationshipTarget]] toXMLElement:document.rootElement];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXDocumentRelationshipsFilename];
}

+ (NSXMLDocument *)basicXMLDocument
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName: RKDOCXRelationshipsRootElementName];
	[document.rootElement addAttribute: [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://schemas.openxmlformats.org/package/2006/relationships"]];
	
	return document;
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
