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

// Relationship types
NSString *RKDOCXHeaderRelationshipType		= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/header";
NSString *RKDOCXFooterRelationshipType		= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer";

@implementation RKDOCXHeaderFooterWriter

+ (void)buildPageElement:(RKDOCXPageElementType)pageElement withIndex:(NSUInteger)index forAttributedString:(NSAttributedString *)contentString usingContext:(RKDOCXConversionContext *)context
{
	NSString *rootElementName;
	NSString *relationshipType;
	switch (pageElement) {
		case RKDOCXHeader:
			rootElementName = RKDOCXHeaderRootElementName;
			relationshipType = RKDOCXHeaderRelationshipType;
			break;
			
		case RKDOCXFooter:
			rootElementName = RKDOCXFooterRootElementName;
			relationshipType = RKDOCXFooterRelationshipType;
			break;
	}
	
	NSString *filename = [self filenameForPageElement:pageElement withIndex:index];
	
	// Namespaces
	NSDictionary *namespaces = @{
								 @"xmlns:wpc": @"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas",
								 @"xmlns:mo": @"http://schemas.microsoft.com/office/mac/office/2008/main",
								 @"xmlns:mc": @"http://schemas.openxmlformats.org/markup-compatibility/2006",
								 @"xmlns:mv": @"urn:schemas-microsoft-com:mac:vml",
								 @"xmlns:o": @"urn:schemas-microsoft-com:office:office",
								 @"xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
								 @"xmlns:m": @"http://schemas.openxmlformats.org/officeDocument/2006/math",
								 @"xmlns:v": @"urn:schemas-microsoft-com:vml",
								 @"xmlns:wp14": @"http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing",
								 @"xmlns:wp": @"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
								 @"xmlns:w10": @"urn:schemas-microsoft-com:office:word",
								 @"xmlns:w": @"http://schemas.openxmlformats.org/wordprocessingml/2006/main",
								 @"xmlns:w14": @"http://schemas.microsoft.com/office/word/2010/wordml",
								 @"xmlns:w15": @"http://schemas.microsoft.com/office/word/2012/wordml",
								 @"xmlns:wpg": @"http://schemas.microsoft.com/office/word/2010/wordprocessingGroup",
								 @"xmlns:wpi": @"http://schemas.microsoft.com/office/word/2010/wordprocessingInk",
								 @"xmlns:wne": @"http://schemas.microsoft.com/office/word/2006/wordml",
								 @"xmlns:wps": @"http://schemas.microsoft.com/office/word/2010/wordprocessingShape",
								 @"mc:Ignorable": @"w14 w15 wp14"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:rootElementName namespaces:namespaces];
	
	document.rootElement.children = [RKDOCXAttributedStringWriter processAttributedString:contentString usingContext:context];
	
	[context indexForRelationshipWithTarget:filename andType:relationshipType];
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:[@"word/" stringByAppendingString: filename]];
}

+ (NSString *)filenameForPageElement:(RKDOCXPageElementType)pageElement withIndex:(NSUInteger)index
{
	return (pageElement == RKDOCXHeader) ? [NSString stringWithFormat: @"header%lu.xml", index] : [NSString stringWithFormat: @"footer%lu.xml", index];
}

@end
