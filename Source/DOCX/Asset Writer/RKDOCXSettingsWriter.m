//
//  RKDOCXSettingsWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXSettingsWriter.h"


// Root element name
NSString *RKDOCXSettingsRootElementName = @"w:settings";

// Relationship type and target
NSString *RKDOCXSettingsRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings";
NSString *RKDOCXSettingsRelationshipTarget = @"settings.xml";

@implementation RKDOCXSettingsWriter

+ (void)buildSettingsUsingContext:(RKDOCXConversionContext *)context
{
	// Namespaces
	NSDictionary *namespaces = @{
								 @"xmlns:mc": @"http://schemas.openxmlformats.org/markup-compatibility/2006",
								 @"xmlns:o": @"urn:schemas-microsoft-com:office:office",
								 @"xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
								 @"xmlns:m": @"http://schemas.openxmlformats.org/officeDocument/2006/math",
								 @"xmlns:v": @"urn:schemas-microsoft-com:vml",
								 @"xmlns:w10": @"urn:schemas-microsoft-com:office:word",
								 @"xmlns:w": @"http://schemas.openxmlformats.org/wordprocessingml/2006/main",
								 @"xmlns:w14": @"http://schemas.microsoft.com/office/word/2010/wordml",
								 @"xmlns:w15": @"http://schemas.microsoft.com/office/word/2012/wordml",
								 @"xmlns:sl": @"http://schemas.openxmlformats.org/schemaLibrary/2006/main",
								 @"mc:Ignorable": @"w14 w15"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXSettingsRootElementName namespaces:namespaces];
	
	// Settings
	// Complex type font compatibility settings
	NSXMLElement *compat = [NSXMLElement elementWithName: @"w:compat"];
	[compat addChild: [NSXMLElement elementWithName: @"w:useFELayout"]];
	
	// Avoid compatibility mode
	NSXMLElement *compatSetting = [NSXMLElement elementWithName: @"w:compatSetting"];
	[compatSetting addAttribute: [NSXMLElement attributeWithName:@"w:name" stringValue:@"compatibilityMode"]];
	[compatSetting addAttribute: [NSXMLElement attributeWithName:@"w:uri" stringValue:@"http://schemas.microsoft.com/office/word"]];
	[compatSetting addAttribute: [NSXMLElement attributeWithName:@"w:val" stringValue:@"15"]];
	[compat addChild: compatSetting];
	
	[document.rootElement addChild: compat];
	
	[context indexForRelationshipWithTarget:RKDOCXSettingsRelationshipTarget andType:RKDOCXSettingsRelationshipType];
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXSettingsFilename];
}

@end
