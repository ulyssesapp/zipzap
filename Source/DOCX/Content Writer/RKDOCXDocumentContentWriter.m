//
//  RKDOCXDocumentContentWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXDocumentContentWriter.h"

#import "RKDOCXConversionContext.h"
#import "RKDOCXSectionWriter.h"

// Root element name
NSString *RKDOCXDocumentRootElementName				= @"w:document";

// Content type
NSString *RKDOCXDocumentContentType					= @"application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml";

// Filename
NSString *RKDOCXDocumentFilename					= @"document.xml";

// Element names
NSString *RKDOCXDocumentContentBodyElementName		= @"w:body";
NSString *RKDOCXDocumentContentParagraphElementName	= @"w:p";
NSString *RKDOCXDocumentContentRunElementName		= @"w:r";
NSString *RKDOCXDocumentContentTextElementName		= @"w:t";

@implementation RKDOCXDocumentContentWriter

+ (void)buildDocumentUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithStandardNamespacesAndRootElementName: RKDOCXDocumentRootElementName];
	
	// Document content
	NSXMLElement *body = [NSXMLElement elementWithName: RKDOCXDocumentContentBodyElementName];
	[document.rootElement addChild: body];
	
	body.children = [RKDOCXSectionWriter sectionElementsUsingContext: context];
	
	[context addXMLDocumentPart:document withFilename:[self fullPathForFilename:RKDOCXDocumentFilename inLevel:RKDOCXWordLevel] contentType:RKDOCXDocumentContentType];
}

@end
