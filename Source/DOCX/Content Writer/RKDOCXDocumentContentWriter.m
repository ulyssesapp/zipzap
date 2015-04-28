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
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXDocumentFilename];
}

@end
