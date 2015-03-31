//
//  RKDOCXPartWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@class RKDOCXConversionContext;

// Filenames
extern NSString *RKDOCXPackageRelationshipsFilename;
extern NSString *RKDOCXContentTypesFilename;
extern NSString *RKDOCXCorePropertiesFilename;
extern NSString *RKDOCXExtendedPropertiesFilename;
extern NSString *RKDOCXDocumentRelationshipsFilename;
extern NSString *RKDOCXDocumentFilename;
extern NSString *RKDOCXSettingsFilename;

/*!
 @abstract Abstract superclass used by all writers creating XML document parts.
 */
@interface RKDOCXPartWriter : NSObject

/*!
 @abstract Returns an XML document with XML processing instruction and rootelement.
 */
+ (NSXMLDocument *)basicXMLDocumentWithRootElementName:(NSString *)root namespaces:(NSDictionary *)namespaces;

@end
