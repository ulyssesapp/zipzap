//
//  RKDOCXHeaderFooterWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 22.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXHeaderFooterWriter.h"

#import "RKDOCXAttributedStringWriter.h"

// Root element names
NSString *RKDOCXHeaderRootElementName		= @"w:hdr";
NSString *RKDOCXFooterRootElementName		= @"w:ftr";

// Content types
NSString *RKDOCXFooterContentType			= @"application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml";
NSString *RKDOCXHeaderContentType			= @"application/vnd.openxmlformats-officedocument.wordprocessingml.header+xml";

// Relationship types
NSString *RKDOCXHeaderRelationshipType		= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/header";
NSString *RKDOCXFooterRelationshipType		= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer";

@implementation RKDOCXHeaderFooterWriter

+ (void)buildPageElement:(RKDOCXPageElementType)pageElement withIndex:(NSUInteger)index forAttributedString:(NSAttributedString *)contentString usingContext:(RKDOCXConversionContext *)context
{
	NSString *rootElementName;
	NSString *relationshipType;
	NSString *contentType;
	switch (pageElement) {
		case RKDOCXHeader:
			rootElementName = RKDOCXHeaderRootElementName;
			relationshipType = RKDOCXHeaderRelationshipType;
			contentType = RKDOCXHeaderContentType;
			break;
			
		case RKDOCXFooter:
			rootElementName = RKDOCXFooterRootElementName;
			relationshipType = RKDOCXFooterRelationshipType;
			contentType = RKDOCXFooterContentType;
			break;
	}
	
	NSString *filename = [self filenameForPageElement:pageElement withIndex:index];
	
	NSXMLDocument *document = [self basicXMLDocumentWithStandardNamespacesAndRootElementName: rootElementName];
	
	document.rootElement.children = [RKDOCXAttributedStringWriter processAttributedString:contentString usingContext:context];
	
	[context indexForRelationshipWithTarget:filename andType:relationshipType];
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:filename folder:RKDOCXWordFolder] contentType:contentType];
}

+ (NSString *)filenameForPageElement:(RKDOCXPageElementType)pageElement withIndex:(NSUInteger)index
{
	return (pageElement == RKDOCXHeader) ? [NSString stringWithFormat: @"header%lu.xml", index] : [NSString stringWithFormat: @"footer%lu.xml", index];
}

@end
