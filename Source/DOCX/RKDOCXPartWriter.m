//
//  RKDOCXPartWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"

#import "RKDOCXConversionContext.h"

@implementation RKDOCXPartWriter

+ (NSXMLDocument *)basicXMLDocumentWithRootElementName:(NSString *)root namespaces:(NSDictionary *)namespaces
{
	NSXMLElement *rootElement = [NSXMLElement elementWithName: root];
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement: rootElement];
	
#if !TARGET_OS_IPHONE
	document.version = @"1.0";
	document.characterEncoding = @"UTF-8";
	document.standalone = YES;
#endif
	
	// Namespaces
	for (NSString *namespace in namespaces) {
		[rootElement addAttribute: [NSXMLElement attributeWithName:namespace stringValue:namespaces[namespace]]];
	}
	
	return document;
}

+ (NSXMLDocument *)basicXMLDocumentWithStandardNamespacesAndRootElementName:(NSString *)root
{
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
	
	return [self basicXMLDocumentWithRootElementName:root namespaces:namespaces];
}

+ (NSString *)packagePathForFilename:(NSString *)filename folder:(RKDOCXPackageFolder)folder
{
	NSString *levelString;
	
	switch (folder) {
		case RKDOCXRootFolder:
			levelString = @"";
			break;
			
		case RKDOCXRelsFolder:
			levelString = @"_rels/";
			break;
			
		case RKDOCXDocPropsFolder:
			levelString = @"docProps/";
			break;
			
		case RKDOCXWordFolder:
			levelString = @"word/";
			break;
			
		case RKDOCXMediaFolder:
			levelString = @"media/";
			break;
			
		case RKDOCXWordRelsFolder:
			levelString = @"word/_rels/";
			break;
			
		case RKDOCXWordMediaFolder:
			levelString = @"word/media/";
			break;
	}
	
	return [levelString stringByAppendingString: filename];
}

@end
