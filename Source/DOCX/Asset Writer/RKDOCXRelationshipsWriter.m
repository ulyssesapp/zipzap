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
NSString *RKDOCXRelationshipDocumentType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
NSString *RKDOCXRelationshipDocumentTarget = @"word/document.xml";
NSString *RKDOCXRelationshipCorePropertiesType = @"http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties";
NSString *RKDOCXRelationshipCorePropertiesTarget = @"docProps/core.xml";
NSString *RKDOCXRelationshipExtendedPropertiesType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties";
NSString *RKDOCXRelationshipExtendedPropertiesTarget = @"docProps/app.xml";
NSString *RKDOCXRelationshipSettingsType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings";
NSString *RKDOCXRelationshipSettingsTarget = @"settings.xml";

#import "RKDOCXRelationshipsWriter.h"

@implementation RKDOCXRelationshipsWriter

+ (void)buildPackageRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName: RKDOCXRelationshipsRootElementName];
	
	// Namespace attribute
	[document.rootElement addAttribute: [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://schemas.openxmlformats.org/package/2006/relationships"]];
	
	// Relationships
	NSUInteger relationshipCounter = 0;
	NSDictionary *relationships = @{
									RKDOCXRelationshipDocumentType: RKDOCXRelationshipDocumentTarget,
									RKDOCXRelationshipCorePropertiesType: RKDOCXRelationshipCorePropertiesTarget,
									RKDOCXRelationshipExtendedPropertiesType: RKDOCXRelationshipExtendedPropertiesTarget
									};
	
	for (NSString *type in relationships) {
		NSXMLElement *relationshipElement = [NSXMLElement elementWithName: RKDOCXRelationshipElementName];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Id" stringValue:[NSString stringWithFormat:@"rId%ld", ++relationshipCounter]]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Type" stringValue:type]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Target" stringValue:relationships[type]]];
		[document.rootElement addChild: relationshipElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXPackageRelationshipsFilename];
}

+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName: RKDOCXRelationshipsRootElementName];
	
	// Namespace attribute
	[document.rootElement addAttribute: [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://schemas.openxmlformats.org/package/2006/relationships"]];
	
	// Relationships
	NSDictionary *relationships = @{
									RKDOCXRelationshipSettingsType: RKDOCXRelationshipSettingsTarget
									};
	
	for (NSString *type in relationships) {
		NSXMLElement *relationshipElement = [NSXMLElement elementWithName: RKDOCXRelationshipElementName];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Id" stringValue:[NSString stringWithFormat: @"rId%ld", [context indexForRelationshipWithTarget: relationships[type]]]]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Type" stringValue:type]];
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Target" stringValue:relationships[type]]];
		[document.rootElement addChild: relationshipElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXDocumentRelationshipsFilename];
}

@end
