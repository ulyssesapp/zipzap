//
//  RKDOCXPartWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@class RKDOCXConversionContext;

// Filenames
extern NSString *RKDOCXContentTypesFilename;
extern NSString *RKDOCXCorePropertiesFilename;
extern NSString *RKDOCXDocumentFilename;
extern NSString *RKDOCXDocumentRelationshipsFilename;
extern NSString *RKDOCXEndnotesFilename;
extern NSString *RKDOCXExtendedPropertiesFilename;
extern NSString *RKDOCXFootnotesFilename;
extern NSString *RKDOCXNumberingFilename;
extern NSString *RKDOCXPackageRelationshipsFilename;
extern NSString *RKDOCXSettingsFilename;
extern NSString *RKDOCXStyleTemplateFilename;

/*!
 @abstract Abstract superclass used by all writers creating XML document parts.
 */
@interface RKDOCXPartWriter : NSObject

/*!
 @abstract Returns an XML document with XML processing instruction and rootelement.
 */
+ (NSXMLDocument *)basicXMLDocumentWithRootElementName:(NSString *)root namespaces:(NSDictionary *)namespaces;

/*!
 @abstract Convenience method that returns an XML document with commonly used namespaces.
 @discussion All files with document text content use these namespaces.
 */
+ (NSXMLDocument *)basicXMLDocumentWithStandardNamespacesAndRootElementName:(NSString *)root;

@end
