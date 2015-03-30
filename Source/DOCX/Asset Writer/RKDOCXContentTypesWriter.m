//
//  RKDOCXContentTypesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXContentTypesWriter.h"

// Root element name
NSString *RKDOCXContentTypesRootElementName = @"Types";

// Element names
NSString *RKDOCXDefaultContentTypeElementName = @"Default";
NSString *RKDOCXOverrideContentTypeElementName = @"Override";

// Content Types
NSString *RKDOCXDefaultXMLExtension = @"xml";
NSString *RKDOCXDefaultXMLContentType = @"application/xml";
NSString *RKDOCXDefaultRelationshipExtension = @"rels";
NSString *RKDOCXDefaultRelationshipContentType = @"application/vnd.openxmlformats-package.relationships+xml";
NSString *RKDOCXDocumentContentType = @"application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml";
NSString *RKDOCXSettingsContentType = @"application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml";
NSString *RKDOCXCorePropertiesContentType = @"application/vnd.openxmlformats-package.core-properties+xml";
NSString *RKDOCXExtendedPropertiesContentType = @"application/vnd.openxmlformats-officedocument.extended-properties+xml";

@implementation RKDOCXContentTypesWriter

+ (void)buildContentTypesUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName: RKDOCXContentTypesRootElementName];
	
	// Namespace attribute
	[document.rootElement addAttribute: [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://schemas.openxmlformats.org/package/2006/content-types"]];
	
	// Default Content Types
	NSDictionary *defaultContentTypes = @{
										  RKDOCXDefaultXMLExtension: RKDOCXDefaultXMLContentType,
										  RKDOCXDefaultRelationshipExtension: RKDOCXDefaultRelationshipContentType
										  };
	for (NSString *extension in defaultContentTypes) {
		NSXMLElement *defaultElement = [NSXMLElement elementWithName: RKDOCXDefaultContentTypeElementName];
		[defaultElement addAttribute: [NSXMLElement attributeWithName:@"Extension" stringValue:extension]];
		[defaultElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:defaultContentTypes[extension]]];
		[document.rootElement addChild: defaultElement];
	}
	
	// Override Content Types
	NSDictionary *overrideContentTypes = @{
										   [@"/" stringByAppendingString: RKDOCXDocumentFilename]: RKDOCXDocumentContentType,
										   [@"/" stringByAppendingString: RKDOCXSettingsFilename]: RKDOCXSettingsContentType,
										   [@"/" stringByAppendingString: RKDOCXCorePropertiesFilename]: RKDOCXCorePropertiesContentType,
										   [@"/" stringByAppendingString: RKDOCXExtendedPropertiesFilename]: RKDOCXExtendedPropertiesContentType
										   };
	for (NSString *partName in overrideContentTypes) {
		NSXMLElement *overrideElement = [NSXMLElement elementWithName: RKDOCXOverrideContentTypeElementName];
		[overrideElement addAttribute: [NSXMLElement attributeWithName:@"PartName" stringValue:partName]];
		[overrideElement addAttribute: [NSXMLElement attributeWithName:@"ContentType" stringValue:overrideContentTypes[partName]]];
		[document.rootElement addChild: overrideElement];
	}
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXContentTypesFilename];
}

@end
