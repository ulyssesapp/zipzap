//
//  RKDOCXAssetsWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@class RKDOCXContextObject;

@interface RKDOCXAssetsWriter : NSObject

/*!
 @abstract Builds the relationship NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildPackageRelationshipsUsingContext:(RKDOCXContextObject *)context;

/*!
 @abstract Builds the content types NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildContentTypesUsingContext:(RKDOCXContextObject *)context;

/*!
 @abstract Builds the core properties NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildCorePropertiesUsingContext:(RKDOCXContextObject *)context;

/*!
 @abstract Builds the extended properties NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildExtendedPropertiesUsingContext:(RKDOCXContextObject *)context;

/*!
 @abstract Builds the document relationship NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXContextObject *)context;

/*!
 @abstract Builds the settings NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildSettingsUsingContext:(RKDOCXContextObject *)context;

/*!
 @abstract Builds the main document NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildDocumentUsingContext:(RKDOCXContextObject *)context;

@end
