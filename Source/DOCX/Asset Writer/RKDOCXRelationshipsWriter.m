//
//  RKDOCXRelationshipsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRelationshipsWriter.h"

#import "RKDOCXDocumentContentWriter.h"
#import "RKDOCXDocumentPropertiesWriter.h"

// Root element name
NSString *RKDOCXRelationshipsRootElementName			= @"Relationships";

// Element name
NSString *RKDOCXRelationshipElementName					= @"Relationship";

// Filenames
NSString *RKDOCXDocumentRelationshipsFilename			= @"document.xml.rels";
NSString *RKDOCXEndnotesRelationshipsFilename			= @"endnotes.xml.rels";
NSString *RKDOCXFootnotesRelationshipsFilename			= @"footnotes.xml.rels";
NSString *RKDOCXPackageRelationshipsFilename			= @".rels";

NSString *RKDOCXLinkRelationshipType					= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink";

@implementation RKDOCXRelationshipsWriter

+ (void)buildPackageRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXRelationshipsRootElementName namespaces:@{@"xmlns": @"http://schemas.openxmlformats.org/package/2006/relationships"}];
	
	// Relationships
	NSUInteger relationshipCounter = 0;
	
	for (NSString *target in context.packageRelationships) {
		[self addRelationshipWithTarget:target type:context.packageRelationships[target] id:[NSString stringWithFormat: @"rId%ld", ++relationshipCounter] toXMLElement:document.rootElement];
	}

	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:RKDOCXPackageRelationshipsFilename folder:RKDOCXRelsFolder] contentType:nil];
}

+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXConversionContext *)context
{
	[self buildRelationshipsOfType:RKDOCXRelationshipDocumentSource usingContext:context];
	[self buildRelationshipsOfType:RKDOCXRelationshipEndnoteSource usingContext:context];
	[self buildRelationshipsOfType:RKDOCXRelationshipFootnoteSource usingContext:context];
}

+ (void)buildRelationshipsOfType:(RKDOCXRelationshipSource)relationshipType usingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXRelationshipsRootElementName namespaces:@{@"xmlns": @"http://schemas.openxmlformats.org/package/2006/relationships"}];
	NSDictionary *relationships;
	NSString *filename;
	
	switch (relationshipType) {
		case RKDOCXRelationshipDocumentSource:
			relationships = context.documentRelationships;
			filename = RKDOCXDocumentRelationshipsFilename;
			break;
			
		case RKDOCXRelationshipEndnoteSource:
			relationships = context.endnoteRelationships;
			filename = RKDOCXEndnotesRelationshipsFilename;
			break;
			
		case RKDOCXRelationshipFootnoteSource:
			relationships = context.footnoteRelationships;
			filename = RKDOCXFootnotesRelationshipsFilename;
			break;
	}
	
	if (relationships.count == 0)
		return;
	
	// Relationships
	for (NSString *target in relationships) {
		[self addRelationshipWithTarget:target type:relationships[target][RKDOCXConversionContextRelationshipTypeName] id:[NSString stringWithFormat:@"rId%@", relationships[target][RKDOCXConversionContextRelationshipIdentifierName]] toXMLElement:document.rootElement];
	}
	
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:filename folder:RKDOCXWordRelsFolder] contentType:nil];
}

+ (void)addRelationshipWithTarget:(NSString *)target type:(NSString *)type id:(NSString *)identifier toXMLElement:(NSXMLElement *)rootElement
{
	NSXMLElement *relationshipElement = [NSXMLElement elementWithName: RKDOCXRelationshipElementName];
	[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Id" stringValue:identifier]];
	[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Type" stringValue:type]];
	[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"Target" stringValue:target]];
	if ([type isEqual: RKDOCXLinkRelationshipType])
		[relationshipElement addAttribute: [NSXMLElement attributeWithName:@"TargetMode" stringValue:@"External"]];
	
	[rootElement addChild: relationshipElement];
}

@end
